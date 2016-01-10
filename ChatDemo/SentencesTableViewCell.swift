//
//  SentencesTableViewCell.swift
//  ChatDemo
//
//  Created by Tuan Le on 11/30/15.
//  Copyright © 2015 Tuan Le. All rights reserved.
//

import UIKit

class SentencesTableViewCell: UITableViewCell {
    @IBOutlet var img: UIImageView!
    @IBOutlet var enLabel: UILabel!
    @IBOutlet var viLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
