//
//  AppDelegate.swift
//  ChatDemo
//
//  Created by Tuan Le on 11/29/15.
//  Copyright © 2015 Tuan Le. All rights reserved.
//

import UIKit
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private func createMenuView() {
        let storyBroad = UIStoryboard(name: "Main", bundle: nil)
        
        let mainViewController = storyBroad.instantiateViewControllerWithIdentifier("MainView") as! MainViewController
        let slideMenuViewController = storyBroad.instantiateViewControllerWithIdentifier("SlideMenu") as! SlideMenuViewController
        
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
        slideMenuViewController.mainViewController = nvc
        
        let slideMenuController = ExSlideMenuController(mainViewController: nvc, leftMenuViewController: slideMenuViewController)
        slideMenuController.automaticallyAdjustsScrollViewInsets = true
        self.window?.backgroundColor = UIColor(hex: "1976D2")
        self.window?.rootViewController = slideMenuController
        self.window?.makeKeyAndVisible()
        
        let pageController = UIPageControl.appearance()
        pageController.pageIndicatorTintColor = UIColor.lightGrayColor()
        pageController.currentPageIndicatorTintColor = UIColor.blackColor()
    }


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        self.createMenuView()
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        if(NSUserDefaults.standardUserDefaults().boolForKey("FirstLaunch")){
            
        } else{
            let storyboard: UIStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
            let vc: UIViewController = storyboard.instantiateViewControllerWithIdentifier("IntroView") as! IntroViewController
            
            self.window?.makeKeyAndVisible()
            self.window?.rootViewController?.presentViewController(vc, animated: true, completion: nil)
            
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "FirstLaunch")
            NSUserDefaults.standardUserDefaults().synchronize()
            
        }
        
        return true
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

