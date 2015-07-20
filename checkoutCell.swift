//
//  checkoutCell.swift
//  BikeCodingChallenge
//
//  Created by Annemarie Ketola on 7/20/15.
//  Copyright (c) 2015 Annemarie Ketola. All rights reserved.
//

import UIKit

class checkoutCell: UITableViewCell {
    
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
