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
    
    @State var futures = Futures()
    @State private var newFuture = Future()
    @State private var selectedFuture: Future?
    @State private var performAdd: Bool = false
    @State private var loading: Bool = true
    @State private var editMode = EditMode.inactive
    @State private var isSaving: Bool = false
    @State private var showingSheet: Bool = false
    
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
            return AnyView(
//                Button(action: onAdd) { Image(systemName: "plus") }
                Button("Add") {
                    self.showingSheet.toggle()
                }
                .sheet(isPresented: self.$showingSheet, onDismiss: {
                    if performAdd {
                        futures.list.append(newFuture)
                        newFuture = Future()
                    }
                }, content: {
                    FutureItemView(futures: futures, future: newFuture, performAdd: $performAdd)
                })
            )
        default:
            return AnyView(EmptyView())
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

                    List {
                        Section(header: Text("Futures:")) {
                            ForEach(futures.list) { future in
                                FutureRow(future: future, active: future.active)
                            }
                            .onDelete(perform: delete)
                        }
                    }
                    .listStyle(GroupedListStyle())
                    .environment(\.horizontalSizeClass, .regular)
                }
//                .navigationBarItems(leading: EditButton(), trailing: addButton)
                .navigationBarItems(trailing: addButton)
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

struct FutureItemView: View {

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var futures: Futures
    @ObservedObject var future: Future
    @Binding var performAdd: Bool
    
    @State private var priceString = ""
    @State private var ticker = ""
    @State private var tickerMsg = ""
    @State private var priceMsg = ""
    @State private var tickerIsValid = false
    @State private var priceIsValid = false
    @State private var isSaving = false
    @State private var showAlert = false
    @State private var disableSaveButton: Bool = true
    
    func isPriceStringValid() -> Bool {
        guard let price = Double(priceString) else {
            return false
        }
        
        return price >= 0
    }
    
    var allFieldsValidated: Bool {
        let tickerIsValid = tickerIsValid && (future.ticker.count != 0)
        return tickerIsValid && isPriceStringValid() && (future.price != -1)
    }

    
    var body: some View {
        VStack (alignment: .center, spacing: 0,  content: {
            Text("Enter Future Stock Value")
                .frame(maxWidth: Constants.textFieldMaxWidth, alignment: .center)
                .padding(.top, 4)
                .padding(.bottom, 10)
                .foregroundColor(Color.themeForeground)
            
            CustomTextField("Stock Ticker", text: $ticker, keyboardType: .default, textAlignment: .center, tag: 1, onCommit: nil)
                .frame(height: Constants.textFieldFrameHeight, alignment: .center)
                .background(Capsule().fill(Color.themeAccent.opacity(0.2)))
                .frame(maxWidth: Constants.textFieldMaxWidth)
                .padding(.top, 4)
                .padding(.bottom, 4)
                .padding([.leading, .trailing], Constants.horizontalPadding)
                
                .onChange(of: self.ticker) { newValue in
                    self.ticker = self.ticker.uppercased()
                    future.ticker = self.ticker
                    self.tickerMsg = ""
                    
                    Api().getStockQuote(ticker: ticker) { (quote) in
                        guard let quote = quote, quote.symbol == future.ticker else {
                            self.tickerMsg = self.ticker.isEmpty ? "" : "Invalid stock price"
                            self.tickerIsValid = false
                            disableSaveButton = !allFieldsValidated
                            return
                        }
                        
                        if let _ = futures.list.firstIndex(where: { $0.ticker == self.ticker }) {
                            self.tickerMsg = self.ticker.isEmpty ? "" : "Future price for ticker already exists"
                            self.tickerIsValid = false
                            disableSaveButton = !allFieldsValidated
                            return
                        }
                        self.tickerIsValid = true
                        future.ticker = self.ticker
                        disableSaveButton = !allFieldsValidated
                        let name = quote.displayName ?? quote.shortName ?? quote.longName ?? ""
                        self.tickerMsg = name + "\n" + "Current Price: " + "\(quote.regularMarketPrice)"
                        print("Ticker found for " + self.tickerMsg)
                    }
                }
            
            Text($tickerMsg.wrappedValue)
                .frame(maxWidth: Constants.textFieldMaxWidth, alignment: .center)
                .padding(.bottom, 14)
                .foregroundColor(tickerIsValid ? Color.themeValid : Color.themeError)
                .lineLimit(nil)
                .multilineTextAlignment(.center)
            
            
            SvTextField(placeholder: "Price", text: self.$priceString, isValid: $priceIsValid,
                        textAlignment: .center,
                        tag: 2,
                        textMsg: $priceMsg,
                        validationCallback: {
                            return ValidationResult(isValid: self.isPriceStringValid(),
                                                    errorMessage: "Invalid stock price")
                        },
                        onChangeHandler: {
                            future.price = Double(self.priceString) ?? -1
                            disableSaveButton = !allFieldsValidated
                        }
            )
            
            HStack (spacing: 20) {
                Button(action: {
                    if allFieldsValidated {
                        self.isSaving = true
                        let future = FutureBody(ticker: future.ticker, price: future.price)
                        Api().addFuture(futureBody: future) { (response) in
                            self.future._id = response._id
                            performAdd.toggle()
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                    
                }) {
                    Text(isSaving ? "Saving" : "Save")
                        .frame(minWidth: 100)
                        .padding()
                        .foregroundColor(Color.themeBackground)
                        .background(Capsule().fill(Color.themeAccent.opacity(disableSaveButton || isSaving ? 0.2 : 1.0)))
                }
                .disabled(disableSaveButton || isSaving)

                Button(action: {
                    print("Canceling")
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                        .frame(minWidth: 100)
                        .cancelButtonTextModifier()
                }
            }
            .frame(maxWidth: Constants.textFieldMaxWidth)
            .padding([.leading, .trailing], Constants.horizontalPadding)
        })
    }
}
        

struct FutureRow: View {
    
    @ObservedObject var future: Future
    @State var active: Bool
    
    var body: some View {
        
        HStack {
            Text(future.ticker + ":")
            Text(Utils.getFormattedNumber(future.price, fractionDigits: 2))
            Spacer()
            Toggle("", isOn: $active)
                .onChange(of: active) { value in
                    self.future.active.toggle()
                    Api().updateFuture(future: future) { (updateFuture) in
                        dump(updateFuture)
                    }
                }
        }
    }
}

struct FuturesView_Previews: PreviewProvider {
    static var previews: some View {
        FuturesView()
    }
}
