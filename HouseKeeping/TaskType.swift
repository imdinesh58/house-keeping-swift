//
//  TaskType.swift
//  HouseKeeping
//
//  Created by Apple-1 on 9/25/17.
//  Copyright © 2017 Apple-1. All rights reserved.
//

import UIKit

class TaskType: UITableViewCell {
    @IBOutlet weak var taskType: UILabel!
    @IBOutlet weak var taskTypeId: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
