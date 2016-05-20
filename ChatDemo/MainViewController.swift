//
//  MainViewController.swift
//  ChatDemo
//
//  Created by Tuan Le on 11/29/15.
//  Copyright © 2015 Tuan Le. All rights reserved.
//

import UIKit
import JGProgressHUD

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    @IBOutlet var tableView: UITableView!
    
    let botNameArr = ["Emma", "William", "Special person", "Jacob", "Abigail"]
    let botUrlArr = ["http://www.tolearnenglish.com/free/celebs/audreyg.php",
                     "http://www.tolearnenglish.com/free/celebs/charlesg.php",
                     "http://www.englishchat247.com/chat-english-with-teacher/",
                     "http://www.tolearnenglish.com/free/celebs/cristalg.php",
                     "http://www.tolearnenglish.com/free/celebs/mikeg.php"]
    let botAvatarArr = ["a","b","e","d","c"]
    let pattern = "http://www.pandorabots.com/pandora/talk?botid="
    var HUD: JGProgressHUD!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        HUD = JGProgressHUD()
        HUD.textLabel.text = "Connecting"
        self.navigationController?.navigationBar.translucent = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
        self.title = "GPaddy Chat"
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return botNameArr.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! HomeTableViewCell
        cell.avatarBot.image = UIImage(named: botAvatarArr[indexPath.row])
        cell.nameBot.text = botNameArr[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.HUD.showInView(self.view, animated: true)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            let botID = self.getBotIdFromUrl(self.botUrlArr[indexPath.row], mPartern: self.pattern, index: indexPath.row)
            let botVariableName = self.getVariablename(self.pattern, id: botID, index: indexPath.row)
            dispatch_async(dispatch_get_main_queue(), {
                let storyBroad = UIStoryboard(name: "Main", bundle: nil)
                /*let pagerview = storyBroad.instantiateViewControllerWithIdentifier("PagerView") as! PagerViewController
                if(indexPath.row == 0){
                    pagerview.botID = "\(self.pattern)\(botID)"
                } else if(indexPath.row == 2){
                    pagerview.botID = "http://bandore.pandorabots.com/pandora/talk?botid=\(botID)"
                } else {
                    pagerview.botID = "http://demo.vhost.pandorabots.com/pandora/talk?botid=\(botID)"
                }
                pagerview.botVariableName = botVariableName
                pagerview.botAvatar = self.botAvatarArr[indexPath.row]
                pagerview.botName = self.botNameArr[indexPath.row]
                pagerview.botNum = "\(indexPath.row)"
                self.navigationController?.pushViewController(pagerview, animated: true)*/
                
                /*let pagerview = storyBroad.instantiateViewControllerWithIdentifier("ChatView") as! ChatViewController
                if(indexPath.row == 0){
                    pagerview.botID = "\(self.pattern)\(botID)"
                } else if(indexPath.row == 2){
                    pagerview.botID = "http://bandore.pandorabots.com/pandora/talk?botid=\(botID)"
                } else {
                    pagerview.botID = "http://demo.vhost.pandorabots.com/pandora/talk?botid=\(botID)"
                }
                pagerview.botVariableName = botVariableName
                pagerview.botAvatar = self.botAvatarArr[indexPath.row]
                pagerview.botName = self.botNameArr[indexPath.row]
                pagerview.botNum = "\(indexPath.row)"
                self.navigationController?.pushViewController(pagerview, animated: true)*/
                
                let pagerview = storyBroad.instantiateViewControllerWithIdentifier("TabPager") as! TabPagerViewController
                if(indexPath.row == 0){
                    pagerview.botID = "\(self.pattern)\(botID)"
                } else if(indexPath.row == 2){
                    pagerview.botID = "http://bandore.pandorabots.com/pandora/talk?botid=\(botID)"
                } else {
                    pagerview.botID = "http://demo.vhost.pandorabots.com/pandora/talk?botid=\(botID)"
                }
                pagerview.botVariableName = botVariableName
                pagerview.botAvatar = self.botAvatarArr[indexPath.row]
                pagerview.botName = self.botNameArr[indexPath.row]
                pagerview.botNum = "\(indexPath.row)"
                self.navigationController?.pushViewController(pagerview, animated: true)
                
                self.HUD.dismiss()
            })
        })
    }
    
    func getBotIdFromUrl(url: String, mPartern: String, index: Int) -> String{
        var id = ""
        do{
            let data = try NSString(contentsOfURL: NSURL(string: url)!, encoding: NSISOLatin1StringEncoding)
            if(index != 2){
                let partern = mPartern
                let range = data.rangeOfString(partern)
                let substr = data.substringFromIndex(range.location+range.length)
                let range1 = substr.rangeOfString("\"")
                id = substr.substringToIndex((range1?.first)!)
            } else {
                let partern = "http://bandore.pandorabots.com/pandora/talk?botid="
                let range = data.rangeOfString(partern)
                let substr = data.substringFromIndex(range.location+range.length)
                let range1 = substr.rangeOfString("\"")
                id = substr.substringToIndex((range1?.first)!)
            }
        }
        catch{
            print(error)
        }
        return id
    }
    
    func getVariablename(url: String, id: String, index: Int) -> String{
        var value = ""
        do{
            if(index != 2){
                let data = try NSString(contentsOfURL: NSURL(string: "\(url)\(id)")!, encoding: NSISOLatin1StringEncoding)
                let range = data.rangeOfString("name=\"botcust2\" value=\"")
                let substr = data.substringFromIndex(range.location+range.length)
                let range1 = substr.rangeOfString("\">")
                value = substr.substringToIndex((range1?.first)!)
            } else {
                let data = try NSString(contentsOfURL: NSURL(string: "http://bandore.pandorabots.com/pandora/talk?botid=\(id)")!, encoding: NSISOLatin1StringEncoding)
                let range = data.rangeOfString("name=\"botcust2\" value=\"")
                let substr = data.substringFromIndex(range.location+range.length)
                let range1 = substr.rangeOfString("\">")
                value = substr.substringToIndex((range1?.first)!)
            }
        }
        catch{
            print(error)
        }
        return value
    }
}
