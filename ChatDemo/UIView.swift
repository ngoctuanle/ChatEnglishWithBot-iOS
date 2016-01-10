//
//  UIView.swift
//  ChatDemo
//
//  Created by Tuan Le on 12/9/15.
//  Copyright © 2015 Tuan Le. All rights reserved.
//

import UIKit

extension UIView {
    class func loadNib<T: UIView>(viewType: T.Type) -> T {
        let className = String.className(viewType)
        return NSBundle(forClass: viewType).loadNibNamed(className, owner: nil, options: nil).first as! T
    }
    
    class func loadNib() -> Self {
        return loadNib(self)
    }
}

