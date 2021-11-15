//
//  BalanceHistoryView.swift
//  StockViewer
//
//  Created by Jim Long on 2/8/21.
//

import SwiftUI
import Charts

struct BalanceHistoryView: View {
    
    enum DateRangeType: Int {
//        case all, ytd, threeMonths, lastMonth, last7Days
        case all, lastMonth, last2weeks, last7Days, last3Days
    }
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var appData: AppData
    
    
    @State private var selectedDataPoint = 0
    @State private var lineChartData: [ChartDataEntry] = []
    @State private var accounts: [AccountName] = []
    @State private var loading: Bool = false
    @State private var dateRangeType = DateRangeType.lastMonth.rawValue
    @State private var gain = AnyView(EmptyView())
    @State private var gainPercent = AnyView(EmptyView())
    @State private var startDate: String?
    @State private var endDate: String?
    
    
    let horizontalPadding: CGFloat = 40
    let maxWidth: CGFloat = .infinity
    
    struct AccountName: Identifiable {
        var id = UUID()
        var name: String
    }
    
    private func getStartDateFor(_ dateRange: Int) -> String? {
        let dateRangeType = DateRangeType(rawValue: dateRange);
        
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        switch dateRangeType {
        case .all:
            return nil
//        case .ytd:
//            return dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: -7, to: today.startOfYear)!)
//        case .threeMonths:
//            return dateFormatter.string(from:today.last3Months)
        case .lastMonth:
            return dateFormatter.string(from:today.lastMonth)
        case .last2weeks:
            return dateFormatter.string(from:today.last2Weeks)
        case .last7Days:
            return dateFormatter.string(from:today.lastWeek)
        case .last3Days:
            return dateFormatter.string(from:today.last3Days)
        default:
            break
        }
        
        return nil;
    }
    
    private func getEndDateFor(_ dateRangeType: Int) -> String {
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        return dateFormatter.string(from: today)
    }
    
    private func getAccounts(_ history: [History]) -> [AccountName] {
        
        let names = history.flatMap { $0.data.summary.accounts }.map { $0.name }
        
        var result = [AccountName]()
        names.forEach { name in
            result.append(AccountName(name: name))
        }
        return result
    }
    
    private func getGainPercent() -> AnyView {
        let first = appData.history.first;
        let last = appData.history.last;
        let firstTotal = first?.data.summary.totals.total ?? 0;
        let lastTotal = last?.data.summary.totals.total ?? 0;
        let change = lastTotal - firstTotal
        let gain: Double = (lastTotal == 0) ? 0 : change/firstTotal
        return AnyView(Utils.getColorCodedTextView(gain, style: .percent))
    }
    
    private func getGain() -> AnyView {
        let first = appData.history.first;
        let last = appData.history.last;
        let firstTotal = first?.data.summary.totals.total ?? 0;
        let lastTotal = last?.data.summary.totals.total ?? 0;
        let change = lastTotal - firstTotal
        return AnyView(Utils.getColorCodedTextView(change, style: .currency))
    }
    
    
    var body: some View {
        Group {
            if !appData.isNetworkReachable {
                GeometryReader { geometry in
                    VStack(alignment: .center) {
                        Text("No Network Connection")
                            .font(.system(size: 16))
                            .fontWeight(.bold)
                    }
                    .frame(width: geometry.size.width / 2, height: geometry.size.width / 2)
                    .foregroundColor(Color.themeAccent)
                    .insetView()
                }
            }
            else if self.loading {
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
                    GeometryReader { geometry in
                        ScrollView (showsIndicators: false) {
                            VStack(alignment: .center, spacing: 0,  content: {
                                
                                SegmentedPicker(items: ["All", "1m", "2w", "1w", "3d"], selection: $dateRangeType)
                                    .frame(maxWidth: maxWidth)
                                    .padding([.bottom, .top], 10)
                                    .padding([.leading, .trailing], horizontalPadding)
                                    .onChange(of: dateRangeType) { newValue in
                                        self.loading.toggle()
                                        self.startDate = getStartDateFor(dateRangeType)
                                        self.endDate = getEndDateFor(dateRangeType)
                                        print("Start Date: \(self.startDate ?? ""), End Date: \(self.endDate ?? "")")
                                        Api().getStocksBackupWithDateRange(startDate: startDate, endDate: endDate) { historyWithDateRange in
                                            appData.history = historyWithDateRange ?? []
                                            self.gain = getGain()
                                            self.gainPercent = getGainPercent()
                                            self.loading.toggle()
                                        }
                                    }
                                
                                
                                Text("Portfolio").font(.title).padding(.top, 10)
                                Text("Gain").font(.headline).padding(.top, 10)
                                self.gain.padding(.top, 5)
                                self.gainPercent.padding(.top, 5)
                                CustomLineChartView(entries: CustomLineChartView.getLineChartData(history: appData.history),
                                                    xAxisValues: appData.history.map { $0.date } , selected: $selectedDataPoint).frame(width: geometry.size.width, height: 240, alignment: .center)
                                
                                
                                
                                ForEach (self.accounts, id: \.id) { account in
                                    Text(account.name).font(.title).padding(.top, 10)
                                    CustomLineChartView(entries: CustomLineChartView.getLineChartDataForAccount(history: appData.history, name: account.name),
                                                        xAxisValues: appData.history.map { $0.date } , selected: $selectedDataPoint).frame(width: geometry.size.width, height: 240, alignment: .center)
                                }
                            })
                        }
                    }
                }
            }
        }
        .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
        .navigationTitle("Balance History")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear() {
            print("BalanceHistoryView appearing")
            self.selectedDataPoint = appData.history.count - 1;
            self.lineChartData = CustomLineChartView.getLineChartData(history: appData.history)
            self.accounts = getAccounts(appData.history)
            self.gain = getGain()
            self.gainPercent = getGainPercent()
        }
        .dismissKeyboardOnTap()
    }
}


struct BalanceHistoryView_Previews: PreviewProvider {
    @State static var history = Api.getMockHistory();
    
    static var previews: some View {
        BalanceHistoryView()
    }
}

