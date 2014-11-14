//
//  PickerTableViewCell.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 11/13/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

class PickerTableViewCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet var headerCell : UITableViewCell!
    @IBOutlet var pickerView : UIPickerView!
    
    var items : NSArray? {
        didSet {
            updateHeader(0)
        }
    }
    
    func reloadData() {
        self.pickerView?.reloadAllComponents()
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
        updateHeader(row)
    }
    
}
