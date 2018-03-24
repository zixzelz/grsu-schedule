//
//  PickerTableViewCell.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 11/13/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


@objc protocol PickerTableViewCellDelegate {
    func pickerTableViewCell(_ cell: PickerTableViewCell, didSelectRow row: Int, withText text: String)
}

class PickerTableViewCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet fileprivate weak var headerCell : UITableViewCell!
    @IBOutlet fileprivate weak var pickerView : UIPickerView!
    
    @IBOutlet fileprivate weak var delegate : PickerTableViewCellDelegate?
    
    var items : Array<String>? {
        didSet {
            pickerView?.reloadAllComponents()
            pickerView?.selectRow(0, inComponent: 0, animated: false)
            updateHeader(0)
        }
    }
    
    func selectRow(_ text: String) {
        let index = items?.index(of: text)
        if (index != nil && index != pickerView.selectedRow(inComponent: 0)) {
            pickerView.selectRow(index!, inComponent: 0, animated: true)
            updateHeader(index!)
        }
    }
    
    func selectedRow() -> String? {

        var text : String?
        if let index = selectedRow() as Int? {
            text = items?[index]
        }
        
        return text
    }
    
    func selectedRow() -> Int? {
        var index : Int? = nil
        
        if (items?.count > 0) {
            index = pickerView.selectedRow(inComponent: 0)
        }
        
        return index
    }
    
    fileprivate func didSelectRow(_ row: Int) {
        updateHeader(row)
        
        let text = items![row] as String
        delegate?.pickerTableViewCell(self, didSelectRow: row, withText: text)
    }

    fileprivate func updateHeader(_ row: Int) {
        var text : String?
        if (items?.count > row) {
            text = items![row]
        }
        headerCell.detailTextLabel?.text = text ?? " "
    }
    
    // MARK: - UIPickerViewDataSource

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items?.count ?? 0
    }
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return items?[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (items?.count > 0) {
            didSelectRow(row)
        }
    }
    
}
