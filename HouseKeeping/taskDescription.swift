//  taskDescription.swift
//  HouseKeeping
//  Created by Apple-1 on 6/23/17.
//  Copyright © 2017 Apple-1. All rights reserved.

import UIKit
import Fusuma
import Alamofire
import SwiftyJSON
import LIHAlert
import Firebase
import ActionSheetPicker_3_0
import Foundation

class taskDescription: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate,UITextFieldDelegate,UIPopoverPresentationControllerDelegate, UITableViewDelegate, UITableViewDataSource,FusumaDelegate {
    @IBOutlet weak var floorsPicker: UIPickerView!
    @IBOutlet weak var priority: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var scrollViews: UIScrollView!
    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var uploadBtn: UIButton!
    @IBOutlet weak var tblViewTaskType: UITableView!
    
    var mainArrayToDisplay: [String] = []
    
    var pendingTask : String  = ""
    var userStatus: String = ""
    var EmpId : String  = ""
    var USERMOB: String = ""
    var employeeName: String = ""
    var ROLE: String?
    var MULTIArr:[String] = [""]
    
    var X = 0
    var picker: [String] = [String]()
    var pickerDatas:[String] = []
    
    var Y = 0
    var _TasksTypes_: [String] = []
    var _TasksTypesId_: [String] = []
    @IBOutlet weak var taskTypeBTN: UIButton!
    var successAlert: LIHAlert?
    var isTaskTypeSelected = false
    
    var objects7: [saveGalleryImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        objects7.removeAll()
        self.tblViewTaskType?.delegate = self
        self.tblViewTaskType?.dataSource = self
        tblViewTaskType.isHidden = true
        let myColorWhite : UIColor = UIColor(red:230.0/255.0, green: 121/255.0, blue:10/255.0, alpha: 1.0)
        taskTypeBTN.layer.cornerRadius = 2.0
        taskTypeBTN.layer.borderWidth = 1.5
        taskTypeBTN.layer.borderColor = myColorWhite.cgColor
        tblViewTaskType.layer.cornerRadius = 2.0
        tblViewTaskType.layer.borderWidth = 1.5
        tblViewTaskType.layer.borderColor = myColorWhite.cgColor
        floorsPicker.layer.cornerRadius = 2.0
        floorsPicker.layer.borderWidth = 1.5
        floorsPicker.layer.borderColor = myColorWhite.cgColor
        //uploadBtn.contentHorizontalAlignment = .left
        let defaultss = UserDefaults.standard
        EmpId = defaultss.string(forKey: "EMPId")!
        txtField.delegate = self
        self.ActivityIndicator.isHidden = true
        self.floorsPicker.delegate = self
        self.floorsPicker.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        //if userStatus == "Online" {
        self.successAlert = LIHAlertManager.getSuccessAlert(message: "Task Saved & Assigned Successfully")
        //} else {
        //  self.successAlert = LIHAlertManager.getSuccessAlert(message: "Task Saved Successfully")
        // }
        self.successAlert?.initAlert(self.view)
        self.successAlert?.icon = UIImage(named:"Progress-And-Tick-Icon-Animation")
        self.setPriorityText()
        
        self.picker.removeAll()
        self.pickerDatas.removeAll()
        
        self.GETFloorObj()
        
        self.mainArrayToDisplay.removeAll()
        
        for objects in objects6 {
            if objects.FloorID == "1" && objects.AreaTypeID == "1" {
                mainArrayToDisplay.append(objects.AreaDetail)
            }
        }
        
        self._TasksTypes_.removeAll()
        self._TasksTypesId_.removeAll()
        for objectt in objects77 {
            //print("taskListId " , objectt.taskListId )
            //print("taskListName " , objectt.taskListName )
            _TasksTypes_.append(objectt.taskListName)
            _TasksTypesId_.append(objectt.taskListId)
        }
        self.tblViewTaskType?.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _TasksTypesId_.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblViewTaskType.dequeueReusableCell(withIdentifier: "TaskType", for: indexPath) as! TaskType
        
        cell.taskType?.text = ""
        cell.taskTypeId?.text = ""
        cell.taskType?.text = self._TasksTypes_[indexPath.row]
        cell.taskTypeId?.text = self._TasksTypesId_[indexPath.row]
        
        return cell
    }
    
    var taskTypeIDString : String?
    var taskTypeString : String?
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let Cell = tableView.cellForRow(at: indexPath)! as! TaskType
        taskTypeIDString = (Cell.taskTypeId?.text)!
        taskTypeString = (Cell.taskType?.text)!
        isTaskTypeSelected = true
        taskTypeBTN.setTitle(Cell.taskType?.text, for: .normal)
        tblViewTaskType.isHidden = true
    }
    
    var isTimeSet = false
    
    var hrs : String?
    var mins : String?
    @IBOutlet weak var TimeDurationBtn: UIButton!
    
    @IBAction func setTaskDuration(_ sender: UIButton) {
        let acp = ActionSheetMultipleStringPicker(title: "Task Duration (HH:MM)", rows: [
            ["00", "01", "02", "03", "04", "05", "06", "07", "08","09", "10", "11", "12" , "13", "14", "15", "16", "17", "18", "19", "20","21", "22", "23", "24"],
            ["00", "01", "02" , "03", "04" ,"05", "10", "15", "20","25", "30", "35", "40" ,"45", "50", "55"]
            ], initialSelection: [0,1], doneBlock: {
                picker, values, indexes in
                
                let indexValuesOfArray = String(describing: indexes!)
                let formattedString = indexValuesOfArray.replacingOccurrences(of: " ", with: "")
                let trimmedString = formattedString.trimmingCharacters(in: .whitespaces)
                let sepArr = trimmedString.components(separatedBy: ",")
                self.isTimeSet = true
                let Str1 = String(sepArr[0])
                let Str2 = String(sepArr[1])
                let newString1 = Str1?.replacingOccurrences(of: "(", with: "", options: .literal, range: nil)
                let newString2 = Str2?.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
                let newString3 = newString2?.replacingOccurrences(of: ")", with: "", options: .literal, range: nil)
                let newString4 = newString1?.components(separatedBy: " ")
                let newString5 = newString3?.components(separatedBy: " ")
                let newString6 = String(describing: newString4?[0])
                let newString7 = String(describing: newString5?[0])
                let split0 = newString6.components(separatedBy: ["n", "\\"])
                let split00 = newString7.components(separatedBy: ["n", "\\"])
                let newSplit = split0[3]
                let newSplit2 = split00[3]
                let split1 = String(newSplit.characters.prefix(2))
                let split11 = String(newSplit2.characters.prefix(2))
                self.hrs = split1
                self.mins = split11
                print("came on done H")
                print(self.hrs!)
                print("came on done M")
                print(self.mins!)
                self.TimeDurationBtn.setTitle(self.hrs! + ":" + self.mins!, for: .normal)
                return
        }, cancel: { ActionMultipleStringCancelBlock in return }, origin: sender)
        
        acp?.setTextColor(UIColor.black)
        acp?.pickerBackgroundColor = UIColor.white
        acp?.toolbarBackgroundColor = UIColor(red:246.0/255.0, green: 147/255.0, blue:9/255.0, alpha: 1.0)
        acp?.toolbarButtonsColor = UIColor.black
        acp?.show()
    }
    
    
    @IBAction func AddTaskType() {
        self.tblViewTaskType?.reloadData()
        self.tblViewTaskType.isHidden = !self.tblViewTaskType.isHidden
    }
    
    @IBAction func Dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    var SendStr: String = ""
    @IBAction func Details() {
        OperationQueue.main.addOperation {
            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vicCont = mainStoryboard.instantiateViewController(withIdentifier: "DetailsPending") as! DetailsPending
            self.SendStr = self.EmpId
            vicCont.EmployeeId = self.SendStr
            self.present(vicCont, animated: true, completion: nil)
        }
    }
    
    func setPriorityText (){
        //DispatchQueue.main.async(){
        ///Pending Tasks
        let defaults = UserDefaults.standard
        self.pendingTask = defaults.string(forKey: "pendingTask")!
        //print("**********************  pendingTask **********************   ", self.pendingTask)
        self.Y = Int(self.pendingTask)!
        self.Y += 1
        self.priority.text = String(self.Y)
        //}
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true;
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) { // became first responder
        //move textfields up
        let myScreenRect: CGRect = UIScreen.main.bounds
        let keyboardHeight : CGFloat = 216
        UIView.beginAnimations( "animateView", context: nil)
        var movementDuration:TimeInterval = 0.35
        var needToMove: CGFloat = 0
        var frame : CGRect = self.view.frame
        if (textField.frame.origin.y + textField.frame.size.height + UIApplication.shared.statusBarFrame.size.height > (myScreenRect.size.height - keyboardHeight - 150)) {
            needToMove = (textField.frame.origin.y + textField.frame.size.height + UIApplication.shared.statusBarFrame.size.height) - (myScreenRect.size.height - keyboardHeight - 150);
        }
        frame.origin.y = -needToMove
        self.view.frame = frame
        UIView.commitAnimations()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //move textfields back down
        UIView.beginAnimations( "animateView", context: nil)
        var movementDuration:TimeInterval = 0.35
        var frame : CGRect = self.view.frame
        frame.origin.y = 0
        self.view.frame = frame
        UIView.commitAnimations()
    }
    
    func GETFloorObj() {
        pickerDatas.removeAll()
        picker.removeAll()
        for object in objects6 {
            pickerDatas.append(object.FloorName)
        }
        let dedupe = removeDuplicates(array: self.pickerDatas)
        picker = dedupe
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
    var flag = false
    @IBAction func plusBtnClick() {
        var maxLimit = Int(pendingTask)!
        maxLimit += 1
        
        if Int(priority.text!)! != 0 || Int(priority.text!)! != maxLimit {
            if flag == false {
                X = maxLimit
                if X != maxLimit {
                    X += 1
                }
            } else {
                X = Int(priority.text!)!
                if X != maxLimit {
                    X += 1
                }
            }
            let myString = String(X)
            priority.text = myString
        }
    }
    
    @IBAction func minusBtnClick() {
        flag = true
        var Txt:Int = Int(priority.text!)!
        if Int(priority.text!)! > 1 {
            Txt -= 1
            let myString = String(describing: Txt)
            priority.text = myString
        } else if Int(priority.text!)! == 0 {
            //print("came zero")
        }
    }
    
    public func fusumaVideoCompleted(withFileURL fileURL: URL) {
        print("video completed and output to file: \(fileURL)")
    }
    
    let fusuma = FusumaViewController()
    @IBAction func ChooseImage() {
        // Show Fusuma
        fusuma.delegate = self
        fusuma.cropHeightRatio = 0.6
        fusuma.hasVideo = false
        fusuma.allowMultipleSelection = true
        fusumaSavesImage = true
        self.present(fusuma, animated: true, completion: nil)
    }
    // MARK: FusumaDelegate Protocol
    
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        objects7.removeAll()
        switch source {
        case .camera:
            print("Image captured from Camera")
        case .library:
            print("Image selected from Camera Roll")
        default:
            print("Image selected")
        }
        let imageWidth:CGFloat = 100
        let imageHeight:CGFloat = 100
        let yPosition:CGFloat = 15
        var xPosition:CGFloat = 5
        var scrollViewContentSize:CGFloat=0;
        let myImageView:UIImageView = UIImageView()
        myImageView.image = image
        print("CAMERA Imaged " , image)
        myImageView.contentMode = UIViewContentMode.scaleAspectFit
        myImageView.frame.size.width = imageWidth
        myImageView.frame.size.height = imageHeight
        myImageView.center = self.view.center
        myImageView.frame.origin.y = yPosition
        myImageView.frame.origin.x = xPosition
        myImageView.layer.borderWidth = 1.0
        myImageView.layer.masksToBounds = false
        myImageView.clipsToBounds = true
        myImageView.layer.cornerRadius = myImageView.frame.size.width/2
        self.scrollViews.addSubview(myImageView)
        let spacer:CGFloat = 30
        xPosition+=imageHeight + spacer
        scrollViewContentSize+=imageHeight + spacer
        self.scrollViews.contentSize = CGSize(width: scrollViewContentSize, height: imageWidth)
        let thisObj = saveGalleryImage(saveimages: image)
        self.objects7.append(thisObj)
        print("objects7  CAMERA ", objects7)
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
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return picker.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return picker[row]
    }
    
    var selectedFloor:String = "Ground Floor"
    var selFloor = false
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let valueSelected = picker[row] as String
        selectedFloor = picker[row] as String
        mainArrayToDisplay.removeAll()
        if valueSelected == "Ground Floor" && self.segmentedControl.selectedSegmentIndex == 0 {
            mainArrayToDisplay.removeAll()
            for objects in objects6 {
                if objects.FloorID == "1" && objects.AreaTypeID == "1" {
                    mainArrayToDisplay.append(objects.AreaDetail)
                }
            }
        }else if valueSelected == "Ground Floor" && self.segmentedControl.selectedSegmentIndex == 1 {
            mainArrayToDisplay.removeAll()
            for objects in objects6 {
                if objects.FloorID == "1" && objects.AreaTypeID == "2" {
                    mainArrayToDisplay.append(objects.AreaDetail)
                }
            }
        } else if valueSelected == "1st Floor" && self.segmentedControl.selectedSegmentIndex == 0 {
            mainArrayToDisplay.removeAll()
            for objects in objects6 {
                if objects.FloorID == "2" && objects.AreaTypeID == "1" {
                    mainArrayToDisplay.append(objects.AreaDetail)
                }
            }
        } else if valueSelected == "1st Floor" && self.segmentedControl.selectedSegmentIndex == 1 {
            mainArrayToDisplay.removeAll()
            for objects in objects6 {
                if objects.FloorID == "2" && objects.AreaTypeID == "2" {
                    mainArrayToDisplay.append(objects.AreaDetail)
                }
            }
        } else if valueSelected == "2nd Floor" && self.segmentedControl.selectedSegmentIndex == 0 {
            mainArrayToDisplay.removeAll()
            for objects in objects6 {
                if objects.FloorID == "3" && objects.AreaTypeID == "1" {
                    mainArrayToDisplay.append(objects.AreaDetail)
                }
            }
        } else if valueSelected == "2nd Floor" && self.segmentedControl.selectedSegmentIndex == 1 {
            mainArrayToDisplay.removeAll()
            for objects in objects6 {
                if objects.FloorID == "3" && objects.AreaTypeID == "2" {
                    mainArrayToDisplay.append(objects.AreaDetail)
                }
            }
        } else if valueSelected == "3rd Floor" && self.segmentedControl.selectedSegmentIndex == 0 {
            mainArrayToDisplay.removeAll()
            for objects in objects6 {
                if objects.FloorID == "4" && objects.AreaTypeID == "1" {
                    mainArrayToDisplay.append(objects.AreaDetail)
                }
            }
        } else if valueSelected == "3rd Floor" && self.segmentedControl.selectedSegmentIndex == 1 {
            mainArrayToDisplay.removeAll()
            for objects in objects6 {
                if objects.FloorID == "4" && objects.AreaTypeID == "2" {
                    mainArrayToDisplay.append(objects.AreaDetail)
                }
            }
        } else if valueSelected == "4th Floor" && self.segmentedControl.selectedSegmentIndex == 0 {
            mainArrayToDisplay.removeAll()
            for objects in objects6 {
                if objects.FloorID == "5" && objects.AreaTypeID == "1" {
                    mainArrayToDisplay.append(objects.AreaDetail)
                }
            }
        } else if valueSelected == "4th Floor" && self.segmentedControl.selectedSegmentIndex == 1 {
            mainArrayToDisplay.removeAll()
            for objects in objects6 {
                if objects.FloorID == "5" && objects.AreaTypeID == "2" {
                    mainArrayToDisplay.append(objects.AreaDetail)
                }
            }
        }else if valueSelected == "5th Floor" && self.segmentedControl.selectedSegmentIndex == 0 {
            mainArrayToDisplay.removeAll()
            for objects in objects6 {
                if objects.FloorID == "6" && objects.AreaTypeID == "1" {
                    mainArrayToDisplay.append(objects.AreaDetail)
                }
            }
        } else if valueSelected == "5th Floor" && self.segmentedControl.selectedSegmentIndex == 1 {
            mainArrayToDisplay.removeAll()
            for objects in objects6 {
                if objects.FloorID == "6" && objects.AreaTypeID == "2" {
                    mainArrayToDisplay.append(objects.AreaDetail)
                }
            }
        }else if valueSelected == "6th Floor" && self.segmentedControl.selectedSegmentIndex == 0 {
            mainArrayToDisplay.removeAll()
            for objects in objects6 {
                if objects.FloorID == "7" && objects.AreaTypeID == "1" {
                    mainArrayToDisplay.append(objects.AreaDetail)
                }
            }
        } else if valueSelected == "6th Floor" && self.segmentedControl.selectedSegmentIndex == 1 {
            mainArrayToDisplay.removeAll()
            for objects in objects6 {
                if objects.FloorID == "7" && objects.AreaTypeID == "2" {
                    mainArrayToDisplay.append(objects.AreaDetail)
                }
            }
        } else if valueSelected == "7th Floor" && self.segmentedControl.selectedSegmentIndex == 0 {
            mainArrayToDisplay.removeAll()
            for objects in objects6 {
                if objects.FloorID == "8" && objects.AreaTypeID == "1" {
                    mainArrayToDisplay.append(objects.AreaDetail)
                }
            }
        } else if valueSelected == "7th Floor" && self.segmentedControl.selectedSegmentIndex == 1 {
            mainArrayToDisplay.removeAll()
            for objects in objects6 {
                if objects.FloorID == "8" && objects.AreaTypeID == "2" {
                    mainArrayToDisplay.append(objects.AreaDetail)
                }
            }
        } else if valueSelected == "8th Floor" && self.segmentedControl.selectedSegmentIndex == 0 {
            mainArrayToDisplay.removeAll()
            for objects in objects6 {
                if objects.FloorID == "9" && objects.AreaTypeID == "1" {
                    mainArrayToDisplay.append(objects.AreaDetail)
                }
            }
        } else if valueSelected == "8th Floor" && self.segmentedControl.selectedSegmentIndex == 1 {
            mainArrayToDisplay.removeAll()
            for objects in objects6 {
                if objects.FloorID == "9" && objects.AreaTypeID == "2" {
                    mainArrayToDisplay.append(objects.AreaDetail)
                }
            }
        } else if valueSelected == "9th Floor" && self.segmentedControl.selectedSegmentIndex == 0 {
            mainArrayToDisplay.removeAll()
            for objects in objects6 {
                if objects.FloorID == "10" && objects.AreaTypeID == "1" {
                    mainArrayToDisplay.append(objects.AreaDetail)
                }
            }
        } else if valueSelected == "9th Floor" && self.segmentedControl.selectedSegmentIndex == 1 {
            mainArrayToDisplay.removeAll()
            for objects in objects6 {
                if objects.FloorID == "10" && objects.AreaTypeID == "2" {
                    mainArrayToDisplay.append(objects.AreaDetail)
                }
            }
        } else if valueSelected == "Outer Area" && self.segmentedControl.selectedSegmentIndex == 0 {
            mainArrayToDisplay.removeAll()
            for objects in objects6 {
                if objects.FloorID == "11" && objects.AreaTypeID == "1" {
                    mainArrayToDisplay.append(objects.AreaDetail)
                }
            }
        } else if valueSelected == "Outer Area" && self.segmentedControl.selectedSegmentIndex == 1 {
            mainArrayToDisplay.removeAll()
            for objects in objects6 {
                if objects.FloorID == "11" && objects.AreaTypeID == "2" {
                    mainArrayToDisplay.append(objects.AreaDetail)
                }
            }
        }
        // DispatchQueue.main.async(){
        self.collectionView.reloadData()
        //}
    }
    
    var selectedRooms:String = ""
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        selectedRooms = picker[row] as String
        var label = view as! UILabel!
        if label == nil {
            label = UILabel()
            label?.textColor = UIColor(red:230.0/255.0, green: 121/255.0, blue:10/255.0, alpha: 1.0)
            label?.textAlignment = NSTextAlignment.center
        }
        switch component {
        case 0:
            label?.text = picker[row]
            label?.font = UIFont(name:"Futura", size:13)
            return label!
        default:
            return label!
        }
    }
    
    
    ///Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainArrayToDisplay.count
    }
    
    var selectedCell = [IndexPath]()
    internal func collectionView(_ collectionView: UICollectionView,cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell (withReuseIdentifier: "collectionCell", for: indexPath) as! roomsCollectionViewCell
        
        if selectedCell.contains(indexPath) {
            cell.roomLbl.textColor = UIColor(red: 51/255.0, green:51/255.0, blue:51/255.0, alpha: 1.0)
            cell.home.backgroundColor = UIColor.white
        }else{
            cell.roomLbl.textColor = UIColor(red: 51/255.0, green:51/255.0, blue:51/255.0, alpha: 1.0)
            cell.home.backgroundColor = UIColor.white
        }
        cell.roomLbl.text = mainArrayToDisplay[indexPath.item]
        return cell
    }
    
    @IBAction func SegmentControlChanged() {
        mainArrayToDisplay.removeAll()
        if(segmentedControl.selectedSegmentIndex == 0){
            if selectedRooms == "Ground Floor" {
                mainArrayToDisplay.removeAll()
                for objects in objects6 {
                    if objects.FloorID == "1" && objects.AreaTypeID == "1" {
                        mainArrayToDisplay.append(objects.AreaDetail)
                    }
                }
            } else if selectedRooms == "1st Floor"{
                mainArrayToDisplay.removeAll()
                for objects in objects6 {
                    if objects.FloorID == "2" && objects.AreaTypeID == "1" {
                        mainArrayToDisplay.append(objects.AreaDetail)
                    }
                }
            } else if selectedRooms == "2nd Floor"  {
                mainArrayToDisplay.removeAll()
                for objects in objects6 {
                    if objects.FloorID == "3" && objects.AreaTypeID == "1" {
                        mainArrayToDisplay.append(objects.AreaDetail)
                    }
                }
            } else if selectedRooms == "3rd Floor" {
                mainArrayToDisplay.removeAll()
                for objects in objects6 {
                    if objects.FloorID == "4" && objects.AreaTypeID == "1" {
                        mainArrayToDisplay.append(objects.AreaDetail)
                    }
                }
            } else if selectedRooms == "4th Floor" {
                mainArrayToDisplay.removeAll()
                for objects in objects6 {
                    if objects.FloorID == "5" && objects.AreaTypeID == "1" {
                        mainArrayToDisplay.append(objects.AreaDetail)
                    }
                }
            } else if selectedRooms == "5th Floor" {
                mainArrayToDisplay.removeAll()
                for objects in objects6 {
                    if objects.FloorID == "6" && objects.AreaTypeID == "1" {
                        mainArrayToDisplay.append(objects.AreaDetail)
                    }
                }
            }else if selectedRooms == "6th Floor" {
                mainArrayToDisplay.removeAll()
                for objects in objects6 {
                    if objects.FloorID == "7" && objects.AreaTypeID == "1" {
                        mainArrayToDisplay.append(objects.AreaDetail)
                    }
                }
            }else if selectedRooms == "7th Floor" {
                mainArrayToDisplay.removeAll()
                for objects in objects6 {
                    if objects.FloorID == "8" && objects.AreaTypeID == "1" {
                        mainArrayToDisplay.append(objects.AreaDetail)
                    }
                }
            }else if selectedRooms == "8th Floor" {
                mainArrayToDisplay.removeAll()
                for objects in objects6 {
                    if objects.FloorID == "9" && objects.AreaTypeID == "1" {
                        mainArrayToDisplay.append(objects.AreaDetail)
                    }
                }
            }else if selectedRooms == "9th Floor" {
                mainArrayToDisplay.removeAll()
                for objects in objects6 {
                    if objects.FloorID == "10" && objects.AreaTypeID == "1" {
                        mainArrayToDisplay.append(objects.AreaDetail)
                    }
                }
            }else if selectedRooms == "Outer Floor" {
                mainArrayToDisplay.removeAll()
                for objects in objects6 {
                    if objects.FloorID == "11" && objects.AreaTypeID == "1" {
                        mainArrayToDisplay.append(objects.AreaDetail)
                    }
                }
            }
        } else if(segmentedControl.selectedSegmentIndex == 1){
            if selectedRooms == "Ground Floor" {
                mainArrayToDisplay.removeAll()
                for objects in objects6 {
                    if objects.FloorID == "1" && objects.AreaTypeID == "2" {
                        mainArrayToDisplay.append(objects.AreaDetail)
                    }
                }
            } else if selectedRooms == "1st Floor" {
                mainArrayToDisplay.removeAll()
                for objects in objects6 {
                    if objects.FloorID == "2" && objects.AreaTypeID == "2" {
                        mainArrayToDisplay.append(objects.AreaDetail)
                    }
                }
            } else if selectedRooms == "2nd Floor" {
                mainArrayToDisplay.removeAll()
                for objects in objects6 {
                    if objects.FloorID == "3" && objects.AreaTypeID == "2" {
                        mainArrayToDisplay.append(objects.AreaDetail)
                    }
                }
            } else if selectedRooms == "3rd Floor" {
                mainArrayToDisplay.removeAll()
                for objects in objects6 {
                    if objects.FloorID == "4" && objects.AreaTypeID == "2" {
                        mainArrayToDisplay.append(objects.AreaDetail)
                    }
                }
            } else if selectedRooms == "4th Floor" {
                mainArrayToDisplay.removeAll()
                for objects in objects6 {
                    if objects.FloorID == "5" && objects.AreaTypeID == "2" {
                        mainArrayToDisplay.append(objects.AreaDetail)
                    }
                }
            } else if selectedRooms == "5th Floor" {
                mainArrayToDisplay.removeAll()
                for objects in objects6 {
                    if objects.FloorID == "6" && objects.AreaTypeID == "2" {
                        mainArrayToDisplay.append(objects.AreaDetail)
                    }
                }
            }else if selectedRooms == "6th Floor" {
                mainArrayToDisplay.removeAll()
                for objects in objects6 {
                    if objects.FloorID == "7" && objects.AreaTypeID == "2" {
                        mainArrayToDisplay.append(objects.AreaDetail)
                    }
                }
            }else if selectedRooms == "7th Floor" {
                mainArrayToDisplay.removeAll()
                for objects in objects6 {
                    if objects.FloorID == "8" && objects.AreaTypeID == "2" {
                        mainArrayToDisplay.append(objects.AreaDetail)
                    }
                }
            }else if selectedRooms == "8th Floor" {
                mainArrayToDisplay.removeAll()
                for objects in objects6 {
                    if objects.FloorID == "9" && objects.AreaTypeID == "2" {
                        mainArrayToDisplay.append(objects.AreaDetail)
                    }
                }
            }else if selectedRooms == "9th Floor" {
                mainArrayToDisplay.removeAll()
                for objects in objects6 {
                    if objects.FloorID == "10" && objects.AreaTypeID == "2" {
                        mainArrayToDisplay.append(objects.AreaDetail)
                    }
                }
            }else if selectedRooms == "Outer Area" {
                mainArrayToDisplay.removeAll()
                for objects in objects6 {
                    if objects.FloorID == "11" && objects.AreaTypeID == "2" {
                        mainArrayToDisplay.append(objects.AreaDetail)
                    }
                }
            }
        }
        self.collectionView.reloadData()
    }
    
    var selected = false
    var selectedRoomType:String = ""
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedRoomType = mainArrayToDisplay[indexPath.item]
        
        let cell = collectionView.cellForItem(at: indexPath) as! roomsCollectionViewCell
        
        selectedCell.append(indexPath)
        cell.roomLbl.textColor = UIColor(red:230.0/255.0, green: 121/255.0, blue:10/255.0, alpha: 1.0)
        cell.home.backgroundColor = UIColor(red:230.0/255.0, green: 121/255.0, blue:10/255.0, alpha: 1.0)
        selected = true
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.allowsMultipleSelection = false
        if selected == true {
            let cell = collectionView.cellForItem(at: indexPath) as! roomsCollectionViewCell
            if selectedCell.contains(indexPath) {
                selectedCell.remove(at: selectedCell.index(of: indexPath)!)
                cell.roomLbl.textColor = UIColor(red: 51/255.0, green:51/255.0, blue:51/255.0, alpha: 1.0)
                cell.home.backgroundColor = UIColor.white
            }
            selected = false
        }
    }
    
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {
        //print("Number of selection images: \(images.count)")
        var count: Double = 0
        let imageWidth:CGFloat = 100
        let imageHeight:CGFloat = 100
        let yPosition:CGFloat = 15
        var xPosition:CGFloat = 5
        var scrollViewContentSize:CGFloat=0;
        objects7.removeAll()
        for myImageView in scrollViews.subviews
        {
            if myImageView.tag == 1004
            {
                myImageView.removeFromSuperview()
            }
        }
        for image in images {
            DispatchQueue.main.async() {
                let myImageView:UIImageView = UIImageView()
                myImageView.image = image
                //print("GALLERY  " , image)
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
                let thisObj = saveGalleryImage(saveimages: image)
                self.objects7.append(thisObj)
            }
        }
        //print("objects7 GALLERY  ", objects7)
        count += 1
    }
    
    var Descriptions : String?
    var StringemployeeIDLogin : String?
    var Priorities : String?
    var dateSigned : String?
    var signedRooms : String?
    var signedFloor : String?
    var signedEmpId : String?
    var apenStr : String?
    var combineStr : String?
    var combineStr2 : String?
    
    @IBAction func SendNotification() {
        if isTaskTypeSelected == false {
            let alertController = UIAlertController(title: "Select Task Type !", message: "", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        } else if isTimeSet == false {
            let alert = UIAlertController(title: "Set Task Duration", message: "", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if TimeDurationBtn.title(for: .normal) == "00:00" {
            let alert = UIAlertController(title: "Invalid Task Duration", message: "", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            sendTheNotification()
        }
    }
    
    func sendTheNotification() {
        signedRooms =  selectedRoomType
        if signedRooms == nil || signedRooms!.isEmpty == true || signedRooms == "" {
            let alertController = UIAlertController(title: "Select a Room !", message: "", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            ActivityIndicator.isHidden = false
            ActivityIndicator.startAnimating()
            ///ASSIGNED BY
            let defaults = UserDefaults.standard
            let assignedBYId = defaults.string(forKey: "employeeIDLogin")
            let assignedByNames = defaults.string(forKey: "name")
            let BranchId : String?
            BranchId = defaults.string(forKey: "branchID")
            let assignedByRole : String?
            assignedByRole = defaults.string(forKey: "employeeStatusID")
            let test:String? = assignedBYId
            StringemployeeIDLogin = test!
            ///DATE
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
            dateSigned = formatter.string(from: date)
            print("dateSigned  " ,dateSigned!)
            ////Description
            if self.txtField.text == "" {
                Descriptions = "none"
            } else {
                Descriptions = self.txtField.text!
            }
            Priorities = self.priority.text
            
            signedFloor =  selectedFloor
            signedEmpId =  EmpId
            
            apenStr = "^"
            combineStr = taskTypeString! + apenStr!
            combineStr2 = combineStr! + Descriptions!
            
            // let ImgCount : String?
            //ImgCount = String(self.objects7.count)
            
            //print("ROLE while send ", ROLE!)
            
            let assignedBy_Role : String?
            assignedBy_Role = defaults.string(forKey: "employeeStatusID")
            
            if assignedBy_Role! == "1" && ROLE! == "Employee" {
                //print("Super USer to employee")
                ROLE = "3"
                
                let originalString = "C:\\Housekeeping_Directory"
                let newString2:String?
                newString2 = originalString.replacingOccurrences(of: "\\", with: "\\\\", options: .literal, range: nil)
                let postString = "{\"assignedBY\": \"\(StringemployeeIDLogin!)\",\"belongsTo\": \"14\", \"dateAssigned\": \"\(dateSigned!)\",\"description\": \"\(combineStr2!)\",\"employeeId\": \"\(signedEmpId!)\",\"floorNumber\": \"\(signedFloor!)\",\"image\": \"\(newString2!)\",\"location\": \"\(signedRooms!)\",\"priorities\": \"\(Priorities!)\",\"taskStatusID\": \"3\",\"employeeName\": \"\(employeeName)\",\"taskListId\": \"\(taskTypeIDString!)\",\"checkListIds\":\"0\",\"assignedByName\": \"\(assignedByNames!)\",\"isDistributsed\": \"1\",\"distributedToName\": \"0\",\"distributedToId\": \"0\",\"branchId\": \"\(BranchId!)\",\"assignedByRole\": \"\(assignedByRole!)\",\"assignedToRole\": \"\(ROLE!)\",\"duration\": \"\(TimeDurationBtn.title(for: .normal)!)\"}"
                
                print(postString)
                let df = DateFormatter()
                df.dateFormat = "dd-mm-yy-hh-mm-ss"

                //DispatchQueue.main.async {
                    Alamofire.upload(multipartFormData: { multipartFormData in
                        print("WHILE SEND " , self.objects7.count)
                        for objects in self.objects7 {
                            print("WHILE SEND FOR " , objects)
                            let test = objects.saveimages as UIImage
                            // let conV = UIImagePNGRepresentation(test)
                            let conV = UIImageJPEGRepresentation(test, 0.4)
                            let imageName = df.string(from: date as Date)
                            multipartFormData.append(conV!, withName: "file", fileName: "\(imageName).png", mimeType: "image/png")
                        }
                        multipartFormData.append((postString.data(using:.utf8))!, withName: "jsonString")
                    },to: HKURL+"/postjson/assignedtasks",method: .post, headers: nil,
                      encodingCompletion: { encodingResult in
                        switch encodingResult {
                        case .success(let upload, _, _):
                            upload.response { response in
                                print("SEND IMAGE TO SERVER API SUCCESS " , response)
                                self.sendNotificationAPICall()
                            }
                        case .failure(let encodingError):
                            print("SEND IMAGE TO SERVER API ERROR ", encodingError)
                            OperationQueue.main.addOperation{
                                self.ActivityIndicator.stopAnimating()
                                let alert = UIAlertController(title: "", message: "Unable to send Notification", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    })
 
 
                }
                
            //}
            
            if assignedBy_Role! == "1" && ROLE! == "Supervisor" {
                print("Super user to Supervisor ")
                self.ROLE = "2"
                let originalString = "C:\\Housekeeping_Directory"
                let newString2:String?
                newString2 = originalString.replacingOccurrences(of: "\\", with: "\\\\", options: .literal, range: nil)
                let postString = "{\"assignedBY\": \"\(StringemployeeIDLogin!)\",\"belongsTo\": \"14\", \"dateAssigned\": \"\(dateSigned!)\",\"description\": \"\(combineStr2!)\",\"employeeId\": \"\(signedEmpId!)\",\"floorNumber\": \"\(signedFloor!)\",\"image\": \"\(newString2!)\",\"location\": \"\(signedRooms!)\",\"priorities\": \"\(Priorities!)\",\"taskStatusID\": \"3\",\"employeeName\": \"\(employeeName)\",\"taskListId\": \"\(taskTypeIDString!)\",\"checkListIds\":\"0\",\"assignedByName\": \"\(assignedByNames!)\",\"isDistributsed\": \"0\",\"distributedToName\": \"0\",\"distributedToId\": \"0\",\"branchId\": \"\(BranchId!)\",\"assignedByRole\": \"\(assignedByRole!)\",\"assignedToRole\": \"\(ROLE!)\",\"duration\": \"\(TimeDurationBtn.title(for: .normal)!)\"}"
                
                print(postString)
                let df = DateFormatter()
                df.dateFormat = "dd-mm-yy-hh-mm-ss"
                
                Alamofire.upload(multipartFormData: { multipartFormData in
                    print("WHILE SEND " , self.objects7.count)
                    for objects in self.objects7 {
                        print("WHILE SEND FOR " , objects)
                        let test = objects.saveimages as UIImage
                        // let conV = UIImagePNGRepresentation(test)
                        let conV = UIImageJPEGRepresentation(test, 0.4)
                        let imageName = df.string(from: date as Date)
                        multipartFormData.append(conV!, withName: "file", fileName: "\(imageName).png", mimeType: "image/png")
                    }
                    multipartFormData.append((postString.data(using:.utf8))!, withName: "jsonString")
                },to: HKURL+"/postjson/assignedtasks",method: .post, headers: nil,
                  encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.response { response in
                            print("SEND IMAGE TO SERVER API SUCCESS " , response)
                            self.sendNotificationAPICall()
                        }
                    case .failure(let encodingError):
                        print("SEND IMAGE TO SERVER API ERROR ", encodingError)
                        OperationQueue.main.addOperation{
                            self.ActivityIndicator.stopAnimating()
                            let alert = UIAlertController(title: "", message: "Unable to send Notification", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                })
                
            }
            
            if assignedBy_Role! == "2" && ROLE! == "Employee" {
                print("Supervisor to employee")
                ROLE = "3"
                
                let originalString = "C:\\Housekeeping_Directory"
                let newString2:String?
                newString2 = originalString.replacingOccurrences(of: "\\", with: "\\\\", options: .literal, range: nil)
                let postString = "{\"assignedBY\": \"\(StringemployeeIDLogin!)\",\"belongsTo\": \"14\", \"dateAssigned\": \"\(dateSigned!)\",\"description\": \"\(combineStr2!)\",\"employeeId\": \"\(signedEmpId!)\",\"floorNumber\": \"\(signedFloor!)\",\"image\": \"\(newString2!)\",\"location\": \"\(signedRooms!)\",\"priorities\": \"\(Priorities!)\",\"taskStatusID\": \"3\",\"employeeName\": \"\(employeeName)\",\"taskListId\": \"\(taskTypeIDString!)\",\"checkListIds\":\"0\",\"assignedByName\": \"\(assignedByNames!)\",\"isDistributsed\": \"1\",\"distributedToName\": \"0\",\"distributedToId\": \"0\",\"branchId\": \"\(BranchId!)\",\"assignedByRole\": \"\(assignedByRole!)\",\"assignedToRole\": \"\(ROLE!)\",\"duration\": \"\(TimeDurationBtn.title(for: .normal)!)\"}"
                
                print(postString)
                let df = DateFormatter()
                df.dateFormat = "dd-mm-yy-hh-mm-ss"
                
                Alamofire.upload(multipartFormData: { multipartFormData in
                    print("WHILE SEND " , self.objects7.count)
                    for objects in self.objects7 {
                        print("WHILE SEND FOR " , objects)
                        let test = objects.saveimages as UIImage
                        // let conV = UIImagePNGRepresentation(test)
                        let conV = UIImageJPEGRepresentation(test, 0.4)
                        let imageName = df.string(from: date as Date)
                        multipartFormData.append(conV!, withName: "file", fileName: "\(imageName).png", mimeType: "image/png")
                    }
                    multipartFormData.append((postString.data(using:.utf8))!, withName: "jsonString")
                },to: HKURL+"/postjson/assignedtasks",method: .post, headers: nil,
                  encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.response { response in
                            print("SEND IMAGE TO SERVER API SUCCESS " , response)
                            self.sendNotificationAPICall()
                        }
                    case .failure(let encodingError):
                        print("SEND IMAGE TO SERVER API ERROR ", encodingError)
                        OperationQueue.main.addOperation{
                            self.ActivityIndicator.stopAnimating()
                            let alert = UIAlertController(title: "", message: "Unable to send Notification", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                })
            }
            
            
        }
    }
    
    let defaults = UserDefaults.standard
    func sendNotificationAPICall() {
        let name = self.defaults.string(forKey: "name")
        let test = "Admin " + name! + " has assigned a new task."
        let test2 = "Superuser " + name! + " has assigned a new task."
        
        let assignedBy_Role : String?
        assignedBy_Role = defaults.string(forKey: "employeeStatusID")
        
        //if assignedBy_Role! == "1" {
        //}
        
        print("sendNotificationAPICall")
        
        if assignedBy_Role! == "1" && ROLE == "2" {
            print("Role while notfying", ROLE!)
            print("Supervisor params", USERMOB)
            print("assignedBy_Role  ", assignedBy_Role!)
            
            self.ActivityIndicator.stopAnimating()
            self.successAlert?.show(nil, hidden: nil)
            self.goBack()
            let defaults = UserDefaults.standard
            defaults.set("noticationSent", forKey: "RefreshServiceCall")
            
            /*let params = [
             "to" : USERMOB,
             "notification": [
             "body": test,
             "title": "New Assigned Task",
             "icon" : "appicon"
             ]
             ] as [String : Any]
             
             Alamofire.request("https://fcm.googleapis.com/fcm/send", method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json","Authorization": "key=AAAAwqPRhzU:APA91bEt7g8zgMgaiol6RodUOk0NB4q5vpGubNrOTNVMLa1dNCs1dTrDr09XemCN9mT7zm-LkbbQXh2HduOO3APPDtF__QfdJ-C307l8KnYyziKdvozcRwJmg7-W0KV1rweA-gE7xX6N"]).responseJSON {
             response in
             switch response.result {
             case .success(let value):
             let jsonArray = JSON(value)
             let status = jsonArray["success"]
             if status == 0 {
             print("Notification FAILURE ")
             } else {
             print("Notification SUCCESS ")
             }
             
             break
             case .failure(let error):
             print("Notification API Failure" , error)
             break
             }
             }*/
        } else if assignedBy_Role! == "2" && ROLE == "3" {
            print("Role while notfying", ROLE!)
            print("Supervisor params", USERMOB)
            
            let params = [
                "to" : USERMOB,
                "notification": [
                    "body": test,
                    "title": "New Assigned Task",
                    "icon" : "appicon",
                    "sound" : "default"
                ]
                ] as [String : Any]
            
            Alamofire.request("https://fcm.googleapis.com/fcm/send", method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json","Authorization": "key=AAAAwqPRhzU:APA91bEt7g8zgMgaiol6RodUOk0NB4q5vpGubNrOTNVMLa1dNCs1dTrDr09XemCN9mT7zm-LkbbQXh2HduOO3APPDtF__QfdJ-C307l8KnYyziKdvozcRwJmg7-W0KV1rweA-gE7xX6N"]).responseJSON {
                response in
                switch response.result {
                case .success(let value):
                    let jsonArray = JSON(value)
                    let status = jsonArray["success"]
                    if status == 0 {
                        print("Notification FAILURE ")
                    } else {
                        print("Notification SUCCESS ")
                    }
                    self.ActivityIndicator.stopAnimating()
                    self.successAlert?.show(nil, hidden: nil)
                    self.goBack()
                    let defaults = UserDefaults.standard
                    defaults.set("noticationSent", forKey: "RefreshServiceCall")
                    
                    break
                case .failure(let error):
                    print("Notification API Failure" , error)
                    break
                }
            }
        }
        else if assignedBy_Role! == "1" && ROLE == "3" {
            print("Role while notify " , ROLE!)
            print("assignedBy_Role  ", assignedBy_Role!)
            print(" Admin role MULTIArr  params ", MULTIArr)
            
            let params = [
                "results" : [],
                "notification": [
                    "body": test2,
                    "title": "New Assigned Task",
                    "icon" : "appicon",
                    "sound" : "default"
                ],
                "registration_ids" : MULTIArr
                ] as [String : Any]
            Alamofire.request("https://fcm.googleapis.com/fcm/send", method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json","Authorization": "key=AAAAwqPRhzU:APA91bEt7g8zgMgaiol6RodUOk0NB4q5vpGubNrOTNVMLa1dNCs1dTrDr09XemCN9mT7zm-LkbbQXh2HduOO3APPDtF__QfdJ-C307l8KnYyziKdvozcRwJmg7-W0KV1rweA-gE7xX6N"]).responseJSON {
                response in
                switch response.result {
                case .success(let value):
                    let jsonArray = JSON(value)
                    let status = jsonArray["success"]
                    if status == 0 {
                        print("Notification FAILURE ")
                    } else {
                        print("Notification SUCCESS ")
                    }
                    self.ActivityIndicator.stopAnimating()
                    self.successAlert?.show(nil, hidden: nil)
                    self.goBack()
                    let defaults = UserDefaults.standard
                    defaults.set("noticationSent", forKey: "RefreshServiceCall")
                    break
                case .failure(let error):
                    print("Notification API Failure" , error)
                    break
                }
            }
        }
    }
    
    var defaultsProperty = UserDefaults.standard
    func goBack() {
        defaultsProperty.set("", forKey: "RefreshServiceCall")
        objects.removeAll()
        objects2.removeAll()
        objects3.removeAll()
        objects4.removeAll()
        objects5.removeAll()
        objects6.removeAll()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (3.0)) {
            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "DashBoard") as UIViewController
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


