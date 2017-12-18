
//  tblHistoryAll.swift
//  HouseKeeping
//
//  Created by Apple-1 on 8/7/17.
//  Copyright © 2017 Apple-1. All rights reserved.
//

import UIKit

class tblHistoryCompleted: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    @IBOutlet weak var tblViewHistoryCompleted: UITableView!
    @IBOutlet weak var WHSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblViewHistoryCompleted?.delegate = self
        self.tblViewHistoryCompleted?.dataSource = self
        self.getHistoryAll()
    }
    var dates_Arr:[String] = []
    var All_locationArr:[String] = []
    var All_locationArr2:[String] = []
    var All_descriptionArr:[String] = []
    var All_dateAssignedArr:[String] = []
    var All_taskStatusArr:[String] = []
    var EmpArr:[String] = []
    var taskListIdArr:[String] = []
    var checkListIdArr:[String] = []
    var priorityArr:[String] = []
    var AssignedByArr:[String] = []
    
    
    func getHistoryAll() {
        All_locationArr.removeAll()
        All_locationArr2.removeAll()
        All_descriptionArr.removeAll()
        All_dateAssignedArr.removeAll()
        All_taskStatusArr.removeAll()
        checkListIdArr.removeAll()
        AssignedByArr.removeAll()
        taskListIdArr.removeAll()
        priorityArr.removeAll()
        EmpArr.removeAll()
        for object in objects.reversed() {
            var status = ""
            if object.taskStatusID == "1" {
                status = "Completed"
                self.All_taskStatusArr.append(status)
                self.All_descriptionArr.append(object.description)
                self.All_dateAssignedArr.append(object.dateAssigned)
                self.All_locationArr.append(object.location)
                self.All_locationArr2.append(object.floorNumber)
                self.EmpArr.append(object.employeeName)
                self.AssignedByArr.append(object.assignedByName)
                self.taskListIdArr.append(object.taskListId)
                self.checkListIdArr.append(object.checkListIds)
                self.priorityArr.append(object.priorities)
            }
        }
        self.tblViewHistoryCompleted?.reloadData()
    }
    @IBAction func SegControlChange() {
        let cell = self.tblViewHistoryCompleted.dequeueReusableCell(withIdentifier: "WHcell2") as! workHistoryCell
        if(WHSegmentedControl.selectedSegmentIndex == 0){
            cell.HDescription?.text = ""
            cell.HLocation?.text = ""
            cell.HDate?.text = ""
            cell.HStasus?.text = ""
            cell.icon?.text = ""
            cell.priority?.text = ""
            cell.checklists?.text = ""
            cell.comments?.text = ""
            cell.taskId?.text = ""
             cell.assignedby?.text = ""
            getHistoryAll()
            self.tblViewHistoryCompleted?.reloadData()
        } else if(WHSegmentedControl.selectedSegmentIndex == 1){
            cell.HDescription?.text = ""
            cell.HLocation?.text = ""
            cell.HDate?.text = ""
            cell.HStasus?.text = ""
            cell.icon?.text = ""
            cell.priority?.text = ""
            cell.checklists?.text = ""
            cell.comments?.text = ""
            cell.taskId?.text = ""
             cell.assignedby?.text = ""
            getCurrent()
            self.tblViewHistoryCompleted?.reloadData()
        } else if(WHSegmentedControl.selectedSegmentIndex == 2){
            cell.HDescription?.text = ""
            cell.HLocation?.text = ""
            cell.HDate?.text = ""
            cell.HStasus?.text = ""
            cell.icon?.text = ""
            cell.priority?.text = ""
            cell.checklists?.text = ""
            cell.comments?.text = ""
            cell.taskId?.text = ""
             cell.assignedby?.text = ""
            getPastfive()
            self.tblViewHistoryCompleted?.reloadData()
        } else if(WHSegmentedControl.selectedSegmentIndex == 3){
            cell.HDescription?.text = ""
            cell.HLocation?.text = ""
            cell.HDate?.text = ""
            cell.HStasus?.text = ""
            cell.icon?.text = ""
            cell.priority?.text = ""
            cell.checklists?.text = ""
            cell.comments?.text = ""
            cell.taskId?.text = ""
             cell.assignedby?.text = ""
            getPastfifteenDays()
            self.tblViewHistoryCompleted?.reloadData()
        } else if(WHSegmentedControl.selectedSegmentIndex == 4){
            cell.HDescription?.text = ""
            cell.HLocation?.text = ""
            cell.HDate?.text = ""
            cell.HStasus?.text = ""
            cell.icon?.text = ""
            cell.priority?.text = ""
            cell.checklists?.text = ""
            cell.comments?.text = ""
            cell.taskId?.text = ""
             cell.assignedby?.text = ""
            getPast30Days()
            self.tblViewHistoryCompleted?.reloadData()
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var returnValue = 0
        switch(WHSegmentedControl.selectedSegmentIndex)
        {
        case 0:
            returnValue = All_dateAssignedArr.count
            break
        case 1:
            returnValue = All_dateAssignedArr.count
            break
        case 2:
            returnValue = All_dateAssignedArr.count
            break
        case 3:
            returnValue = All_dateAssignedArr.count
            break
        case 4:
            returnValue = All_dateAssignedArr.count
            break
        default:
            break
        }
        return returnValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblViewHistoryCompleted.dequeueReusableCell(withIdentifier: "WHcell2", for: indexPath) as! workHistoryCell
        cell.HDescription?.text = ""
        cell.HLocation?.text = ""
        cell.HDate?.text = ""
        cell.HStasus?.text = ""
        cell.icon?.text = ""
        cell.priority?.text = ""
        cell.checklists?.text = ""
        cell.comments?.text = ""
        cell.assignedby?.text = ""
        
        let strArr = All_descriptionArr[indexPath.row].components(separatedBy: "^")
        cell.HDescription?.text =  strArr[0]
        cell.comments?.text = strArr[1]
        let loc1 = self.All_locationArr[indexPath.row]
        let loc2 =  " , " + self.All_locationArr2[indexPath.row]
        cell.HLocation.text = loc1 + loc2
        cell.HDate?.text = self.EmpArr[indexPath.row] + "," + self.All_dateAssignedArr[indexPath.row]
        cell.HStasus?.text = "Priority: " + self.priorityArr[indexPath.row]
        cell.HStasus?.layer.cornerRadius = 1.0
        cell.HStasus?.layer.borderWidth = 1
        cell.HStasus?.layer.masksToBounds = true
        cell.HStasus?.backgroundColor = UIColor.white
        cell.HStasus?.textColor = UIColor(red:246.0/255.0, green: 147/255.0, blue:9/255.0, alpha: 1.0)
        let myColorT : UIColor = UIColor(red:230.0/255.0, green: 121/255.0, blue:10/255.0, alpha: 1.0)
        cell.HStasus?.layer.borderColor = myColorT.cgColor
        cell.checklists?.text = self.checkListIdArr[indexPath.row]
        cell.priority?.text = self.priorityArr[indexPath.row]
       cell.assignedby?.text = "Assigned by: " + self.AssignedByArr[indexPath.row]
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let Cell = tableView.cellForRow(at: indexPath)! as! workHistoryCell
        let send = Cell.HDate?.text
        let send2 = Cell.HDescription?.text
        let send3 = Cell.HLocation?.text
        let send4 = Cell.comments?.text
        let send5 = Cell.checklists?.text
        let send6 = Cell.priority?.text
        let send7 = Cell.taskId?.text
        
        self.ViewTaskDescription(pendingText : send! , pendingText2 : send2! , pendingText3 : send3! , pendingText4 : send4! , pendingText5 : send5! , pendingText6 : send6! , pendingText7 : send7!)
    }
    
    var sendPendingStr:String = ""
    var sendPendingStr2:String = ""
    var sendPendingStr3:String = ""
    var sendPendingStr4:String = "none"
    var sendPendingStr5:String = ""
    var sendPendingStr6:String = ""
    var sendPendingStr7:String = ""
    
    func ViewTaskDescription(pendingText: String, pendingText2: String, pendingText3: String, pendingText4: String ,pendingText5: String, pendingText6: String , pendingText7: String) {
        OperationQueue.main.addOperation {
            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vicCont2 = mainStoryboard.instantiateViewController(withIdentifier: "viewCompletedChecklist") as! viewCompletedChecklist
            self.sendPendingStr = pendingText
            self.sendPendingStr2 = pendingText2
            self.sendPendingStr3 = pendingText3
            self.sendPendingStr4 = pendingText4
            self.sendPendingStr5 = pendingText5
            self.sendPendingStr6 = pendingText6
            self.sendPendingStr7 = pendingText7
            
            let strArr = self.self.sendPendingStr.components(separatedBy: ",")
            vicCont2.employee2 = strArr[0]
            vicCont2.task2 = self.sendPendingStr2
            vicCont2.location22 = self.sendPendingStr3
            vicCont2.comments2 = self.sendPendingStr4
            vicCont2.checklist2 = self.sendPendingStr5
            vicCont2.priority2 = self.sendPendingStr6
            vicCont2.checklistID = self.sendPendingStr7
            self.present(vicCont2, animated: true, completion: nil)
        }
    }
    
    func getCurrent(){
        All_locationArr.removeAll()
        All_locationArr2.removeAll()
        All_descriptionArr.removeAll()
        All_dateAssignedArr.removeAll()
        All_taskStatusArr.removeAll()
        checkListIdArr.removeAll()
        priorityArr.removeAll()
        EmpArr.removeAll()
        taskListIdArr.removeAll()
        for object in objects.reversed() {
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let dateString = object.dateAssigned
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateObj = dateFormatter.date(from: dateString)
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let convertedDate = dateFormatter.string(from: dateObj!)
            if(formatter.string(from: date).contains(convertedDate)){
                var status = ""
                if object.taskStatusID == "1" {
                    status = "Completed"
                    self.All_taskStatusArr.append(status)
                    self.All_descriptionArr.append(object.description)
                    self.All_dateAssignedArr.append(object.dateAssigned)
                    self.All_locationArr.append(object.location)
                    self.All_locationArr2.append(object.floorNumber)
                    self.taskListIdArr.append(object.taskListId)
                    self.priorityArr.append(object.priorities)
                    self.EmpArr.append(object.employeeName)
                    self.checkListIdArr.append(object.checkListIds)
                }
            }
        }
        self.tblViewHistoryCompleted?.reloadData()
    }
    
    func getPastfive() {
        All_locationArr.removeAll()
        All_locationArr2.removeAll()
        All_descriptionArr.removeAll()
        All_dateAssignedArr.removeAll()
        All_taskStatusArr.removeAll()
        checkListIdArr.removeAll()
        priorityArr.removeAll()
        EmpArr.removeAll()
        taskListIdArr.removeAll()
        _ = getPastDates(days: 7)
        for object in objects.reversed() {
            let dateString = object.dateAssigned
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateObj = dateFormatter.date(from: dateString)
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let convertedDate = dateFormatter.string(from: dateObj!)
            if(dates_Arr.contains(convertedDate)){
                var status = ""
                if object.taskStatusID == "1" {
                    status = "Completed"
                    self.All_taskStatusArr.append(status)
                    self.All_descriptionArr.append(object.description)
                    self.All_dateAssignedArr.append(object.dateAssigned)
                    self.All_locationArr.append(object.location)
                    self.All_locationArr2.append(object.floorNumber)
                    self.taskListIdArr.append(object.taskListId)
                    self.priorityArr.append(object.priorities)
                    self.EmpArr.append(object.employeeName)
                    self.checkListIdArr.append(object.checkListIds)
                }
            }
        }
        self.tblViewHistoryCompleted?.reloadData()
    }
    
    func getPastfifteenDays() {
        All_locationArr.removeAll()
        All_locationArr2.removeAll()
        All_descriptionArr.removeAll()
        All_dateAssignedArr.removeAll()
        All_taskStatusArr.removeAll()
        checkListIdArr.removeAll()
        priorityArr.removeAll()
        EmpArr.removeAll()
        taskListIdArr.removeAll()
        _ = getPastDates(days: 15)
        for object in objects.reversed() {
            let dateString = object.dateAssigned
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateObj = dateFormatter.date(from: dateString)
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let convertedDate = dateFormatter.string(from: dateObj!)
            if(dates_Arr.contains(convertedDate)){
                var status = ""
                if object.taskStatusID == "1" {
                    status = "Completed"
                    self.All_taskStatusArr.append(status)
                    self.All_descriptionArr.append(object.description)
                    self.All_dateAssignedArr.append(object.dateAssigned)
                    self.All_locationArr.append(object.location)
                    self.All_locationArr2.append(object.floorNumber)
                    self.taskListIdArr.append(object.taskListId)
                    self.priorityArr.append(object.priorities)
                    self.EmpArr.append(object.employeeName)
                    self.checkListIdArr.append(object.checkListIds)
                }
            }
        }
        self.tblViewHistoryCompleted?.reloadData()
    }
    
    func getPast30Days() {
        All_locationArr.removeAll()
        All_locationArr2.removeAll()
        All_descriptionArr.removeAll()
        All_dateAssignedArr.removeAll()
        All_taskStatusArr.removeAll()
        checkListIdArr.removeAll()
        priorityArr.removeAll()
        EmpArr.removeAll()
        taskListIdArr.removeAll()
       _ =  getPastDates(days: 30)
        for object in objects.reversed() {
            let dateString = object.dateAssigned
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateObj = dateFormatter.date(from: dateString)
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let convertedDate = dateFormatter.string(from: dateObj!)
            if(dates_Arr.contains(convertedDate)){
                var status = ""
                if object.taskStatusID == "1" {
                    status = "Completed"
                    self.All_taskStatusArr.append(status)
                    self.All_descriptionArr.append(object.description)
                    self.All_dateAssignedArr.append(object.dateAssigned)
                    self.All_locationArr.append(object.location)
                    self.All_locationArr2.append(object.floorNumber)
                    self.taskListIdArr.append(object.taskListId)
                    self.priorityArr.append(object.priorities)
                    self.EmpArr.append(object.employeeName)
                    self.checkListIdArr.append(object.checkListIds)
                }
            }
        }
        self.tblViewHistoryCompleted?.reloadData()
    }
    
    func getPastDates(days: Int) -> NSArray {
        dates_Arr.removeAll()
        let cal = NSCalendar.current
        var today = cal.startOfDay(for: NSDate() as Date) as Date
        for i in 1 ... days {
            let year = cal.component(.year, from: today)
            let ins = "-"
            let month =  cal.component(.month, from: today)
            var MM: String = ""
            if String(month).characters.count == 1 {
                MM = "0" + String(month)
            } else {
                MM =  String(month)
            }
            let day_ = cal.component(.day, from: today)
            var DD: String = ""
            if String(day_).characters.count == 1 {
                DD = "0" + String(day_)
            } else {
                DD =  String(day_)
            }
            let ins2 = "-"
            let apprehend = String(year) + ins + MM + ins2 + DD
            today = cal.date(byAdding: .day, value: -1, to: today)!
            dates_Arr.append(apprehend)
        }
        return dates_Arr as NSArray
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
