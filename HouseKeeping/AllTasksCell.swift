//
//  AllTasksCell.swift
//  HouseKeeping
//
//  Created by Apple-1 on 9/25/17.
//  Copyright © 2017 Apple-1. All rights reserved.
//

import UIKit

class AllTasksCell: UITableViewCell {

    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl3: UILabel!
    @IBOutlet weak var lbl4: UILabel!
    @IBOutlet weak var lbl5: UILabel!
    @IBOutlet weak var lbl6: UILabel!
    
    @IBOutlet weak var checkListId: UILabel!
    @IBOutlet weak var prio: UILabel!
    @IBOutlet weak var comments: UILabel!
    @IBOutlet weak var taskId: UILabel!
    @IBOutlet weak var assignedBy: UILabel!
    
    @IBOutlet weak var AssignedTaskId: UILabel!
    @IBOutlet weak var isDistributed: UILabel!
    
    @IBOutlet weak var AssignedByRoleId: UILabel!
    @IBOutlet weak var UserMobID: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
