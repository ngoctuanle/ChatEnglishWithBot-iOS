//
//  PageIntroItemViewController.swift
//  ChatDemo
//
//  Created by Tuan Le on 12/31/15.
//  Copyright © 2015 Tuan Le. All rights reserved.
//

import UIKit

class PageIntroItemViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    
    var imageFiles: String!
    var pageIndex: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = UIImage(named: self.imageFiles)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
