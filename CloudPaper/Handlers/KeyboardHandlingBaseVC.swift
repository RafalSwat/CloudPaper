//
//  KeyboardHandlingBaseVC.swift
//  CloudPaper
//
//  Created by Rafał Swat on 27/04/2021.
//

import Foundation
import UIKit

class KeyboardHandlingBaseVC: UIViewController {

    @IBOutlet weak var backgroundSV: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subscribeToNotification(UIResponder.keyboardWillShowNotification, selector: #selector(keyboardWillShow))
        subscribeToNotification(UIResponder.keyboardWillHideNotification, selector: #selector(keyboardWillHide))

        initializeHideKeyboard()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromAllNotifications()
    }

}

// MARK : Keyboard Dismissal Handling on Tap
private extension KeyboardHandlingBaseVC {
    
    func initializeHideKeyboard(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
    }
}

// MARK : Textfield Visibility Handling with Scroll
private extension KeyboardHandlingBaseVC {
    
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y -= keyboardSize.height/3
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    

//    @objc func keyboardWillShowOrHide(notification: NSNotification) {
//
//        // Pull a bunch of info out of the notification
//        if let scrollView = backgroundSV, let userInfo = notification.userInfo, let endValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey], let durationValue = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey], let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] {
//
//            // Transform the keyboard's frame into our view's coordinate system
//            let endRect = view.convert((endValue as AnyObject).cgRectValue, from: view.window)
//
//            // Find out how much the keyboard overlaps the scroll view
//            // We can do this because our scroll view's frame is already in our view's coordinate system
//            let keyboardOverlap = scrollView.frame.maxY - endRect.origin.y
//
//            // Set the scroll view's content inset to avoid the keyboard
//            // Don't forget the scroll indicator too!
//            scrollView.contentInset.bottom = keyboardOverlap
//            //scrollView.scrollIndicatorInsets.bottom = keyboardOverlap
//            scrollView.verticalScrollIndicatorInsets.bottom = keyboardOverlap
//
//            let duration = (durationValue as AnyObject).doubleValue
//            let options = UIView.AnimationOptions(rawValue: UInt((curveValue as AnyObject).integerValue << 16))
//            UIView.animate(withDuration: duration!, delay: 0, options: options, animations: {
//                self.view.layoutIfNeeded()
//            }, completion: nil)
//        }
//    }

}
