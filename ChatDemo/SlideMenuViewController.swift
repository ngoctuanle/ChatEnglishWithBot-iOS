//
//  SlideMenuViewController.swift
//  ChatDemo
//
//  Created by Tuan Le on 11/29/15.
//  Copyright © 2015 Tuan Le. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

enum SlideMenu: Int {
    case Main = 0
    case Sentences
    case Translate
    case Settings
}

protocol SlideMenuProtocol: class {
    func changeViewController(menu: SlideMenu)
}

class SlideMenuViewController: UIViewController, SlideMenuProtocol, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    var headerView: HeaderView!
    
    var menus = ["Home", "Common Sentences", "Online Translate", "Settings"]
    var image = ["ic_home", "ic_category", "ic_translate", "ic_setting"]
    var mainViewController: UIViewController!
    var sentencesViewController: UIViewController!
    var translateViewController: UIViewController!
    var settingsViewController: UIViewController!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let storyBroad = UIStoryboard(name: "Main", bundle: nil)
        let sentencesViewController = storyBroad.instantiateViewControllerWithIdentifier("SentencesView") as! SentencesViewController
        self.sentencesViewController = UINavigationController(rootViewController: sentencesViewController)
        
        let translateViewController = storyBroad.instantiateViewControllerWithIdentifier("TranslateView") as! TranslateViewController
        self.translateViewController = UINavigationController(rootViewController: translateViewController)
        
        let settingsViewController = storyBroad.instantiateViewControllerWithIdentifier("SettingsView") as! SettingsViewController
        self.settingsViewController = UINavigationController(rootViewController: settingsViewController)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        FBSDKProfile.enableUpdatesOnAccessTokenChange(true)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "observeProfileChange:", name: FBSDKProfileDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "observeTokenChange:", name: FBSDKAccessTokenDidChangeNotification, object: nil)
        self.headerView = HeaderView.loadNib()
        if(FBSDKAccessToken.currentAccessToken() != nil){
            self.observeProfileChange(nil)
        }
        self.headerView.btnLogin.addTarget(self, action: "loginClicked:", forControlEvents: .TouchUpInside)
        self.view.addSubview(self.headerView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func changeViewController(menu: SlideMenu) {
        switch menu{
        case .Main:
            self.slideMenuController()?.changeMainViewController(self.mainViewController, close: true)
        case .Sentences:
            self.slideMenuController()?.changeMainViewController(self.sentencesViewController, close: true)
        case .Translate:
            self.slideMenuController()?.changeMainViewController(self.translateViewController, close: true)
        case .Settings:
            self.slideMenuController()?.changeMainViewController(self.settingsViewController, close: true)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if let menu = SlideMenu(rawValue: indexPath.item){
            self.changeViewController(menu)
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! MenuTableViewCell
        cell.img.image = UIImage(named: image[indexPath.row])
        cell.title.text = menus[indexPath.row]
        return cell
    }
    
    @IBAction func loginClicked(sender: UIButton){
        let login = FBSDKLoginManager()
        if(FBSDKAccessToken.currentAccessToken() == nil){
            login.logInWithReadPermissions(["public_profile"], fromViewController: self, handler: {
                (result : FBSDKLoginManagerLoginResult!, error: NSError!) -> Void in
                if(error != nil){
                    print(error.localizedDescription)
                } else if (result.isCancelled){
                    print("Cancel")
                } else {
                    print("Logged in...")
                }
            })
        } else {
            let alertController = UIAlertController(title: "", message: "Logged as \(FBSDKProfile.currentProfile().name)", preferredStyle: .ActionSheet)
            let actionOk = UIAlertAction(title: "Close",style: .Cancel,handler: nil)
            let actionLogout = UIAlertAction(title: "Logout", style: .Destructive, handler: {
                Void in
                login.logOut()
                self.headerView.nameLabel.text = "Login"
                print("Logout...")
            })
            alertController.addAction(actionLogout)
            alertController.addAction(actionOk)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func observeProfileChange(notfication: NSNotification!) {
        if(FBSDKProfile.currentProfile() != nil){
            self.headerView.nameLabel.text = "\(FBSDKProfile.currentProfile().name)"
        }
    }
    
    func observeTokenChange(notfication: NSNotification!) {
        if(FBSDKAccessToken.currentAccessToken() == nil){
            self.headerView.nameLabel.text = ""
        }else {
            self.observeProfileChange(nil)
        }
    }
}
