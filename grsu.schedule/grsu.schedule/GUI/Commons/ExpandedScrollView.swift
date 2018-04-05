//
//  ExpandedScrollView.swift
//
//  Created by Ruslan Maslouski on 11/12/14.
//

import UIKit

extension UIView {

    func findFirstResponder() -> UIResponder? {
        if (self.isFirstResponder) {
            return self
        }

        for subView in self.subviews {
            if let responder = subView.findFirstResponder() {
                return responder
            }
        }
        return nil
    }

}

class ExpandedScrollView: UIScrollView {

    @IBInspectable var autoScrollingToFirstResponder: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
        registerKeyboardNotification()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    //pragma mark - Keyboard Notification

    func registerKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(ExpandedScrollView.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ExpandedScrollView.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    @objc func keyboardWillShow(_ notification: Foundation.Notification) {
        guard let _ = window else { return }
        changeViewSizeWithKeyboardNotification(notification, animated: true)
    }

    @objc func keyboardWillHide(_ notification: Foundation.Notification) {
        guard let _ = window else { return }
        changeViewSizeWithKeyboardNotification(notification, animated: true)
    }

    func changeViewSizeWithKeyboardNotification(_ notification: Foundation.Notification, animated: Bool) {
        var info = notification.userInfo
        guard let rect = (info?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue else {
            return
        }

        let keyboardEndRect = convert(rect, from: nil)
        let keyboardTopOnScrollView = keyboardEndRect.minY - contentOffset.y
        var bottomSpace = frame.height - keyboardTopOnScrollView

        bottomSpace = max(bottomSpace, 0)
        let inset = UIEdgeInsetsMake(0, 0, bottomSpace, 0)

        UIView.animate(withDuration: 0.15, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
            self.contentInset = inset
            self.scrollIndicatorInsets = inset
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
            let positionRectInSelf = convert(positionRect, from: textInput)

            self.scrollRectToVisible(positionRectInSelf, animated: true)
        }
    }

    func cursorPositionInTextInput(_ textInput: UITextInput) -> CGRect {
        guard let range = textInput.selectedTextRange else { return CGRect.zero }
        let position = range.start
        let cursorRect = textInput.caretRect(for: position)

        return cursorRect.insetBy(dx: 0, dy: -4)
    }

}
