//
//  TBLViewEmpDND.swift
//  HouseKeeping
//
//  Created by Apple-1 on 8/29/17.
//  Copyright © 2017 Apple-1. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
//import SwiftSpinner

class TBLViewEmpDND: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tblViewEmployeeDNDTasks: UITableView!
    let defaults = UserDefaults.standard
    
    var locationArr:[String] = []
    var locationArr2:[String] = []
    var descriptionArr:[String] = []
    var dateAssignedArr:[String] = []
    var priorityArr:[String] = []
    var assignedTskArr:[Int] = []
    var taskStatusIDArr:[String] = []
    var FlorDataArr:[String] = []
    var EmpArr:[String] = []
    var TaskListIdArr:[String] = []
    var AssignedByArr:[String] = []
    var AssignedByIDArr:[String] = []
    var durationArr:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tblViewEmployeeDNDTasks?.delegate = self
        self.tblViewEmployeeDNDTasks?.dataSource = self
        
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
        getListJSON()
        GETFloorDetails()
        
        if #available(iOS 10.0, *) {
            let refreshControl = UIRefreshControl()
            let title = NSLocalizedString("Refreshing", comment: "")
            refreshControl.attributedTitle = NSAttributedString(string: title)
            refreshControl.addTarget(self,
                                     action: #selector(refreshE3Options(sender:)),
                                     for: .valueChanged)
            self.tblViewEmployeeDNDTasks.refreshControl = refreshControl
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func refreshE3Options(sender: UIRefreshControl) {
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
        autoreleasepool {
            print(" if objectsEmpLogin.isEmpty at Refresh  ==  " , objectsEmpLogin.isEmpty)
            if objectsEmpLogin.isEmpty == true {
                //SwiftSpinner.show("Retrieving data from server please wait")
                let branchID = defaults.string(forKey: "branchID")
                let employeeStatusID = defaults.string(forKey: "employeeStatusID")
                let employeeIDLogin = defaults.string(forKey: "employeeIDLogin")
                print("making API Call GET ")
                let ApiUrl = HKURL + "/getjson/assignedtask&workers/" + employeeIDLogin! + "/" + employeeStatusID! + "/" + branchID!
                //let APiUrl = "http://www.mobile.chembiantech.com:8080/HouseKeeping/getjson/assignedtask&workers/81/1/1"
                let req = NSMutableURLRequest(url: NSURL(string: ApiUrl)! as URL)
                req.httpMethod = "GET"
                let task = URLSession.shared.dataTask(with: req as URLRequest) {
                    data, response, error in
                    // Check for error
                    if error != nil {
                        print("error=\(error)")
                        //SwiftSpinner.hide()
                        return
                    }
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                        print("StatusCode is === \(httpStatus.statusCode)")
                        OperationQueue.main.addOperation{
                            let alert = UIAlertController(title: "Alert", message: "Server Error... failed to load assigned tasks", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                        //SwiftSpinner.hide()
                    }
                    
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 {
                        let responseString = String(data: data!, encoding: String.Encoding.utf8)
                        //print("API call done with ResponseString = \(responseString)")
                        print("StatusCode is === \(httpStatus.statusCode)")
                        //print("ResponseString = success status " +     responseString!)
                        _ = self.convertStringToDictionary(text: responseString!)
                        sender.endRefreshing()
                    }
                    
                }  //close task
                task.resume()
                GETFloorDetails()
            }
        }
    }
    
    func getListJSON(){
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
        autoreleasepool {
        //SwiftSpinner.show("Retrieving data from server please wait")
        let branchID = defaults.string(forKey: "branchID")
        let employeeStatusID = defaults.string(forKey: "employeeStatusID")
        let employeeIDLogin = defaults.string(forKey: "employeeIDLogin")
        let ApiUrl = HKURL + "/getjson/assignedtask&workers/" + employeeIDLogin! + "/" + employeeStatusID! + "/" + branchID!
        //let APiUrl = "http://www.mobile.chembiantech.com:8080/HouseKeeping/getjson/assignedtask&workers/81/1/1"
        let req = NSMutableURLRequest(url: NSURL(string: ApiUrl)! as URL)
        req.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: req as URLRequest) {
            data, response, error in
            // Check for error
            if error != nil {
                print("error=\(error)")
                //SwiftSpinner.hide()
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("StatusCode is === \(httpStatus.statusCode)")
                OperationQueue.main.addOperation{
                    let alert = UIAlertController(title: "Alert", message: "Server Error... failed to load assigned tasks", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                //SwiftSpinner.hide()
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 {
                //print("StatusCode is === \(httpStatus.statusCode)")
                let responseString = String(data: data!, encoding: String.Encoding.utf8)
                //print("ResponseString = \(responseString)")
                //print("ResponseString = success status " +     responseString!)
                _ = self.convertStringToDictionary(text: responseString!)
            }
            
        }  //close task
        task.resume()
        }
    }
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        DispatchQueue.main.async(){
            if let data = text.data(using: String.Encoding.utf8) {
                do {
                    let jsonObj = try JSONSerialization.jsonObject(with: data, options: [])
                    let jsonArray = JSON(jsonObj)
                    
                    for (_, dict) in jsonArray["JsonAssignedTasks"] { //(key or index, element)
                        let dateString = dict["dateAssigned"].stringValue
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm.ss.SSS"
                        let dateObj = dateFormatter.date(from: dateString)
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                        print("Dateobj: \(dateFormatter.string(from: dateObj!))")
                        
                        let thisObject = getAssignedTasks(assignedTaskID: dict["assignedTaskID"].intValue, taskStatusID: dict["taskStatusID"].stringValue, description: dict["description"].stringValue,dateAssigned: dateFormatter.string(from: dateObj!),location: dict["location"].stringValue,assignedBY: dict["assignedBY"].stringValue,employeeId: dict["employeeId"].stringValue,priorities : dict["priorities"].stringValue,floorNumber : dict["floorNumber"].stringValue,employeeName: dict["employeeName"].stringValue,imageCount : dict["imageCount"].stringValue,checkListIds : dict["checkListIds"].stringValue,taskListId : dict["taskListId"].stringValue,assignedByName : dict["assignedByName"].stringValue,assignedByRole : dict["assignedByRole"].stringValue,isDistributsed : dict["isDistributsed"].stringValue,duration : dict["duration"].stringValue)
                        objectsEmpLogin.append(thisObject)
                    }
                    
                    for (_, dict2) in jsonArray["JsonWorkers"] { //(key or index, element)
                        let thisObj = getWorkers(employeeLevelID: dict2["employeeLevelID"].stringValue,levelName: dict2["levelName"].stringValue)
                        objectsEmpLogin2.append(thisObj)
                        
                        let employeeDetailsArray = dict2["employeeDetails"]
                        ///Housekeeping
                        if dict2["levelName"].stringValue == "Housekeeping" {
                            for (_, dict3) in employeeDetailsArray {
                                let thisObj2 = getEmployeeDetailsHousekeeping(FirstName: dict3["FirstName"].stringValue,LastName: dict3["LastName"].stringValue,UserMobileID: dict3["UserMobileID"].stringValue,EmployeeID: dict3["EmployeeID"].stringValue,completed: dict3["workDetails"][0].stringValue,onprogress: dict3["workDetails"][1].stringValue,pending: dict3["workDetails"][2].stringValue,dnd: dict3["workDetails"][3].stringValue,Phone : dict3["Phone"].stringValue,Email : dict3["Email"].stringValue, Address : dict3["Address"].stringValue)
                                objectsEmpLogin3.append(thisObj2)
                            }
                        }
                        ///Car Parking
                        if dict2["levelName"].stringValue == "Car Parking" {
                            for (_, dict4) in employeeDetailsArray {
                                let thisObject4 = getEmployeeDetailsCarParking(FirstName: dict4["FirstName"].stringValue,LastName: dict4["LastName"].stringValue,UserMobileID: dict4["UserMobileID"].stringValue,EmployeeID: dict4["EmployeeID"].stringValue,completed: dict4["workDetails"][0].stringValue,onprogress: dict4["workDetails"][1].stringValue,pending: dict4["workDetails"][2].stringValue,dnd: dict4["workDetails"][3].stringValue,Phone : dict4["Phone"].stringValue,Email : dict4["Email"].stringValue, Address : dict4["Address"].stringValue)
                                objectsEmpLogin4.append(thisObject4)
                            }
                        }
                        ///Maintanence
                        if dict2["levelName"].stringValue == "Maintanence" {
                            for (_, dict5) in employeeDetailsArray {
                                let thisObj5 = getEmployeeDetailsMaintenance(FirstName: dict5["FirstName"].stringValue,LastName: dict5["LastName"].stringValue,UserMobileID: dict5["UserMobileID"].stringValue,EmployeeID: dict5["EmployeeID"].stringValue,completed: dict5["workDetails"][0].stringValue,onprogress: dict5["workDetails"][1].stringValue,pending: dict5["workDetails"][2].stringValue,dnd: dict5["workDetails"][3].stringValue,Phone : dict5["Phone"].stringValue,Email : dict5["Email"].stringValue, Address : dict5["Address"].stringValue)
                                objectsEmpLogin5.append(thisObj5)
                            }
                        }
                        ///Maintanence
                        if dict2["levelName"].stringValue == "Plumber" {
                            for (_, dict5) in employeeDetailsArray {
                                let thisObj5 = getEmployeeDetailsPlumber(FirstName: dict5["FirstName"].stringValue,LastName: dict5["LastName"].stringValue,UserMobileID: dict5["UserMobileID"].stringValue,EmployeeID: dict5["EmployeeID"].stringValue,completed: dict5["workDetails"][0].stringValue,onprogress: dict5["workDetails"][1].stringValue,pending: dict5["workDetails"][2].stringValue,dnd: dict5["workDetails"][3].stringValue,Phone : dict5["Phone"].stringValue,Email : dict5["Email"].stringValue, Address : dict5["Address"].stringValue)
                                objectsErole1.append(thisObj5)
                            }
                        }
                        ///Maintanence
                        if dict2["levelName"].stringValue == "Carpenter" {
                            for (_, dict5) in employeeDetailsArray {
                                let thisObj5 = getEmployeeDetailsCarpenter(FirstName: dict5["FirstName"].stringValue,LastName: dict5["LastName"].stringValue,UserMobileID: dict5["UserMobileID"].stringValue,EmployeeID: dict5["EmployeeID"].stringValue,completed: dict5["workDetails"][0].stringValue,onprogress: dict5["workDetails"][1].stringValue,pending: dict5["workDetails"][2].stringValue,dnd: dict5["workDetails"][3].stringValue,Phone : dict5["Phone"].stringValue,Email : dict5["Email"].stringValue, Address : dict5["Address"].stringValue)
                                objectsErole2.append(thisObj5)
                            }
                        }
                        ///Maintanence
                        if dict2["levelName"].stringValue == "Electrician" {
                            for (_, dict5) in employeeDetailsArray {
                                let thisObj5 = getEmployeeDetailsElectrician(FirstName: dict5["FirstName"].stringValue,LastName: dict5["LastName"].stringValue,UserMobileID: dict5["UserMobileID"].stringValue,EmployeeID: dict5["EmployeeID"].stringValue,completed: dict5["workDetails"][0].stringValue,onprogress: dict5["workDetails"][1].stringValue,pending: dict5["workDetails"][2].stringValue,dnd: dict5["workDetails"][3].stringValue,Phone : dict5["Phone"].stringValue,Email : dict5["Email"].stringValue, Address : dict5["Address"].stringValue)
                                objectsErole3.append(thisObj5)
                            }
                        }
                        ///Maintanence
                        if dict2["levelName"].stringValue == "Driver" {
                            for (_, dict5) in employeeDetailsArray {
                                let thisObj5 = getEmployeeDetailsDriver(FirstName: dict5["FirstName"].stringValue,LastName: dict5["LastName"].stringValue,UserMobileID: dict5["UserMobileID"].stringValue,EmployeeID: dict5["EmployeeID"].stringValue,completed: dict5["workDetails"][0].stringValue,onprogress: dict5["workDetails"][1].stringValue,pending: dict5["workDetails"][2].stringValue,dnd: dict5["workDetails"][3].stringValue,Phone : dict5["Phone"].stringValue,Email : dict5["Email"].stringValue, Address : dict5["Address"].stringValue)
                                objectsErole4.append(thisObj5)
                            }
                        }
                        ///Maintanence
                        if dict2["levelName"].stringValue == "Cleaner" {
                            for (_, dict5) in employeeDetailsArray {
                                let thisObj5 = getEmployeeDetailsCleaner(FirstName: dict5["FirstName"].stringValue,LastName: dict5["LastName"].stringValue,UserMobileID: dict5["UserMobileID"].stringValue,EmployeeID: dict5["EmployeeID"].stringValue,completed: dict5["workDetails"][0].stringValue,onprogress: dict5["workDetails"][1].stringValue,pending: dict5["workDetails"][2].stringValue,dnd: dict5["workDetails"][3].stringValue,Phone : dict5["Phone"].stringValue,Email : dict5["Email"].stringValue, Address : dict5["Address"].stringValue)
                                objectsErole5.append(thisObj5)
                            }
                        }
                        ///Maintanence
                        if dict2["levelName"].stringValue == "Washer" {
                            for (_, dict5) in employeeDetailsArray {
                                let thisObj5 = getEmployeeDetailsWasher(FirstName: dict5["FirstName"].stringValue,LastName: dict5["LastName"].stringValue,UserMobileID: dict5["UserMobileID"].stringValue,EmployeeID: dict5["EmployeeID"].stringValue,completed: dict5["workDetails"][0].stringValue,onprogress: dict5["workDetails"][1].stringValue,pending: dict5["workDetails"][2].stringValue,dnd: dict5["workDetails"][3].stringValue,Phone : dict5["Phone"].stringValue,Email : dict5["Email"].stringValue, Address : dict5["Address"].stringValue)
                                objectsErole6.append(thisObj5)
                            }
                        }
                        ///Maintanence
                        if dict2["levelName"].stringValue == "Arranger" {
                            for (_, dict5) in employeeDetailsArray {
                                let thisObj5 = getEmployeeDetailsArranger(FirstName: dict5["FirstName"].stringValue,LastName: dict5["LastName"].stringValue,UserMobileID: dict5["UserMobileID"].stringValue,EmployeeID: dict5["EmployeeID"].stringValue,completed: dict5["workDetails"][0].stringValue,onprogress: dict5["workDetails"][1].stringValue,pending: dict5["workDetails"][2].stringValue,dnd: dict5["workDetails"][3].stringValue,Phone : dict5["Phone"].stringValue,Email : dict5["Email"].stringValue, Address : dict5["Address"].stringValue)
                                objectsErole7.append(thisObj5)
                            }
                        }
                    }
                    //print("After Insert Object" ,objects 2)
                    self.getEmployeeDNDtasks()
                    //SwiftSpinner.hide()
                    
                } catch {
                    // Catch any other errors
                }
            }
        }
        return nil
    }
    
    func GETFloorDetails() {
        if let branchID = defaults.string(forKey: "branchID") {
            let req = NSMutableURLRequest(url: NSURL(string: HKURL+"/getjson/floordetails/" + branchID)! as URL)
            req.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: req as URLRequest) {
                data, response, error in
                // Check for error
                if error != nil {
                    print("error=\(error)")
                    return
                }
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    print("StatusCode is === \(httpStatus.statusCode)")
                    OperationQueue.main.addOperation{
                        let alert = UIAlertController(title: "Alert", message: "Server Error... failed to load assigned tasks", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 {
                    let responseString = String(data: data!, encoding: String.Encoding.utf8)
                    //print("ResponseString = \(responseString)")
                    //print("ResponseString = success status " +     responseString!)
                    _ = self.convertStringToDictionary2(text: responseString!)
                }
            }  //close task
            task.resume()
        }
    }
    
    func convertStringToDictionary2(text: String) -> [String:AnyObject]? {
        DispatchQueue.main.async(){
            if let data = text.data(using: String.Encoding.utf8) {
                do {
                    let jsonObj = try JSONSerialization.jsonObject(with: data, options: [])
                    let jsonArray = JSON(jsonObj)
                    for (_, dict3) in jsonArray["floorDetails"] {
                        let thisObj2 = getFloorDetails(FloorID: dict3["FloorID"].stringValue,FloorName: dict3["FloorName"].stringValue,AreaDetail: dict3["AreaDetail"].stringValue,AreaDetailID: dict3["AreaDetailID"].stringValue,AreaTypeID: dict3["AreaTypeID"].stringValue)
                        objectsEmpLogin6.append(thisObj2)
                    }
                    for (_, dict4) in jsonArray["taskListDetails"] {
                        let thisObj3 = getWorkTypeDetails(taskListId: dict4["taskListId"].stringValue,taskListName: dict4["taskListName"].stringValue)
                        objectsEmpLogin7.append(thisObj3)
                    }
                } catch {
                    // Catch any other errors
                }
            }
        }
        return nil
    }
    
    func getEmployeeDNDtasks() {
        locationArr.removeAll()
        locationArr2.removeAll()
        descriptionArr.removeAll()
        dateAssignedArr.removeAll()
        priorityArr.removeAll()
        assignedTskArr.removeAll()
        taskStatusIDArr.removeAll()
        AssignedByArr.removeAll()
        FlorDataArr.removeAll()
        AssignedByIDArr.removeAll()
        TaskListIdArr.removeAll()
        EmpArr.removeAll()
        durationArr.removeAll()
        if AssignedByArr.count == 0 {
            for object in objectsEmpLogin.reversed() {
                //let defaults = UserDefaults.standard
                //let employeeIDLogins = defaults.string(forKey: "employeeIDLogin")
                if object.taskStatusID == "4" {
                    self.priorityArr.append(object.priorities)
                    self.descriptionArr.append(object.description)
                    self.dateAssignedArr.append(object.dateAssigned)
                    self.locationArr.append(object.location)
                    self.locationArr2.append(object.floorNumber)
                    self.assignedTskArr.append(object.assignedTaskID)
                    self.taskStatusIDArr.append(object.taskStatusID)
                    self.FlorDataArr.append(object.floorNumber)
                    self.EmpArr.append(object.employeeName)
                    self.AssignedByArr.append(object.assignedByName)
                    self.TaskListIdArr.append(object.taskListId)
                    self.AssignedByIDArr.append(object.assignedByRole)
                    self.durationArr.append(object.duration)
                    self.tblViewEmployeeDNDTasks?.reloadData()
                }
            }
        }
        print("After DND" ,AssignedByArr.count)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return priorityArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblViewEmployeeDNDTasks.dequeueReusableCell(withIdentifier: "EDNDCell", for: indexPath) as! EmployeeLoginCell
        cell.lbl1?.text = ""
        cell.lbl2?.text = ""
        cell.lbl3?.text = ""
        cell.lbl4?.text = ""
        cell.lbl5?.text = ""
        cell.duration?.text = ""
        cell.assignedByID?.text = ""
        cell.taskListId?.text = ""
        //LABEL 1 remove
        for Employee in cell.subviews
        {
            if Employee.tag == 999
            {
                Employee.removeFromSuperview()
            }
        }
        for Location in cell.subviews
        {
            if Location.tag == 1000
            {
                Location.removeFromSuperview()
            }
        }
        //label 2 remove
        for Description in cell.subviews
        {
            if Description.tag == 1001
            {
                Description.removeFromSuperview()
            }
        }
        //label 3 remove
        for DateAssigned in cell.subviews
        {
            if DateAssigned.tag == 1002
            {
                DateAssigned.removeFromSuperview()
            }
        }
        //label 4 remove
        for TaskStatus in cell.subviews
        {
            if TaskStatus.tag == 1003
            {
                TaskStatus.removeFromSuperview()
            }
        }
        
        //label 5 remove
        for Icon in cell.subviews
        {
            if Icon.tag == 1004
            {
                Icon.removeFromSuperview()
            }
        }
        
        for assignedby in cell.subviews
        {
            if assignedby.tag == 1011
            {
                assignedby.removeFromSuperview()
            }
        }
        
        //label 1 add
        let Employee = UILabel(frame: CGRect(x: 30, y: 18, width: 250.0, height: 50.0))
        Employee.text = "Assigned To: " + self.EmpArr[indexPath.row]
        Employee.textColor = UIColor.black
        Employee.tag = 999
        Employee.clearsContextBeforeDrawing = true
        Employee.baselineAdjustment = .alignCenters
        Employee.font = UIFont(name: "Futura", size: 13)!
        Employee.numberOfLines = 0
        cell.addSubview(Employee)
        
        //label 1 add
        let Description = UILabel(frame: CGRect(x: 30, y: 0, width: 250.0, height: 55))
        let strArr = self.descriptionArr[indexPath.row].components(separatedBy: "^")
        Description.text = strArr[0]
        Description.textColor = UIColor.black
        Description.tag = 1001
        Description.clearsContextBeforeDrawing = true
        Description.baselineAdjustment = .alignCenters
        Description.font = UIFont(name: "Futura-bold", size: 13)!
        Description.numberOfLines = 0
        cell.addSubview(Description)
        //label 2 add
        let Location = UILabel(frame: CGRect(x: 30, y: 33, width: 250.0, height: 50.0))
        let loc1 = self.locationArr[indexPath.row]
        let loc2 =  " , " + self.locationArr2[indexPath.row]
        Location.text = loc1 + loc2
        Location.textColor = UIColor.black
        Location.tag = 1000
        Location.clearsContextBeforeDrawing = true
        Location.baselineAdjustment = .alignCenters
        Location.font = UIFont(name: "Futura", size: 13)!
        Location.numberOfLines = 0
        cell.addSubview(Location)
        
        //label 3 add
        let DateAssigned = UILabel(frame: CGRect(x: 30, y: 50, width: 250.0, height: 50.0))
        DateAssigned.text = self.dateAssignedArr[indexPath.row]
        DateAssigned.tag = 1002
        DateAssigned.clearsContextBeforeDrawing = true
        DateAssigned.baselineAdjustment = .alignCenters
        DateAssigned.font = UIFont(name: "Futura", size: 13)!
        DateAssigned.numberOfLines = 0
        cell.addSubview(DateAssigned)
        
        let assignedby = UILabel(frame: CGRect(x: 30, y: 65, width: 250.0, height: 50.0))
        assignedby.text = "Assigned by: " + self.AssignedByArr[indexPath.row]
        assignedby.textColor = UIColor.black
        assignedby.tag = 1011
        assignedby.clearsContextBeforeDrawing = true
        assignedby.baselineAdjustment = .alignCenters
        assignedby.font = UIFont(name: "Futura", size: 13)!
        assignedby.numberOfLines = 0
        cell.addSubview(assignedby)
        
        //label 4 add
        let TaskStatus = UILabel(frame: CGRect(x: 305, y: 20, width: 90.0, height: 28.0))
        TaskStatus.text = "Priority: "+self.priorityArr[indexPath.row]
        TaskStatus.textColor = UIColor.white
        TaskStatus.backgroundColor = UIColor(red:230.0/255.0, green: 121/255.0, blue:10/255.0, alpha: 1.0)
        TaskStatus.textAlignment = NSTextAlignment.center
        TaskStatus.layer.cornerRadius = 1.0
        TaskStatus.layer.masksToBounds = true
        TaskStatus.layer.borderWidth = 1
        TaskStatus.backgroundColor = UIColor.white
        TaskStatus.textColor = UIColor(red:246.0/255.0, green: 147/255.0, blue:9/255.0, alpha: 1.0)
        let myColor : UIColor = UIColor(red:246.0/255.0, green: 147/255.0, blue:9/255.0, alpha: 1.0)
        TaskStatus.layer.borderColor = myColor.cgColor
        TaskStatus.tag = 1003
        TaskStatus.clearsContextBeforeDrawing = true
        TaskStatus.baselineAdjustment = .alignCenters
        TaskStatus.font = UIFont(name: "Futura", size: 13)!
        TaskStatus.numberOfLines = 0
        cell.addSubview(TaskStatus)
        
        ////
        cell.lbl1?.text = String(self.assignedTskArr[indexPath.row])
        cell.lbl2?.text = self.taskStatusIDArr[indexPath.row]
        cell.lbl3?.text = self.descriptionArr[indexPath.row]
        cell.lbl4?.text = self.FlorDataArr[indexPath.row]
        cell.lbl5?.text = self.locationArr[indexPath.row]
        cell.assignedByID?.text = self.AssignedByIDArr[indexPath.row]
        cell.taskListId?.text = self.TaskListIdArr[indexPath.row]
        cell.duration?.text = self.durationArr[indexPath.row]
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let Cell = tableView.cellForRow(at: indexPath)! as! EmployeeLoginCell
        let send = Cell.lbl1?.text
        let send2 = Cell.lbl2?.text
        let send3 = Cell.lbl3?.text
        let send4 = Cell.lbl4?.text
        let send5 = Cell.lbl5?.text
        let send6 = Cell.taskListId?.text
        let send7 = Cell.assignedByID?.text
        let send8 = Cell.duration?.text
        self.goWorkingPage(pendingText : send! , pendingText2 : send2! , pendingText3 : send3! , pendingText4 : send4!, pendingText5 : send5! , pendingText6 : send6! , pendingText7 : send7! , pendingText8 : send8!)
    }
    
    var sendPendingStr:String = ""
    var sendPendingStr2:String = ""
    var sendPendingStr3:String = ""
    var sendPendingStr4:String = ""
    var sendPendingStr5:String = ""
    var sendPendingStr6:String = ""
    var sendPendingStr7:String = ""
    var sendPendingStr8:String = ""
    
    func goWorkingPage(pendingText: String, pendingText2: String, pendingText3: String, pendingText4: String, pendingText5: String,pendingText6: String, pendingText7: String, pendingText8: String) {
        OperationQueue.main.addOperation {
            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vicCont = mainStoryboard.instantiateViewController(withIdentifier: "individualEmpTask") as! individualEmpTask
            self.sendPendingStr = pendingText
            self.sendPendingStr2 = pendingText2
            self.sendPendingStr3 = pendingText3
            self.sendPendingStr4 = pendingText4
            self.sendPendingStr5 = pendingText5
            self.sendPendingStr6 = pendingText6
            self.sendPendingStr7 = pendingText7
            self.sendPendingStr8 = pendingText8
            vicCont.assignedTaskID_ = self.sendPendingStr
            vicCont.taskStatusID_ = self.sendPendingStr2
            vicCont.description_ = self.sendPendingStr3
            vicCont.floorNumber_ = self.sendPendingStr4
            vicCont.location_ = self.sendPendingStr5
            vicCont.TaskCheckId = self.sendPendingStr6
            vicCont.AssignedByRoleID = self.sendPendingStr7
            vicCont.DURATION1 = self.sendPendingStr8
            self.present(vicCont, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
