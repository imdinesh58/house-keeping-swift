//
//  individualEmpTask.swift
//  HouseKeeping
//
//  Created by Apple-1 on 7/20/17.
//  Copyright © 2017 Apple-1. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class individualEmpTask: UIViewController {
    var assignedTaskID_ : String  = ""
    var taskStatusID_ : String  = ""
    var description_ : String  = ""
    var floorNumber_ : String  = ""
    var location_ : String  = ""
    var TaskCheckId : String = ""
    var AssignedByRoleID : String = ""
    var DURATION1 : String = ""
    
    @IBOutlet weak var Area: UILabel!
    @IBOutlet weak var comments: UILabel!
    @IBOutlet weak var Floors: UILabel!
    var sendAssignId:String = ""
    @IBOutlet weak var durationLbl: UILabel!
    @IBAction func ViewFullSize() {
        OperationQueue.main.addOperation {  // run in main thread
            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vicCont = mainStoryboard.instantiateViewController(withIdentifier: "FullSizeImage") as! FullSizeImage
            self.sendAssignId = self.assignedTaskID_
            vicCont.assignedTaskID__ = self.sendAssignId
            self.present(vicCont, animated: true, completion: nil)
        }
    }
    
    @IBAction func backBtnTask() {
       /* let defaultss = UserDefaults.standard
        let Refresh = defaultss.string(forKey: "RefreshServiceCall2")
        if Refresh == nil || Refresh?.isEmpty == true || Refresh == "" {
            //print("Dont make Service Call")
            self.resetObjects2()
        } else{
            //print("RESET & make Service Call")
            self.resetObjects2()
            defaultss.set("", forKey: "RefreshServiceCall2")
        }*/
        self.dismiss(animated: true, completion: nil)
    }
    
    func resetObjects2() {
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
    }
    
    var ImageArr:Int = 0
    @IBOutlet weak var taskType: UILabel!
    
    let defaultsss = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        durationLbl.text = "Your task duration is " + DURATION1 + " hrs"
        Area.text = location_
        let strArr = self.description_.components(separatedBy: "^")
        
        if strArr[1].characters.count > 1 {
            comments.text = strArr[1]
        } else {
            comments.text = "none"
        }
        
        Floors.text = floorNumber_
        taskType.text = strArr[0]
        getImageCount()
        getImages()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBOutlet weak var scrollViews: UIScrollView!
    
    func getImageCount() {
        for object in objectsEmpLogin {
            if(assignedTaskID_.contains(String(object.assignedTaskID))){
                print("object.imageCount ",object.imageCount)
                let splitImg = object.imageCount.components(separatedBy: "-")
                ImageArr = Int(splitImg[0])!
            }
        }
    }
    
    func getImages() {
        var count: Double = 0
        let imageWidth:CGFloat = 100
        let imageHeight:CGFloat = 100
        let yPosition:CGFloat = 15
        var xPosition:CGFloat = 5
        var scrollViewContentSize:CGFloat=0;
        for myImageView in scrollViews.subviews {
            if myImageView.tag == 1004
            {
                myImageView.removeFromSuperview()
            }
        }
        for imgCnt in 0..<ImageArr {
            print("self.assignedTaskID_  ",self.assignedTaskID_)
            let String1 = HKImgUrl + "/images/Admin_Images/" + self.assignedTaskID_ + "/Image-"
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
            
            /*let task = URLSession.shared.dataTask(with: url!) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.sync() {
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
            }
            task.resume() */
        }
        count += 1
    }
    
    var sendPendingStr_:String = ""
    var sendPendingStr2_:String = ""
    var sendPendingStr3_:String = ""
    var sendPendingStr4_:String = ""
    var sendPendingStr5_:String = ""
    
    @IBAction func StartWorking() {
        let defaults = UserDefaults.standard
        defaults.set("noticationSent", forKey: "RefreshServiceCall2")
        switchToWorkScreen()
    }
        
    func switchToWorkScreen() {
        OperationQueue.main.addOperation {
            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vicCont = mainStoryboard.instantiateViewController(withIdentifier: "currentTask") as! currentTask
            self.sendPendingStr_ = self.assignedTaskID_
            self.sendPendingStr2_ = self.taskStatusID_
            vicCont._assignedTaskID_ = self.sendPendingStr_
            vicCont._taskStatusID_ = self.sendPendingStr2_
            vicCont._TasksListId_ = self.TaskCheckId
            vicCont._AssignedByRole_ = self.AssignedByRoleID
            vicCont._Duration_ = self.DURATION1
            self.present(vicCont, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
