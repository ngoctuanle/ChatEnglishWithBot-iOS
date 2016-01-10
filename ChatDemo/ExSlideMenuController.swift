//
//  ExSlideMenuController.swift
//  ChatDemo
//
//  Created by Tuan Le on 11/29/15.
//  Copyright © 2015 Tuan Le. All rights reserved.
//

import Foundation
import UIKit

class ExSlideMenuController: SlideMenuController {
    override func isTagetViewController() -> Bool {
        if let vc = UIApplication.topViewController() {
            if vc is MainViewController ||
            vc is SentencesViewController ||
            vc is TranslateViewController ||
            vc is SettingsViewController {
                    return true
            }
        }
        return false
    }
}
