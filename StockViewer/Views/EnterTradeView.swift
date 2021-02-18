//
//  EnterTradeView.swift
//  StockViewer
//
//  Created by Jim Long on 2/8/21.
//

import SwiftUI

struct EnterTradeView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var appState: AppState
    
    @State var portfolio: Portfolio
    @State private var isSaving: Bool = false
    @State private var disableSaveButton: Bool = true
    
    @State private var ticker = ""
    @State private var account = ""
    @State private var quantity = ""
    @State private var totalCost = ""
    
    @State private var tickerMsg = ""
    @State private var quantityMsg = ""
    @State private var totalCostMsg = ""
    
    @State private var showAlert = false
    @State private var tickerIsValid = false
    @State private var quantityIsValid = false
    @State private var totalCostIsValid = false
    
    let horizontalPadding: CGFloat = 40
    let maxWidth: CGFloat = .infinity
    
    private func getAccountList() -> [String] {
        return portfolio.summary.accounts.map { $0.name }
    }
    
    var quantityValue: Double {
        guard let quantity = Double(self.quantity) else {
            return 0
        }
        return quantity
    }
    
    var totalCostValue: Double {
        guard let totalCost = Double(self.totalCost) else {
            return 0
        }
        return totalCost
    }
    
    
    var allFieldsValidated: Bool {
        
        if self.account.isEmpty {
            self.account = getAccountList().first ?? ""
        }
        
        let quantityIsValid = (Double(self.quantity) != nil)
        let totalCostIsValid = (Double(self.totalCost) != nil)
        let tickerIsValid = self.tickerIsValid && (self.ticker.count != 0)
        let result = tickerIsValid && quantityIsValid && totalCostIsValid
        return result
    }
    
    
    private func updateCashHoldings(totalCost: Double,
                                    cashHoldings: Holding) {
        
        // Cash has a totalCost of zero so we
        // substract totalCost of the new Entry from the quanity of
        // cash unnits
        
        let holding = Holding(_id: cashHoldings._id,
                              ticker: cashHoldings.ticker,
                              quantity: cashHoldings.quantity - totalCost,
                              totalCost: cashHoldings.totalCost,
                              account: cashHoldings.account)
        
        Api().updateHolding(holding: holding) { (updatedHolding) in
            print("Updated cash holding:")
            dump(updatedHolding)
            self.isSaving.toggle()
            self.showAlert.toggle()
        }
        
    }
    
    private func deleteHolding(quantity: Double,
                               totalCost: Double,
                               originalHolding: Holding,
                               cashHoldings: Holding) {
        
        Api().deleteHolding(id: originalHolding._id) { (message) in
            print(message)
            updateCashHoldings(totalCost: totalCost,
                               cashHoldings: cashHoldings)
        }
    }
    
    
    private func updateHolding(quantity: Double,
                               totalCost: Double,
                               originalHolding: Holding,
                               cashHoldings: Holding) {
        
        let holding = Holding(_id: originalHolding._id,
                              ticker: self.ticker,
                              quantity: originalHolding.quantity + quantity,
                              totalCost: originalHolding.totalCost + totalCost,
                              account: self.account)
        
        Api().updateHolding(holding: holding) { (updatedHolding) in
            print("Updated holding:")
            dump(updatedHolding)
            
            updateCashHoldings(totalCost: totalCost,
                               cashHoldings: cashHoldings)
        }
    }
    
    private func createHolding(quantity: Double,
                               totalCost: Double,
                               cashHoldings: Holding) {
        
        let holdingBody = HoldingBody(ticker: self.ticker, quantity: quantity, totalCost: totalCost, account: self.account)
        
        Api().createHolding(holdingBody: holdingBody) { (holding) in
            print("New holding:")
            dump(holding)
            
            updateCashHoldings(totalCost: totalCost,
                               cashHoldings: cashHoldings)
        }
        
    }
    
    private func enterTrade(quantity: Double, totalCost: Double) {
        
        Api().getHoldingsForAccount(account: account) { (holdingsResponse) in
            
            guard let cashHoldings = holdingsResponse.holdings.filter({ $0.ticker == "SPAXX" && $0.account == account }).first
            else {
                print("No cash found in account: \(self.account)")
                return
            }
            
            if let originalHolding = holdingsResponse.holdings
                .filter({ $0.ticker == ticker && $0.account == account })
                .first {
                
                print("Holding found:")
                dump(originalHolding)
                
                if (originalHolding.quantity + quantity == 0) {
                    deleteHolding(quantity: quantity,
                                  totalCost: totalCost,
                                  originalHolding: originalHolding,
                                  cashHoldings: cashHoldings)
                } else {
                    updateHolding(quantity: quantity,
                                  totalCost: totalCost,
                                  originalHolding: originalHolding,
                                  cashHoldings: cashHoldings)
                }
            } else {
                createHolding(quantity: quantity,
                              totalCost: totalCost,
                              cashHoldings: cashHoldings)
            }
        }
    }
    
    
    var body: some View {
        NavigationView {
            
            ZStack {
                Color.themeBackground
                
                VStack(alignment: .center, spacing: 0,  content: {
                    CustomPicker(getAccountList(), selection: $account,
                                 selectedItemBackgroundColor: Color.themeAccent.opacity(0.2),
                                 rowHeight: 40,
                                 horizontalPadding: horizontalPadding)
                        .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
                    
                    CustomTextField("Stock Ticker", text: $ticker, keyboardType: .default, textAlignment: .center, tag: 1, onCommit: nil)
                        .frame(height: 40, alignment: .center)
                        .background(Capsule().fill(Color.themeAccent.opacity(0.2)))
                        .frame(maxWidth: maxWidth)
                        .padding([.top, .bottom], 4)
                        .padding([.leading, .trailing], horizontalPadding)
                        
                        .onChange(of: ticker) { newValue in
                            self.ticker = self.ticker.uppercased()
                            self.tickerMsg = ""
                            Api().getStockQuote(ticker: ticker) { (quote) in
                                print("\(self.ticker)")
                                guard let quote = quote, quote.symbol == self.ticker else {
                                    self.tickerMsg = self.ticker.isEmpty ? "" : "Invalid ticker"
                                    self.tickerIsValid = false
                                    self.disableSaveButton = !allFieldsValidated
                                    return
                                }
                                self.tickerIsValid = true
                                self.disableSaveButton = !allFieldsValidated
                                self.tickerMsg = quote.displayName ?? quote.shortName
                                print("Ticker found for " + self.tickerMsg)
                            }
                        }
                    
                    Text($tickerMsg.wrappedValue)
                        .frame(maxWidth: maxWidth, alignment: .center)
                        .padding(.bottom, 10)
                        .foregroundColor(tickerIsValid ? Color.themeValid : Color.themeError)
                    
                    CustomTextField("Quantity", text: $quantity, keyboardType: .numbersAndPunctuation, textAlignment: .center, tag: 2, onCommit: nil)
                        .frame(height: 40, alignment: .center)
                        .background(Capsule().fill(Color.themeAccent.opacity(0.2)))
                        .frame(maxWidth: maxWidth)
                        .padding([.top, .bottom], 4)
                        .padding([.leading, .trailing], horizontalPadding)
                        .onChange(of: quantity) { newValue in
                            self.quantityMsg = ""
                            guard let _ = Double(self.quantity) else {
                                self.quantityIsValid = false
                                self.disableSaveButton = !allFieldsValidated
                                self.quantityMsg = self.quantity.isEmpty ? "" : "Invalid number"
                                print(self.quantityMsg)
                                return
                            }
                            self.quantityIsValid = true
                            self.disableSaveButton = !allFieldsValidated
                        }
                    
                    Text($quantityMsg.wrappedValue)
                        .frame(maxWidth: maxWidth, alignment: .center)
                        .padding(.bottom, 10)
                        .foregroundColor(quantityIsValid ? Color.themeValid : Color.themeError)
                    
                    CustomTextField("Total Cost", text: $totalCost, keyboardType: .numbersAndPunctuation, textAlignment: .center, tag: 3, onCommit: nil)
                        .frame(height: 40, alignment: .center)
                        .background(Capsule().fill(Color.themeAccent.opacity(0.2)))
                        .frame(maxWidth: maxWidth)
                        .padding([.top, .bottom], 4)
                        .padding([.leading, .trailing], horizontalPadding)
                        
                        .onChange(of: totalCost) { newValue in
                            self.totalCostMsg = ""
                            guard let _ = Double(self.totalCost) else {
                                self.totalCostIsValid = false
                                self.disableSaveButton = !allFieldsValidated
                                self.totalCostMsg = self.totalCost.isEmpty ? "" : "Invalid number"
                                print(self.totalCostMsg)
                                return
                            }
                            self.totalCostIsValid = true
                            self.disableSaveButton = !allFieldsValidated
                        }
                    Text($totalCostMsg.wrappedValue)
                        .frame(maxWidth: maxWidth, alignment: .center)
                        .padding(.bottom, 10)
                        .foregroundColor(totalCostIsValid ? Color.themeValid : Color.themeError)
                    
                    HStack (spacing: 20) {
                        Button(action: {
                            print("Save")
                            
                            if allFieldsValidated {
                                self.isSaving = true
                                print("Entering trade")
                                
                                print("ticker: \(self.ticker)")
                                print("quantity: \(self.quantityValue)")
                                print("Total Cost: \(self.totalCostValue)")
                                
                                enterTrade(quantity: quantityValue, totalCost: totalCostValue)
                                
                            }
                            
                        }) {
                            Text(isSaving ? "Saving" : "Save")
                                .frame(minWidth: 100)
                                .padding()
                                .foregroundColor(Color.themeBackground)
                                .background(Capsule().fill(Color.themeAccent.opacity(disableSaveButton || isSaving ? 0.2 : 1.0)))
                        }
                        .disabled(disableSaveButton || isSaving)
                        .alert(isPresented: $showAlert, content: {
                            return Alert(title: Text("Trade Entered and Balance Updated"),
                                         message: Text("All Done?"),
                                         primaryButton: .default(Text("Yes"), action: {
                                            self.appState.navigateTo = .Home
                                            
                                         }),
                                         secondaryButton: .destructive(Text("No")))
                        })
                        Button(action: {
                            print("Canceling")
                            self.appState.navigateTo = .Home
                        }) {
                            Text("Cancel")
                                .frame(minWidth: 100)
                                .cancelButtonTextModifier()
                        }
                    }
                    .frame(maxWidth: maxWidth)
                    .padding([.leading, .trailing], horizontalPadding)
                    
                    Spacer()
                    
                })
                .dismissKeyboardOnTap()
                .padding(.top, 10)
                .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
                .edgesIgnoringSafeArea(.all)
                .navigationBarTitle("Enter Trade", displayMode: .inline)
            }
        }
    }
}

struct EnterTradeView_Previews: PreviewProvider {
    @State static var portfolio = Api.getMockPortfolio();
    static var previews: some View {
        EnterTradeView(portfolio: portfolio)
    }
}
