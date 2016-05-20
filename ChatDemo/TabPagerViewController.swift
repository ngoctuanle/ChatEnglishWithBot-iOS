//
//  TabPagerViewController.swift
//  ChatDemo
//
//  Created by Tuan Le on 3/14/16.
//  Copyright © 2016 Tuan Le. All rights reserved.
//

import UIKit

class TabPagerViewController: KHTabPagerViewController, KHTabPagerDataSource, KHTabPagerDelegate {
    
    var botID: String!
    var botName: String!
    var botVariableName: String!
    var botAvatar: String!
    var botNum: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        self.delegate = self
        
        self.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfViewControllers() -> Int {
        return 3
    }
    
    func viewControllerForIndex(index: Int) -> UIViewController! {
        switch index{
        case 0:
            let storyBroad = UIStoryboard(name: "Main", bundle: nil)
            let chatview = storyBroad.instantiateViewControllerWithIdentifier("ChatView") as! ChatViewController
            chatview.botID = botID
            chatview.botVariableName = botVariableName
            chatview.botAvatar = botAvatar
            chatview.botName = botName
            chatview.botNum = botNum
            return chatview
        case 1:
            let storyBroad = UIStoryboard(name: "Main", bundle: nil)
            let sentencesview = storyBroad.instantiateViewControllerWithIdentifier("SentencesView") as! SentencesViewController
            return sentencesview
        case 2:
            let storyBroad = UIStoryboard(name: "Main", bundle: nil)
            let translateview = storyBroad.instantiateViewControllerWithIdentifier("TranslateView") as! TranslateViewController
            return translateview
        default:
            return nil
        }
    }
    
    func titleForTabAtIndex(index: Int) -> String! {
        switch (index) {
        case 0:
            return "Chat Conversation"
        case 1:
            return "Common Sentences"
        case 2:
            return "Translate Online"
        default:
            return nil;
        }
    }
    
    func tabHeight() -> CGFloat {
        return 40.0
    }
    
    func tabColor() -> UIColor! {
        return UIColor.whiteColor()
    }
    
    func tabBackgroundColor() -> UIColor! {
        //return UIColor(hex: "1E88E5")
        return UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
    }
    
    func titleColor() -> UIColor! {
        return UIColor.whiteColor()
    }
    
    func titleFont() -> UIFont! {
        return UIFont.systemFontOfSize(16)
    }
    
    func isProgressiveTabBar() -> Bool {
        return true
    }
    
    func tabPager(tabPager: KHTabPagerViewController!, didTransitionToTabAtIndex index: Int) {
        
    }
    
    func tabPager(tabPager: KHTabPagerViewController!, willTransitionToTabAtIndex index: Int) {
        
    }
}
