import Foundation
import Charts

open class LargeValueFormatter: NSObject, IValueFormatter, IAxisValueFormatter
{
    fileprivate static let MAX_LENGTH = 5
    fileprivate static let MIN_LENGTH = -5
    
    
    /// Suffix to be appended after the values.
    ///
    /// **default**: suffix: ["", "k", "m", "b", "t"]
    open var suffix = ["p","n","µ", "m", "" ,"k", "M", "G", "T"]
    open var stringMask = ["%2.f", "%2.f", "%2.f", "%2.3f", "%2.f", "%2.1f", "%2.3f", "%2.3f", "%2.3f"]
    
    /// An appendix text to be added at the end of the formatted value.
    open var appendix: String?
    
    open var disableFirst: Bool = false
    
    public override init()
    {
    }
    
    public init(appendix: String?)
    {
        self.appendix = appendix
    }
    
    public init(disableFirst: Bool) {
        self.disableFirst = disableFirst
    }
    
    fileprivate func format(value: Double) -> String
    {
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
        var r = String(format: stringMask[length + 4], sig * sign) + suffix[length + 4]
        
        if appendix != nil
        {
            r += appendix!
        }
        
        return r
    }
    
    open func stringForValue( _ value: Double, axis: AxisBase?) -> String {
        return format(value: value)
    }
    
    open func stringForValue(
        _ value: Double,
        entry: ChartDataEntry,
        dataSetIndex: Int,
        viewPortHandler: ViewPortHandler?) -> String {

        if (disableFirst) && ((entry.data as? Int) == 0) {
            return ""
        }
        return format(value: value)
    }
}
