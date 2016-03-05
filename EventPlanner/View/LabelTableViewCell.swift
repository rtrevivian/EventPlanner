//
//  LabelTableViewCell.swift
//  EventPlanner
//
//  Created by Richard Trevivian on 3/4/16.
//  Copyright © 2016 Richard Trevivian. All rights reserved.
//

import UIKit

class LabelTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
