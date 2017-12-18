    
    import UIKit
    import Alamofire
    import SwiftyJSON
    
    class FullSizeImage: UIViewController {
        var assignedTaskID__ : String  = ""
        
        var ImageArr:Int = 0
        override func viewDidLoad() {
            super.viewDidLoad()
            getImageCount()
            getImages()
        }
        
        deinit {
            NotificationCenter.default.removeObserver(self)
        }
        
        
        func getImageCount() {
            let empStatusID = UserDefaults.standard.string(forKey: "employeeStatusID")
            if empStatusID == "3" {
                for object in objectsEmpLogin {
                    if(assignedTaskID__.contains(String(object.assignedTaskID))){
                        let splitImg = object.imageCount.components(separatedBy: "-")
                        ImageArr = Int(splitImg[0])!
                    }
                }
            } else {
                for object in objects {
                    if(assignedTaskID__.contains(String(object.assignedTaskID))){
                        let splitImg = object.imageCount.components(separatedBy: "-")
                        ImageArr = Int(splitImg[1])!
                    }
                }
            }
        }
        
        @IBAction func Exit() {
            self.dismiss(animated: true, completion: nil)
        }
        
        @IBOutlet weak var scrollViews: UIScrollView!
        
        func getImages() {
            var count: Double = 0
            let imageWidth:CGFloat = 620
            let imageHeight:CGFloat = 610
            let yPosition:CGFloat = 50
            var xPosition:CGFloat = 0
            var scrollViewContentSize:CGFloat=0;
            for myImageView in scrollViews.subviews {
                if myImageView.tag == 1004
                {
                    myImageView.removeFromSuperview()
                }
            }
            
            let empStatusID = UserDefaults.standard.string(forKey: "employeeStatusID")
            if empStatusID == "3" {
                for imgCnt in 0..<ImageArr {
                    let String1 = HKImgUrl + "/images/Admin_Images/" + self.assignedTaskID__ + "/Image-"
                    let String2 = self.assignedTaskID__
                    let String3 = String(imgCnt) + ".jpg"
                    let appendString = String1 + String2 + String3
                    let url = URL(string: appendString)
                    let task = URLSession.shared.dataTask(with: url!) { data, response, error in
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
                            myImageView.layer.borderColor = UIColor.red.cgColor
                            myImageView.layer.masksToBounds = false
                            myImageView.clipsToBounds = true
                            myImageView.layer.cornerRadius = 1 //myImageView.frame.size.width/2
                            self.scrollViews.addSubview(myImageView)
                            let spacer:CGFloat = 30
                            xPosition+=imageHeight + spacer
                            scrollViewContentSize+=imageHeight + spacer
                            self.scrollViews.contentSize = CGSize(width: scrollViewContentSize, height: imageWidth)
                        }
                    }
                    task.resume()
                }
                count += 1
            } else {
                for imgCnt in 0..<ImageArr {
                    let String1 = HKImgUrl + "/images/Worker_Images/" + self.assignedTaskID__ + "/Image-"
                    let String2 = self.assignedTaskID__
                    let String3 = String(imgCnt) + ".jpg"
                    let appendString = String1 + String2 + String3
                    let url = URL(string: appendString)
                    let task = URLSession.shared.dataTask(with: url!) { data, response, error in
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
                            myImageView.layer.borderColor = UIColor.red.cgColor
                            myImageView.layer.masksToBounds = false
                            myImageView.clipsToBounds = true
                            myImageView.layer.cornerRadius = 1 //myImageView.frame.size.width/2
                            self.scrollViews.addSubview(myImageView)
                            let spacer:CGFloat = 30
                            xPosition+=imageHeight + spacer
                            scrollViewContentSize+=imageHeight + spacer
                            self.scrollViews.contentSize = CGSize(width: scrollViewContentSize, height: imageWidth)
                        }
                    }
                    task.resume()
                }
                count += 1
                
            }
            
           
        }
        
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
    }
