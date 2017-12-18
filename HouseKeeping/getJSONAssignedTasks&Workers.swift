

import UIKit

//For Data Download
let HKURL =   "http://www.mobile.chembiantech.com:8080/HouseKeeping" ///"http://192.168.1.200:8081/HouseKeeping"
//For Image Download
let HKImgUrl = "http://www.mobile.chembiantech.com:8080/housekeeping"

//JsonAssignedTasks
struct getAssignedTasks {
    let assignedTaskID: Int
    let taskStatusID: String
    let description: String
    let dateAssigned : String
    let location : String
    let assignedBY : String
    let employeeId : String
    let priorities : String
    let floorNumber : String
    let employeeName : String
    let imageCount : String
    let checkListIds : String
    let taskListId : String
    let assignedByName : String
    let assignedByRole : String
    let isDistributsed : String
    let duration : String
}

//JsonWorkers
struct getWorkers {
    let employeeLevelID: String
    let levelName: String
}

//Employee Details Housekeeping
struct getEmployeeDetailsHousekeeping {
    let FirstName : String
    let LastName : String
    let UserMobileID : String
    let EmployeeID : String
    let completed : String
    let onprogress : String
    let pending : String
    let dnd : String
    let Phone : String
    let Email : String
    let Address : String
}

//Employee Details Car Parking
struct getEmployeeDetailsCarParking {
    let FirstName : String
    let LastName : String
    let UserMobileID : String
    let EmployeeID : String
    let completed : String
    let onprogress : String
    let pending : String
    let dnd : String
    let Phone : String
    let Email : String
    let Address : String
}

//Employee Details Maintenance
struct getEmployeeDetailsMaintenance {
    let FirstName : String
    let LastName : String
    let UserMobileID : String
    let EmployeeID : String
    let completed : String
    let onprogress : String
    let pending : String
    let dnd : String
    let Phone : String
    let Email : String
    let Address : String
}

struct getEmployeeDetailsPlumber {
    let FirstName : String
    let LastName : String
    let UserMobileID : String
    let EmployeeID : String
    let completed : String
    let onprogress : String
    let pending : String
    let dnd : String
    let Phone : String
    let Email : String
    let Address : String
}
struct getEmployeeDetailsCarpenter {
    let FirstName : String
    let LastName : String
    let UserMobileID : String
    let EmployeeID : String
    let completed : String
    let onprogress : String
    let pending : String
    let dnd : String
    let Phone : String
    let Email : String
    let Address : String
}
struct getEmployeeDetailsElectrician {
    let FirstName : String
    let LastName : String
    let UserMobileID : String
    let EmployeeID : String
    let completed : String
    let onprogress : String
    let pending : String
    let dnd : String
    let Phone : String
    let Email : String
    let Address : String
}
struct getEmployeeDetailsDriver {
    let FirstName : String
    let LastName : String
    let UserMobileID : String
    let EmployeeID : String
    let completed : String
    let onprogress : String
    let pending : String
    let dnd : String
    let Phone : String
    let Email : String
    let Address : String
}
struct getEmployeeDetailsCleaner {
    let FirstName : String
    let LastName : String
    let UserMobileID : String
    let EmployeeID : String
    let completed : String
    let onprogress : String
    let pending : String
    let dnd : String
    let Phone : String
    let Email : String
    let Address : String
}
struct getEmployeeDetailsWasher {
    let FirstName : String
    let LastName : String
    let UserMobileID : String
    let EmployeeID : String
    let completed : String
    let onprogress : String
    let pending : String
    let dnd : String
    let Phone : String
    let Email : String
    let Address : String
}
struct getEmployeeDetailsArranger {
    let FirstName : String
    let LastName : String
    let UserMobileID : String
    let EmployeeID : String
    let completed : String
    let onprogress : String
    let pending : String
    let dnd : String
    let Phone : String
    let Email : String
    let Address : String
}

//Floor Details
struct getFloorDetails {
    let FloorID : String
    let FloorName : String
    let AreaDetail : String
    let AreaDetailID : String
    let AreaTypeID : String
}

//Work Type Details
struct getWorkTypeDetails {
    let taskListId : String
    let taskListName : String
}

//IMAGE
struct saveGalleryImage {
    let saveimages : UIImage
}

struct saveGalleryImage2 {
    let saveimages2 : UIImage
}
