//
//  CourseTableViewCell.swift
//  ChatDemo
//
//  Created by Tuan Le on 11/30/15.
//  Copyright © 2015 Tuan Le. All rights reserved.
//

import UIKit

class CourseTableViewCell: UITableViewCell {
    @IBOutlet var enText: UITextView!
    @IBOutlet var viText: UITextView!
    @IBOutlet var usButton: UIButton!
    @IBOutlet var ukButton: UIButton!
    @IBOutlet var copyButton: UIButton!
    @IBOutlet var viewCell: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
