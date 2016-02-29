//
//  DateTableViewCell.swift
//  EventPlanner
//
//  Created by Richard Trevivian on 2/22/16.
//  Copyright © 2016 Richard Trevivian. All rights reserved.
//

import UIKit

class DateTimeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
