//
//  ToastMessage.swift
//  CodeExcercise
//
//  Created by fgb on 2/13/18.
//  Copyright © 2018 vimlesh. All rights reserved.
//

import Foundation
import UIKit

/**
 * A simple class which creates a Toast message like Android. This message could be animated from right to left and vice versa or could be displayed as a fade in effect for any operation or event completion to the user. 
 *
 */
class Toast {
    
    class private func showAlert(backgroundColor:UIColor, textColor:UIColor, message:String) {
        DispatchQueue.main.async {
            let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
            let label = UILabel(frame: CGRect.zero)
            label.textAlignment = NSTextAlignment.center
            label.text = message
            label.font = UIFont(name: "Helvetica", size: 15)
            label.adjustsFontSizeToFitWidth = true
            
            label.backgroundColor =  backgroundColor
            label.textColor = textColor
            
            label.sizeToFit()
            label.numberOfLines = 4
            label.layer.shadowColor = UIColor.gray.cgColor
            label.layer.shadowOffset = CGSize(width: 4, height: 3)
            label.layer.shadowOpacity = 0.3
            label.frame = CGRect(x: appDelegate.window!.frame.size.width, y: 64, width: appDelegate.window!.frame.size.width, height: 44)
            
            label.alpha = 1
            
            appDelegate.window!.addSubview(label)
            
            var basketTopFrame: CGRect = label.frame;
            basketTopFrame.origin.x = 0;
            
            UIView.animate(withDuration
                :2.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
                    label.frame = basketTopFrame
            },  completion: {
                (value: Bool) in
                UIView.animate(withDuration:2.0, delay: 1.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
                    label.alpha = 0
                },  completion: {
                    (value: Bool) in
                    label.removeFromSuperview()
                })
            })
        }
    }
    
    /**
     * Class method to create a Positive toast message.
     * @param message The messsage to be displayed.
     *
     */
    class func showPositiveMessage(message:String) {
        showAlert(backgroundColor: UIColor.green, textColor: UIColor.white, message: message)
    }
    
    /**
     * Class method to create a Negative toast message.
     * @param message The messsage to be displayed.
     *
     */
    class func showNegativeMessage(message:String) {
        showAlert(backgroundColor: UIColor.red, textColor: UIColor.white, message: message)
    }
}
