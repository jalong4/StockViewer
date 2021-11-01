//
//  CustomLineChartView.swift
//  StockViewer
//
//  Created by Jim Long on 6/6/21.
//

import Charts
import SwiftUI


struct CustomLineChartView: UIViewRepresentable {
    
    var entries: [ChartDataEntry]
    var xAxisValues: [String]
    @Binding var selected: Int
    
    let chart = LineChartView()
    
    func makeUIView(context: Context) -> LineChartView {
        chart.delegate = context.coordinator
        return chart
    }
    
    public func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight)
    {
        print("chartValueSelected : x = \(highlight.x)")
    }
    
    public func chartValueNothingSelected(_ chartView: ChartViewBase)
    {
        print("chartValueNothingSelected")
    }
    
    
    func updateUIView(_ uiView: LineChartView, context: Context) {
        let set = LineChartDataSet(entries: entries)
        set.drawFilledEnabled = true
        set.circleColors = [UIColor(Color.themeAccentFaded)]
        set.fillColor = UIColor(Color.themeAccentFaded)
        set.colors = [UIColor(Color.themeAccent)]
        set.drawCirclesEnabled = false
        set.drawValuesEnabled = false

        uiView.noDataText = "No Data"
        uiView.minOffset = 40
        
        uiView.backgroundColor = UIColor(Color.themeBackground)
        uiView.leftAxis.labelFont = .boldSystemFont(ofSize: 12)
        uiView.leftAxis.labelTextColor = UIColor(Color.themeAccent)
        uiView.leftAxis.axisLineColor = UIColor(Color.themeAccent)
        uiView.leftAxis.drawGridLinesEnabled = false

        uiView.leftAxis.valueFormatter = LargeValueFormatter()
        uiView.leftAxis.spaceTop = 0.35
        
        uiView.xAxis.labelPosition = .bottom
        uiView.xAxis.granularity = 1.0
        uiView.xAxis.labelFont = .boldSystemFont(ofSize: 12)
        uiView.xAxis.labelTextColor = UIColor(Color.themeAccent)
        uiView.xAxis.axisLineColor = UIColor(Color.themeAccent)
        uiView.xAxis.valueFormatter = CustomFormatter(labels: xAxisValues)
        uiView.xAxis.drawGridLinesEnabled = false
        
        uiView.xAxisRenderer = XAxisRendererWithTicks(viewPortHandler: uiView.viewPortHandler, xAxis:  uiView.xAxis, transformer: uiView.getTransformer(forAxis: .left))
        
        uiView.rightAxis.enabled = false
        uiView.data = LineChartData(dataSet: set)
        uiView.data?.setValueFormatter(LargeValueFormatter(disableFirst: true))
        uiView.data?.setValueFont(.boldSystemFont(ofSize: 12))
        uiView.data?.setValueTextColor(UIColor(Color.themeAccent))
        uiView.scaleYEnabled = false
        uiView.scaleXEnabled = true
        
        uiView.legend.enabled = false
        
        let marker = XYMarkerView(color: UIColor(Color.themeAccent),
                                  font: .systemFont(ofSize: 12),
                                  textColor: UIColor(Color.themeBackground),
                                  insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8),
                                  xAxisValueFormatter: uiView.xAxis.valueFormatter!)
        marker.chartView = uiView
        marker.minimumSize = CGSize(width: 80, height: 40)
        uiView.marker = marker

        uiView.animate(xAxisDuration: 0.5, easingOption: .easeInOutCirc)
        uiView.notifyDataSetChanged()
    }
    
    class Coordinator: NSObject, ChartViewDelegate {
        var parent: CustomLineChartView
        init(parent: CustomLineChartView) {
            self.parent = parent
        }
        
        func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
            print("chartValueSelected : x = \(highlight.x)")
            parent.selected = Int(highlight.x)
            
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    static func getLineChartData(history: [History]) -> [ChartDataEntry] {
        let values = history
            .map { $0.data.summary.totals.total }
        let result = values.enumerated().map { ChartDataEntry(x: Double($0),  y: $1, data: Int($0)) }
        return result
    }
    
    static func getLineChartDataForAccount(history: [History], name: String) -> [ChartDataEntry] {
        let accounts = history.flatMap { $0.data.summary.accounts }
        let account = accounts.filter { $0.name == name }
        let values = account.map { $0.total }
        let result = values.enumerated().map { ChartDataEntry(x: Double($0),  y: $1, data: Int($0)) }
        return result
    }
    
}

struct CustomLineChartView_Previews: PreviewProvider {

    static var history = Api.getMockHistory()
    static var previews: some View {
        GeometryReader { geometry in
            ZStack {
                Color.themeBackground
                
                ScrollView (showsIndicators: false) {
                    VStack(alignment: .center, spacing: 0,  content: {
                        Group {
                            Text("Portfolio").font(.title).padding(.top, 10)
                            CustomLineChartView(entries: CustomLineChartView.getLineChartData(history: history),
                                                xAxisValues: history.map { $0.date } , selected: .constant(1)).frame(width: geometry.size.width, height: 240, alignment: .center)
                            
                            Text("Fidelity").font(.title).padding(.top, 10)
                            CustomLineChartView(entries: CustomLineChartView.getLineChartDataForAccount(history: history, name: "Fidelity"),
                                                xAxisValues: history.map { $0.date } , selected: .constant(1)).frame(width: geometry.size.width, height: 240, alignment: .center)
                            
                            Text("TD Ameritrade 401K").font(.title).padding(.top, 10)
                            CustomLineChartView(entries: CustomLineChartView.getLineChartDataForAccount(history: history, name: "TD Ameritrade 401K"),
                                                xAxisValues: history.map { $0.date } , selected: .constant(1)).frame(width: geometry.size.width, height: 240, alignment: .center)
                            
                            Text("TD Ameritrade Roth 401K").font(.title).padding(.top, 10)
                            CustomLineChartView(entries: CustomLineChartView.getLineChartDataForAccount(history: history, name: "TD Ameritrade Roth 401K"),
                                                xAxisValues: history.map { $0.date } , selected: .constant(1)).frame(width: geometry.size.width, height: 240, alignment: .center)
                        }
                        
                        Text("Jo's IRA").font(.title).padding(.top, 10)
                        CustomLineChartView(entries: CustomLineChartView.getLineChartDataForAccount(history: history, name: "Jo's IRA"),
                                            xAxisValues: history.map { $0.date } , selected: .constant(1)).frame(width: geometry.size.width, height: 240, alignment: .center)
                        
                        Text("Jim's IRA").font(.title).padding(.top, 10)
                        CustomLineChartView(entries: CustomLineChartView.getLineChartDataForAccount(history: history, name: "Jim's IRA"),
                                            xAxisValues: history.map { $0.date } , selected: .constant(1)).frame(width: geometry.size.width, height: 240, alignment: .center)
                        Text("Employee Stock Plan").font(.title).padding(.top, 10)
                        CustomLineChartView(entries: CustomLineChartView.getLineChartDataForAccount(history: history, name: "Employee Stock Plan"),
                                            xAxisValues: history.map { $0.date } , selected: .constant(1)).frame(width: geometry.size.width, height: 240, alignment: .center)
                        Text("Employee Stock Plan - Vested").font(.title).padding(.top, 10)
                        CustomLineChartView(entries: CustomLineChartView.getLineChartDataForAccount(history: history, name: "Employee Stock Plan - Vested"),
                                            xAxisValues: history.map { $0.date } , selected: .constant(1)).frame(width: geometry.size.width, height: 240, alignment: .center)
                        
                    })
                }
            }
        }
    }
}

final public class XYMarkerView: BalloonMarker {
    public var xAxisValueFormatter: IAxisValueFormatter
    fileprivate var yAxisValueFormatter = LargeValueFormatter()
    
    public init(color: UIColor, font: UIFont, textColor: UIColor, insets: UIEdgeInsets,
                xAxisValueFormatter: IAxisValueFormatter) {
        self.xAxisValueFormatter = xAxisValueFormatter
        super.init(color: color, font: font, textColor: textColor, insets: insets)
    }
    
    public override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        let string = /* xAxisValueFormatter.stringForValue(entry.x, axis: XAxis())
            + */ yAxisValueFormatter.stringForValue(entry.y, axis: YAxis())
        setLabel(string)
    }
    
}

final class CustomFormatter: IAxisValueFormatter {
    
    var labels: [String] = []
    
    init(labels: [String]) {
        self.labels = labels
    }
    
    lazy private var dateFormatter: DateFormatter = {
        // set up date formatter using locale
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "M-d"
        return dateFormatter
    }()
    
    func toDate(dateString: String) -> Date? {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.date(from: dateString)
    }
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let index = Int(value)
        
        guard index < labels.count, let date = toDate(dateString: labels[index]) else {
            return "?"
        }
        
        return dateFormatter.string(from: date)
    }
}

final class XAxisRendererWithTicks: XAxisRenderer {
    
    override func drawLabel(context: CGContext, formattedLabel: String, x: CGFloat, y: CGFloat, attributes: [NSAttributedString.Key: Any], constrainedToSize: CGSize, anchor: CGPoint, angleRadians: CGFloat) {
        
        super.drawLabel(context: context, formattedLabel: formattedLabel, x: x, y: y, attributes: attributes, constrainedToSize: constrainedToSize, anchor: anchor, angleRadians: angleRadians)
        
        context.beginPath()
        
        context.move(to: CGPoint(x: x, y: y))
        context.addLine(to: CGPoint(x: x, y: self.viewPortHandler.contentBottom))
        
        context.strokePath()
    }
}
