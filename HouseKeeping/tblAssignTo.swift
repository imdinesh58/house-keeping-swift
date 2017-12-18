
import UIKit
import SwiftSpinner
import SwiftyJSON

class tblAssignTo: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tblAssignNew: UITableView!
    @IBAction func AssignToBackBtnClick() {
        //print("Back Btn Clicked ")
        let defaultss = UserDefaults.standard
        let Refresh = defaultss.string(forKey: "RefreshServiceCall")
        //print("Refresh Assign To ==  ", Refresh as Any)
        if Refresh == nil || Refresh?.isEmpty == true || Refresh == "" {
            self.resetObjects()
            OperationQueue.main.addOperation {  // run in main thread
                let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "DashBoard") as UIViewController
                self.present(vc, animated: true, completion: nil)
            }
        } else{
            //print(" notification has been sent so refresh service call ")
            self.resetObjects()
            defaultss.set("", forKey: "RefreshServiceCall")
            OperationQueue.main.addOperation {  // run in main thread
                let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "DashBoard") as UIViewController
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    func resetObjects() {
        objects.removeAll()
        objects2.removeAll()
        objects3.removeAll()
        objects4.removeAll()
        objects5.removeAll()
        objectsrole1.removeAll()
        objectsrole2.removeAll()
        objectsrole3.removeAll()
        objectsrole4.removeAll()
        objectsrole5.removeAll()
        objectsrole6.removeAll()
        objectsrole7.removeAll()
        objects6.removeAll()
        objects77.removeAll()
    }
    
    var levelNameArr:[String] = []
    var TotallevelNameArr:[String] = []
    var USERArr:[String] = []
    var FirstNameArr:[String] = []
    var LastNameArr:[String] = []
    var completedArr:[String] = []
    var onprogressArr:[String] = []
    var pendingArr:[String] = []
    var dndArr:[String] = []
    var employeeIDArr:[String] = []
    var userMobArr:[String] = []
    var multiUserMobArr:[String] = []
    var multiEmployeeIDArr:[String] = []
    var multiEmployeeLevelArr:[String] = []
    var EmpArr:[String] = []
    
    @IBOutlet weak var scrollingView: UIScrollView!
    
    var segControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        autoreleasepool {
            self.tblAssignNew?.delegate = self
            self.tblAssignNew?.dataSource = self
            
            levelNameArr.removeAll()
            TotallevelNameArr.removeAll()
            USERArr.removeAll()
            FirstNameArr.removeAll()
            LastNameArr.removeAll()
            completedArr.removeAll()
            onprogressArr.removeAll()
            pendingArr.removeAll()
            dndArr.removeAll()
            employeeIDArr.removeAll()
            userMobArr.removeAll()
            EmpArr.removeAll()
            multiUserMobArr.removeAll()
            multiEmployeeIDArr.removeAll()
            multiEmployeeLevelArr.removeAll()
            
            getAssignTasksCompleted()
            let tuples = removeDuplicates(array: levelNameArr)
            segControl = UISegmentedControl(items: tuples)
            segControl.frame = CGRect(x: 5, y: 3, width: 365, height: 29)
            segControl.addTarget(self, action: #selector(self.SeGmentChange), for: .valueChanged)
            segControl.selectedSegmentIndex = 0
            segControl.frame.size.width = 1000
            
            if tuples.count == 1 {
                for var i in (0..<tuples.count){
                    segControl.setWidth(403, forSegmentAt: i)
                    segControl.frame.size.width = 500
                }
            } else if tuples.count == 2 {
                for var i in (0..<tuples.count){
                    segControl.setWidth(203, forSegmentAt: i)
                    segControl.frame.size.width = 500
                }
            } else {
                for var i in (0..<tuples.count){
                    segControl.setWidth(135, forSegmentAt: i)
                }
            }
            segControl.backgroundColor = UIColor.clear
            segControl.tintColor = UIColor(red: 246/255.0, green: 147/255.0, blue: 9/255.0, alpha: 1.0)
            self.scrollingView?.addSubview(segControl)
            self.scrollingView?.contentSize.width = 1000
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("viewWillDisappear Assighn To ")
        multiUserMobArr.removeAll()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func removeDuplicates(array: [String]) -> [String] {
        var encountered = Set<String>()
        var result: [String] = []
        for value in array {
            if encountered.contains(value) {
                // Do not add a duplicate element.
            }
            else {
                // Add value to the set.
                encountered.insert(value)
                // ... Append the value.
                result.append(value)
            }
        }
        return result
    }
    
    let data = UserDefaults.standard.object(forKey: "DefaultJSON")
    let defaults = UserDefaults.standard
    func getAssignTasksCompleted() {
        let jsonArray = JSON(data!)
        
        if defaults.string(forKey: "employeeStatusID") == "1" {
            for (_, dict) in jsonArray["JsonWorkers"].reversed() { //(key or index, element)
                self.TotallevelNameArr.append(dict["levelName"].stringValue)
                let LEVEL = dict["levelName"].stringValue
                self.levelNameArr.append(LEVEL)
                self.USERArr.append("Supervisor")
                self.FirstNameArr.append(dict["FirstName"].stringValue)
                self.LastNameArr.append(dict["LastName"].stringValue)
                self.employeeIDArr.append(dict["EmployeeID"].stringValue)
                self.completedArr.append("0")
                self.onprogressArr.append("0")
                self.pendingArr.append("0")
                self.dndArr.append("0")
                self.userMobArr.append(dict["UserMobileID"].stringValue)
               // print("SU login Admin UserMobArr", self.userMobArr)
                self.EmpArr.append(dict["FirstName"].stringValue + " " + dict["LastName"].stringValue)
                
                let employeeDetailsArray = dict["employeeDetails"]
                for (_, dict) in employeeDetailsArray {
                    self.levelNameArr.append(LEVEL)
                    self.USERArr.append("Employee")
                    self.FirstNameArr.append(dict["FirstName"].stringValue)
                    self.LastNameArr.append(dict["LastName"].stringValue)
                    self.completedArr.append(dict["workDetails"][0].stringValue)
                    self.onprogressArr.append(dict["workDetails"][1].stringValue)
                    self.pendingArr.append(dict["workDetails"][2].stringValue)
                    self.dndArr.append(dict["workDetails"][3].stringValue)
                    self.employeeIDArr.append(dict["EmployeeID"].stringValue)
                    self.userMobArr.append(dict["UserMobileID"].stringValue)
                   // print("SU login Employee UserMobArr", self.userMobArr)
                    self.EmpArr.append(dict["FirstName"].stringValue + " " + dict["LastName"].stringValue)
                }
            }
        } else if self.defaults.string(forKey: "employeeStatusID") == "2" {
            for (_, dict) in jsonArray["JsonWorkers"].reversed() { //(key or index, element)
                let LEVEL = dict["levelName"].stringValue
                let employeeDetailsArray = dict["employeeDetails"]
                for (_, dict) in employeeDetailsArray {
                    self.levelNameArr.append(LEVEL)
                    self.USERArr.append("Employee")
                    self.FirstNameArr.append(dict["FirstName"].stringValue)
                    self.LastNameArr.append(dict["LastName"].stringValue)
                    self.completedArr.append(dict["workDetails"][0].stringValue)
                    self.onprogressArr.append(dict["workDetails"][1].stringValue)
                    self.pendingArr.append(dict["workDetails"][2].stringValue)
                    self.dndArr.append(dict["workDetails"][3].stringValue)
                    self.employeeIDArr.append(dict["EmployeeID"].stringValue)
                    self.userMobArr.append(dict["UserMobileID"].stringValue)
                    //print(" Admin login employee UserMobArr", self.userMobArr)
                    self.EmpArr.append(dict["FirstName"].stringValue + " " + dict["LastName"].stringValue)
                }
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func SeGmentChange(sender: UISegmentedControl) {
        let cell = self.tblAssignNew.dequeueReusableCell(withIdentifier: "AssignTo") as! tblAssignToCell
        cell.employee?.text = ""
        cell.completed1?.text = ""
        cell.onprogress1?.text = ""
        cell.pending1?.text = ""
        cell.dnd1?.text = ""
        cell.employeeID?.text = ""
        cell.UserMobile?.text = ""
        cell.empName?.text = ""
        cell.empLevel?.text = ""
        cell.EmployeeStatus?.text = ""
        
        USERArr.removeAll()
        FirstNameArr.removeAll()
        LastNameArr.removeAll()
        completedArr.removeAll()
        onprogressArr.removeAll()
        pendingArr.removeAll()
        dndArr.removeAll()
        employeeIDArr.removeAll()
        userMobArr.removeAll()
        EmpArr.removeAll()
        multiUserMobArr.removeAll()
        
        let jsonArray = JSON(data!)
        
        if defaults.string(forKey: "employeeStatusID") == "1" || self.defaults.string(forKey: "employeeStatusID") == "3" {
            for (_, dict) in jsonArray["JsonWorkers"].reversed() { //(key or index, element)
                let LEVEL = dict["levelName"].stringValue
                if (TotallevelNameArr.contains(LEVEL)) {
                    let employeeDetailsArray = dict["employeeDetails"]
                    for (_, dict) in employeeDetailsArray {
                        self.levelNameArr.append(LEVEL)
                        self.USERArr.append("Employee")
                        self.FirstNameArr.append(dict["FirstName"].stringValue)
                        self.LastNameArr.append(dict["LastName"].stringValue)
                        self.completedArr.append(dict["workDetails"][0].stringValue)
                        self.onprogressArr.append(dict["workDetails"][1].stringValue)
                        self.pendingArr.append(dict["workDetails"][2].stringValue)
                        self.dndArr.append(dict["workDetails"][3].stringValue)
                        self.employeeIDArr.append(dict["EmployeeID"].stringValue)
                        self.userMobArr.append(dict["UserMobileID"].stringValue)
                        self.EmpArr.append(dict["FirstName"].stringValue + " " + dict["LastName"].stringValue)
                    }
                }
            }
        } else{
            for (_, dict) in jsonArray["JsonWorkers"].reversed() { //(key or index, element)
                let LEVEL = dict["levelName"].stringValue
                if (TotallevelNameArr.contains(LEVEL)) {
                    self.USERArr.append("Supervisor")
                    self.FirstNameArr.append(dict["FirstName"].stringValue)
                    self.LastNameArr.append(dict["LastName"].stringValue)
                    self.employeeIDArr.append(dict["EmployeeID"].stringValue)
                    self.completedArr.append("0")
                    self.onprogressArr.append("0")
                    self.pendingArr.append("0")
                    self.dndArr.append("0")
                    self.userMobArr.append(dict["UserMobileID"].stringValue)
                    self.EmpArr.append(dict["FirstName"].stringValue + " " + dict["LastName"].stringValue)
                    
                    let employeeDetailsArray = dict["employeeDetails"]
                    for (_, dict) in employeeDetailsArray {
                        self.levelNameArr.append(LEVEL)
                        self.USERArr.append("Employee")
                        self.FirstNameArr.append(dict["FirstName"].stringValue)
                        self.LastNameArr.append(dict["LastName"].stringValue)
                        self.completedArr.append(dict["workDetails"][0].stringValue)
                        self.onprogressArr.append(dict["workDetails"][1].stringValue)
                        self.pendingArr.append(dict["workDetails"][2].stringValue)
                        self.dndArr.append(dict["workDetails"][3].stringValue)
                        self.employeeIDArr.append(dict["EmployeeID"].stringValue)
                        self.userMobArr.append(dict["UserMobileID"].stringValue)
                        self.EmpArr.append(dict["FirstName"].stringValue + " " + dict["LastName"].stringValue)
                    }
                }
            }
        }
        self.tblAssignNew?.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FirstNameArr.count
    }
    
    var pendingTask:String = ""
    var EmployeeId:String = ""
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblAssignNew.dequeueReusableCell(withIdentifier: "AssignTo", for: indexPath) as! tblAssignToCell
        autoreleasepool {
            cell.employee?.text = ""
            cell.completed1?.text = ""
            cell.onprogress1?.text = ""
            cell.pending1?.text = ""
            cell.dnd1?.text = ""
            cell.employeeID?.text  = ""
            cell.UserMobile?.text = ""
            cell.empName?.text = ""
            cell.empLevel?.text = ""
            cell.EmployeeStatus?.text = ""
            
            //print("TABLEVIEW UserMobile Arr", self.userMobArr[indexPath.row])
            
            if self.USERArr[indexPath.row] == "Supervisor" {
                cell.EmployeeStatus?.text = "Supervisor"
                cell.employee?.text = self.FirstNameArr[indexPath.row] + " " + self.LastNameArr[indexPath.row]
                cell.completed1?.text = "0"
                cell.onprogress1?.text = "0"
                cell.pending1?.text = "0"
                cell.dnd1?.text = "0"
                cell.employeeID?.text = self.employeeIDArr[indexPath.row]
                cell.UserMobile?.text = self.userMobArr[indexPath.row]
                cell.empName?.text = self.EmpArr[indexPath.row]
                cell.empLevel?.text = self.levelNameArr[indexPath.row]
            } else if self.USERArr[indexPath.row] == "Employee" {
                cell.EmployeeStatus?.text = "Employee"
                cell.employee?.text = self.FirstNameArr[indexPath.row] + " " + self.LastNameArr[indexPath.row]
                cell.completed1?.text = self.completedArr[indexPath.row]
                cell.onprogress1?.text = self.onprogressArr[indexPath.row]
                cell.pending1?.text = self.pendingArr[indexPath.row]
                cell.dnd1?.text = self.dndArr[indexPath.row]
                cell.employeeID?.text = self.employeeIDArr[indexPath.row]
                cell.UserMobile?.text = self.userMobArr[indexPath.row]
                cell.empName?.text = self.EmpArr[indexPath.row]
                cell.empLevel?.text = self.levelNameArr[indexPath.row]
            }
            //cell.UserMobile?.text  
            //self.userMobArr[indexPath.row]
            if cell.UserMobile?.text == "false" || cell.UserMobile?.text == "0" || cell.UserMobile?.text == "" {
                cell.mobile?.isHidden = true
                cell.statuslbl?.text = "Active Status: Offline"
                cell.statuslbl?.textColor = UIColor.red
            } else {
                cell.mobile?.isHidden = false
                cell.statuslbl?.text = "Active Status: Online"
                cell.statuslbl?.textColor = UIColor(red: 0/255.0, green: 128/255.0, blue: 0/255.0, alpha: 1.0)
            }
            cell.AssignedToRole?.text = self.USERArr[indexPath.row]
            cell.assign?.layer.cornerRadius = 3.0
            cell.assign?.layer.masksToBounds = true
            cell.assign?.layer.borderWidth = 1
            let myColorT : UIColor = UIColor.white
            cell.assign?.layer.borderColor = myColorT.cgColor
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        autoreleasepool {
            let Cell = tableView.cellForRow(at: indexPath)! as! tblAssignToCell
            var send = ""
            if Cell.pending1?.text == "0" {
                send = "0"
            } else{
                send = (Cell.pending1?.text)!
            }
            let send2 = Cell.employeeID?.text
            let send3 = Cell.UserMobile?.text
            let send4 = Cell.empName?.text
            let send5 = Cell.AssignedToRole?.text

            if self.USERArr[indexPath.row] == "Supervisor" {
                if Cell.UserMobile?.text == "false" || Cell.UserMobile?.text == "0" {
                    self.getPendingTasks(pendingText : send , pendingText2 : send2! , pendingText3 : send3! , pendingText4 : "Offline" , pendingText5 : send4!, pendingText6 : send5! , pendingText7 : ["0"])
                } else {
                    self.getPendingTasks(pendingText : send , pendingText2 : send2! , pendingText3 : send3! , pendingText4 : "Online" , pendingText5 : send4!, pendingText6 : send5! , pendingText7 : ["0"])
                }
            } else {
                let jsonArray = JSON(data!)
                
                for (_, dict) in jsonArray["JsonWorkers"] {
                    self.multiUserMobArr.append(dict["UserMobileID"].stringValue)
                    let employeeDetailsArray = dict["employeeDetails"]
                    if (TotallevelNameArr.contains((Cell.empLevel?.text)!)) {
                        for (_, dict) in employeeDetailsArray {
                            let EmpID = dict["EmployeeID"].stringValue
                            if (EmpID.contains(send2!)) {
                                self.multiUserMobArr.append(dict["UserMobileID"].stringValue)
                            }
                        }
                    }
                }
                
                //print("self.multiUserMobAr  " ,self.multiUserMobArr)
                
                if Cell.UserMobile?.text == "false" || Cell.UserMobile?.text == "0" {
                    self.getPendingTasks(pendingText : send , pendingText2 : send2! , pendingText3 : send3! , pendingText4 : "Offline" , pendingText5 : send4!, pendingText6 : send5! , pendingText7 : self.multiUserMobArr)
                } else {
                    self.getPendingTasks(pendingText : send , pendingText2 : send2! , pendingText3 : send3! , pendingText4 : "Online" , pendingText5 : send4!, pendingText6 : send5! , pendingText7 : self.multiUserMobArr)
                }
                
            }
        }
    }
    
    var sendPendingStr:String = ""
    var sendPendingStr2:String = ""
    var sendPendingStr3:String = ""
    var sendPendingStr4:String = ""
    var sendPendingStr5:String = ""
    var sendPendingStr6:String = ""
    var sendPendingStr7:[String] = [""]
    
    func getPendingTasks(pendingText: String, pendingText2: String, pendingText3: String, pendingText4: String, pendingText5: String, pendingText6: String, pendingText7: [String]) {
        OperationQueue.main.addOperation {
            autoreleasepool {
                let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let vicCont = mainStoryboard.instantiateViewController(withIdentifier: "taskDesciption") as! taskDescription
                self.sendPendingStr = pendingText
                self.sendPendingStr2 = pendingText2
                self.sendPendingStr3 = pendingText3
                self.sendPendingStr4 = pendingText4
                self.sendPendingStr5 = pendingText5
                self.sendPendingStr6 = pendingText6
                self.sendPendingStr7 = pendingText7
                let defaults = UserDefaults.standard
                defaults.set(self.sendPendingStr, forKey: "pendingTask")
                vicCont.USERMOB = self.sendPendingStr3
                vicCont.userStatus = self.sendPendingStr4
                vicCont.employeeName = self.sendPendingStr5
                vicCont.ROLE = self.sendPendingStr6
                vicCont.MULTIArr = self.sendPendingStr7 
                defaults.set(self.sendPendingStr2, forKey: "EMPId")
                self.present(vicCont, animated: true, completion: nil)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

