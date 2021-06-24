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
	
	@IBOutlet var lapsLabel: UILabel!
	@IBOutlet var speedLabel: UILabel!
	
	public var avatarUrl: URL?
}
