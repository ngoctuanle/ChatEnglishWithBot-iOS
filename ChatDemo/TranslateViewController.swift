//
//  TranslateViewController.swift
//  ChatDemo
//
//  Created by Tuan Le on 11/29/15.
//  Copyright © 2015 Tuan Le. All rights reserved.
//

import UIKit
import AVFoundation

class TranslateViewController: UIViewController, UITextViewDelegate {
    @IBOutlet var originView: UIView!
    @IBOutlet var transView: UIView!

    @IBOutlet var originImg: UIImageView!
    @IBOutlet var transImg: UIImageView!

    @IBOutlet var originTitle: UIButton!
    @IBOutlet var transTitle: UIButton!
    
    @IBOutlet var originInput: UITextView!
    @IBOutlet var transOutput: UITextView!
    
    @IBOutlet var transButton: UIButton!
    
    @IBAction func originTap(sender: UIButton) {
        var tmp: String!
        tmp = origin
        origin = native
        native = tmp
        tmp = originShort
        originShort = nativeShort
        nativeShort = tmp
        
        originImg.image = UIImage(named: originShort)
        originTitle.setTitle(origin, forState: .Normal)
        transImg.image = UIImage(named: nativeShort)
        transTitle.setTitle(native, forState: .Normal)
    }
    @IBAction func transTap(sender: UIButton) {
        var tmp: String!
        tmp = origin
        origin = native
        native = tmp
        tmp = originShort
        originShort = nativeShort
        nativeShort = tmp
        
        originImg.image = UIImage(named: originShort)
        originTitle.setTitle(origin, forState: .Normal)
        transImg.image = UIImage(named: nativeShort)
        transTitle.setTitle(native, forState: .Normal)
    }
    @IBAction func translate(sender: UIButton) {
        self.view.endEditing(true)
        var translate = ""
        if(self.originInput.text != "enter sentences"){
            translate = translateQuickGoogle(originInput.text, origin: originShort, target: nativeShort)
        }
        transOutput.text = translate
    }
    
    var origin: String = "English"
    var originShort: String = "en"
    var native: String!
    var nativeShort: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.translucent = false
        
        self.originView.layer.cornerRadius = 5
        self.transView.layer.cornerRadius = 5
        
        self.originInput.layer.cornerRadius = 5
        self.transOutput.layer.cornerRadius = 5
        
        originInput.delegate = self
        originInput.text = "enter sentences"
        originInput.textColor = UIColor.lightGrayColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
        self.title = "Translate"
        native = ""
        nativeShort = ""
        let database: COpaquePointer = connectdb1("gpchat", type: "sqlite")
        let statement: COpaquePointer = db_select("SELECT * FROM NativeLanguage", database: database)
        while sqlite3_step(statement) == SQLITE_ROW {
            let rowdata = sqlite3_column_text(statement, 0)
            let navShort = String.fromCString(UnsafePointer<CChar>(rowdata))
            nativeShort = navShort
            
            let rowdata1 = sqlite3_column_text(statement, 1)
            let navLan = String.fromCString(UnsafePointer<CChar>(rowdata1))
            native = navLan
        }
        sqlite3_finalize(statement)
        sqlite3_close(database)
        
        originImg.image = UIImage(named: originShort)
        originTitle.setTitle(origin, forState: .Normal)
        transImg.image = UIImage(named: nativeShort)
        transTitle.setTitle(native, forState: .Normal)
        
        KCFABManager.defaultInstance().getButton().addItem("Copy English", icon: UIImage(named: "ic_translate_copy_en")!, handler: {
            item in
            if(self.originShort == "en"){
                UIPasteboard.generalPasteboard().string = self.originInput.text
                Toast.appearance.blurStyle = .Dark
                Toast.appearance.textColor = UIColor.whiteColor()
                Toast.makeText("Copied to clipbroad!", duration: Toast.LENGTH_SHORT).show()
            } else {
                UIPasteboard.generalPasteboard().string = self.transOutput.text
                Toast.appearance.blurStyle = .Dark
                Toast.appearance.textColor = UIColor.whiteColor()
                Toast.makeText("Copied to clipbroad!", duration: Toast.LENGTH_SHORT).show()
            }
            KCFABManager.defaultInstance().getButton().close()
        })
        KCFABManager.defaultInstance().getButton().addItem("Play English", icon: UIImage(named: "ic_volume_trans_sentences")!, handler: {
            item in
            if(self.originShort == "en"){
                var myUtterance = AVSpeechUtterance(string: "")
                if(self.originInput.text != "enter sentences"){
                    myUtterance = AVSpeechUtterance(string: self.originInput.text)
                }
                myUtterance.voice = AVSpeechSynthesisVoice(language: "en-us")
                let synth = AVSpeechSynthesizer()
                let sysver = UIDevice.currentDevice().systemVersion
                if(sysver[sysver.startIndex] != Character("9")){
                    myUtterance.rate = AVSpeechUtteranceMinimumSpeechRate
                }else{
                    myUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
                }
                synth.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
                synth.speakUtterance(myUtterance)
            } else {
                let myUtterance = AVSpeechUtterance(string: self.transOutput.text)
                myUtterance.voice = AVSpeechSynthesisVoice(language: "en-us")
                let synth = AVSpeechSynthesizer()
                let sysver = UIDevice.currentDevice().systemVersion
                if(sysver[sysver.startIndex] != Character("9")){
                    myUtterance.rate = AVSpeechUtteranceMinimumSpeechRate
                }else{
                    myUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
                }
                synth.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
                synth.speakUtterance(myUtterance)
            }
        })
        KCFABManager.defaultInstance().getButton().buttonColor = UIColor(hex: "f13232")
        KCFABManager.defaultInstance().show()
    }
    
    override func viewWillDisappear(animated: Bool) {
        KCFABManager.defaultInstance().hide()
        KCFABManager.defaultInstance().getButton().removeItem(index: 0)
        KCFABManager.defaultInstance().getButton().removeItem(index: 0)
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if(originInput.textColor == UIColor.lightGrayColor()){
            originInput.text = nil
            originInput.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if originInput.text.isEmpty {
            originInput.text = "enter sentences"
            originInput.textColor = UIColor.lightGrayColor()
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
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
            let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
            if let blogs = json["sentences"] as? [[String: AnyObject]] {
                for blog in blogs {
                    if let name = blog["trans"] as? String {
                        translate += name
                    }
                }
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
            print("Query Error")
            return
        }
    }
}
