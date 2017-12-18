//
//  currentTask.swift
//  HouseKeeping
//
//  Created by Apple-1 on 7/21/17.
//  Copyright © 2017 Apple-1. All rights reserved.
//

import UIKit
import Fusuma
import Alamofire
import SwiftSpinner
import UserNotifications
import SwiftyJSON

class currentTask: UIViewController,UNUserNotificationCenterDelegate, UIApplicationDelegate,FusumaDelegate {
    @IBOutlet weak var TimerLbl: UILabel!
    let defaults = UserDefaults.standard
    var seconds: UInt = 0
    //var timer = Timer()
    var timer: Timer?
    var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
    var isTimerRunning = false
    var resumeTapped = false
    @IBOutlet weak var startLabel: UIButton!
    @IBOutlet weak var breakLabel: UIButton!
    @IBOutlet weak var DNDBtn: UIButton!
    @IBOutlet weak var MarkCompBtn: UIButton!
    
    var _assignedTaskID_ : String  = ""
    var _taskStatusID_ : String  = ""
    var _TasksListId_ : String = ""
    var _AssignedByRole_ : String = ""
    var _Duration_ : String = ""
    
    @IBOutlet weak var scrollViews: UIScrollView!
    
    private var notification: NSObjectProtocol?
    
    var userMobileIDsArr: [String] = []
    
    @IBOutlet weak var taskDuration: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let myColorWhite2 : UIColor = UIColor.white
        startLabel.layer.cornerRadius =  5.0
        startLabel.layer.borderWidth = 1
        startLabel.layer.borderColor = myColorWhite2.cgColor
        breakLabel.layer.cornerRadius =  5.0
        breakLabel.layer.borderWidth = 1
        breakLabel.layer.borderColor = myColorWhite2.cgColor
        DNDBtn.layer.cornerRadius =  5.0
        DNDBtn.layer.borderWidth = 1
        DNDBtn.layer.borderColor = myColorWhite2.cgColor
        MarkCompBtn.layer.cornerRadius =  5.0
        MarkCompBtn.layer.borderWidth = 1
        MarkCompBtn.layer.borderColor = myColorWhite2.cgColor
        
        let DR = _Duration_.components(separatedBy: ":")
        let NewStr = "This task should be completed within " + DR[0] + " hrs : " + DR[1] + " mins"
        taskDuration.text = NewStr
        objects9.removeAll()
        //print("_AssignedByRole_  CurrentTask = " , _AssignedByRole_)
        userMobileIDsArr.removeAll()
        
        GetDeviceNotificationID()
        
        if #available(iOS 10.0, *) {
            //Seeking permission of the user to display app notifications
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge], completionHandler: {didAllow,Error in })
            UNUserNotificationCenter.current().delegate = self
        }
        breakLabel?.alpha = 0.38
        breakLabel?.titleLabel?.alpha = 0.38
        self.defaults.set("TimerNotstarted", forKey: "TIMER")
        let TIMERR = defaults.string(forKey: "TIMER")
        if TIMERR == "Timerstarted" {
            NotificationCenter.default.addObserver(self, selector: #selector(myObserverMethod), name:NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(reinstateBackgroundTask), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    public func fusumaVideoCompleted(withFileURL fileURL: URL) {
        print("video completed and output to file: \(fileURL)")
    }
    
    let fusuma = FusumaViewController()
    @IBAction func ChooseImage() {
        // Show Fusuma
        fusuma.delegate = self
        fusuma.cropHeightRatio = 0.6
        fusuma.hasVideo = false
        fusuma.allowMultipleSelection = true
        fusumaSavesImage = true
        self.present(fusuma, animated: true, completion: nil)
    }
    
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        objects9.removeAll()
        switch source {
        case .camera:
            print("Image captured from Camera")
        case .library:
            print("Image selected from Camera Roll")
        default:
            print("Image selected")
        }
        let imageWidth:CGFloat = 100
        let imageHeight:CGFloat = 100
        let yPosition:CGFloat = 15
        var xPosition:CGFloat = 5
        var scrollViewContentSize:CGFloat=0;
        let myImageView:UIImageView = UIImageView()
        myImageView.image = image
        print("CAMERA Imaged " , image)
        myImageView.contentMode = UIViewContentMode.scaleAspectFit
        myImageView.frame.size.width = imageWidth
        myImageView.frame.size.height = imageHeight
        myImageView.center = self.view.center
        myImageView.frame.origin.y = yPosition
        myImageView.frame.origin.x = xPosition
        myImageView.layer.borderWidth = 1.0
        myImageView.layer.masksToBounds = false
        myImageView.clipsToBounds = true
        myImageView.layer.cornerRadius = myImageView.frame.size.width/2
        self.scrollViews.addSubview(myImageView)
        let spacer:CGFloat = 30
        xPosition+=imageHeight + spacer
        scrollViewContentSize+=imageHeight + spacer
        self.scrollViews.contentSize = CGSize(width: scrollViewContentSize, height: imageWidth)
        let thisObj = saveGalleryImage2(saveimages2: image)
        objects9.append(thisObj)
        print("objects9  CAMERA ", objects9)
    }
    
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode, metaData: ImageMetadata) {
        print("Location: \(String(describing: metaData.location))")
    }
    
    func fusumaDismissedWithImage(_ image: UIImage, source: FusumaMode) {
        switch source {
        case .camera:
            print("Called just after dismissed FusumaViewController using Camera")
        case .library:
            print("Called just after dismissed FusumaViewController using Camera Roll")
        default:
            print("Called just after dismissed FusumaViewController")
        }
    }
    
    func fusumaCameraRollUnauthorized() {
        let alert = UIAlertController(title: "Access Requested",
                                      message: "Saving image needs to access your photo album",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { (action) -> Void in
            if let url = URL(string:UIApplicationOpenSettingsURLString) {
                UIApplication.shared.openURL(url)
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {
        print("Number of selection images: \(images.count)")
        var count: Double = 0
        let imageWidth:CGFloat = 100
        let imageHeight:CGFloat = 100
        let yPosition:CGFloat = 15
        var xPosition:CGFloat = 5
        var scrollViewContentSize:CGFloat=0;
        objects9.removeAll()
        for myImageView in scrollViews.subviews
        {
            if myImageView.tag == 1004
            {
                myImageView.removeFromSuperview()
            }
        }
        for image in images {
            DispatchQueue.main.async() {
                let myImageView:UIImageView = UIImageView()
                myImageView.image = image
                print("GALLERY  " , image)
                myImageView.contentMode = UIViewContentMode.scaleAspectFill
                myImageView.frame.size.width = imageWidth
                myImageView.frame.size.height = imageHeight
                myImageView.center = self.view.center
                myImageView.tag = 1004
                myImageView.frame.origin.y = yPosition
                myImageView.frame.origin.x = xPosition
                myImageView.layer.borderWidth = 1.0
                myImageView.layer.borderColor = UIColor.white.cgColor
                myImageView.layer.masksToBounds = false
                myImageView.clipsToBounds = true
                myImageView.layer.cornerRadius = myImageView.frame.size.width/2
                self.scrollViews.addSubview(myImageView)
                let spacer:CGFloat = 30
                xPosition+=imageHeight + spacer
                scrollViewContentSize+=imageHeight + spacer
                self.scrollViews.contentSize = CGSize(width: scrollViewContentSize, height: imageWidth)
                let thisObj = saveGalleryImage2(saveimages2: image)
                objects9.append(thisObj)
            }
        }
        print("objects79 GALLERY  ", objects9)
        count += 1
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func reinstateBackgroundTask() {
        if timer != nil && (backgroundTask == UIBackgroundTaskInvalid) {
            registerBackgroundTask()
        }
    }
    
    //To display notifications when app is running  inforeground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }
    
    func endBackgroundTask() {
        print("Background task ended.")
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = UIBackgroundTaskInvalid
    }
    
    @objc private func myObserverMethod(notification : NSNotification) {
        DNDBtn?.alpha = 0.38
        DNDBtn?.titleLabel?.alpha = 0.38
        self.localNotify()
    }
    
    var initialCLick = false
    @IBAction func StartTimer() {
        initialCLick = true
        if isTimerRunning == false {
            seconds = 0
            startLabel.alpha = 0.38
            startLabel.titleLabel?.alpha = 0.38
            breakLabel.alpha = 1
            breakLabel.titleLabel?.alpha = 1
            DNDBtn?.alpha = 0.38
            DNDBtn?.titleLabel?.alpha = 0.38
            runTimer()
            self.localNotify()
            changeStatusAPICall_Start()
            NOtifyStartAdmin()
            self.defaults.set("Timerstarted", forKey: "TIMER")
            let TIMERR = defaults.string(forKey: "TIMER")
            if TIMERR == "Timerstarted" {
                NotificationCenter.default.addObserver(self, selector: #selector(myObserverMethod), name:NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
            }
        }
    }
    
    var ImageArr: String = ""
    
    func changeStatusAPICall_Start() {
        let date = Date()
        let originalString = "C:\\Housekeeping_Directory"
        let newString2:String?
        newString2 = originalString.replacingOccurrences(of: "\\", with: "\\\\", options: .literal, range: nil)
        let postString2 = "2"
        let postString3 = "0"
        let df = DateFormatter()
        df.dateFormat = "dd-mm-yy-hh-mm-ss"
        for object in objectsEmpLogin {
            if(_assignedTaskID_.contains(String(object.assignedTaskID))){
                ImageArr = object.imageCount
            }
        }
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            print("WHILE SEND " , objects9.count)
            for objects in objects9 {
                print("WHILE SEND FOR " , objects)
                let test = objects.saveimages2 as UIImage
                // let conV = UIImagePNGRepresentation(test)
                let conV = UIImageJPEGRepresentation(test, 0.4)
                let imageName = df.string(from: date as Date)
                multipartFormData.append(conV!, withName: "file", fileName: "\(imageName).png", mimeType: "image/png")
            }
            multipartFormData.append((self._assignedTaskID_.data(using: .utf8))!, withName: "taskID")
            multipartFormData.append((postString2.data(using: .utf8))!, withName: "taskStatusID")
            multipartFormData.append((postString3.data(using: .utf8))!, withName: "checkListIds")
            multipartFormData.append((self.ImageArr.data(using: .utf8))!, withName: "imageCount")
            multipartFormData.append((newString2?.data(using: .utf8)!)!, withName: "imageDirectory")
        },to: HKURL+"/putvalue/updatetaskstatus/",method: .post, headers: nil,
          encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.response { response in
                    print("SEND IMAGE TO SERVER API SUCCESS " , response)
                }
            case .failure(let encodingError):
                print("SEND IMAGE TO SERVER API ERROR ", encodingError)
            }
        })
    }
    
    var userMIDs1: String = ""
    var userMIDs2: String = ""
    func GetDeviceNotificationID() {
        let URI = "http://54.68.128.183:8080//HouseKeeping/getjson/adminsuperusermobileids/"
        let UID = UserDefaults.standard.string(forKey: "userIDFirebase")
        Alamofire.request(URI + UID!, method: .get, parameters: [:], encoding: URLEncoding.default, headers: ["Content-Type":"application/json"]).responseJSON {
            response in
            switch response.result {
            case .success( let value):
                let jsonObject = JSON(value)
                print("GetDeviceNotificationID ", jsonObject)
                
                self.userMIDs1 = String(describing: jsonObject["adminUserMobileId"])
                self.userMIDs2 = String(describing: jsonObject["superUserMobileId"])
                
                break
            case .failure( let error):
                print(" API Failure")
                print(error)
                break
            }
        }
    }
    
    func NOtifyStartAdmin() {
        let namee = self.defaults.string(forKey: "name")
        let test = "Employee " + namee! + " started to work from assigned task"
        /*let userMobileIDs:String?
         userMobileIDs = self.defaults.string(forKey: "adminUserMobileId")
         if _AssignedByRole_ == "2" {
         let params = [
         "to" : userMobileIDs!,
         "notification": [
         "body": test,
         "title": "Assigned Task Started",
         "icon" : "appicon"
         ]
         ] as [String : Any]
         Alamofire.request("https://fcm.googleapis.com/fcm/send", method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json","Authorization": "key=AAAAwqPRhzU:APA91bEt7g8zgMgaiol6RodUOk0NB4q5vpGubNrOTNVMLa1dNCs1dTrDr09XemCN9mT7zm-LkbbQXh2HduOO3APPDtF__QfdJ-C307l8KnYyziKdvozcRwJmg7-W0KV1rweA-gE7xX6N"]).responseJSON {
         response in
         switch response.result {
         case .success(let value):
         let jsonArray = JSON(value)
         //print("jsonArray " , value)
         let status = jsonArray["success"]
         if status == 0 {
         print("Notification FAILURE ")
         } else {
         print("Notification SUCCESS ")
         }
         
         break
         case .failure(let error):
         print("Notification API Failure" , error)
         break
         }
         }
         } else if _AssignedByRole_ == "1" { */
        userMobileIDsArr.removeAll()
        userMobileIDsArr.append(self.userMIDs1)
        userMobileIDsArr.append(self.userMIDs2)
        print("START userMobileIDsArr ", userMobileIDsArr)
        let params = [
            "results" : [],
            "notification": [
                "body": test,
                "title": "Assigned Task Started",
                "icon" : "appicon",
                "sound" : "default"
            ],
            "registration_ids" : userMobileIDsArr
            ] as [String : Any]
        
        Alamofire.request("https://fcm.googleapis.com/fcm/send", method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json","Authorization": "key=AAAAwqPRhzU:APA91bEt7g8zgMgaiol6RodUOk0NB4q5vpGubNrOTNVMLa1dNCs1dTrDr09XemCN9mT7zm-LkbbQXh2HduOO3APPDtF__QfdJ-C307l8KnYyziKdvozcRwJmg7-W0KV1rweA-gE7xX6N"]).responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let jsonArray = JSON(value)
                //print("jsonArray " , value)
                let status = jsonArray["success"]
                if status == 0 {
                    print("Notification FAILURE ")
                } else {
                    print("Notification SUCCESS ")
                }
                
                break
            case .failure(let error):
                print("Notification API Failure" , error)
                break
            }
        }
        //}
    }
    
    let center = UNUserNotificationCenter.current()
    let content = UNMutableNotificationContent()
    func localNotify () {
        content.title = "In Progress Task"
        content.body = "One Task is in Progress !"
        content.badge = 1
        //content.sound = UNNotificationSound.default()
        
        //Setting time for notification trigger
        let date = Date(timeIntervalSinceNow: 1)
        let dateCompenents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateCompenents, repeats: true)
        //Adding Request
        let request = UNNotificationRequest(identifier: "myNotif", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    @IBAction func Break() {
        DNDBtn?.alpha = 0.38
        DNDBtn?.titleLabel?.alpha = 0.38
        if initialCLick == true {
            if self.resumeTapped == false {
                timer?.invalidate()
                self.resumeTapped = true
                breakLabel.setTitle("Resume", for: .normal)
                NOtifyBreakAdmin()
            } else {
                runTimer()
                let TIMERR = defaults.string(forKey: "TIMER")
                if TIMERR == "Timerstarted" {
                    NotificationCenter.default.addObserver(self, selector: #selector(myObserverMethod), name:NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
                }
                self.resumeTapped = false
                breakLabel.setTitle("Break", for: .normal)
                NOtifyResumeAdmin()
                UIApplication.shared.applicationIconBadgeNumber = 0
            }
        }
    }
    
    func NOtifyBreakAdmin() {
        let namee = self.defaults.string(forKey: "name")
        let test = "Employee " + namee! + " taking break from assigned task"
        /* let userMobileIDs:String?
         userMobileIDs = self.defaults.string(forKey: "adminUserMobileId")
         if _AssignedByRole_ == "2" {
         let params = [
         "to" : userMobileIDs!,
         "notification": [
         "body": test,
         "title": "Assigned Task Paused",
         "icon" : "appicon"
         ]
         ] as [String : Any]
         Alamofire.request("https://fcm.googleapis.com/fcm/send", method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json","Authorization": "key=AAAAwqPRhzU:APA91bEt7g8zgMgaiol6RodUOk0NB4q5vpGubNrOTNVMLa1dNCs1dTrDr09XemCN9mT7zm-LkbbQXh2HduOO3APPDtF__QfdJ-C307l8KnYyziKdvozcRwJmg7-W0KV1rweA-gE7xX6N"]).responseJSON {
         response in
         switch response.result {
         case .success(let value):
         let jsonArray = JSON(value)
         //print("jsonArray " , value)
         let status = jsonArray["success"]
         if status == 0 {
         print("Notification FAILURE ")
         } else {
         print("Notification SUCCESS ")
         }
         
         break
         case .failure(let error):
         print("Notification API Failure" , error)
         break
         }
         }
         } else if _AssignedByRole_ == "1" { */
        userMobileIDsArr.removeAll()
        userMobileIDsArr.append(self.userMIDs1)
        userMobileIDsArr.append(self.userMIDs2)
        
        let params = [
            "results" : [],
            "notification": [
                "body": test,
                "title": "Assigned Task Paused",
                "icon" : "appicon",
                "sound" : "default"
            ],
            "registration_ids" : userMobileIDsArr
            ] as [String : Any]
        
        Alamofire.request("https://fcm.googleapis.com/fcm/send", method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json","Authorization": "key=AAAAwqPRhzU:APA91bEt7g8zgMgaiol6RodUOk0NB4q5vpGubNrOTNVMLa1dNCs1dTrDr09XemCN9mT7zm-LkbbQXh2HduOO3APPDtF__QfdJ-C307l8KnYyziKdvozcRwJmg7-W0KV1rweA-gE7xX6N"]).responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let jsonArray = JSON(value)
                //print("jsonArray " , value)
                let status = jsonArray["success"]
                if status == 0 {
                    print("Notification FAILURE ")
                } else {
                    print("Notification SUCCESS ")
                }
                
                break
            case .failure(let error):
                print("Notification API Failure" , error)
                break
            }
        }
        //}
    }
    
    func NOtifyResumeAdmin() {
        
        let namee = self.defaults.string(forKey: "name")
        let test = "Employee " + namee! + " resuming assigned task"
        /*let userMobileIDs:String?
         userMobileIDs = self.defaults.string(forKey: "adminUserMobileId")
         if _AssignedByRole_ == "2" {
         let params = [
         "to" : userMobileIDs!,
         "notification": [
         "body": test,
         "title": "Assigned Task resumed",
         "icon" : "appicon"
         ]
         ] as [String : Any]
         Alamofire.request("https://fcm.googleapis.com/fcm/send", method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json","Authorization": "key=AAAAwqPRhzU:APA91bEt7g8zgMgaiol6RodUOk0NB4q5vpGubNrOTNVMLa1dNCs1dTrDr09XemCN9mT7zm-LkbbQXh2HduOO3APPDtF__QfdJ-C307l8KnYyziKdvozcRwJmg7-W0KV1rweA-gE7xX6N"]).responseJSON {
         response in
         switch response.result {
         case .success(let value):
         let jsonArray = JSON(value)
         //print("jsonArray " , value)
         let status = jsonArray["success"]
         if status == 0 {
         print("Notification FAILURE ")
         } else {
         print("Notification SUCCESS ")
         }
         
         break
         case .failure(let error):
         print("Notification API Failure" , error)
         break
         }
         }
         } else if _AssignedByRole_ == "1" { */
        userMobileIDsArr.removeAll()
        userMobileIDsArr.append(self.userMIDs1)
        userMobileIDsArr.append(self.userMIDs2)
        
        let params = [
            "results" : [],
            "notification": [
                "body": test,
                "title": "Assigned Task resumed",
                "icon" : "appicon",
                "sound" : "default"
            ],
            "registration_ids" : userMobileIDsArr
            ] as [String : Any]
        
        Alamofire.request("https://fcm.googleapis.com/fcm/send", method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json","Authorization": "key=AAAAwqPRhzU:APA91bEt7g8zgMgaiol6RodUOk0NB4q5vpGubNrOTNVMLa1dNCs1dTrDr09XemCN9mT7zm-LkbbQXh2HduOO3APPDtF__QfdJ-C307l8KnYyziKdvozcRwJmg7-W0KV1rweA-gE7xX6N"]).responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let jsonArray = JSON(value)
                //print("jsonArray " , value)
                let status = jsonArray["success"]
                if status == 0 {
                    print("Notification FAILURE ")
                } else {
                    print("Notification SUCCESS ")
                }
                
                break
            case .failure(let error):
                print("Notification API Failure" , error)
                break
            }
        }
        // }
    }
    
    @IBAction func DnDStop() {
        if isTimerRunning == false {
            print("At Stop ," , TimerLbl.text!)
            timer?.invalidate()
            timer = nil
            seconds = 0
            if backgroundTask != UIBackgroundTaskInvalid {
                endBackgroundTask()
            }
            TimerLbl.text = timeString(time: TimeInterval(seconds))
            isTimerRunning = false
            breakLabel.setTitle("Break", for: .normal)
            startLabel.alpha = 1
            startLabel.titleLabel?.alpha = 1
            breakLabel.alpha = 0.38
            breakLabel.titleLabel?.alpha = 0.38
            _taskStatusID_ = "4"
            self.defaults.set("TimerNotstarted", forKey: "TIMER")
            self.defaults.set("", forKey: "TIMER")
            NotificationCenter.default.removeObserver(self)
            NOtifyDNDAdmin()
            serviceCallPUTDefault()
            center.removeAllDeliveredNotifications() // To remove all delivered notifications
            center.removeAllPendingNotificationRequests() // To remove all pending notifications which are not delivered yet but scheduled.
            center.removeDeliveredNotifications(withIdentifiers: ["myNotif"])
        }
    }
    
    func NOtifyDNDAdmin() {
        let namee = self.defaults.string(forKey: "name")
        let test = "Employee " + namee! + " marked assigned task as Do Not Disturb (DND)"
        /*let userMobileIDs:String?
         userMobileIDs = self.defaults.string(forKey: "adminUserMobileId")
         if _AssignedByRole_ == "2" {
         let params = [
         "to" : userMobileIDs!,
         "notification": [
         "body": test,
         "title": "Assigned Task Marked as DND",
         "icon" : "appicon"
         ]
         ] as [String : Any]
         Alamofire.request("https://fcm.googleapis.com/fcm/send", method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json","Authorization": "key=AAAAwqPRhzU:APA91bEt7g8zgMgaiol6RodUOk0NB4q5vpGubNrOTNVMLa1dNCs1dTrDr09XemCN9mT7zm-LkbbQXh2HduOO3APPDtF__QfdJ-C307l8KnYyziKdvozcRwJmg7-W0KV1rweA-gE7xX6N"]).responseJSON {
         response in
         switch response.result {
         case .success(let value):
         let jsonArray = JSON(value)
         //print("jsonArray " , value)
         let status = jsonArray["success"]
         if status == 0 {
         print("Notification FAILURE ")
         } else {
         print("Notification SUCCESS ")
         }
         
         break
         case .failure(let error):
         print("Notification API Failure" , error)
         break
         }
         }
         } else if _AssignedByRole_ == "1" { */
        userMobileIDsArr.removeAll()
        userMobileIDsArr.append(self.userMIDs1)
        userMobileIDsArr.append(self.userMIDs2)
        
        let params = [
            "results" : [],
            "notification": [
                "body": test,
                "title": "Assigned Task Marked as DND",
                "icon" : "appicon",
                "sound" : "default"
            ],
            "registration_ids" : userMobileIDsArr
            ] as [String : Any]
        
        Alamofire.request("https://fcm.googleapis.com/fcm/send", method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json","Authorization": "key=AAAAwqPRhzU:APA91bEt7g8zgMgaiol6RodUOk0NB4q5vpGubNrOTNVMLa1dNCs1dTrDr09XemCN9mT7zm-LkbbQXh2HduOO3APPDtF__QfdJ-C307l8KnYyziKdvozcRwJmg7-W0KV1rweA-gE7xX6N"]).responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let jsonArray = JSON(value)
                //print("jsonArray " , value)
                let status = jsonArray["success"]
                if status == 0 {
                    print("Notification FAILURE ")
                } else {
                    print("Notification SUCCESS ")
                }
                
                break
            case .failure(let error):
                print("Notification API Failure" , error)
                break
            }
        }
        // }
    }
    
    @IBAction func completeStop() {
        if isTimerRunning == true {
            print("At Stop ," , TimerLbl.text!)
            timer?.invalidate()
            timer = nil
            seconds = 0
            if backgroundTask != UIBackgroundTaskInvalid {
                endBackgroundTask()
            }
            TimerLbl.text = timeString(time: TimeInterval(seconds))
            isTimerRunning = false
            breakLabel.setTitle("Break", for: .normal)
            startLabel.alpha = 1
            startLabel.titleLabel?.alpha = 1
            breakLabel.alpha = 0.38
            breakLabel.titleLabel?.alpha = 0.38
            _taskStatusID_ = "1"
            self.defaults.set("TimerNotstarted", forKey: "TIMER")
            self.defaults.set("", forKey: "TIMER")
            NotificationCenter.default.removeObserver(self)
            
            let uiAlert = UIAlertController(title: "Do you want to add Checklists ?", message: "", preferredStyle: UIAlertControllerStyle.alert)
            self.present(uiAlert, animated: true, completion: nil)
            
            uiAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                self.AddCheckLists(pendingText : self._assignedTaskID_ , pendingText2 : self._taskStatusID_ , pendingText3 : self._TasksListId_)
                UIApplication.shared.applicationIconBadgeNumber = 0
            }))
            
            uiAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { action in
                self.serviceCallPUTDefault()
                self.NOtifyStoppedAdmin()
                UIApplication.shared.applicationIconBadgeNumber = 0
            }))
            
            //serviceCallPUT()
            center.removeAllDeliveredNotifications() // To remove all delivered notifications
            center.removeAllPendingNotificationRequests() // To remove all pending notifications which are not delivered yet but scheduled.
            center.removeDeliveredNotifications(withIdentifiers: ["myNotif"])
        }
    }
    
    func NOtifyStoppedAdmin() {
        let namee = self.defaults.string(forKey: "name")
        let test = "Employee " + namee! + " completed assigned task"
        /*let userMobileIDs:String?
         userMobileIDs = self.defaults.string(forKey: "adminUserMobileId")
         if _AssignedByRole_ == "2" {
         let params = [
         "to" : userMobileIDs!,
         "notification": [
         "body": test,
         "title": "Assigned Task Completed",
         "icon" : "appicon"
         ]
         ] as [String : Any]
         Alamofire.request("https://fcm.googleapis.com/fcm/send", method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json","Authorization": "key=AAAAwqPRhzU:APA91bEt7g8zgMgaiol6RodUOk0NB4q5vpGubNrOTNVMLa1dNCs1dTrDr09XemCN9mT7zm-LkbbQXh2HduOO3APPDtF__QfdJ-C307l8KnYyziKdvozcRwJmg7-W0KV1rweA-gE7xX6N"]).responseJSON {
         response in
         switch response.result {
         case .success(let value):
         let jsonArray = JSON(value)
         //print("jsonArray " , value)
         let status = jsonArray["success"]
         if status == 0 {
         print("Notification FAILURE ")
         } else {
         print("Notification SUCCESS ")
         }
         
         break
         case .failure(let error):
         print("Notification API Failure" , error)
         break
         }
         }
         } else if _AssignedByRole_ == "1" { */
        userMobileIDsArr.removeAll()
        userMobileIDsArr.append(self.userMIDs1)
        userMobileIDsArr.append(self.userMIDs2)
        
        let params = [
            "results" : [],
            "notification": [
                "body": test,
                "title": "Assigned Task Completed",
                "icon" : "appicon",
                "sound" : "default"
            ],
            "registration_ids" : userMobileIDsArr
            ] as [String : Any]
        
        Alamofire.request("https://fcm.googleapis.com/fcm/send", method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json","Authorization": "key=AAAAwqPRhzU:APA91bEt7g8zgMgaiol6RodUOk0NB4q5vpGubNrOTNVMLa1dNCs1dTrDr09XemCN9mT7zm-LkbbQXh2HduOO3APPDtF__QfdJ-C307l8KnYyziKdvozcRwJmg7-W0KV1rweA-gE7xX6N"]).responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let jsonArray = JSON(value)
                //print("jsonArray " , value)
                let status = jsonArray["success"]
                if status == 0 {
                    print("Notification FAILURE ")
                } else {
                    print("Notification SUCCESS ")
                }
                
                break
            case .failure(let error):
                print("Notification API Failure" , error)
                break
            }
        }
        // }
    }
    
    func serviceCallPUTDefault () {
        let date = Date()
        let originalString = "C:\\Housekeeping_Directory"
        let newString2:String?
        newString2 = originalString.replacingOccurrences(of: "\\", with: "\\\\", options: .literal, range: nil)
        let postString2 = _taskStatusID_
        let postString3 = "0"
        let df = DateFormatter()
        df.dateFormat = "dd-mm-yy-hh-mm-ss"
        for object in objectsEmpLogin {
            if(_assignedTaskID_.contains(String(object.assignedTaskID))){
                ImageArr = object.imageCount
            }
        }
        SwiftSpinner.show("Processing")
        
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            print("WHILE SEND " , objects9.count)
            for objects in objects9 {
                print("WHILE SEND FOR " , objects)
                let test = objects.saveimages2 as UIImage
                // let conV = UIImagePNGRepresentation(test)
                let conV = UIImageJPEGRepresentation(test, 0.4)
                let imageName = df.string(from: date as Date)
                multipartFormData.append(conV!, withName: "file", fileName: "\(imageName).png", mimeType: "image/png")
            }
            multipartFormData.append((self._assignedTaskID_.data(using: .utf8))!, withName: "taskID")
            multipartFormData.append((postString2.data(using: .utf8))!, withName: "taskStatusID")
            multipartFormData.append((postString3.data(using: .utf8))!, withName: "checkListIds")
            multipartFormData.append((self.ImageArr.data(using: .utf8))!, withName: "imageCount")
            multipartFormData.append((newString2?.data(using: .utf8)!)!, withName: "imageDirectory")
        },to: HKURL+"/putvalue/updatetaskstatus/",method: .post, headers: nil,
          encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.response { response in
                    print("SEND IMAGE TO SERVER API SUCCESS " , response)
                    SwiftSpinner.hide()
                    self.switchToLoginScreen()
                }
            case .failure(let encodingError):
                print("SEND IMAGE TO SERVER API ERROR ", encodingError)
                SwiftSpinner.hide()
            }
        })
        
    }
    
    var sendPendingStr:String = ""
    var sendPendingStr2:String = ""
    var sendPendingStr3:String = ""
    func AddCheckLists (pendingText: String, pendingText2: String, pendingText3: String) {
        OperationQueue.main.addOperation {
            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vicCont = mainStoryboard.instantiateViewController(withIdentifier: "CheckLists") as! CheckLists
            self.sendPendingStr = pendingText
            self.sendPendingStr2 = pendingText2
            self.sendPendingStr3 = pendingText3
            
            vicCont._assignedTaskID = self.sendPendingStr
            vicCont._taskStatusID = self.sendPendingStr2
            vicCont._taskListID_ = self.sendPendingStr3
            vicCont._AssigNEDROLEID_ = self._AssignedByRole_
            
            self.present(vicCont, animated: true, completion: nil)
        }
    }
    
    func switchToLoginScreen() {
        objectsEmpLogin.removeAll()
        objectsEmpLogin2.removeAll()
        objectsEmpLogin3.removeAll()
        objectsEmpLogin4.removeAll()
        objectsEmpLogin5.removeAll()
        objectsEmpLogin6.removeAll()
        objectsEmpLogin7.removeAll()
        objectsErole1.removeAll()
        objectsErole2.removeAll()
        objectsErole3.removeAll()
        objectsErole4.removeAll()
        objectsErole5.removeAll()
        objectsErole6.removeAll()
        objectsErole7.removeAll()
        objects9.removeAll()
        OperationQueue.main.addOperation {
            let mainStoryboard2 = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vc2 : UIViewController = mainStoryboard2.instantiateViewController(withIdentifier: "EmployeeDashboard") as UIViewController
            self.present(vc2, animated: true, completion: nil)
        }
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(currentTask.updateTimer)), userInfo: nil, repeats: true)
        isTimerRunning = true
        registerBackgroundTask()
    }
    
    func updateTimer() {
        switch UIApplication.shared.applicationState {
        case .active:
            seconds += 1
            print("seconds B ", seconds)
            TimerLbl.text = timeString(time: TimeInterval(seconds))
            let DefautTime = _Duration_ + ":00"
            if timeString(time: TimeInterval(seconds)) == DefautTime {
                print("task Delayed")
                self.NotifyDelayedTask()
            } else {
                print("task not delayed")
            }
        case .background:
            seconds += 1
            print("seconds B ", seconds)
            //print("Background time remaining = \(UIApplication.shared.backgroundTimeRemaining) seconds")
            TimerLbl.text = timeString(time: TimeInterval(seconds))
            let DefautTime = _Duration_ + ":00"
            if timeString(time: TimeInterval(seconds)) == DefautTime {
                print("task Delayed")
                self.NotifyDelayedTask()
            } else {
                print("task not delayed")
            }
        case .inactive:
            break
        }
    }
    
    func NotifyDelayedTask() {
        let namee = self.defaults.string(forKey: "name")
        let test = "Employee " + namee! + " delaying assigned task"
        /*let userMobileIDs:String?
         userMobileIDs = self.defaults.string(forKey: "adminUserMobileId")
         if _AssignedByRole_ == "2" {
         let params = [
         "to" : userMobileIDs!,
         "notification": [
         "body": test,
         "title": "Delay in Assigned Task",
         "icon" : "appicon"
         ]
         ] as [String : Any]
         Alamofire.request("https://fcm.googleapis.com/fcm/send", method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json","Authorization": "key=AAAAwqPRhzU:APA91bEt7g8zgMgaiol6RodUOk0NB4q5vpGubNrOTNVMLa1dNCs1dTrDr09XemCN9mT7zm-LkbbQXh2HduOO3APPDtF__QfdJ-C307l8KnYyziKdvozcRwJmg7-W0KV1rweA-gE7xX6N"]).responseJSON {
         response in
         switch response.result {
         case .success(let value):
         let jsonArray = JSON(value)
         //print("jsonArray " , value)
         let status = jsonArray["success"]
         if status == 0 {
         print("Notification FAILURE ")
         } else {
         print("Notification SUCCESS ")
         }
         
         break
         case .failure(let error):
         print("Notification API Failure" , error)
         break
         }
         }
         } else if _AssignedByRole_ == "1" { */
        userMobileIDsArr.removeAll()
        userMobileIDsArr.append(self.userMIDs1)
        userMobileIDsArr.append(self.userMIDs2)
        
        let params = [
            "results" : [],
            "notification": [
                "body": test,
                "title": "Delay in Assigned Task",
                "icon" : "appicon",
                "sound" : "default"
            ],
            "registration_ids" : userMobileIDsArr
            ] as [String : Any]
        
        Alamofire.request("https://fcm.googleapis.com/fcm/send", method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json","Authorization": "key=AAAAwqPRhzU:APA91bEt7g8zgMgaiol6RodUOk0NB4q5vpGubNrOTNVMLa1dNCs1dTrDr09XemCN9mT7zm-LkbbQXh2HduOO3APPDtF__QfdJ-C307l8KnYyziKdvozcRwJmg7-W0KV1rweA-gE7xX6N"]).responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let jsonArray = JSON(value)
                //print("jsonArray " , value)
                let status = jsonArray["success"]
                if status == 0 {
                    print("Notification FAILURE ")
                } else {
                    print("Notification SUCCESS ")
                }
                
                break
            case .failure(let error):
                print("Notification API Failure" , error)
                break
            }
        }
        // }
    }
    
    func registerBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
        assert(backgroundTask != UIBackgroundTaskInvalid)
    }
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
