//
//  IconTableViewCell.swift
//  EventPlanner
//
//  Created by Richard Trevivian on 2/23/16.
//  Copyright © 2016 Richard Trevivian. All rights reserved.
//

import UIKit

enum IconTableViewCellType {
    
    case Phone, Email, Address
    
}

class IconTableViewCell: UITableViewCell {
    
    @IBOutlet weak var firstButton: UIView!
    @IBOutlet weak var secondButton: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // MARK: - Actions
    
    @IBAction func didTapFirstButton(sender: UIButton) {
    }
    
    @IBAction func didTapSecondButton(sender: UIButton) {
    }
    
}
