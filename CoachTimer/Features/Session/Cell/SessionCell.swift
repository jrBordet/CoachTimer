//
//  SessionCell.swift
//  CoachTimer
//
//  Created by Jean Raphael Bordet on 18/06/21.
//

import UIKit

class SessionCell: UITableViewCell {
	@IBOutlet var timeLabel: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
