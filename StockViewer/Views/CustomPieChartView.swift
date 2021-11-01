//
//  CustomPieChartView.swift
//  StockViewer
//
//  Created by Jim Long on 6/4/21.
//

import Charts
import SwiftUI


struct CustomPieChartView: UIViewRepresentable {
    
    var entries: [PieChartDataEntry] = []
    var date: String = ""
    let pieChart = PieChartView()
    
    static func format(value: Double) -> String
    {
        let suffix = ["p","n","µ", "m", "" ,"k", "M", "G", "T"]
        let stringMask = ["%2.f", "%2.f", "%2.f", "%2.3f", "%2.f", "%2.1f", "%2.3f", "%2.3f", "%2.3f"]
        var sign = 0.0
        var sig = abs(value)
        if value == 0
        {
            sign = 1
        }
        else
        {
            sign = value / abs(value)
            
        }
        var length = 0
        let maxLength = (suffix.count / 2) - 1
        
        if sig >= 1000
        {
            while sig >= 1000.0 && length < maxLength
            {
                sig /= 1000.0
                length += 1
            }
        }
        else
        {
            while sig <= 1 && length < maxLength
            {
                sig *= 1000.0
                length += 1
            }
        }
        if value == 0
        {
            length = 0
        }
        let r = String(format: stringMask[length + 4], sig * sign) + suffix[length + 4]
        
        return r
    }
    
    private var label: String {
        return "\(date)\n" + CustomPieChartView.format(value: entries.reduce(0) { $0 + $1.value})
        
    }

    func makeUIView(context: Context) -> PieChartView {
        pieChart.delegate = context.coordinator
        return pieChart
    }
    
    func updateUIView(_ uiView: PieChartView, context: Context) {
        let dataSet = PieChartDataSet(entries: entries)
        dataSet.colors = ChartColorTemplates.colorful() + ChartColorTemplates.joyful() + ChartColorTemplates.material()
        let pieChartData = PieChartData(dataSet: dataSet)
        uiView.data = pieChartData
        configureChart(uiView)
        formatCenter(uiView)
        formatDescription(uiView.chartDescription!)
        formatLegend(uiView.legend)
        formatDataSet(dataSet)
        uiView.notifyDataSetChanged()
    }
    
    class Coordinator: NSObject, ChartViewDelegate {
        var parent: CustomPieChartView
        init(parent: CustomPieChartView) {
            self.parent = parent
        }
        func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
            let labelText = entry.value(forKey: "label")! as! String
            let value = entry.value(forKey: "value")! as! Double
            parent.pieChart.centerText = "\(labelText)\n\(CustomPieChartView.format(value: value))"
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func configureChart( _ pieChart: PieChartView) {
        pieChart.rotationEnabled = false
        pieChart.animate(xAxisDuration: 0.5, easingOption: .easeInOutCirc)
        pieChart.drawEntryLabelsEnabled = false
        pieChart.highlightValue(x: -1, dataSetIndex: 0, callDelegate: false)
    }
    
    func formatCenter(_ pieChart: PieChartView) {
        pieChart.holeColor = UIColor.systemBackground
        pieChart.centerText = label
        pieChart.centerTextRadiusPercent = 0.95
    }
    
    func formatDescription( _ description: Description) {
        description.enabled = false
    }
    
    func formatLegend(_ legend: Legend) {
        legend.enabled = false
    }
    
    func formatDataSet(_ dataSet: ChartDataSet) {
        dataSet.drawValuesEnabled = false
    }

}

struct CustomPieChartView_Previews: PreviewProvider {
    
    static var history: History = Api.getMockHistory().last!
    static var date = history.date
    static var data = history.data.summary.accounts.map { PieChartDataEntry(value: $0.total, label: $0.name)}
    
    
    static var previews: some View {
        CustomPieChartView(entries: data, date: date)
        .frame(height: 400)
        .padding()
    }
}

