
import UIKit
import SwiftyJSON

class EmployeeDetails: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tblViewEmployeeDetails: UITableView!
    
    var FirstNameArr:[String] = []
    var RoleArr:[String] = []
    var LastNameArr:[String] = []
    var EmailArr:[String] = []
    var PhoneArr:[String] = []
    var AddressArr:[String] = []
    var userMobArr:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirstNameArr.removeAll()
        LastNameArr.removeAll()
        RoleArr.removeAll()
        userMobArr.removeAll()
        PhoneArr.removeAll()
        EmailArr.removeAll()
        AddressArr.removeAll()
        self.tblViewEmployeeDetails?.delegate = self
        self.tblViewEmployeeDetails?.dataSource = self
        // Do any additional setup after loading the view.
        self.getTheListJSON()
    }
    
    let defaults = UserDefaults.standard
    func getTheListJSON(){
        autoreleasepool {
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
            autoreleasepool {
                if let data = text.data(using: String.Encoding.utf8) {
                    do {
                        let jsonObj = try JSONSerialization.jsonObject(with: data, options: [])
                        let jsonArray = JSON(jsonObj)
                        if self.defaults.string(forKey: "employeeStatusID") == "1" {
                            for (_, dict) in jsonArray["JsonWorkers"] {
                                self.RoleArr.append("Supervisor")
                                self.FirstNameArr.append(dict["FirstName"].stringValue)
                                self.LastNameArr.append(dict["LastName"].stringValue)
                                self.userMobArr.append(dict["UserMobileID"].stringValue)
                                print("Super user login Supervisor userMobArr ", self.userMobArr)
                                self.PhoneArr.append(dict["Phone"].stringValue)
                                self.EmailArr.append(dict["Email"].stringValue)
                                self.AddressArr.append(dict["Address"].stringValue)
                                
                                let employeeDetailsArray = dict["employeeDetails"]
                                for (_, dict) in employeeDetailsArray {
                                    self.RoleArr.append("Employee")
                                    self.FirstNameArr.append(dict["FirstName"].stringValue)
                                    self.LastNameArr.append(dict["LastName"].stringValue)
                                    self.userMobArr.append(dict["UserMobileID"].stringValue)
                                    print("Super user login Employee userMobArr ", self.userMobArr)
                                    self.PhoneArr.append(dict["Phone"].stringValue)
                                    self.EmailArr.append(dict["Email"].stringValue)
                                    self.AddressArr.append(dict["Address"].stringValue)
                                }
                            }
                        } else if self.defaults.string(forKey: "employeeStatusID") == "2" {
                            for (_, dict) in jsonArray["JsonWorkers"] {
                                let employeeDetailsArray = dict["employeeDetails"]
                                for (_, dict) in employeeDetailsArray {
                                    self.RoleArr.append("Employee")
                                    self.FirstNameArr.append(dict["FirstName"].stringValue)
                                    self.LastNameArr.append(dict["LastName"].stringValue)
                                    self.userMobArr.append(dict["UserMobileID"].stringValue)
                                    print("Admin login Employee userMobArr ", self.userMobArr)
                                    self.PhoneArr.append(dict["Phone"].stringValue)
                                    self.EmailArr.append(dict["Email"].stringValue)
                                    self.AddressArr.append(dict["Address"].stringValue)
                                }
                            }
                        } else {
                            for (_, dict) in jsonArray["JsonWorkers"] {
                                
                                self.RoleArr.append("Supervisor")
                                self.FirstNameArr.append(dict["FirstName"].stringValue)
                                self.LastNameArr.append(dict["LastName"].stringValue)
                                self.userMobArr.append(dict["UserMobileID"].stringValue)
                                print("Super user login Supervisor userMobArr ", self.userMobArr)
                                self.PhoneArr.append(dict["Phone"].stringValue)
                                self.EmailArr.append(dict["Email"].stringValue)
                                self.AddressArr.append(dict["Address"].stringValue)
                                
                                let employeeDetailsArray = dict["employeeDetails"]
                                for (_, dict) in employeeDetailsArray {
                                    self.RoleArr.append("Employee")
                                    self.FirstNameArr.append(dict["FirstName"].stringValue)
                                    self.LastNameArr.append(dict["LastName"].stringValue)
                                    self.userMobArr.append(dict["UserMobileID"].stringValue)
                                    print("Super user login Employee userMobArr ", self.userMobArr)
                                    self.PhoneArr.append(dict["Phone"].stringValue)
                                    self.EmailArr.append(dict["Email"].stringValue)
                                    self.AddressArr.append(dict["Address"].stringValue)
                                }
                            }
                        }
                        self.tblViewEmployeeDetails?.reloadData()
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
        return FirstNameArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblViewEmployeeDetails.dequeueReusableCell(withIdentifier: "employee", for: indexPath)
        
        for initial in cell.subviews
        {
            if initial.tag == 1010
            {
                initial.removeFromSuperview()
            }
        }
        for Name in cell.subviews
        {
            if Name.tag == 1011
            {
                Name.removeFromSuperview()
            }
        }
        for status in cell.subviews
        {
            if status.tag == 1012
            {
                status.removeFromSuperview()
            }
        }
        for role in cell.subviews
        {
            if role.tag == 1018
            {
                role.removeFromSuperview()
            }
        }
        for phone in cell.subviews
        {
            if phone.tag == 1013
            {
                phone.removeFromSuperview()
            }
        }
        for email in cell.subviews
        {
            if email.tag == 1014
            {
                email.removeFromSuperview()
            }
        }
        for address in cell.subviews
        {
            if address.tag == 1015
            {
                address.removeFromSuperview()
            }
        }
        
        let Name = UILabel(frame: CGRect(x: 120, y: 0, width: 250.0, height: 50.0))
        Name.text =  self.FirstNameArr[indexPath.row] + " " + self.LastNameArr[indexPath.row]
        Name.textColor = UIColor.black
        Name.tag = 1011
        Name.clearsContextBeforeDrawing = true
        Name.baselineAdjustment = .alignCenters
        Name.font = UIFont(name: "Futura-bold", size: 13)!
        Name.numberOfLines = 0
        cell.addSubview(Name)
        
        let phone = UILabel(frame: CGRect(x: 120, y: 18, width: 200.0, height: 50.0))
        phone.text =  self.PhoneArr[indexPath.row]
        phone.textColor = UIColor.black
        phone.tag = 1013
        phone.clearsContextBeforeDrawing = true
        phone.baselineAdjustment = .alignCenters
        phone.font = UIFont(name: "Futura", size: 12)!
        phone.numberOfLines = 0
        cell.addSubview(phone)
        
        let email = UILabel(frame: CGRect(x: 120, y: 35, width: 200.0, height: 50.0))
        email.text =  self.EmailArr[indexPath.row]
        email.textColor = UIColor.black
        email.tag = 1014
        email.clearsContextBeforeDrawing = true
        email.baselineAdjustment = .alignCenters
        email.font = UIFont(name: "Futura", size: 12)!
        email.numberOfLines = 0
        cell.addSubview(email)
        
        let address = UILabel(frame: CGRect(x: 120, y: 52, width: 250.0, height: 50.0))
        address.text =  self.AddressArr[indexPath.row]
        address.textColor = UIColor.black
        address.tag = 1015
        address.clearsContextBeforeDrawing = true
        address.baselineAdjustment = .alignCenters
        address.font = UIFont(name: "Futura", size: 12)!
        address.numberOfLines = 0
        cell.addSubview(address)
        
        print("self.userMobArr[indexPath.row]  TABLEVIEW ", self.userMobArr[indexPath.row])
        
        let status = UILabel(frame: CGRect(x: 120, y: 67, width: 250.0, height: 50.0))
        if self.userMobArr[indexPath.row] == "" || self.userMobArr[indexPath.row] == "0" || self.userMobArr[indexPath.row] == "false" {
            status.text =   "Active Status: Offline"
            status.textColor = UIColor.red
        } else {
            status.text =   "Active Status: Online"
            status.textColor = UIColor(red: 0/255.0, green: 128/255.0, blue: 0/255.0, alpha: 1.0)
        }
        status.tag = 1012
        status.clearsContextBeforeDrawing = true
        status.baselineAdjustment = .alignCenters
        status.font = UIFont(name: "Futura", size: 12)!
        status.numberOfLines = 0
        cell.addSubview(status)
        
        let role = UILabel(frame: CGRect(x: 120, y: 83, width: 250.0, height: 50.0))
        role.text =  "Role: " + self.RoleArr[indexPath.row]
        role.textColor = UIColor(red: 246/255.0, green: 147/255.0, blue: 9/255.0, alpha: 1.0)
        role.tag = 1018
        role.clearsContextBeforeDrawing = true
        role.baselineAdjustment = .alignCenters
        role.font = UIFont(name: "Futura", size: 12)!
        role.numberOfLines = 0
        cell.addSubview(role)
        
        return cell;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
