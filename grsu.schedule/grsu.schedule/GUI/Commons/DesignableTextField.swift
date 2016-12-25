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
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        var rect = super.textRectForBounds(bounds)
        rect.origin.x += leftInset
        rect.size.width -= leftInset + rightInset
        
        return rect
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return textRectForBounds(bounds)
    }
    
    //MARK: Intrface
    
    @IBInspectable var placeholderColor: UIColor = UIColor.whiteColor() {
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
    
    @IBInspectable var borderColor: UIColor = UIColor.whiteColor() {
        didSet {
            self.layer.borderColor = borderColor.CGColor
        }
    }
    
    @IBInspectable var leftInset: CGFloat = 0
    
    @IBInspectable var rightInset: CGFloat = 0

    //MARK: private
    
    private func updatePlaceholderStyle() {
        if let text = placeholder {
            let attributes = [NSForegroundColorAttributeName: placeholderColor]
            let attributedString = NSAttributedString(string: text, attributes: attributes)
            
            attributedPlaceholder = attributedString
        }
    }
}
