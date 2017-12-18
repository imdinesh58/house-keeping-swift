//
//  DetailsPending.swift
//  HouseKeeping
//
//  Created by Apple-1 on 7/18/17.
//  Copyright © 2017 Apple-1. All rights reserved.
//

import UIKit

class DetailsPending: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var detailsPendingTasks: UITableView!

    var EmployeeId : String  = ""
    
    //TableView
    var locationArr:[String] = []
    var descriptionArr:[String] = []
    var dateAssignedArr:[String] = []
    var taskStatusArr:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.detailsPendingTasks?.delegate = self
        self.detailsPendingTasks?.dataSource = self
        getPendingTasksLists()
        //let selectedEmpId = taskDescription()
        let defaultss = UserDefaults.standard
        //EmpId = defaultss.string(forKey: "EMPId")!
        EmployeeId = defaultss.string(forKey: "EMPId")!
    }
    
    @IBAction func bAck() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getPendingTasksLists() {
        for object in objects {
            if object.taskStatusID == "3" && object.employeeId == EmployeeId {
                let status = "Priority: " + object.priorities
                self.taskStatusArr.append(status)
                self.descriptionArr.append(object.description)
                self.dateAssignedArr.append(object.dateAssigned)
                self.locationArr.append(object.location)
                self.detailsPendingTasks?.reloadData()
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dateAssignedArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "PendingTasksCellLists") as UITableViewCell!
        if !(cell != nil){
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "PendingTasksCellLists")
        }
        //DispatchQueue.main.async(){
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
            //label 1 add
            let Description = UILabel(frame: CGRect(x: 50, y: 5, width: 190.0, height: 50.0))
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
            let Location = UILabel(frame: CGRect(x: 50, y: 25, width: 190.0, height: 50.0))
            Location.text = self.locationArr[indexPath.row]
            Location.textColor = UIColor.black
            Location.tag = 1000
            Location.clearsContextBeforeDrawing = true
            Location.baselineAdjustment = .alignCenters
            Location.font = UIFont(name: "Futura", size: 13)!
            Location.numberOfLines = 0
            cell.addSubview(Location)
            
            //label 3 add
            let DateAssigned = UILabel(frame: CGRect(x: 50, y: 45, width: 190.0, height: 50.0))
            DateAssigned.text = self.dateAssignedArr[indexPath.row]
            DateAssigned.textColor = UIColor.black
            DateAssigned.tag = 1002
            DateAssigned.clearsContextBeforeDrawing = true
            DateAssigned.baselineAdjustment = .alignCenters
            DateAssigned.font = UIFont(name: "Futura", size: 13)!
            DateAssigned.numberOfLines = 0
            cell.addSubview(DateAssigned)
            //label 4 add
            let TaskStatus = UILabel(frame: CGRect(x: 295, y: 28, width: 90.0, height: 30.0))
            TaskStatus.text = self.taskStatusArr[indexPath.row]
            TaskStatus.textColor = UIColor.white
            TaskStatus.backgroundColor = UIColor(red:230.0/255.0, green: 121/255.0, blue:10/255.0, alpha: 1.0)
            TaskStatus.textAlignment = NSTextAlignment.center
            TaskStatus.layer.cornerRadius = 1.0
            TaskStatus.layer.masksToBounds = true
            TaskStatus.layer.borderWidth = 1
            TaskStatus.backgroundColor = UIColor.white
            TaskStatus.textColor =  UIColor(red:246.0/255.0, green: 147/255.0, blue:9/255.0, alpha: 1.0)
            let myColor : UIColor = UIColor(red:230.0/255.0, green: 121/255.0, blue:10/255.0, alpha: 1.0)
            TaskStatus.layer.borderColor = myColor.cgColor
            TaskStatus.tag = 1003
            TaskStatus.clearsContextBeforeDrawing = true
            TaskStatus.baselineAdjustment = .alignCenters
            TaskStatus.font = UIFont(name: "Futura", size: 13)!
            TaskStatus.numberOfLines = 0
            cell.addSubview(TaskStatus)
        //}
        return cell;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
