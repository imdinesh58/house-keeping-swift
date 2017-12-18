//
//  Distribute.swift
//  HouseKeeping
//
//  Created by Apple-1 on 10/31/17.
//  Copyright © 2017 Apple-1. All rights reserved.
//

import UIKit

class Distribute: UITableViewCell {

    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var ID: UILabel!
    @IBOutlet weak var ImageSSS: UIImageView!
    @IBOutlet weak var UserMobileIDArray: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
