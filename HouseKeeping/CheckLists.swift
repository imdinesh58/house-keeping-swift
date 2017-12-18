//
//  CheckLists.swift
//  HouseKeeping
//
//  Created by Apple-1 on 9/28/17.
//  Copyright © 2017 Apple-1. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner

class CheckLists: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    var _assignedTaskID : String = ""
    var _taskStatusID : String = ""
    var _taskListID_ : String = ""
    var _AssigNEDROLEID_ : String = ""
    
    @IBOutlet weak var tblChecklists: UITableView!
    
    var ChecklistTypes: [String] = []
    var ChecklistTypesID: [String] = []
    var userMobileIDsArr: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userMobileIDsArr.removeAll()
        ChecklistTypes.removeAll()
        //IMGObj.removeAll()
        
        print("CheckLists =  ", objects9.count)
        
        ChecklistTypesID.removeAll()
        GetDeviceNotificationID()
        ChecklistTypesAPICall()
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
                print("LOGIN ", jsonObject)
                
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
    
    func ChecklistTypesAPICall()  {
        print("_taskListID_ = ", _taskListID_)
        let String1 = HKURL + "/getjson/checklistdetails/" + _taskListID_
        Alamofire.request(String1, method: .get, parameters: [:], encoding: URLEncoding.httpBody, headers: ["Content-Type":"application/json"]).responseString {
            response in
            switch response.result {
            case .success(let value):
                let strData = String(describing: value).data(using: String.Encoding.utf8)
                let jsonArray = JSON(strData!)
                for (_, dict) in jsonArray["checkListDetails"] {
                    self.ChecklistTypes.append(dict["taskCheckListName"].stringValue)
                    self.ChecklistTypesID.append(dict["taskCheckListId"].stringValue)
                }
                self.tblChecklists?.reloadData()
                break
            case .failure(let error):
                print("ChecklistTypesAPICall failure")
                print(error)
                break
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ChecklistTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblChecklists.dequeueReusableCell(withIdentifier: "CheckListCell", for: indexPath) as! checkListCell
        
        cell.name?.text = ""
        cell.ID?.text = ""
        cell.name?.text = self.ChecklistTypes[indexPath.row]
        cell.ID?.text = self.ChecklistTypesID[indexPath.row]
        
        return cell;
    }
    
    
    var ArrayString : [String] = []
    
    var selected = false
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let Cell = tableView.cellForRow(at: indexPath)! as! checkListCell
        
        ArrayString.append((Cell.ID?.text)!)
        
        print("ArrayString  CHECK  ", ArrayString)
        
        Cell.img.image = nil
        let check : UIImage = UIImage(named: "check.png")!
        Cell.img.image = check
        selected = true
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let Cell = tableView.cellForRow(at: indexPath)! as! checkListCell
        
        ArrayString.removeLast()
        
        print("ArrayString  UN-CHECK  ", ArrayString)
        
        Cell.img.image = nil
        let check : UIImage = UIImage(named: "uncheck.png")!
        Cell.img.image = check
        selected = true
    }
    
    
    @IBAction func DONE() {
        SwiftSpinner.show("Processing please wait...")
        CompleteCheckLists()
    }
    
    var String2 : String = ""
    var ImageArr: String = ""
    
    func CompleteCheckLists () {
        
        let stringConverter = ArrayString.joined(separator: ",")
        print("ArrayString   Count " , ArrayString.count)
        
        if selected == false {  //|| ArrayString.isEmpty == true || ArrayString == []
            String2 = "0"
        } else {
            if ArrayString.count == 1 {
                String2 = stringConverter
            } else {
                String2 = stringConverter
            }
        }
        
        print("String2  = " , String2)
        
        let date = Date()
        let originalString = "C:\\Housekeeping_Directory"
        let newString2:String?
        newString2 = originalString.replacingOccurrences(of: "\\", with: "\\\\", options: .literal, range: nil)
        let postString2 = "1"
        let df = DateFormatter()
        df.dateFormat = "dd-mm-yy-hh-mm-ss"
        for object in objectsEmpLogin {
            if(_assignedTaskID.contains(String(object.assignedTaskID))){
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
            multipartFormData.append((self._assignedTaskID.data(using: .utf8))!, withName: "taskID")
            multipartFormData.append((postString2.data(using: .utf8))!, withName: "taskStatusID")
            multipartFormData.append((self.String2.data(using: .utf8))!, withName: "checkListIds")
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
    
   
    let defaults = UserDefaults.standard
    
    func NOtifyStoppedAdmin() {
        let namee = self.defaults.string(forKey: "name")
        let test = "Employee " + namee! + " completed assigned task"
        /*let userMobileIDs:String?
        userMobileIDs = self.defaults.string(forKey: "adminUserMobileId")
        if _AssigNEDROLEID_ == "2" {
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
        } else if _AssigNEDROLEID_ == "1" { */
            userMobileIDsArr.removeAll()
            userMobileIDsArr.append(self.userMIDs1)
            userMobileIDsArr.append(self.userMIDs2)
            print("START userMobileIDsArr ", userMobileIDsArr)
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
        //}
    }
    
    func switchToLoginScreen() {
        //let defaultss = UserDefaults.standard
        //let Refresh = defaultss.string(forKey: "RefreshServiceCall2")
        //print("Refresh  ", Refresh as Any)
        //if Refresh == nil || Refresh?.isEmpty == true || Refresh == "" {
        //} else{
        self.resetObjects2()
        //   defaultss.set("", forKey: "RefreshServiceCall2")
        //}
        OperationQueue.main.addOperation {
            let mainStoryboard2 = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vc2 : UIViewController = mainStoryboard2.instantiateViewController(withIdentifier: "EmployeeDashboard") as UIViewController
            self.present(vc2, animated: true, completion: nil)
        }
    }
    
    func resetObjects2() {
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
