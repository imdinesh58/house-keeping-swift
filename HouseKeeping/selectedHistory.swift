//
//  selectedHistory.swift
//  HouseKeeping
//
//  Created by Apple-1 on 8/9/17.
//  Copyright © 2017 Apple-1. All rights reserved.
//

import UIKit

class selectedHistory: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tblViewSelectedHistory: UITableView!
    var selectedHistory : String = ""
    @IBAction func Back() {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblViewSelectedHistory?.delegate = self
        self.tblViewSelectedHistory?.dataSource = self
        self.getSelectedHistory()
    }
    
    var dates_Arr:[String] = []
    var All_locationArr:[String] = []
    var All_locationArr2:[String] = []
    var All_descriptionArr:[String] = []
    var All_dateAssignedArr:[String] = []
    var All_taskStatusArr:[String] = []
    var EmpArr:[String] = []
    var checkListIdArr:[String] = []
    var priorityArr:[String] = []
    var AssignedByArr:[String] = []
    
    func getSelectedHistory() {
        All_locationArr.removeAll()
        All_locationArr2.removeAll()
        All_descriptionArr.removeAll()
        All_dateAssignedArr.removeAll()
        All_taskStatusArr.removeAll()
        AssignedByArr.removeAll()
        EmpArr.removeAll()
        checkListIdArr.removeAll()
        priorityArr.removeAll()
        for object in objects.reversed() {
            let dateString = object.dateAssigned
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateObj = dateFormatter.date(from: dateString)
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let convertedDate = dateFormatter.string(from: dateObj!)
            if(selectedHistory.contains(convertedDate)){
                var status = ""
                if object.taskStatusID == "1" {
                    status = "Completed"
                } else if object.taskStatusID == "2" {
                    status = "In Progress"
                } else if object.taskStatusID == "3" {
                    status = "Pending"
                }  else if object.taskStatusID == "4" {
                    status = "DND"
                }
                self.All_taskStatusArr.append(status)
                self.All_descriptionArr.append(object.description)
                self.All_dateAssignedArr.append(object.dateAssigned)
                self.All_locationArr.append(object.location)
                self.EmpArr.append(object.employeeName)
                self.checkListIdArr.append(object.taskListId)
                self.priorityArr.append(object.priorities)
                self.AssignedByArr.append(object.assignedByName)
                self.All_locationArr2.append(object.floorNumber)
            }
        }
        self.tblViewSelectedHistory?.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return All_dateAssignedArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblViewSelectedHistory.dequeueReusableCell(withIdentifier: "WHcell6", for: indexPath) as! workHistoryCell
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
        cell.HDate?.text = self.EmpArr[indexPath.row] + ", " + self.All_dateAssignedArr[indexPath.row]
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
        
        self.ViewTaskDescription(pendingText : send! , pendingText2 : send2! , pendingText3 : send3! , pendingText4 : send4! , pendingText5 : send5! , pendingText6 : send6!)
    }
    
    var sendPendingStr:String = ""
    var sendPendingStr2:String = ""
    var sendPendingStr3:String = ""
    var sendPendingStr4:String = "none"
    var sendPendingStr5:String = ""
    var sendPendingStr6:String = ""
    
    func ViewTaskDescription(pendingText: String, pendingText2: String, pendingText3: String, pendingText4: String ,pendingText5: String, pendingText6: String) {
        OperationQueue.main.addOperation {
            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vicCont2 = mainStoryboard.instantiateViewController(withIdentifier: "viewTaskView") as! viewTaskViewController
            self.sendPendingStr = pendingText
            self.sendPendingStr2 = pendingText2
            self.sendPendingStr3 = pendingText3
            self.sendPendingStr4 = pendingText4
            self.sendPendingStr5 = pendingText5
            self.sendPendingStr6 = pendingText6
            
            let strArr = self.self.sendPendingStr.components(separatedBy: ",")
            vicCont2.employee2 = strArr[0]
            vicCont2.task2 = self.sendPendingStr2
            vicCont2.location22 = self.sendPendingStr3
            vicCont2.comments2 = self.sendPendingStr4
            vicCont2.checklist2 = self.sendPendingStr5
            vicCont2.priority2 = self.sendPendingStr6
            self.present(vicCont2, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
