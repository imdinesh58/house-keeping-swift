//
//  Forgotpassword.swift
//  HouseKeeping
//
//  Created by Apple-1 on 9/28/17.
//  Copyright © 2017 Apple-1. All rights reserved.
//

import UIKit
import SwiftSpinner
import Firebase
import FirebaseAuth
import Foundation

class Forgotpassword: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var enterusername: UITextField!
    @IBOutlet weak var reset: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        autoreleasepool {
            enterusername.delegate = self
            let myColorWhite2 : UIColor = UIColor.white
            reset.layer.cornerRadius = 5.0
            reset.layer.borderWidth = 1
            reset.layer.borderColor = myColorWhite2.cgColor
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true;
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) { // became first responder
        //move textfields up
        let myScreenRect: CGRect = UIScreen.main.bounds
        let keyboardHeight : CGFloat = 216
        UIView.beginAnimations( "animateView", context: nil)
        var movementDuration:TimeInterval = 0.35
        var needToMove: CGFloat = 0
        var frame : CGRect = self.view.frame
        if (textField.frame.origin.y + textField.frame.size.height + UIApplication.shared.statusBarFrame.size.height > (myScreenRect.size.height - keyboardHeight - 30)) {
            needToMove = (textField.frame.origin.y + textField.frame.size.height + UIApplication.shared.statusBarFrame.size.height) - (myScreenRect.size.height - keyboardHeight - 30);
        }
        frame.origin.y = -needToMove
        self.view.frame = frame
        UIView.commitAnimations()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //move textfields back down
        UIView.beginAnimations( "animateView", context: nil)
        var movementDuration:TimeInterval = 0.35
        var frame : CGRect = self.view.frame
        frame.origin.y = 0
        self.view.frame = frame
        UIView.commitAnimations()
    }
    
    @IBAction func Reset() {
        autoreleasepool {
            if self.enterusername.text == "" {
                let alert = UIAlertController(title: "Alert", message: "Enter Username", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            } else {
                _ = Auth.auth().sendPasswordReset(withEmail: self.enterusername.text!) { error in
                    
                    if error != nil {
                        let alert = UIAlertController(title: "Alert", message: "Enter Registered Username", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        self.switchToLoginScreen()
                    }
                    
                }
            }
        }
    }
    
    func switchToLoginScreen() {
        autoreleasepool {
            SwiftSpinner.show(duration: 4.0, title: "Password reset link has been sent to your mail", animated: false)
            DispatchQueue.main.asyncAfter(deadline: .now() + (4.0)) {
                self.switchSceen()
            }
        }
    }
    
    func switchSceen() {
        OperationQueue.main.addOperation {  // run in main thread
            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "login") as UIViewController
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
