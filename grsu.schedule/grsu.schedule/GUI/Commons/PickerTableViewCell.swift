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
    
    var items : NSArray? {
        didSet {
            updateHeader(0)
        }
    }
    
    func reloadData() {
        self.pickerView?.reloadAllComponents()
    }
    
    func selectRow(text: String) {
        let index = items?.indexOfObject(text)
        if (index != NSNotFound) {
            pickerView.selectRow(index!, inComponent: 0, animated: true)
            updateHeader(index!)
        }
    }
    
    func selectedRow() -> String {
        let index = pickerView.selectedRowInComponent(0)
        return items![index] as String
    }
    
    func selectedRow() -> Int {
        return pickerView.selectedRowInComponent(0)
    }
    
    private func didSelectRow(row: Int) {
        updateHeader(row)
        
        var text = items![row] as String
        delegate?.pickerTableViewCell(self, didSelectRow: row, withText: text)
    }

    private func updateHeader(row: Int) {
        headerCell.detailTextLabel?.text = items![row] as? String
    }
    
    // Pragma mark - UIPickerViewDataSource

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items?.count ?? 0
    }
    
    // Pragma mark - UIPickerViewDelegate
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return items![row] as String
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        didSelectRow(row)
    }
    
}
