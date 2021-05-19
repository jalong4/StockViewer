//
//  FuturesView.swift
//  StockViewer
//
//  Created by Jim Long on 4/11/21.
//

import SwiftUI

struct FuturesView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var appData: AppData
    
    @ObservedObject var futures = Futures()
    @State private var loading: Bool = true
    @State private var editMode = EditMode.inactive
    @State private var isSaving: Bool = false
    @State private var disableSaveButton: Bool = true
    @State private var ticker = ""
    @State private var price = ""
    
    @State private var tickerMsg = ""
    @State private var priceMsg = ""
    @State private var tickerIsValid = false
    @State private var priceIsValid = false
    
    let horizontalPadding: CGFloat = 40
    let maxWidth: CGFloat = .infinity
    
    
    var allFieldsValidated: Bool {
        let tickerIsValid = self.tickerIsValid && (self.ticker.count != 0)
        let result = tickerIsValid && isPriceValid()
        return result
    }
    
    private func isPriceValid() -> Bool {
        guard let price = Double(self.price) else {
            return false
        }
        
        return price >= 0
    }
    
    private func getFutures() {
        Api().getFutures() { (futures) in
            if let futures = futures {
                print("got Futures")
                dump(futures)
                self.futures.list = futures
                self.loading.toggle()
                return
            }
            self.loading.toggle()
            print("No futures found")
        }
    }
        
    private func delete(at offsets: IndexSet) {
        for offset in offsets {
            let future =  futures.list[offset]
            
            Api().deleteFuture(id: future._id) { (message) in
                print(message)
                futures.list.remove(at: offset)
            }
        }
    }
    
    private var addButton: some View {
        switch editMode {
        case .inactive:
            return AnyView(Button(action: onAdd) { Image(systemName: "plus") })
        default:
            return AnyView(EmptyView())
        }

    }
    
    func onAdd() {
        
        if !allFieldsValidated {
            return
        }
        
        guard let price = Double(price), ticker != ""  else {
            return
        }
        
        let future = FutureBody(ticker: ticker, price: price)
        Api().addFuture(futureBody: future) { (newFuture) in
            dump(newFuture)
            futures.list.append(newFuture)
        }
    }
    
    var body: some View {
        Group {
            if self.loading {
                GeometryReader { geometry in
                    VStack(alignment: .center) {
                        ProgressView("Loading...")
                            .scaleEffect(1.5, anchor: .center)
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.themeAccent))
                    }
                    .frame(width: geometry.size.width / 2, height: geometry.size.width / 2)
                    .foregroundColor(Color.themeAccent)
                    .opacity(self.loading ? 1 : 0)
                    .insetView()
                }
            } else {

                ZStack {
                    Color.themeBackground

                    VStack (alignment: .center, spacing: 0,  content: {


                        Text("Enter Future Stock Value")
                            .frame(maxWidth: Constants.textFieldMaxWidth, alignment: .center)
                            .padding(.top, 4)
                            .padding(.bottom, 10)
                            .foregroundColor(Color.themeForeground)

                        CustomTextField("Stock Ticker", text: $ticker, keyboardType: .default, textAlignment: .center, tag: 1, onCommit: nil)
                            .frame(height: 40, alignment: .center)
                            .background(Capsule().fill(Color.themeAccent.opacity(0.2)))
                            .frame(maxWidth: maxWidth)
                            .padding(.top, 4)
                            .padding(.bottom, 14)
                            .padding([.leading, .trailing], horizontalPadding)

                            .onChange(of: ticker) { newValue in
                                self.ticker = self.ticker.uppercased()
                                self.tickerMsg = ""

                                Api().getStockQuote(ticker: ticker) { (quote) in
                                    print("\(self.ticker)")
                                    guard let quote = quote, quote.symbol == self.ticker else {
                                        self.tickerMsg = self.ticker.isEmpty ? "" : "Invalid stock price"
                                        self.tickerIsValid = false
                                        self.disableSaveButton = !allFieldsValidated
                                        return
                                    }

                                    if let _ = futures.list.firstIndex(where: { $0.ticker == self.ticker }) {
                                        self.tickerMsg = self.ticker.isEmpty ? "" : "Future price for ticker already exists"
                                        self.tickerIsValid = false
                                        self.disableSaveButton = !allFieldsValidated
                                        return
                                    }
                                    self.tickerIsValid = true
                                    self.disableSaveButton = !allFieldsValidated
                                    self.tickerMsg = quote.displayName ?? quote.shortName ?? quote.longName ?? ""
                                    print("Ticker found for " + self.tickerMsg)
                                }
                            }

                        Text($tickerMsg.wrappedValue)
                            .frame(maxWidth: maxWidth, alignment: .center)
                            .padding(.bottom, 10)
                            .foregroundColor(tickerIsValid ? Color.themeValid : Color.themeError)


                        SvTextField(placeholder: "Price", text: $price, isValid: $priceIsValid,
                                    textAlignment: .center,
                                    tag: 2,
                                    textMsg: $priceMsg,
                                    validationCallback: {
                                        return ValidationResult(isValid: isPriceValid(),
                                                                errorMessage: "Invalid stock price")
                                    },
                                    onChangeHandler: {
                                        self.disableSaveButton = !allFieldsValidated
                                    }
                        )

                        Divider()
                        
                        List {
                            Section(header: Text("Futures:")) {
                                ForEach(futures.list) { future in
                                    FutureRow(future: future, active: future.active)
                                }
                                .onDelete(perform: delete)
                            }
                        }
//                        .listStyle(GroupedListStyle())
//                        .environment(\.horizontalSizeClass, .regular)
                    })
                }
                .navigationBarItems(leading: EditButton(), trailing: addButton.disabled(disableSaveButton))
                .environment(\.editMode, $editMode)
            }
        }
        .onAppear() {
            self.loading = true
            getFutures()
        }
        .dismissKeyboardOnTap()
    }

}

struct FutureRow: View {
    
    @ObservedObject var future: Future
    @State var active: Bool
    @State private var showingToggleActiveAlert = false
    
    func getAlertTitle() -> String {
        if active {
            return "Activating \(future.ticker)"
        }
        return "Deactivating \(future.ticker)"
    }
    
    var body: some View {
        
        HStack {
            Text(future.ticker + ":")
            Text(Utils.getFormattedNumber(future.price, fractionDigits: 2))
            Spacer()
            Toggle("", isOn: $active)
                .onChange(of: active) { value in
                    self.showingToggleActiveAlert.toggle()
                }
        }
        .alert(isPresented: $showingToggleActiveAlert, content: {
            return Alert(title: Text("\(getAlertTitle())"),
                         message: Text("Confirm?"),
                         primaryButton: .default(Text("Yes"), action: {
                            self.future.active.toggle()
                            Api().updateFuture(future: future) { (updateFuture) in
                                dump(updateFuture)
                            }
                            
                         }),
                         secondaryButton: .destructive(Text("No"), action: {
                            // undo toggle
                            active.toggle()
                            
                         })
            )
        })
    }
}

struct FuturesView_Previews: PreviewProvider {
    static var previews: some View {
        FuturesView()
    }
}
