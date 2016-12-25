//
//  ExpandedScrollView.swift
//
//  Created by Ruslan Maslouski on 11/12/14.
//

import UIKit

extension UIView {
    
    func findFirstResponder() -> UIResponder? {
        if (self.isFirstResponder()) {
            return self;
        }
        
        for subView in self.subviews {
            if let responder = subView.findFirstResponder() {
                return responder
            }
        }
        return nil;
    }
    
}

class ExpandedScrollView: UIScrollView {

    @IBInspectable var autoScrollingToFirstResponder : Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib();
        self.registerKeyboardNotification();
    }
    
    deinit {
       NSNotificationCenter.defaultCenter().removeObserver(self);
    }
    
    //pragma mark - Keyboard Notification
    
    func registerKeyboardNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(ExpandedScrollView.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(ExpandedScrollView.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil);
    }
    
    
    func keyboardWillShow(notification : NSNotification) {
        if (self.window == nil) { return; };
        self.changeViewSizeWithKeyboardNotification(notification, animated: true);
    }
    
    func keyboardWillHide(notification : NSNotification) {
        if (self.window == nil) { return; };
        self.changeViewSizeWithKeyboardNotification(notification, animated: true);
    }
    
    func changeViewSizeWithKeyboardNotification(notification: NSNotification, animated: Bool) {
        var info = notification.userInfo;
        var keyboardEndRect = info![UIKeyboardFrameEndUserInfoKey]?.CGRectValue();
        keyboardEndRect = self.convertRect(keyboardEndRect!, fromView: nil);
        
        let keyboardTopOnScrollView = CGRectGetMinY(keyboardEndRect!) - self.contentOffset.y;
        var bottomSpace = CGRectGetHeight(self.frame) - keyboardTopOnScrollView;
        
        bottomSpace = max(bottomSpace, 0);
        let inset = UIEdgeInsetsMake(0, 0, bottomSpace, 0);
        
        UIView.animateWithDuration(0.25, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.contentInset = inset;
            self.scrollIndicatorInsets = inset;
        }) { (complited) -> Void in
            if (self.autoScrollingToFirstResponder) {
                self.scrollToFirstResponder()
            }
        }
    }
    
    //pragma mark - Utils

    func scrollToFirstResponder() {
        let responder = findFirstResponder()
        if let textInput = responder as? UIView {
            let positionRect = textInput is UITextView ? cursorPositionInTextInput(textInput as! UITextInput) : textInput.bounds
            let positionRectInSelf = self.convertRect(positionRect, fromView: textInput)
            
            self.scrollRectToVisible(positionRectInSelf, animated: true)
        }
    }
    
    func cursorPositionInTextInput(textInput : UITextInput) -> CGRect {
        guard let range = textInput.selectedTextRange else { return CGRectZero }
        let position = range.start
        let cursorRect = textInput.caretRectForPosition(position)
        
        return CGRectInset(cursorRect, 0, -4)
    }
    
}
