
//  ViewController.swift
//  HouseKeeping
//  Created by Apple-1 on 5/30/17.
//  Copyright © 2017 Apple-1. All rights reserved.


import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner
import Firebase
import FirebaseAuth

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var login: UIButton!
    @IBAction func loginClick() {
        self.LoginFIrebase()
    }
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var scrl: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrl.contentSize = CGSize(width : self.view.frame.width, height : self.view.frame.height+100)
        autoreleasepool {
            if let accessToken = defaults.string(forKey: "AccessToken")
            {
                if accessToken != "" {
                    print(" TOKEN is Already there ... so go directly to DASHBOARD ||||||  ")
                    if accessToken == "3" {
                        self.switchToEmployeeLoginScreen()
                    } else if accessToken == "2" {
                        self.switchToAdminLoginScreen()
                    } else if accessToken == "1" {
                        self.switchToAdminLoginScreen()
                    }
                } else{
                    print(" No TOKEN Stay in sign in ||||||  ")
                }
            }
            
            username.delegate = self
            password.delegate = self
            
            // Do any additional setup after loading the view, typically from a nib.
            let myColorWhite2 : UIColor = UIColor.white
            login.layer.cornerRadius =  5.0
            login.layer.borderWidth = 1
            login.layer.borderColor = myColorWhite2.cgColor
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
    
    func LoginFIrebase() {
        SwiftSpinner.show("Authenticating sever please wait")
        let firebaseAuth = Auth.auth()
        firebaseAuth.signIn(withEmail: self.username.text!, password: self.password.text!) { (user, error) in
            if error != nil {
                // print(" error != nil" , error!)
                SwiftSpinner.hide()
                let alert = UIAlertController(title: "Alert", message: "Invalid Credentials", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                let userID: String = firebaseAuth.currentUser!.uid
                UserDefaults.standard.set(String(describing: userID), forKey: "userIDFirebase")
                let emailVerified = user?.isEmailVerified
                if emailVerified == false {
                    SwiftSpinner.show(duration: 5.0, title: "User Not Verified... A verification Email has been sent. Please verify now.", animated: false)
                    firebaseAuth.currentUser?.sendEmailVerification { (error) in
                        // ...
                    }
                } else {
                    let notificationToken = self.defaults.string(forKey: "NotificationToken")
                    let String1 = HKURL + "/getjson/userdetails/" + userID + "/" + notificationToken!
                    Alamofire.request(String1, method: .get, parameters: [:], encoding: JSONEncoding.default, headers: ["Content-Type":"application/json"]).responseJSON {
                        response in
                        switch response.result {
                        case .success(let value):
                            let jsonObject = JSON(value)
                            print("LOGIN ", jsonObject)
                            let status = String(describing: jsonObject["employeeStatusID"])
                            let ActiveUser = String(describing: jsonObject["enableYN"])
                            let activeYN = String(describing: jsonObject["activeYN"])
                            self.defaults.set(String(describing: jsonObject["employeeID"]), forKey: "employeeIDLogin")
                            self.defaults.set(String(describing: jsonObject["name"]), forKey: "name")
                            self.defaults.set(String(describing: jsonObject["email"]), forKey: "email")
                            self.defaults.set(String(describing: jsonObject["userMobileID"]), forKey: "userMobileIDs")
                            self.defaults.set(String(describing: jsonObject["branchID"]), forKey: "branchID")
                            self.defaults.set(String(describing: jsonObject["employeeStatusID"]), forKey: "employeeStatusID")
                            self.defaults.set(String(describing: jsonObject["branchName"]), forKey: "branchName")
                            self.defaults.set(String(describing: jsonObject["hotelName"]), forKey: "hotelName")
                            self.defaults.set(String(describing: jsonObject["superUserMobileId"]), forKey: "superUserMobileId")
                            self.defaults.set(String(describing: jsonObject["adminUserMobileId"]), forKey: "adminUserMobileId")
                            if activeYN == "false" {
                                SwiftSpinner.show(duration: 3.0, title: "User Already Logged in.", animated: false)
                            } else {
                                if ActiveUser == "true" {
                                    if status == "0" {
                                        SwiftSpinner.show(duration: 3.0, title: "Authentication Failed... Invalid User", animated: false)
                                    } else if status == "1" {
                                        self.defaults.set("1", forKey: "AccessToken")
                                        SwiftSpinner.hide()
                                        self.switchToAdminLoginScreen()
                                    } else if status == "3" {
                                        self.defaults.set("3", forKey: "AccessToken")
                                        SwiftSpinner.hide()
                                        self.switchToEmployeeLoginScreen()
                                    } else if status == "2" {
                                        self.defaults.set("2", forKey: "AccessToken")
                                        SwiftSpinner.hide()
                                         self.switchToAdminLoginScreen()
                                    }
                                } else {
                                    SwiftSpinner.show(duration: 3.0, title: "User Disabled", animated: false)
                                }
                            }
                            break
                        case .failure(let error):
                            print("Login API Failure ", error)
                            SwiftSpinner.hide()
                            self.username.text = ""
                            self.password.text = ""
                            print(error)
                            SwiftSpinner.show(duration: 3.0, title: "Login Failed", animated: false)
                            break
                        }
                    }
                }
            }
        }
    }
    
    func switchToAdminLoginScreen() {
        OperationQueue.main.addOperation {  // run in main thread
            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "DashBoard") as UIViewController
            self.present(vc, animated: true, completion: nil)
        }
    }
    func switchToEmployeeLoginScreen() {
        OperationQueue.main.addOperation {  // run in main thread
            let mainStoryboard2 = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vc2 : UIViewController = mainStoryboard2.instantiateViewController(withIdentifier: "EmployeeDashboard") as UIViewController
            self.present(vc2, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


