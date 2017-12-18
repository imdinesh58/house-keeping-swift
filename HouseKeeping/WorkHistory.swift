

import UIKit

class WorkHistory: UIViewController {
    @IBOutlet weak var all0: UIButton!
    @IBOutlet weak var completed0: UIButton!
    @IBOutlet weak var inprogress0: UIButton!
    @IBOutlet weak var pending0: UIButton!
    @IBOutlet weak var dnd0: UIButton!
    @IBOutlet weak var all1: UILabel!
    @IBOutlet weak var completed1: UILabel!
    @IBOutlet weak var inprogress1: UILabel!
    @IBOutlet weak var pending1: UILabel!
    @IBOutlet weak var dnd1: UILabel!
    @IBAction func calendarBtnClick() {
        let currentDate = Date()
        var dateComponents = DateComponents()
        dateComponents.month = -150
        let threeMonthAgo = Calendar.current.date(byAdding: dateComponents, to: currentDate)
        var dateComponents2 = DateComponents()
        dateComponents2.month = 250
        let oneYearAfter = Calendar.current.date(byAdding: dateComponents2, to: currentDate)
        
        DatePickerDialog().show(" ", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", minimumDate: threeMonthAgo, maximumDate: oneYearAfter, datePickerMode: .date) { (date) in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                OperationQueue.main.addOperation {
                    let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    let vicCont = mainStoryboard.instantiateViewController(withIdentifier: "selectedHistory") as! selectedHistory
                    vicCont.selectedHistory = formatter.string(from: dt)
                    self.present(vicCont, animated: true, completion: nil)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        all1?.isHidden = false
        completed1?.isHidden = true
        inprogress1?.isHidden = true
        pending1?.isHidden = true
        dnd1?.isHidden = true
        OperationQueue.main.addOperation{
            NotificationCenter.default.addObserver(self, selector: #selector(self.HrefreshAll), name: NSNotification.Name(rawValue: "HrefreshAll"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.HrefreshCompleted), name: NSNotification.Name(rawValue: "HrefreshCompleted"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.HrefreshOnprogress), name: NSNotification.Name(rawValue: "HrefreshOnprogress"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.HrefreshPending), name: NSNotification.Name(rawValue: "HrefreshPending"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.HrefreshDND), name: NSNotification.Name(rawValue: "HrefreshDND"), object: nil)
        }
    }
    @IBAction func AllOnClick() {
        all1?.isHidden = false
        completed1?.isHidden = true
        inprogress1?.isHidden = true
        pending1?.isHidden = true
        dnd1?.isHidden = true
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HclickedAll"), object: nil)
        
    }
    @IBAction func completedOnClick() {
        all1?.isHidden = true
        completed1?.isHidden = false
        inprogress1?.isHidden = true
        pending1?.isHidden = true
        dnd1?.isHidden = true
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HclickedCompleted"), object: nil)
    }
    @IBAction func inProgressClick() {
        all1?.isHidden = true
        completed1?.isHidden = true
        inprogress1?.isHidden = false
        pending1?.isHidden = true
        dnd1?.isHidden = true
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HclickedOnProgress"), object: nil)
    }
    @IBAction func pendingClick() {
        all1?.isHidden = true
        completed1?.isHidden = true
        inprogress1?.isHidden = true
        pending1?.isHidden = false
        dnd1?.isHidden = true
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HclickedPending"), object: nil)
    }
    @IBAction func DnDClick() {
        all1?.isHidden = true
        completed1?.isHidden = true
        inprogress1?.isHidden = true
        pending1?.isHidden = true
        dnd1?.isHidden = false
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HclickedDND"), object: nil)
    }
    
    func HrefreshAll() {
        all1?.isHidden = false
        completed1?.isHidden = true
        inprogress1?.isHidden = true
        pending1?.isHidden = true
        dnd1?.isHidden = true
    }
    func HrefreshCompleted() {
        all1?.isHidden = true
        completed1?.isHidden = false
        inprogress1?.isHidden = true
        pending1?.isHidden = true
        dnd1?.isHidden = true
    }
    func HrefreshOnprogress() {
        all1?.isHidden = true
        completed1?.isHidden = true
        inprogress1?.isHidden = false
        pending1?.isHidden = true
        dnd1?.isHidden = true
    }
    func HrefreshPending() {
        all1?.isHidden = true
        completed1?.isHidden = true
        inprogress1?.isHidden = true
        pending1?.isHidden = false
        dnd1?.isHidden = true
    }
    func HrefreshDND() {
        all1?.isHidden = true
        completed1?.isHidden = true
        inprogress1?.isHidden = true
        pending1?.isHidden = true
        dnd1?.isHidden = false
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
