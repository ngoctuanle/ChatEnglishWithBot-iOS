//
//  UIViewController.swift
//  ChatDemo
//
//  Created by Tuan Le on 11/29/15.
//  Copyright © 2015 Tuan Le. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func setNavigationBarItem() {
        self.addLeftBarButtonWithImage(UIImage(named: "ic_menu_black_24dp")!)
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.addLeftGestures()
    }
    
    func removeNavigationBarItem() {
        self.navigationItem.leftBarButtonItem = nil
        self.slideMenuController()?.removeLeftGestures()
    }

}
