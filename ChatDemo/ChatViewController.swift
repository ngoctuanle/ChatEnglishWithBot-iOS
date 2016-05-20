//
//  ChatViewController.swift
//  ChatDemo
//
//  Created by Tuan Le on 12/14/15.
//  Copyright © 2015 Tuan Le. All rights reserved.
//

import UIKit
import AVFoundation
import JSQMessagesViewController

class ChatViewController: JSQMessagesViewController, UIActionSheetDelegate{
    
    var botID: String!
    var botName: String!
    var botVariableName: String!
    var botAvatar: String!
    var botNum: String!
    
    var method: Bool!
    
    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor(hex: "1E88E5"))
    var incomingAvatar: JSQMessagesAvatarImage!
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor.lightGrayColor())
    var messages = [JSQMessage]()
    
    var native: String!
    var trans: [String]!
    var didtrans: [Bool]!

    override func viewDidLoad() {
        super.viewDidLoad()
        trans = []
        didtrans = []
        incomingAvatar = JSQMessagesAvatarImage(placeholder: UIImage(named: self.botAvatar))
        self.setup()
        self.loadOldMessages()
        method = false //false is text to text
        native = ""
        let database: COpaquePointer = connectdb1("gpchat", type: "sqlite")
        let statement: COpaquePointer = db_select("SELECT * FROM NativeLanguage", database: database)
        while sqlite3_step(statement) == SQLITE_ROW {
            let rowdata = sqlite3_column_text(statement, 0)
            let navShort = String.fromCString(UnsafePointer<CChar>(rowdata))
            native = navShort
        }
        sqlite3_finalize(statement)
        sqlite3_close(database)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
        //self.saveOldMessage()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.saveOldMessage()
    }
    
    func reloadMessagesView(){
        self.collectionView?.reloadData()
    }
    
    func getContentFromBot(path: String, varname: String, conteninput: String, botName: String) -> String{
        var res = "I`m busy, please try again later."
        let request = NSMutableURLRequest(URL: NSURL(string: path)!)
        request.HTTPMethod = "POST"
        let postString = "botcust2=\(varname)&input=\(conteninput)"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        var response: NSURLResponse?
        
        do{
            if(self.botName != "Special person"){
                let data = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
                let responseString = NSString(data: data, encoding: NSISOLatin1StringEncoding)
                let range = responseString?.rangeOfString("<font color=\"green\">")
                let substr = responseString?.substringFromIndex((range?.location)! + (range?.length)!)
                let range1 = substr?.rangeOfString("</font>")
                let response1 = substr?.substringToIndex((range1?.first)!)
                if(response1 != ""){
                    res = response1!
                }
            } else {
                let data = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
                let responseString = NSString(data: data, encoding: NSISOLatin1StringEncoding)
                let range = responseString?.rangeOfString("<b> Mike:<em>")
                let substr = responseString?.substringFromIndex((range?.location)! + (range?.length)!)
                let range1 = substr?.rangeOfString("</em></b>")
                let response1 = substr?.substringToIndex((range1?.first)!)
                if(response1 != ""){
                    res = response1!
                }
            }
        } catch {
            print(error)
        }
        return res
    }
    
    func translateQuickGoogle(input: String, origin: String, target: String) -> String{
        let TRANSLATE_GOOGLE = "https://translate.googleapis.com/translate_a/single?client=gtx&dt=t&dt=bd&dj=1&dt=ex&dt=ld&dt=md&dt=qca&dt=rw&dt=rm&dt=ss&dt=at"
        var LANGUAGE_TARGET = "&tl="
        var LANGUAGE_SOURCE = "&sl="
        var QUERY = "&q="
        var translate = ""
        let query1 = input.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        LANGUAGE_SOURCE += origin
        LANGUAGE_TARGET += target
        QUERY += query1!
        let url = TRANSLATE_GOOGLE + LANGUAGE_TARGET + LANGUAGE_SOURCE + QUERY
        let data = NSData(contentsOfURL: NSURL(string: url)!)
        do{
            if(data != nil){
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                if let blogs = json["sentences"] as? [[String: AnyObject]] {
                    for blog in blogs {
                        if let name = blog["trans"] as? String {
                            translate += name
                        }
                    }
                }
            } else {
                return translate
            }
        } catch {
            print("error serializing JSON: \(error)")
        }
        return translate
    }
    
    func connectdb1(dbname: String, type: String) -> COpaquePointer{
        var database: COpaquePointer = nil
        let path: NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentpath: NSString = path.objectAtIndex(0) as! NSString
        let dbpath: NSString = documentpath.stringByAppendingPathComponent("\(dbname).\(type)")
        let dbAlreadyExits = NSFileManager.defaultManager().fileExistsAtPath(dbpath as String)
        if(!dbAlreadyExits){
            let dbFromBundle: NSString = NSBundle.mainBundle().pathForResource(dbname, ofType: type)!
            try! NSFileManager.defaultManager().copyItemAtPath(dbFromBundle as String, toPath: dbpath as String)
            print("DB Create")
        }
        if(sqlite3_open(dbpath.UTF8String, &database) != SQLITE_OK){
            sqlite3_close(database)
            print("Open Error")
        }
        return database
    }
    
    func db_select(query:String, database:COpaquePointer)->COpaquePointer{
        var statement:COpaquePointer = nil
        sqlite3_prepare_v2(database, query, -1, &statement, nil)
        return statement
    }
    
    func db_query(sql:String, database: COpaquePointer){
        var errmsg:UnsafeMutablePointer<Int8> = nil
        let result = sqlite3_exec(database, sql, nil, nil, &errmsg)
        if (result != SQLITE_OK){
            sqlite3_close(database)
            print("Query Error \(errmsg)")
            return
        }
    }
}

extension ChatViewController {
    func addDemoMessages() {
        for i in 1...10 {
            let sender = (i%2 == 0) ? "Server" : self.senderId
            let messageContent = "Message nr. \(i)"
            let message = JSQMessage(senderId: sender, displayName: sender, text: messageContent)
            self.messages += [message]
        }
        self.reloadMessagesView()
    }
    
    func loadOldMessages(){
        let database: COpaquePointer = connectdb1("gpchat", type: "sqlite")
        let statement: COpaquePointer = db_select("SELECT * FROM chatLog\(botNum)", database: database)
        var ID = ""
        var senderName = ""
        var date: NSDate!
        var text = ""
        while sqlite3_step(statement) == SQLITE_ROW {
            let rowdata = sqlite3_column_text(statement, 0)
            let data = String.fromCString(UnsafePointer<CChar>(rowdata))
            ID = data!
            
            let rowdata1 = sqlite3_column_text(statement, 1)
            let data1 = String.fromCString(UnsafePointer<CChar>(rowdata1))
            senderName = data1!
            
            let rowdata2 = sqlite3_column_text(statement, 2)
            let data2 = String.fromCString(UnsafePointer<CChar>(rowdata2))
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM-yyyy-dd HH:mm:ss"
            dateFormatter.timeZone = NSTimeZone(name: "UTC")
            date = dateFormatter.dateFromString(data2!)
            
            let rowdata3 = sqlite3_column_text(statement, 3)
            let data3 = String.fromCString(UnsafePointer<CChar>(rowdata3))
            text = data3!
            
            //let rowdata4 = sqlite3_column_text(statement, 4)
            //let data4 = String.fromCString(UnsafePointer<CChar>(rowdata4))
            
            if(ID != ""){
                let mess = JSQMessage(senderId: ID, senderDisplayName: senderName, date: date, text: text)
                self.messages += [mess]
                if(ID == "Server"){
                    trans.append("Tap to translate")
                } else {
                    trans.append("")
                }
                didtrans.append(false)
            }
        }
        sqlite3_finalize(statement)
        sqlite3_close(database)
        self.reloadMessagesView()
    }
    
    func saveOldMessage(){
        if(self.messages.count >= 20){
            var j = 1
            for i in self.messages.count - 19 ..< self.messages.count
            {
                let ID = self.messages[i].senderId
                let name = self.messages[i].senderDisplayName
                let date = self.messages[i].date
                let text = self.messages[i].text
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "MM-yyyy-dd HH:mm:ss"
                dateFormatter.timeZone = NSTimeZone(name: "UTC")
                let dateString = dateFormatter.stringFromDate(date)
                let query = "UPDATE main.chatLog\(self.botNum) SET senderID = '\(ID)', senderName = '\(name)', date = '\(dateString)', text = '\(text)', trans = '' WHERE rowid = \(j)"
                j += 1
                let database: COpaquePointer = connectdb1("gpchat", type: "sqlite")
                self.db_query(query, database: database)
                sqlite3_close(database)
            }
        } else{
            var i = 1
            for mess:JSQMessage in self.messages {
                let ID = mess.senderId
                let name = mess.senderDisplayName
                let date = mess.date
                let text = mess.text
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "MM-yyyy-dd HH:mm:ss"
                dateFormatter.timeZone = NSTimeZone(name: "UTC")
                let dateString = dateFormatter.stringFromDate(date)
                let query = "UPDATE main.chatLog\(self.botNum) SET senderID = '\(ID)', senderName = '\(name)', date = '\(dateString)', text = '\(text)', trans = '' WHERE rowid = \(i)"
                i += 1
                let database: COpaquePointer = connectdb1("gpchat", type: "sqlite")
                self.db_query(query, database: database)
                sqlite3_close(database)
            }
        }
    }
    
    func setup() {
        self.senderId = "User"
        self.senderDisplayName = "User"
        let settingBtn = UIButton(type: .Custom)
        settingBtn.setImage(UIImage(named: "ic_setting"), forState: .Normal)
        self.inputToolbar?.contentView?.leftBarButtonItem = settingBtn
        
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        let data = self.messages[indexPath.row]
        return data
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, didDeleteMessageAtIndexPath indexPath: NSIndexPath!) {
        self.messages.removeAtIndex(indexPath.row)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let data = messages[indexPath.row]
        switch(data.senderId) {
        case self.senderId:
            return self.outgoingBubble
        default:
            return self.incomingBubble
        }
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        let data = messages[indexPath.row]
        switch(data.senderId) {
        case self.senderId:
            return nil
        default:
            return self.incomingAvatar
        }
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAtIndexPath indexPath: NSIndexPath!) {
        let data = messages[indexPath.row]
        if(self.didtrans[indexPath.row]==false){
            self.trans[indexPath.row] = "Translating..."
            self.didtrans[indexPath.row]=true
            self.reloadMessagesView()
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                let transres = self.translateQuickGoogle(data.text, origin: "en", target: self.native)
                dispatch_async(dispatch_get_main_queue(), {
                    self.trans[indexPath.row] = transres
                    self.reloadMessagesView()
                })
            })
        } else {
            self.trans[indexPath.row] = "Tap to translate"
            self.didtrans[indexPath.row]=false
            self.reloadMessagesView()
        }
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellBottomLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        let data = messages[indexPath.row]
        if(data.senderId == "Server" && self.didtrans[indexPath.row]==true){
            return NSAttributedString(string: trans[indexPath.row])
        }
        return NSAttributedString(string: "Tap to translate")
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellBottomLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        let data = messages[indexPath.row]
        if(data.senderId == "Server"){
            if(trans[indexPath.row].length > 40){
                let row: CGFloat = CGFloat(trans[indexPath.row].length)/40.0
                return kJSQMessagesCollectionViewCellLabelHeightDefault*row
            }
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        return 0
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        let message = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
        self.messages += [message]
        trans.append("")
        didtrans.append(false)
        self.finishSendingMessage()
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        self.showTypingIndicator = !self.showTypingIndicator
        self.scrollToBottomAnimated(true)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            var res = self.getContentFromBot(self.botID, varname: self.botVariableName, conteninput: text, botName: self.botName)
            if(res.containsString("ToLearnEnglish.com")){
                let range = res.rangeOfString("ToLearnEnglish.com")
                res.replaceRange(range!, with: "Gpaddy")
            }
            //let transres = self.translateQuickGoogle(res, origin: "en", target: self.native)
            NSThread.sleepForTimeInterval(0.5)
            dispatch_async(dispatch_get_main_queue(), {
                let messages = JSQMessage(senderId: "Server", senderDisplayName: self.botName, date: date, text: res)
                self.messages += [messages]
                self.trans.append("Tap to translate")
                self.didtrans.append(false)
                self.finishReceivingMessage()
                JSQSystemSoundPlayer.jsq_playMessageReceivedSound()
                if(self.method == true){
                    let myUtterance = AVSpeechUtterance(string: res)
                    if(self.botName == "Emma"){
                        myUtterance.voice = AVSpeechSynthesisVoice(language: "en-au")
                    }
                    if(self.botName == "William"){
                        myUtterance.voice = AVSpeechSynthesisVoice(language: "en-us")
                    }
                    if(self.botName == "Special person"){
                        myUtterance.voice = AVSpeechSynthesisVoice(language: "en-gb")
                    }
                    if(self.botName == "Jacob"){
                        myUtterance.voice = AVSpeechSynthesisVoice(language: "en-ie")
                    }
                    if(self.botName == "Abigail"){
                        myUtterance.voice = AVSpeechSynthesisVoice(language: "en-za")
                    }
                    let sysver = UIDevice.currentDevice().systemVersion
                    if(sysver[sysver.startIndex] != Character("9")){
                        myUtterance.rate = AVSpeechUtteranceMinimumSpeechRate
                    }else{
                        myUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
                    }
                    let synth = AVSpeechSynthesizer()
                    synth.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
                    synth.speakUtterance(myUtterance)
                }
            })
        })
    }
    
    override func didPressAccessoryButton(sender: UIButton!) {
        /* let alertController = UIAlertController(title: "Select chat method", message: "", preferredStyle: .ActionSheet)
        let actionOk = UIAlertAction(title: "Close",style: .Cancel,handler: nil)
        let actionT2T = UIAlertAction(title: "Text to Text", style: .Default, handler: {
            Void in
            self.method = false
        })
        let actionT2V = UIAlertAction(title: "Text to Voice", style: .Default, handler: {
            Void in
            self.method = true
        })
        alertController.addAction(actionT2T)
        alertController.addAction(actionT2V)
        alertController.addAction(actionOk)
        self.presentViewController(alertController, animated: true, completion: nil) */
        self.inputToolbar?.contentView?.textView?.resignFirstResponder()
        let sheet = UIActionSheet(title: "Select chat method", delegate: self, cancelButtonTitle: "Close", destructiveButtonTitle: nil, otherButtonTitles: "Text to Text", "Text to Voice")
        sheet.showFromToolbar(self.inputToolbar!)
    }
    
    func actionSheet(actionSheet: UIActionSheet, didDismissWithButtonIndex buttonIndex: Int) {
        if buttonIndex == actionSheet.cancelButtonIndex {
            self.inputToolbar?.contentView?.textView?.becomeFirstResponder()
            return
        }
        switch (buttonIndex) {
        case 1:
            self.method = false
            self.showHint("Enable Text to Text")
            break
        case 2:
            self.method = true
            self.showHint("Enable Text to Voice")
            break
        default:
            break
        }
    }
    
    func showHint(hint: String!) {
        let hud = MBProgressHUD(view: self.view!)
        hud.removeFromSuperViewOnHide = true
        self.view.addSubview(hud)
        hud.show(true)
        hud.userInteractionEnabled = false
        hud.mode = MBProgressHUDMode.Text
        hud.labelText = hint!
        hud.labelFont = UIFont.systemFontOfSize(15)
        hud.margin = 10
        hud.yOffset = 0
        hud.removeFromSuperViewOnHide = true
        hud.hide(true, afterDelay: 2)
    }
}
