//
//  EmployeeLoginCell.swift
//  HouseKeeping
//
//  Created by Apple-1 on 7/27/17.
//  Copyright © 2017 Apple-1. All rights reserved.
//

import UIKit

class EmployeeLoginCell: UITableViewCell {
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl3: UILabel!
    @IBOutlet weak var lbl4: UILabel!
    @IBOutlet weak var lbl5: UILabel!
    @IBOutlet weak var assignedByID: UILabel!
    @IBOutlet weak var taskListId: UILabel!
    @IBOutlet weak var duration: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
