//
//  HeaderView.swift
//  ChatDemo
//
//  Created by Tuan Le on 12/9/15.
//  Copyright © 2015 Tuan Le. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class HeaderView: UIView {
    
    @IBOutlet var pro5Pic: FBSDKProfilePictureView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var btnLogin: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.pro5Pic.layer.cornerRadius = 40
        self.pro5Pic.clipsToBounds = true
        self.pro5Pic.layer.borderWidth = 1
        self.pro5Pic.layer.borderColor = UIColor.whiteColor().CGColor
    }
}
