//
//  workHistoryCell.swift
//  HouseKeeping
//
//  Created by Apple-1 on 8/7/17.
//  Copyright © 2017 Apple-1. All rights reserved.
//

import UIKit

class workHistoryCell: UITableViewCell {
    @IBOutlet weak var HDescription: UILabel!
    @IBOutlet weak var HLocation: UILabel!
    @IBOutlet weak var HDate: UILabel!
    @IBOutlet weak var HStasus: UILabel!
    @IBOutlet weak var icon: UILabel!
    @IBOutlet weak var priority: UILabel!
    @IBOutlet weak var checklists: UILabel!
    @IBOutlet weak var comments: UILabel!
    @IBOutlet weak var taskId: UILabel!
    @IBOutlet weak var assignedby: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
