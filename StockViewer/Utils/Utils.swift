//
//  Utils.swift
//  StockViewer
//
//  Created by Jim Long on 2/5/21.
//

import SwiftUI

class Utils {
    
    class func getColor(_ value: Double) -> Color {
        
        if (value > 0) { return Color(red:19/255, green:130/255, blue:63/255) }
        if (value < 0) { return Color(red:232/255, green:35/255, blue:50/255) }
        return Color.black
    }
    
    private class func getFormatted(_ doubleValue: Double, _ fractionDigits:Int = 2, style:NumberFormatter.Style = .decimal) -> String {
        let number = NSNumber(value: doubleValue)
        let formatter = NumberFormatter()
        formatter.numberStyle = style
        formatter.minimumFractionDigits = fractionDigits
        formatter.maximumFractionDigits = fractionDigits
        return formatter.string(from: number)!
    }
    
    
    class func getFormattedNumber(_ doubleValue: Double, fractionDigits:Int = 2) -> String {
        return getFormatted(doubleValue, fractionDigits)
    }
    
    class func getFormattedPercent(_ doubleValue: Double, fractionDigits:Int = 2) -> String {
        return getFormatted(doubleValue, fractionDigits, style: .percent)
    }
    
    class func getFormattedCurrency(_ doubleValue: Double, fractionDigits:Int = 2) -> String {
        return getFormatted(doubleValue, fractionDigits, style: . currency)
    }
    
    class func getFormattedGain(gain: Double, percent: Double, fractionDigits:Int = 2) -> String {
        return getFormattedCurrency(gain) + " (" + getFormattedPercent(percent) + ")"
    }
    
    class func getColorCodedTextView(_ doubleValue: Double, fractionDigits:Int = 2, style:NumberFormatter.Style = .decimal) -> Text {
        return Text (Utils.getFormatted(doubleValue, fractionDigits, style: style))
            .foregroundColor(Utils.getColor(doubleValue))
    }
    
    class func getGreenColor() -> Color {
        return Color(red:19/255, green:130/255, blue:63/255) 
    }
    
}