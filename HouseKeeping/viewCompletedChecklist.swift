
import UIKit
import Alamofire
import SwiftyJSON

class viewCompletedChecklist: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBAction func Exit() {
        self.dismiss(animated: true, completion: nil)
    }
    
    var employee2 : String = ""
    var task2 : String = ""
    var location22 : String = ""
    var checklist2 : String = ""
    var priority2 : String = ""
    var comments2 : String = "none"
    var checklistID : String = ""
    var checklistIDArr : [String] = []
    var assignedTaskID_ : String  = ""
    
    @IBOutlet weak var lblEmployee : UILabel!
    @IBOutlet weak var lblPriority : UILabel!
    @IBOutlet weak var Tasks : UILabel!
    @IBOutlet weak var location2 : UILabel!
    @IBOutlet weak var tblChecklist : UITableView!
    @IBOutlet weak var comments: UILabel!
    
    var ChecklistTypes: [String] = []
    var ChecklistTypesID: [String] = []
    
    var sendAssignId:String = ""
    
    @IBOutlet weak var scrollViews: UIScrollView!
    
    @IBAction func ViewFullSize() {
        OperationQueue.main.addOperation {  // run in main thread
            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vicCont = mainStoryboard.instantiateViewController(withIdentifier: "FullSizeImage") as! FullSizeImage
            self.sendAssignId = self.assignedTaskID_
            vicCont.assignedTaskID__ = self.sendAssignId
            self.present(vicCont, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblChecklist?.delegate = self
        self.tblChecklist?.dataSource = self
        lblEmployee.text = employee2
        lblPriority.text = priority2
        Tasks.text = task2
        location2.text = location22
        
        checklistIDArr = checklistID.components(separatedBy: ",")
        
        if comments2.characters.count > 1 {
            comments.text = "Comments: " + comments2
        } else {
            comments.text = "Comments: none"
        }
        
        ChecklistTypesAPICall()
        getImageCount()
        getImages()
    }
    
    var ImageArr:Int = 0
    func getImageCount() {
        for object in objects {
            if(assignedTaskID_.contains(String(object.assignedTaskID))){
                print("object.imageCount  ", object.imageCount)
                let splitImg = object.imageCount.components(separatedBy: "-")
                ImageArr = Int(splitImg[1])!
            }
        }
    }
    
    func getImages() {
        var count: Double = 0
        let imageWidth:CGFloat = 100
        let imageHeight:CGFloat = 100
        let yPosition:CGFloat = 15
        var xPosition:CGFloat = 5
        var scrollViewContentSize:CGFloat = 0;
        for myImageView in scrollViews.subviews {
            if myImageView.tag == 1004
            {
                myImageView.removeFromSuperview()
            }
        }
        for imgCnt in 0..<ImageArr {
            print("ID " ,self.assignedTaskID_)
            let String1 = HKImgUrl + "/images/Worker_Images/" + self.assignedTaskID_ + "/Image-"
            let String2 = self.assignedTaskID_
            let String3 = String(imgCnt) + ".jpg"
            let appendString = String1 + String2 + String3
            let url = URL(string: appendString)
            
            Alamofire.request(url!).responseData { (response) in
                if response.error == nil {
                    print(response.result)
                  //DispatchQueue.global(qos: .userInitiated).async {
                    // Show the downloaded image:
                    if let data = response.data {
                        let myImageView:UIImageView = UIImageView()
                        myImageView.image = UIImage(data: data)
                        myImageView.contentMode = UIViewContentMode.scaleAspectFill
                        myImageView.frame.size.width = imageWidth
                        myImageView.frame.size.height = imageHeight
                        myImageView.center = self.view.center
                        myImageView.tag = 1004
                        myImageView.frame.origin.y = yPosition
                        myImageView.frame.origin.x = xPosition
                        myImageView.layer.borderWidth = 1.0
                        myImageView.layer.borderColor = UIColor.white.cgColor
                        myImageView.layer.masksToBounds = false
                        myImageView.clipsToBounds = true
                        myImageView.layer.cornerRadius = myImageView.frame.size.width/2
                        self.scrollViews.addSubview(myImageView)
                        let spacer:CGFloat = 30
                        xPosition+=imageHeight + spacer
                        scrollViewContentSize+=imageHeight + spacer
                        self.scrollViews.contentSize = CGSize(width: scrollViewContentSize, height: imageWidth)
                    }
                   // }
                }
            }
            
            /*
             let task = URLSession.shared.dataTask(with: url!) { data, response, error in
             //guard let data = data, error == nil else { return }
             DispatchQueue.main.sync() {
             let myImageView:UIImageView = UIImageView()
             myImageView.image = UIImage(data: data!)
             myImageView.contentMode = UIViewContentMode.scaleAspectFill
             myImageView.frame.size.width = imageWidth
             myImageView.frame.size.height = imageHeight
             myImageView.center = self.view.center
             myImageView.tag = 1004
             myImageView.frame.origin.y = yPosition
             myImageView.frame.origin.x = xPosition
             myImageView.layer.borderWidth = 1.0
             myImageView.layer.borderColor = UIColor.white.cgColor
             myImageView.layer.masksToBounds = false
             myImageView.clipsToBounds = true
             myImageView.layer.cornerRadius = myImageView.frame.size.width/2
             self.scrollViews.addSubview(myImageView)
             let spacer:CGFloat = 30
             xPosition+=imageHeight + spacer
             scrollViewContentSize+=imageHeight + spacer
             self.scrollViews.contentSize = CGSize(width: scrollViewContentSize, height: imageWidth)
             }
             }
             task.resume() */
        }
        count += 1
    }
    
    func ChecklistTypesAPICall()  {
        let String1 = HKURL + "/getjson/checklistdetails/" + checklist2
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
        return ChecklistTypesID.count
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
        
        for EmployeeID in cell.subviews
        {
            if EmployeeID.tag == 1000
            {
                EmployeeID.removeFromSuperview()
            }
        }
        
        for imageView in cell.subviews {
            if imageView.tag == 1001
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
        
        let EmployeeID = UILabel(frame: CGRect(x: 1, y: 1, width: 1, height: 1))
        EmployeeID.text = self.ChecklistTypesID[indexPath.row]
        EmployeeID.textColor = UIColor.white
        EmployeeID.tag = 1000
        EmployeeID.clearsContextBeforeDrawing = true
        EmployeeID.textAlignment = .left
        EmployeeID.font = UIFont(name: "Futura", size: 1)!
        EmployeeID.numberOfLines = 0
        cell.addSubview(EmployeeID)
        
        ///IMAGE
        var Calendarimage1 : String = ""
        if(checklistIDArr.contains(self.ChecklistTypesID[indexPath.row])){
            Calendarimage1 = "check.png"
        } else {
            Calendarimage1 = "uncheck.png"
        }
        let Calendarimage2 = UIImage(named: Calendarimage1)
        let CalendarimageView = UIImageView(frame: CGRect(x: 360, y: 15, width: 18, height: 18))
        CalendarimageView.tag = 1001
        CalendarimageView.layer.masksToBounds = true
        CalendarimageView.image = Calendarimage2
        cell.addSubview(CalendarimageView)
        
        return cell;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
