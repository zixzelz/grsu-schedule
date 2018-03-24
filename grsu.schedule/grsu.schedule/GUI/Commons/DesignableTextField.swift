//
//  DesignableTextField.swift
//  Intuition
//
//  Created by Ruslan Maslouski on 3/28/15.
//  Copyright (c) 2015 Intuition inc. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableTextField: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        updatePlaceholderStyle()
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.textRect(forBounds: bounds)
        rect.origin.x += leftInset
        rect.size.width -= leftInset + rightInset
        
        return rect
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
    //MARK: Intrface
    
    @IBInspectable var placeholderColor: UIColor = UIColor.white {
        didSet {
            updatePlaceholderStyle()
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var leftInset: CGFloat = 0
    
    @IBInspectable var rightInset: CGFloat = 0

    //MARK: private
    
    fileprivate func updatePlaceholderStyle() {
        if let text = placeholder {
            let attributes = [NSAttributedStringKey.foregroundColor: placeholderColor]
            let attributedString = NSAttributedString(string: text, attributes: attributes)
            
            attributedPlaceholder = attributedString
        }
    }
}
