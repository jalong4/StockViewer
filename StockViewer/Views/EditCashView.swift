//
//  EditCashView.swift
//  StockViewer
//
//  Created by Jim Long on 2/15/21.
//

import SwiftUI

struct EditCashView: View {
    
    enum CashTransactionType: Int {
        case deposit, withdrawal
    }
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var appState: AppState
    @ObservedObject var keyboardHeightHelper = KeyboardHeightHelper()
    
    @State var portfolio: Portfolio
    @State private var isSaving: Bool = false
    @State private var disableSaveButton: Bool = true
    @State private var transactionType = 0
    
    @State private var account = ""
    @State private var amount = ""
    @State private var amountMsg = ""
    
    @State private var showAlert = false
    @State private var amountIsValid = false
    
    let horizontalPadding: CGFloat = 40
    let maxWidth: CGFloat = .infinity
    
    private func getAccountList() -> [String] {
        return portfolio.summary.accounts.map { $0.name }
    }
    
    var amountValue: Double {
        guard let amount = Double(self.amount) else {
            return 0
        }
        return amount
    }
    
    var allFieldsValidated: Bool {
        
        if self.account.isEmpty {
            self.account = getAccountList().first ?? ""
        }
        
        guard let amount = Double(self.amount) else {
            return false
        }
        
        return amount > 0
    }
    
    
    private func updateCashHoldings(amount: Double,
                                    cashHoldings: Holding) {
        
        // Cash has a totalCost of zero so we
        // substract totalCost of the new Entry from the quanity of
        // cash unnits
        
        let transactionAmount: Double = (CashTransactionType(rawValue: self.transactionType) == .deposit) ? self.amountValue : -self.amountValue
        print("Transaction Amount: \(transactionAmount)")
        
        
        let holding = Holding(_id: cashHoldings._id,
                              ticker: cashHoldings.ticker,
                              quantity: cashHoldings.quantity + transactionAmount,
                              totalCost: cashHoldings.totalCost,
                              account: cashHoldings.account)
        
        Api().updateHolding(holding: holding) { (updatedHolding) in
            print("Updated cash holding:")
            dump(updatedHolding)
            self.isSaving.toggle()
            self.showAlert.toggle()
        }
        
    }
    
    
    private func editCashBalance(amount: Double) {
        
        Api().getHoldingsForAccount(account: self.account) { (holdingsResponse) in
            guard let cashHoldings = holdingsResponse.holdings.filter({ $0.ticker == "SPAXX" && $0.account == self.account }).first
            else {
                print("No cash found in account: \(self.account)")
                return
            }
            updateCashHoldings(amount: amount, cashHoldings: cashHoldings)
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
                    
                    SegmentedPicker(items: ["Deposit", "Withdrawal"], selection: $transactionType)
                        .frame(maxWidth: maxWidth)
                        .padding(.bottom, 10)
                        .padding([.leading, .trailing], horizontalPadding)

                    CustomTextField("Amount", text: $amount, keyboardType: .numbersAndPunctuation, textAlignment:  .center, tag: 1, onCommit: nil)
                        .frame(height: 40, alignment: .center)
                        .background(Capsule().fill(Color.themeAccent.opacity(0.2)))
                        .frame(maxWidth: maxWidth)
                        .padding([.top, .bottom], 10)
                        .padding([.leading, .trailing], horizontalPadding)
                        
                        .onChange(of: amount) { newValue in
                            self.amountMsg = ""
                            guard let value = Double(self.amount), value > 0 else {
                                self.amountIsValid = false
                                self.disableSaveButton = !allFieldsValidated
                                self.amountMsg = self.amount.isEmpty ? "" : "Invalid number"
                                print(self.amountMsg)
                                return
                            }
                            self.amountIsValid = true
                            self.disableSaveButton = !allFieldsValidated
                        }
   
                        
                        Text($amountMsg.wrappedValue)
                            .frame(maxWidth: maxWidth, alignment: .center)
                            .padding(.bottom, 10)
                            .foregroundColor(amountIsValid ? Color.themeValid : Color.themeError)
                        
                        
                        HStack (spacing: 20) {
                            Button(action: {
                                print("Save")
                                if allFieldsValidated {
                                    self.isSaving = true
                                    print("Amount: \(self.amountValue)")
                                    print("Type: \(["Deposit", "Withdrawal"][self.transactionType])")
                                    print("Account: \(self.account)")
                                    
                                    editCashBalance(amount: amountValue)
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
                                return Alert(title: Text("Balance Updated"),
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
                .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
                .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
                .edgesIgnoringSafeArea(.all)
                .navigationTitle("Edit Cash Balance")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarHidden(true)
            }
        }
    }
}

struct EditCashView_Previews: PreviewProvider {
    @State static var portfolio = Api.getMockPortfolio()
    static var previews: some View {
        EditCashView(portfolio: portfolio)
    }
}
