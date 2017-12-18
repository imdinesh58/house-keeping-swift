//
//  EmployeeLoginHome.swift
//  HouseKeeping
//
//  Created by Apple-1 on 7/18/17.
//  Copyright © 2017 Apple-1. All rights reserved.
//

import UIKit
import Alamofire
import Firebase
import Fusuma

 var objects9: [saveGalleryImage2] = []

class EmployeeLoginHome: UIViewController,FusumaDelegate {
    @IBOutlet weak var pending0: UIButton!
    @IBOutlet weak var pending1: UILabel!
    @IBOutlet weak var completed0: UIButton!
    @IBOutlet weak var completed1: UILabel!
    @IBOutlet weak var profieIMG: UIImageView!
    @IBOutlet weak var DND0: UIButton!
    @IBOutlet weak var DND1: UILabel!
    
    let defaults = UserDefaults.standard
    @IBOutlet weak var team: UILabel!
    @IBOutlet weak var hotelname: UILabel!
    @IBOutlet weak var branchname: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let name = self.defaults.string(forKey: "name")
        let Hotelname = self.defaults.string(forKey: "hotelName")
        let Branchname = self.defaults.string(forKey: "branchName")
        team?.text = name
        hotelname?.text = Hotelname
        branchname?.text = Branchname
        defaults.set("LoggesAsEmployee", forKey: "LOGIN_TYPE")
        defaults.set("TimerNotstarted", forKey: "TIMER")
        pending1?.isHidden = false
        completed1?.isHidden = true
        DND1?.isHidden = true
        OperationQueue.main.addOperation{
            NotificationCenter.default.addObserver(self, selector: #selector(self.ErefreshPending), name: NSNotification.Name(rawValue: "ErefreshPending"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.ErefreshCompleted), name: NSNotification.Name(rawValue: "ErefreshCompleted"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.ErefreshDND), name: NSNotification.Name(rawValue: "ErefreshDND"), object: nil)
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(home.setProfile))
        profieIMG.addGestureRecognizer(tap)
        profieIMG.isUserInteractionEnabled = true
        profieIMG.image = nil
        
        if objects9.isEmpty == true {
            profieIMG.image =  UIImage(named: "sample_profile")
        } else {
            profieIMG.image =  UIImage(named: "sample_profile")
            /*for objectt in objects9 {
                profieIMG.image = objectt.saveimages2
                profieIMG.layer.masksToBounds = false
                profieIMG.clipsToBounds = true
                profieIMG.layer.cornerRadius = 25.0
                profieIMG.layer.borderWidth = 0.1
                let myColorWhite2 : UIColor =  UIColor(red: 238/255.0, green: 41/255.0, blue: 105/255.0, alpha: 1.0)
                profieIMG.layer.borderColor = myColorWhite2.cgColor
            }*/
        }
    }
        deinit {
            NotificationCenter.default.removeObserver(self)
        }
    

    @IBAction func pending1OnClick() {
        completed1.isHidden = true
        pending1.isHidden = false
        DND1.isHidden = true
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "EclickedPending"), object: nil)
    }
    
    @IBAction func CompletedOnClick() {
        completed1.isHidden = false
        pending1.isHidden = true
        DND1.isHidden = true
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "EclickedCompleted"), object: nil)
    }
    
    @IBAction func DNDOnClick() {
        DND1.isHidden = false
        completed1.isHidden = true
        pending1.isHidden = true
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "EclickedDND"), object: nil)
    }
    
    func ErefreshCompleted() {
        DND1?.isHidden = true
        completed1?.isHidden = false
        pending1?.isHidden = true
    }
    
    func ErefreshPending() {
        DND1?.isHidden = true
        completed1?.isHidden = true
        pending1?.isHidden = false
    }
    
    func ErefreshDND() {
        DND1?.isHidden = false
        completed1?.isHidden = true
        pending1?.isHidden = true
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
        objects9.removeAll()
        switch source {
        case .camera:
            print("Image captured from Camera")
        case .library:
            print("Image selected from Camera Roll")
        default:
            print("Image selected")
        }
        let thisObj = saveGalleryImage2(saveimages2: image)
        objects9.append(thisObj)
        
        profieIMG.image = nil
        for objectt in objects9 {
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
                UIApplication.shared.openURL(url)
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func logoutClick() {
        defaults.set("", forKey: "LOGIN_TYPE")
        defaults.set("", forKey: "AccessToken")
        //defaults.set(nil, forKey: "userIDFirebase")
        //defaults.set("", forKey: "NotificationToken")
        defaults.set(nil, forKey: "employeeStatusID")
        defaults.set(nil, forKey: "DefaultJSON")
        //Clear Objects
        objectsEmpLogin.removeAll()
        objectsEmpLogin2.removeAll()
        objectsEmpLogin3.removeAll()
        objectsEmpLogin4.removeAll()
        objectsEmpLogin5.removeAll()
        objectsEmpLogin6.removeAll()
        objectsEmpLogin7.removeAll()
        objectsErole1.removeAll()
        objectsErole2.removeAll()
        objectsErole3.removeAll()
        objectsErole4.removeAll()
        objectsErole5.removeAll()
        objectsErole6.removeAll()
        objectsErole7.removeAll()
        objects9.removeAll()
        
        User.logOutUser { (status) in }
        
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





