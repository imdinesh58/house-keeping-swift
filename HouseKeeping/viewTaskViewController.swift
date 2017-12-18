//
//  viewTaskViewController.swift
//  HouseKeeping
//
//  Created by Apple-1 on 9/25/17.
//  Copyright © 2017 Apple-1. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class viewTaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBAction func Exit() {
        self.dismiss(animated: true, completion: nil)
    }
    
    var employee2 : String = ""
    var task2 : String = ""
    var location22 : String = ""
    var checklist2 : String = ""
    var priority2 : String = ""
    var comments2 : String = "none"
    
    @IBOutlet weak var lblEmployee : UILabel!
    @IBOutlet weak var lblPriority : UILabel!
    @IBOutlet weak var Tasks : UILabel!
    @IBOutlet weak var location2 : UILabel!
    @IBOutlet weak var tblChecklist : UITableView!
    @IBOutlet weak var comments: UILabel!
    
    var ChecklistTypes: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblChecklist?.delegate = self
        self.tblChecklist?.dataSource = self
        lblEmployee.text = employee2
        lblPriority.text = priority2
        Tasks.text = task2
        location2.text = location22
        if comments2.characters.count > 1 {
            comments.text = "Comments: " + comments2
        } else {
            comments.text = "Comments: none" 
        }
        print("checklist2   " , checklist2)
        ChecklistTypesAPICall()
    }
    
    func ChecklistTypesAPICall()  {
        let String1 = HKURL + "/getjson/checklistdetails/" + checklist2
        print("URl " + String1)
        Alamofire.request(String1, method: .get, parameters: [:], encoding: URLEncoding.httpBody, headers: ["Content-Type":"application/json"]).responseString {
            response in
            switch response.result {
            case .success(let value):
                let strData = String(describing: value).data(using: String.Encoding.utf8)
                let jsonArray = JSON(strData!)
                print("jsonArray  " , jsonArray)
                for (_, dict) in jsonArray["checkListDetails"] {
                    self.ChecklistTypes.append(dict["taskCheckListName"].stringValue)
                }
                self.tblChecklist?.reloadData()
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
        var cell:UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "AllTasksLists") as UITableViewCell!
        if !(cell != nil){
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "AllTasksLists")
        }

        for Employee in cell.subviews
        {
            if Employee.tag == 999
            {
                Employee.removeFromSuperview()
            }
        }
        
        for imageView in cell.subviews {
            if imageView.tag == 1000
            {
                imageView.removeFromSuperview()
            }
        }

        let Employee = UILabel(frame: CGRect(x: 25, y: 0, width: 290.0, height: 50.0))
        Employee.text = self.ChecklistTypes[indexPath.row]
        Employee.textColor = UIColor(red:230.0/255.0, green: 121/255.0, blue:10/255.0, alpha: 1.0)
        Employee.tag = 999
        Employee.clearsContextBeforeDrawing = true
        Employee.textAlignment = .left
        Employee.font = UIFont(name: "Futura", size: 13)!
        Employee.numberOfLines = 0
        cell.addSubview(Employee)
        ///IMAGE
        let Calendarimage1 = "uncheck.png"
        let Calendarimage2 = UIImage(named: Calendarimage1)
        let CalendarimageView = UIImageView(frame: CGRect(x: 360, y: 15, width: 18, height: 18))
        CalendarimageView.tag = 1000
        CalendarimageView.layer.masksToBounds = true
        CalendarimageView.image = Calendarimage2
        cell.addSubview(CalendarimageView)
        
        return cell;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
