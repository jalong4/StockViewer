//
//  BalanceHistoryView.swift
//  StockViewer
//
//  Created by Jim Long on 2/8/21.
//

import SwiftUI
import Charts

struct BalanceHistoryView: View {

    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var appData: AppData
    

    @State private var selectedDataPoint = 0
    @State private var lineChartData: [ChartDataEntry] = []
    @State private var accounts: [AccountName] = []

    
    let horizontalPadding: CGFloat = 40
    let maxWidth: CGFloat = .infinity
    
    struct AccountName: Identifiable {
        var id = UUID()
        var name: String
    }
    
    private func getAccounts(_ history: [History]) -> [AccountName] {

        
        let names = history.flatMap { $0.data.summary.accounts }.map { $0.name }.uniqued()

        var result = [AccountName]()
        names.forEach { name in
            result.append(AccountName(name: name))
        }
        return result
    }
    
    
    var body: some View {
        
        let history = appData.history.filter { $0.date > "2021-10/01" }
        
        ZStack {
            Color.themeBackground
            GeometryReader { geometry in
                ScrollView (showsIndicators: false) {
                    VStack(alignment: .center, spacing: 0,  content: {


                            Text("Portfolio").font(.title).padding(.top, 10)
                            CustomLineChartView(entries: CustomLineChartView.getLineChartData(history: history),
                                                xAxisValues: history.map { $0.date } , selected: $selectedDataPoint).frame(width: geometry.size.width, height: 240, alignment: .center)

                        
                            
                        ForEach (self.accounts, id: \.id) { account in
                                    Text(account.name).font(.title).padding(.top, 10)
                            CustomLineChartView(entries: CustomLineChartView.getLineChartDataForAccount(history: history, name: account.name),
                                                xAxisValues: history.map { $0.date } , selected: $selectedDataPoint).frame(width: geometry.size.width, height: 240, alignment: .center)
                        }
                    })
                }
            }
            
        }
        .dismissKeyboardOnTap()
        .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
        .navigationTitle("Balance History")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear() {
            print("BalanceHistoryView appearing")
            self.selectedDataPoint = appData.history.count - 1;
            self.lineChartData = CustomLineChartView.getLineChartData(history: appData.history)
            self.accounts = getAccounts(appData.history)
        }
    }
}


struct BalanceHistoryView_Previews: PreviewProvider {
    @State static var history = Api.getMockHistory();
    
    static var previews: some View {
        BalanceHistoryView()
    }
}
