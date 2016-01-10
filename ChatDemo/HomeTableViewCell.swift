//
//  HomeTableViewCell.swift
//  ChatDemo
//
//  Created by Tuan Le on 12/14/15.
//  Copyright © 2015 Tuan Le. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    @IBOutlet var avatarBot: UIImageView!
    @IBOutlet var nameBot: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
