//
//  StargazerCell.swift
//  CoachTimer
//
//  Created by Jean Raphael Bordet on 25/05/21.
//

import UIKit

class UserCell: UITableViewCell {
	
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
	}
	
}

extension UIImageView {
	func load(url: URL) {
		DispatchQueue.global().async { [weak self] in
			guard
				let data = try? Data(contentsOf: url),
				let image = UIImage(data: data) else {
				return
			}
			
			DispatchQueue.main.async {
				self?.image = image
			}
		}
	}
}
