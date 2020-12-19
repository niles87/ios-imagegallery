//
//  FilterController.swift
//  ImageCapture
//
//  Created by Niles Bingham on 12/19/20.
//

import UIKit

class FilterController: UIViewController, UIPickerViewDelegate {
    @IBOutlet weak var picker: UIPickerView!
    
    var wheelContents: [[String]] = []
    
    var filters = ["Sepia", "Noir", "Inverted", "MonoColor", "Vintage"]
    var intensity = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wheelContents = [filters, intensity]
    }
    
    func numberOfComponentsInPickerView(picker: UIPickerView) -> Int {
        return wheelContents.count
    }
    
    func pickerView(picker: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return wheelContents[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return wheelContents[component][row]
    }
}
