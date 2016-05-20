//
//  IntroViewController.swift
//  ChatDemo
//
//  Created by Tuan Le on 12/31/15.
//  Copyright © 2015 Tuan Le. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController, UIPageViewControllerDataSource, UIAlertViewDelegate {
    
    var pageViewController: UIPageViewController!
    var pageImages: NSArray!
    var skip:UIButton!
    
    var alert: UIAlertView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.pageImages = NSArray(objects: "intro0","intro1","intro2","intro3","intro4")
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageIntroView") as! UIPageViewController
        pageViewController.dataSource = self
        
        let startVC = self.viewControllerAtIndex(0) as PageIntroItemViewController
        let viewControllers = NSArray(object: startVC)
        
        self.pageViewController.setViewControllers(viewControllers as? [UIViewController], direction: .Forward, animated: true, completion: nil)
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        
        skip = UIButton.init()
        skip.frame = CGRectMake(self.view.frame.width-100, self.view.frame.height-80, 100, 40)
        skip.setTitle("Skip", forState: UIControlState.Normal)
        skip.setTitleColor(UIColor(hex: "2196f3"), forState: UIControlState.Normal)
        skip.addTarget(self, action: #selector(IntroViewController.Click), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(skip)
        
        self.pageViewController.didMoveToParentViewController(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func Click(){
        let trick: UIViewController = self.presentingViewController!
        self.dismissViewControllerAnimated(true, completion: {
            if(NSUserDefaults.standardUserDefaults().boolForKey("FirstLaunch1")){
                
            } else{
                let introView = self.storyboard?.instantiateViewControllerWithIdentifier("LanguageView")
                trick.presentViewController(introView!, animated: true, completion: nil)
                
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "FirstLaunch1")
                NSUserDefaults.standardUserDefaults().synchronize()
            }
        })
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        print(buttonIndex)
    }
    
    func viewControllerAtIndex(index: Int) -> PageIntroItemViewController{
        
        if((self.pageImages.count == 0) || (index >= self.pageImages.count)){
            return PageIntroItemViewController()
        }
        
        let vc: PageIntroItemViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageIntroItem") as! PageIntroItemViewController
        
        vc.imageFiles = self.pageImages[index] as! String
        vc.pageIndex = index
        return vc
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.pageImages.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let vc = viewController as! PageIntroItemViewController
        var index = vc.pageIndex as Int
        
        if(index == 0 || index == NSNotFound){
            return nil
        }
        
        index -= 1
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let vc = viewController as! PageIntroItemViewController
        var index = vc.pageIndex as Int
        
        if( index == NSNotFound){
            return nil
        }
        
        index += 1
        if(index == self.pageImages.count){
            self.skip.setTitle("Start", forState: UIControlState.Normal)
            return nil
        }
        
        return self.viewControllerAtIndex(index)
    }
}
