//
//  String.swift
//  ChatDemo
//
//  Created by Tuan Le on 11/29/15.
//  Copyright © 2015 Tuan Le. All rights reserved.
//

import Foundation
import UIKit

extension String {
    static func className(aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).componentsSeparatedByString(".").last!
    }
    
    func substring(from: Int) -> String {
        return self.substringFromIndex(self.startIndex.advancedBy(from))
    }
    
    var length: Int {
        return self.characters.count
    }
    
    var html2AttributedString:NSAttributedString {
        return try! NSAttributedString(data: dataUsingEncoding(NSUTF8StringEncoding)!, options:[NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding], documentAttributes: nil)
    }
    
    var capitalizeFirst:String {
        var result = self
        result.replaceRange(startIndex...startIndex, with: String(self[startIndex]).capitalizedString)
        return result
    }
}