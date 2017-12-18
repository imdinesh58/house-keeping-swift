//
//  AlertsViewController.swift
//  HouseKeeping
//
//  Created by Apple-1 on 11/21/17.
//  Copyright © 2017 Apple-1. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class AlertsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var tblAlertsView: UITableView!
    
    let defaults = UserDefaults.standard
    //TableView
    var locationArr:[String] = []
    var locationArr2:[String] = []
    var descriptionArr:[String] = []
    var dateAssignedArr:[String] = []
    var taskStatusArr:[String] = []
    var EmpArr:[String] = []
    var taskListIdArr:[String] = []
    var priorityArr:[String] = []
    var checkListIdArr:[String] = []
    var AssignedByArr:[String] = []
    var isDistributedArr:[String] = []
    var AssignedTaskIdArr:[String] = []
    var assignedByRoleID:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("View controller alertsloaded")
        
        self.tblAlertsView?.delegate = self
        self.tblAlertsView?.dataSource = self
        
        self.ReleaeObj()
        getTheListJSON()
        
        if #available(iOS 10.0, *) {
            let refreshControl = UIRefreshControl()
            let title = NSLocalizedString("Refreshing", comment: "")
            refreshControl.attributedTitle = NSAttributedString(string: title)
            refreshControl.addTarget(self,
                                     action: #selector(refreshCOptions(sender:)),
                                     for: .valueChanged)
            self.tblAlertsView.refreshControl = refreshControl
        }
    }
    
    @objc private func refreshCOptions(sender: UIRefreshControl) {
        sender.endRefreshing()
    }
    
    func ReleaeObj() {
        locationArr.removeAll()
        locationArr2.removeAll()
        descriptionArr.removeAll()
        dateAssignedArr.removeAll()
        taskStatusArr.removeAll()
        checkListIdArr.removeAll()
        EmpArr.removeAll()
        taskListIdArr.removeAll()
        AssignedByArr.removeAll()
        AssignedTaskIdArr.removeAll()
        priorityArr.removeAll()
        isDistributedArr.removeAll()
        assignedByRoleID.removeAll()
    }
    
    @IBAction func Exit() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getTheListJSON(){
        autoreleasepool {
            print(" getTheListJSON ")
            let branchID = defaults.string(forKey: "branchID")
            let employeeStatusID = defaults.string(forKey: "employeeStatusID")
            let employeeIDLogin = defaults.string(forKey: "employeeIDLogin")
            let ApiUrl = HKURL + "/getjson/assignedtask&workers/" + employeeIDLogin! + "/" + employeeStatusID! + "/" + branchID!
            let req = NSMutableURLRequest(url: NSURL(string: ApiUrl)! as URL)
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
                    print("StatusCode is Success === \(httpStatus.statusCode)")
                    //print("ResponseString = success status " +     responseString!)
                    _ = self.convertStringToDictionary(text: responseString!)
                }
                
            }  //close task
            task.resume()
        }
    }
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        DispatchQueue.main.async(){
            autoreleasepool {
                if let data = text.data(using: String.Encoding.utf8) {
                    do {
                        let jsonObj = try JSONSerialization.jsonObject(with: data, options: [])
                        let jsonArray = JSON(jsonObj)
                        //print("jsonArray  " , jsonArray)
                        
                        for (_, dict) in jsonArray["JsonAssignedTasks"] {
                            var status = ""
                            ///Saved Date
                            let dateString = dict["dateAssigned"].stringValue
                            let dateFormatter_ = DateFormatter()
                            dateFormatter_.dateFormat = "yyyy-MM-dd HH:mm.ss.SSS"
                            let dateObj = dateFormatter_.date(from: dateString)
                            dateFormatter_.dateFormat = "yyyy-MM-dd HH:mm"
                            // print("saved date " , dateFormatter_.string(from: dateObj!))
                            ///saved date 2
                            let dateFormatter_2 = DateFormatter()
                            dateFormatter_2.dateFormat = "yyyy-MM-dd HH:mm.ss.SSS"
                            let dateObj2 = dateFormatter_2.date(from: dateString)
                            dateFormatter_2.dateFormat = "yyyy-MM-dd"
                            //print("equal date 2 " , dateFormatter_2.string(from: dateObj!))
                            ///current date
                            let date = Date()
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyy-MM-dd"
                            //print("current date = " , formatter.string(from: date))
                            
                            //timedifference
                            
                            let elapsed = date.timeIntervalSince(dateObj!)
                            let duration = Int(elapsed )
                            
                            var minutes: Int?
                            var hours: Int?
                            
                            func stringFromTimeInterval(interval: TimeInterval) -> NSString {
                                /*let ms = Int(interval.truncatingRemainder(dividingBy: 1) * 1000)
                                 let formatter = DateComponentsFormatter()
                                 formatter.allowedUnits = [.hour, .minute, .second]
                                 return formatter.string(from: interval)! as NSString */
                                // return formatter.string(from: interval)! + ".\(ms)"
                                let ti = NSInteger(interval)
                                let ms = Int((interval.truncatingRemainder(dividingBy: 1)) * 1000)
                                let seconds = ti % 60
                                minutes = (ti / 60) % 60
                                hours = (ti / 3600)
                                //return NSString(format: "%0.2d:%0.2d",hours!,minutes!)
                                return NSString(format: "%0.2d:%0.2d:%0.2d.%0.3d",hours!,minutes!,seconds,ms)
                            }
                            
                            //print("duration ", stringFromTimeInterval(interval: TimeInterval(duration)))
                            
                            _ = stringFromTimeInterval(interval: TimeInterval(duration))
                            
                            // print(dateFormatter_2.string(from: dateObj!) + "," + formatter.string(from: date))
                            
                            if dateFormatter_2.string(from: dateObj!) == formatter.string(from: date) {
                                if minutes! >= 1 {
                                    //print("Task Delayed")
                                    if dict["taskStatusID"].stringValue == "3" {
                                        status = "Pending"
                                        self.taskStatusArr.append(status)
                                        self.descriptionArr.append(dict["description"].stringValue)
                                        ///Saved Date
                                        let dateString = dict["dateAssigned"].stringValue
                                        let dateFormatter = DateFormatter()
                                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm.ss.SSS"
                                        let dateObj = dateFormatter.date(from: dateString)
                                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                                        //print("saved date " , dateFormatter.string(from: dateObj!))
                                        self.dateAssignedArr.append(dateFormatter.string(from: dateObj!))
                                        self.locationArr.append(dict["location"].stringValue)
                                        self.locationArr2.append(dict["floorNumber"].stringValue)
                                        self.EmpArr.append(dict["employeeName"].stringValue)
                                        self.taskListIdArr.append(dict["taskListId"].stringValue)
                                        self.priorityArr.append(dict["priorities"].stringValue)
                                        self.checkListIdArr.append(dict["checkListIds"].stringValue)
                                        self.isDistributedArr.append(dict["isDistributsed"].stringValue)
                                        self.AssignedByArr.append(dict["assignedByName"].stringValue)
                                        self.AssignedTaskIdArr.append(String(dict["assignedTaskID"].stringValue))
                                        self.assignedByRoleID.append(dict["assignedByRole"].stringValue)
                                        self.tblAlertsView?.reloadData()
                                    }
                                } else {
                                    //print("Task Not Delayed")
                                }
                            } else {
                                // print("Date not equal")
                            }
                            
                        } //for end
                        print("AssignedTaskIdArr after = ", self.AssignedTaskIdArr.count)
                    } catch {
                        // Catch any other errors
                    }
                }
            }
        }
        return nil
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AssignedTaskIdArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblAlertsView.dequeueReusableCell(withIdentifier: "alerts", for: indexPath) as! AllTasksCell
        cell.checkListId?.text = ""
        cell.lbl1?.text = ""
        cell.lbl2?.text = ""
        cell.lbl3?.text = ""
        cell.lbl4?.text = ""
        cell.lbl5?.text = ""
        cell.lbl6?.text = ""
        cell.assignedBy?.text = ""
        cell.comments?.text = ""
        cell.taskId?.text = ""
        cell.prio?.text = ""
        cell.AssignedTaskId?.text = ""
        cell.isDistributed?.text = ""
        cell.AssignedByRoleId.text = ""
        cell.lbl2?.text = "Assigned To: "  + self.EmpArr[indexPath.row]
        let strArr = self.descriptionArr[indexPath.row].components(separatedBy: "^")
        cell.lbl3?.text = strArr[0]
        cell.comments?.text = strArr[1]
        let loc1 = self.locationArr[indexPath.row]
        let loc2 =  " , " + self.locationArr2[indexPath.row]
        cell.lbl4?.text = loc1 + loc2
        cell.lbl5?.text = self.dateAssignedArr[indexPath.row]
        cell.lbl6?.text = "REASSIGN"
        cell.lbl6?.layer.cornerRadius = 1.0
        cell.lbl6?.layer.masksToBounds = true
        cell.lbl6?.layer.borderWidth = 1
        cell.lbl6?.backgroundColor = UIColor.white
        cell.lbl6?.textColor = UIColor(red:246.0/255.0, green: 147/255.0, blue:9/255.0, alpha: 1.0)
        let myColor : UIColor = UIColor(red:246.0/255.0, green: 147/255.0, blue:9/255.0, alpha: 1.0)
        cell.lbl6?.layer.borderColor = myColor.cgColor
        cell.lbl6?.numberOfLines = 0
        
        cell.checkListId?.text = self.taskListIdArr[indexPath.row]
        cell.prio?.text = self.priorityArr[indexPath.row]
        cell.taskId?.text = self.checkListIdArr[indexPath.row]
        
        cell.assignedBy?.text = "Assigned by: " + self.AssignedByArr[indexPath.row]
        cell.AssignedTaskId?.text = self.AssignedTaskIdArr[indexPath.row]
        cell.isDistributed?.text = self.isDistributedArr[indexPath.row]
        cell.AssignedByRoleId?.text = self.assignedByRoleID[indexPath.row]
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let Cell = self.tblAlertsView.cellForRow(at: indexPath)! as! AllTasksCell
        let send = Cell.AssignedByRoleId?.text
        let send2 = Cell.AssignedTaskId?.text
        self.ViewTaskDescriptions(penText : send! , penText2 : send2!)
    }
    
    var sendPendingStrt:String = ""
    var sendPendingStr2t:String = ""
    func ViewTaskDescriptions(penText: String, penText2: String) {
        OperationQueue.main.addOperation {
            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vicCon = mainStoryboard.instantiateViewController(withIdentifier: "reassignTask") as! reassignTask
            self.sendPendingStrt = penText
            self.sendPendingStr2t = penText2
            vicCon.ASSIGNED_BY__ = self.sendPendingStrt
            vicCon.TASKNAMEID = self.sendPendingStr2t
            self.present(vicCon, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
