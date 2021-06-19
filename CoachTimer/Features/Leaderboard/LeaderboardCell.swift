//
//  LeaderboardCell.swift
//  CoachTimer
//
//  Created by Jean Raphael Bordet on 19/06/21.
//

import UIKit

class LeaderboardCell: UITableViewCell {

	@IBOutlet var nameLabel: UILabel!
	@IBOutlet var avatarImage: UIImageView! {
		didSet {
			avatarImage.layer.cornerRadius = 4.0
		}
	}
	
	public var avatarUrl: URL?
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
