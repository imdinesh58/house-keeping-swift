
import UIKit
import Alamofire
import SwiftyJSON

class viewAdminTask: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBAction func Exit() {
        self.dismiss(animated: true, completion: nil)
    }
    
    var employee2 : String = ""
    var task2 : String = ""
    var location22 : String = ""
    var checklist2 : String = ""
    var priority2 : String = ""
    var comments2 : String = "none"
    var TASKID : String = ""
    var IsDistributed : String = ""
    var AssignedBYRoleID : String = ""
    var ASSIGNED_BY : String = ""
    
    @IBOutlet weak var lblEmployee : UILabel!
    @IBOutlet weak var lblPriority : UILabel!
    @IBOutlet weak var Tasks : UILabel!
    @IBOutlet weak var location2 : UILabel!
    @IBOutlet weak var tblChecklist : UITableView!
    @IBOutlet weak var comments: UILabel!
    @IBOutlet weak var btnDistribute: UIButton!
    
    var ChecklistTypes: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblChecklist?.delegate = self
        self.tblChecklist?.dataSource = self
        lblEmployee.text = employee2
        lblPriority.text = priority2
        Tasks.text = task2
        print("TASKID  " , TASKID)
        print("IsDistributed  " ,IsDistributed)
        location2.text = location22
        if comments2.characters.count > 1 {
            comments.text = "Comments: " + comments2
        } else {
            comments.text = "Comments: none"
        }
       
        
        print("AssignedBYRoleID  ", AssignedBYRoleID)
        
        if AssignedBYRoleID == "1" || IsDistributed == "1" {
            btnDistribute.isHidden = true
        } else {
            btnDistribute.isHidden = false
        }
        print("checklist2  " , checklist2)
        ChecklistTypesAPICall()
    }
    
    @IBAction func DistributeTaskClik() {
        OperationQueue.main.addOperation {
            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vicCont2 = mainStoryboard.instantiateViewController(withIdentifier: "Distributetask") as! Distributetask
            vicCont2.TASKNAMEID = self.TASKID
            vicCont2.ASSIGNED_BY__ = self.ASSIGNED_BY
            self.present(vicCont2, animated: true, completion: nil)
        }
    }
    
    
    func ChecklistTypesAPICall()  {
        let String1 = HKURL + "/getjson/checklistdetails/" + checklist2
        Alamofire.request(String1, method: .get, parameters: [:], encoding: URLEncoding.httpBody, headers: ["Content-Type":"application/json"]).responseString {
            response in
            switch response.result {
            case .success(let value):
                let strData = String(describing: value).data(using: String.Encoding.utf8)
                let jsonArray = JSON(strData!)
                print("ChecklistTypesAPICall success")
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
