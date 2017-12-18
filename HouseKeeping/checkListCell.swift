//
//  checkListCell.swift
//  HouseKeeping
//
//  Created by Apple-1 on 9/28/17.
//  Copyright © 2017 Apple-1. All rights reserved.
//

import UIKit

class checkListCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var ID: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
