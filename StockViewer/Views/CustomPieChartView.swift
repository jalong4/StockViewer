//
//  PieChartView.swift
//  StockViewer
//
//  Created by Jim Long on 6/4/21.
//

import SwiftUI
import Charts


struct CustomPieChart: UIViewRepresentable {
    let pieSegments: [PieChart]
    let strokeWidth: Double?
    

    func makeUIView(context: Context) -> some UIView {
        return PieChartView()
    }

    @ViewBuilder var mask: some View {
        if let strokeWidth = strokeWidth {
            Circle().strokeBorder(Color.white, lineWidth: CGFloat(strokeWidth))
        } else {
            Circle()
        }
    }
    
    var body: some View {
        ZStack {
            ForEach(pieSegments) { segment in
                segment
                    .fill(segment.data.color)
            }
        }
        .mask(mask)
    }
}

struct PieChartView_Previews: PreviewProvider {

    static var previews: some View {
        ZStack {
            Color.orange
            PieChart(dataPoints: [
                DataPoint(id: 1, value: 25, color: .red),
                DataPoint(id: 2, value: 32, color: .yellow),
                DataPoint(id: 3, value: 46, color: .green),
                DataPoint(id: 4, value: 12, color: .blue)
            ], strokeWidth: nil)
        }
    }
}
