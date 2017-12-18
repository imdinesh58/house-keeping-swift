//
//  tblAssignToCell.swift
//  HouseKeeping
//
//  Created by Apple-1 on 6/27/17.
//  Copyright © 2017 Apple-1. All rights reserved.
//

import UIKit

class tblAssignToCell: UITableViewCell {
    @IBOutlet weak var completed0: UILabel!
    @IBOutlet weak var completed1: UILabel!
    @IBOutlet weak var onprogress0: UILabel!
    @IBOutlet weak var onprogress1: UILabel!
    @IBOutlet weak var pending0: UILabel!
    @IBOutlet weak var pending1: UILabel!
    @IBOutlet weak var dnd0: UILabel!
    @IBOutlet weak var dnd1: UILabel!
    @IBOutlet weak var assign: UILabel!
    @IBOutlet weak var employee: UILabel!
    @IBOutlet weak var employeeID: UILabel!
    @IBOutlet weak var UserMobile: UILabel!
    @IBOutlet weak var mobile: UIImageView!
    @IBOutlet weak var statuslbl: UILabel!
    @IBOutlet weak var empName: UILabel!
    @IBOutlet weak var EmployeeStatus: UILabel!
    @IBOutlet weak var AssignedToRole: UILabel!
    @IBOutlet weak var empLevel: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
