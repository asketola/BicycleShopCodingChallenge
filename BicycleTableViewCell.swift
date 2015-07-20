//
//  BicycleTableViewCell.swift
//  BikeCodingChallenge
//
//  Created by Annemarie Ketola on 7/14/15.
//  Copyright (c) 2015 Annemarie Ketola. All rights reserved.
//

import UIKit
import Parse

class BicycleTableViewCell: UITableViewCell {

    @IBOutlet weak var bikeImage: UIImageView!
    @IBOutlet weak var bikeBrandNameText: UILabel!
    @IBOutlet weak var bikeModelText: UILabel!
    @IBOutlet weak var bikepriceText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
