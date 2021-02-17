//
//  CustomTextField.swift
//  StockViewer
//
//  Created by Jim Long on 2/14/21.
//

import SwiftUI

class CustomUIPickerView: UIPickerView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
}

struct CustomPicker: UIViewRepresentable {
    let dataArrays : [String]
    @Binding var selection: String
    let selectedItemBackgroundColor : Color
    let rowHeight: CGFloat
    let horizontalPadding: CGFloat
    let pickerStyle = WheelPickerStyle()
    
    
    init(_ dataArrays: [String],
         selection: Binding<String>,
         selectedItemBackgroundColor:Color = Color.themeAccent.opacity(0.2),
         rowHeight: CGFloat = 40,
         horizontalPadding:CGFloat = 40) {
        self.dataArrays = dataArrays
        self._selection = selection
        self.selectedItemBackgroundColor = selectedItemBackgroundColor
        self.rowHeight = rowHeight
        self.horizontalPadding = horizontalPadding
    }
    
    func makeCoordinator() -> CustomPicker.Coordinator {
        return CustomPicker.Coordinator(self)
    }
    
    
    func makeUIView(context: Context) -> CustomUIPickerView {
        let picker = CustomUIPickerView(frame: .zero)
        picker.dataSource = context.coordinator
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIView(_ view: CustomUIPickerView, context: UIViewRepresentableContext<CustomPicker>) {
    }
    
    
    
    class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
        var parent: CustomPicker
        init(_ pickerView: CustomPicker) {
            self.parent = pickerView
        }
        
        //Number Of Components:
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        
        //Number Of Rows In Component:
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return parent.dataArrays.count
        }
        
        //Width for component:
        func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
            return UIScreen.main.bounds.width - (parent.horizontalPadding * 2)
        }
        
        //Row height:
        func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
            return parent.rowHeight
        }
        
        //View for Row
        func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
            
            let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - (parent.horizontalPadding * 2), height: parent.rowHeight))
            
            let pickerLabel = UILabel(frame: view.bounds)
            pickerView.subviews[1].backgroundColor = UIColor(self.parent.selectedItemBackgroundColor)
            pickerView.subviews[1].layer.cornerRadius = 20
            pickerLabel.text = parent.dataArrays[row]
            
            pickerLabel.adjustsFontSizeToFitWidth = true
            pickerLabel.textAlignment = .center
            pickerLabel.lineBreakMode = .byWordWrapping
            pickerLabel.numberOfLines = 0
            pickerLabel.backgroundColor = .clear
            
            view.addSubview(pickerLabel)
            
            view.clipsToBounds = true
            view.layer.cornerRadius = view.bounds.height * 0.1
            
            return view
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            self.parent.selection = self.parent.dataArrays[row]
        }
        
        
    }
}
