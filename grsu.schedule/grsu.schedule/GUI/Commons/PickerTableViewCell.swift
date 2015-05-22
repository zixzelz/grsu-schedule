//
//  PickerTableViewCell.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 11/13/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

@objc protocol PickerTableViewCellDelegate {
    func pickerTableViewCell(cell: PickerTableViewCell, didSelectRow row: Int, withText text: String)
}

class PickerTableViewCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet private weak var headerCell : UITableViewCell!
    @IBOutlet private weak var pickerView : UIPickerView!
    
    @IBOutlet private weak var delegate : PickerTableViewCellDelegate?
    
    var items : Array<String>? {
        didSet {
            self.pickerView?.reloadAllComponents()
            updateHeader(0)
        }
    }
    
    func selectRow(text: String) {
        let index = find(items!, text)
        if (index != nil && index != pickerView.selectedRowInComponent(0)) {
            pickerView.selectRow(index!, inComponent: 0, animated: true)
            updateHeader(index!)
        }
    }
    
    func selectedRow() -> String? {
        let index = pickerView.selectedRowInComponent(0)
        
        var text : String?
        if let index = selectedRow() as Int? {
            text = items?[index]
        }
        
        return text
    }
    
    func selectedRow() -> Int? {
        var index : Int? = nil
        
        if (items?.count > 0) {
            index = pickerView.selectedRowInComponent(0)
        }
        
        return index
    }
    
    private func didSelectRow(row: Int) {
        updateHeader(row)
        
        var text = items![row] as String
        delegate?.pickerTableViewCell(self, didSelectRow: row, withText: text)
    }

    private func updateHeader(row: Int) {
        var text : String?
        if (items?.count > row) {
            text = items![row]
        }
        headerCell.detailTextLabel?.text = text ?? " "
    }
    
    // MARK: - UIPickerViewDataSource

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items?.count ?? 0
    }
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return items![row] as String
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (items?.count > 0) {
            didSelectRow(row)
        }
    }
    
}
