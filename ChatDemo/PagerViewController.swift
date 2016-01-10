//
//  PagerViewController.swift
//  ChatDemo
//
//  Created by Tuan Le on 12/17/15.
//  Copyright © 2015 Tuan Le. All rights reserved.
//

import UIKit

class PagerViewController: UIViewController {
    
    var botID: String!
    var botName: String!
    var botVariableName: String!
    var botAvatar: String!
    var botNum: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.translucent = false
        
        let tabBarController = ESTabBarController(tabIconNames: ["ic_chat_24dp_gray",
                                                                 "ic_sample_sentence_24dp_gray",
                                                                 "ic_trans_24dp_gray"])
        self.addChildViewController(tabBarController)
        self.view.addSubview(tabBarController.view)
        tabBarController.view.frame = self.view.bounds
        tabBarController.didMoveToParentViewController(self)
        
        let storyBroad = UIStoryboard(name: "Main", bundle: nil)
        let chatview = storyBroad.instantiateViewControllerWithIdentifier("ChatView") as! ChatViewController
        chatview.botID = botID
        chatview.botVariableName = botVariableName
        chatview.botAvatar = botAvatar
        chatview.botName = botName
        chatview.botNum = botNum
        let sentencesview = storyBroad.instantiateViewControllerWithIdentifier("SentencesView")
        let translateview = storyBroad.instantiateViewControllerWithIdentifier("TranslateView") as! TranslateViewController
        
        tabBarController.setViewController(chatview, atIndex: 0)
        tabBarController.setViewController(sentencesview, atIndex: 1)
        tabBarController.setViewController(translateview, atIndex: 2)
        
        tabBarController.selectedColor = UIColor(hex: "FFFFFF")
        tabBarController.buttonsBackgroundColor = UIColor(hex: "1E88E5")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
