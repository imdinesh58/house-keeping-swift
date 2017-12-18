
import UIKit
import Alamofire
import Firebase
import Fusuma

 var objects8: [saveGalleryImage2] = []

class home: UIViewController,FusumaDelegate,UIPopoverPresentationControllerDelegate {

    //viewDidLoad close
    @IBOutlet weak var All0: UIButton!
    @IBOutlet weak var All1: UILabel!
    @IBOutlet weak var completed0: UIButton!
    @IBOutlet weak var completed1: UILabel!
    @IBOutlet weak var onprogress0: UIButton!
    @IBOutlet weak var onprogress1: UILabel!
    @IBOutlet weak var pending0: UIButton!
    @IBOutlet weak var pending1: UILabel!
    @IBOutlet weak var DND0: UIButton!
    @IBOutlet weak var DND1: UILabel!
    @IBOutlet weak var NoOfTasks: UILabel!
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var profieIMG: UIImageView!
    
    @IBOutlet weak var team: UILabel!
    @IBOutlet weak var hotelname: UILabel!
    @IBOutlet weak var branchname: UILabel!
    @IBOutlet weak var Role: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        defaults.set("LoggesAsAdmin", forKey: "LOGIN_TYPE")
        UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Arial", size: 12)!], for: .normal)
        let name = self.defaults.string(forKey: "name")
        let Hotelname = self.defaults.string(forKey: "hotelName")
        let Branchname = self.defaults.string(forKey: "branchName")
        team?.text = name
        hotelname?.text = Hotelname
        branchname?.text = Branchname
        
       /* var statusId = defaults.string(forKey: "employeeStatusID")!
        if statusId.isEmpty == false || statusId != "" {
            if statusId == "1" {
                statusId = "Super User"
            } else if statusId == "2" {
                statusId = "Supervisor"
            }
        }
       
        Role.text = statusId */
        
        All1?.isHidden = false
        completed1?.isHidden = false
        onprogress1?.isHidden = true
        pending1?.isHidden = true
        DND1?.isHidden = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(home.setProfile))
        profieIMG?.addGestureRecognizer(tap)
        profieIMG?.isUserInteractionEnabled = true
        
        OperationQueue.main.addOperation{
                NotificationCenter.default.addObserver(self, selector: #selector(self.ArefreshAll), name: NSNotification.Name(rawValue: "ArefreshAll"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.ArefreshCompleted), name: NSNotification.Name(rawValue: "ArefreshCompleted"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.ArefreshOnprogress), name: NSNotification.Name(rawValue: "ArefreshOnprogress"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.ArefreshPending), name: NSNotification.Name(rawValue: "ArefreshPending"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.ArefreshDND), name: NSNotification.Name(rawValue: "ArefreshDND"), object: nil)
                self.NoOfTasks?.text = ""
                NotificationCenter.default.addObserver(self, selector: #selector(self.refreshLbl), name: NSNotification.Name(rawValue: "refreshLbl"), object: nil)
            }
        
        refreshLbl()
        
        profieIMG?.image = nil
        
        if objects8.isEmpty == true {
            profieIMG?.image =  UIImage(named: "sample_profile")
        } else {
            profieIMG?.image =  UIImage(named: "sample_profile")
            /*for objectt in objects8 {
                profieIMG?.image = objectt.saveimages2
                profieIMG?.layer.masksToBounds = false
                profieIMG?.clipsToBounds = true
                profieIMG?.layer.cornerRadius = 25.0
                profieIMG?.layer.borderWidth = 0.1
                let myColorWhite2 : UIColor =  UIColor(red: 238/255.0, green: 41/255.0, blue: 105/255.0, alpha: 1.0)
                profieIMG?.layer.borderColor = myColorWhite2.cgColor
            } */
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //refreshLbl()
    }
    
    func refreshLbl() {
        //self.NoOfTasks?.text = ""
        //let defaults = UserDefaults.standard
        //let RefreshLbl = defaults.string(forKey: "RefreshLbl")
       // self.NoOfTasks?.text = RefreshLbl!
    }
    
    @IBAction func EXIT() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func AllOnClick() {
        print("AllOnClick")
        All1?.isHidden = false
        completed1?.isHidden = true
        onprogress1?.isHidden = true
        pending1?.isHidden = true
        DND1?.isHidden = true
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "clickedAll"), object: nil)
    }
    @IBAction func CompletedOnClick() {
        print("CompletedOnClick")
        All1?.isHidden = true
        completed1?.isHidden = false
        onprogress1?.isHidden = true
        pending1?.isHidden = true
        DND1?.isHidden = true
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "clickedCompleted"), object: nil)
    }
    @IBAction func OnProgressClick() {
        print("OnprogressOnClick")
        All1?.isHidden = true
        completed1?.isHidden = true
        onprogress1?.isHidden = false
        pending1?.isHidden = true
        DND1?.isHidden = true
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "clickedOnProgress"), object: nil)
    }
    @IBAction func pending1OnClick() {
        print("PendingOnClick")
        All1?.isHidden = true
        completed1?.isHidden = true
        onprogress1?.isHidden = true
        pending1?.isHidden = false
        DND1?.isHidden = true
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "clickedPending"), object: nil)
    }
    @IBAction func DNDOnClick() {
        All1?.isHidden = true
        completed1?.isHidden = true
        onprogress1?.isHidden = true
        pending1?.isHidden = true
        DND1?.isHidden = false
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "clickedDND"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func ArefreshAll() {
        All1?.isHidden = true
        completed1?.isHidden = false
        onprogress1?.isHidden = true
        pending1?.isHidden = true
        DND1?.isHidden = true
    }
    func ArefreshCompleted() {
        All1?.isHidden = true
        completed1?.isHidden = false
        onprogress1?.isHidden = true
        pending1?.isHidden = true
        DND1?.isHidden = true
    }
    func ArefreshOnprogress() {
        All1?.isHidden = true
        completed1?.isHidden = true
        onprogress1?.isHidden = false
        pending1?.isHidden = true
        DND1?.isHidden = true
    }
    func ArefreshPending() {
        All1?.isHidden = true
        completed1?.isHidden = true
        onprogress1?.isHidden = true
        pending1?.isHidden = false
        DND1?.isHidden = true
    }
    func ArefreshDND() {
        All1?.isHidden = true
        completed1?.isHidden = true
        onprogress1?.isHidden = true
        pending1?.isHidden = true
        DND1?.isHidden = false
    }
    
    public func fusumaVideoCompleted(withFileURL fileURL: URL) {
        print("video completed and output to file: \(fileURL)")
    }
    
    let fusuma = FusumaViewController()
    func setProfile() {
        fusuma.delegate = self
        fusuma.cropHeightRatio = 0.6
        fusuma.hasVideo = false
        fusuma.allowMultipleSelection = false
        fusumaSavesImage = true
        self.present(fusuma, animated: true, completion: nil)
    }
    
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        objects8.removeAll()
        switch source {
        case .camera:
            print("Image captured from Camera")
        case .library:
            print("Image selected from Camera Roll")
        default:
            print("Image selected")
        }
        let thisObj = saveGalleryImage2(saveimages2: image)
        objects8.append(thisObj)

        profieIMG.image = nil
        for objectt in objects8 {
            profieIMG.image = objectt.saveimages2
            profieIMG.layer.masksToBounds = false
            profieIMG.clipsToBounds = true
            profieIMG.layer.cornerRadius = 25.0
            profieIMG.layer.borderWidth = 0.1
            let myColorWhite2 : UIColor =  UIColor(red: 238/255.0, green: 41/255.0, blue: 105/255.0, alpha: 1.0)
            profieIMG.layer.borderColor = myColorWhite2.cgColor
        }
    }
    
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode, metaData: ImageMetadata) {
        print("Location: \(String(describing: metaData.location))")
    }
    
    func fusumaDismissedWithImage(_ image: UIImage, source: FusumaMode) {
        switch source {
        case .camera:
            print("Called just after dismissed FusumaViewController using Camera")
        case .library:
            print("Called just after dismissed FusumaViewController using Camera Roll")
        default:
            print("Called just after dismissed FusumaViewController")
        }
    }
    
    public func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {
        print("MULTIPLE Number of selection images: \(images.count)")
    }
    
    func fusumaCameraRollUnauthorized() {
        let alert = UIAlertController(title: "Access Requested",
                                      message: "Saving image needs to access your photo album",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { (action) -> Void in
            if let url = URL(string:UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url, options: ["" : ""], completionHandler: nil)
                // UIApplication.shared.openURL(url)
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func LOGOUTCLICK() {
        //Clear Objects
        objects.removeAll()
        objects2.removeAll()
        objects3.removeAll()
        objects4.removeAll()
        objects5.removeAll()
        objects6.removeAll()
        objects8.removeAll()
        objects77.removeAll()
        objectsrole1.removeAll()
        objectsrole2.removeAll()
        objectsrole3.removeAll()
        objectsrole4.removeAll()
        objectsrole5.removeAll()
        objectsrole6.removeAll()
        objectsrole7.removeAll()

        
        User.logOutUser { (status) in }
        
        let defaults = UserDefaults.standard
        defaults.set(nil, forKey: "RefreshLbl")
        defaults.set(nil, forKey: "LOGIN_TYPE")
        //defaults.set("", forKey: "NotificationToken")
        defaults.set(nil, forKey: "AccessToken")
        defaults.set(nil, forKey: "employeeStatusID")
        defaults.set(nil, forKey: "DefaultJSON")
        
        let employeeIDLogins = defaults.string(forKey: "employeeIDLogin")
        let URI = HKURL+"/putvalue/updatelogoutstatus/"
        Alamofire.request(URI+employeeIDLogins!, method: .put, parameters: [:], encoding: URLEncoding.default, headers: ["Content-Type":"application/json"]).responseJSON {
            response in
            switch response.result {
            case .success( _):
                print(" PUT Logout API Success ")
                OperationQueue.main.addOperation {  // run in main thread
                    let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "login") as UIViewController
                    self.present(vc, animated: true, completion: nil)
                }
                break
            case .failure( _):
                print("PUT Logout API Failure")
                break
            }
        }
        
        //Firebase logout
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

