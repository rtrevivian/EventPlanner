//
//  KeyboardController.swift
//  Scrypt
//
//  Created by Richard Trevivian on 11/19/15.
//  Copyright © 2015 Richard Trevivian. All rights reserved.
//

import UIKit

class KeyboardController {
    
    static func addObservers(sender: AnyObject) {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(sender, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(sender, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    static func removeObservers(sender: AnyObject) {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(sender, name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(sender, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    static func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
}
