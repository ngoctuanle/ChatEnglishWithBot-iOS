//
//  SettingsViewController.swift
//  ChatDemo
//
//  Created by Tuan Le on 11/29/15.
//  Copyright © 2015 Tuan Le. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var rateCell: UITableViewCell!
    @IBOutlet var guideCell: UITableViewCell!
    @IBOutlet var aboutCell: UITableViewCell!
    @IBOutlet var shareCell: UITableViewCell!
    @IBOutlet var languageCell: UITableViewCell!
    @IBOutlet var labelLanguage: UILabel!
    @IBOutlet var imageLanguage: UIImageView!
    
    @IBOutlet var pickerView: UIView!
    @IBOutlet var pick: UIPickerView!
    @IBAction func btnDone(sender: UIBarButtonItem) {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3)
        pickerView.frame = CGRectMake(0, self.view.bounds.height, self.view.bounds.width, 250)
        UIView.commitAnimations()
    }
    let language = ["Afrikaans","Albanian","Arabic","Armenian",
                    "Azerbaijani","Basque","Bengali","Belarusian",
                    "Bosnian","Bulgarian","Catalan","Cebuano",
                    "Chinese Simplified","Chinese Traditional","Croatian","Czech",
                    "Danish","Dutch","English","Esperanto",
                    "Estonian","Filipino","Finnish","French",
                    "Galician","Georgian","German","Greek",
                    "Gujarati","Haitian Creole","Hausa","Hebrew",
                    "Hindi","Hmong","Hungarian","Icelandic",
                    "Igbo","Indonesian","Irish","Italian",
                    "Japanese","Javanese","Kannada","Khmer",
                    "Korean","Lao","Latin","Latvian",
                    "Lithuanian","Macedonian","Malay","Maltese",
                    "Maori","Marathi","Mongolian","Nepali",
                    "Norwegian","Persian","Polish","Portuguese",
                    "Punjabi","Romanian","Russian","Serbian",
                    "Slovak","Slovenian","Somali","Spanish",
                    "Swahili","Swedish","Tamil","Telugu",
                    "Thai","Turkish","Ukrainian","Urdu",
                    "Vietnamese","Welsh","Yiddish","Yoruba",
                    "Zulu"]
    let languageImg = ["af","sq","ar","hy",
                        "az","eu","bn","be",
                        "bs","bg","ca","ceb",
                        "zh-CN","zh-TW","hr","cs",
                        "da","nl","en","eo",
                        "et","tl","fi","fr",
                        "gl","ka","de","el",
                        "gu","ht","ha","iw",
                        "hi","hmn","hu","is",
                        "ig","id","ga","it",
                        "ja","jw","kn","km",
                        "ko","lo","la","lv",
                        "lt","mk","ms","mt",
                        "mi","mr","mn","ne",
                        "no","fa","pl","pt",
                        "pa","ro","ru","sr",
                        "sk","sl","so","es",
                        "sw","sv","ta","te",
                        "th","tr","uk","ur",
                        "vi","cy","yi","yo",
                        "zu"]
    
    var nativeLanguage: String!
    var nativeShort: String!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NSBundle.mainBundle().loadNibNamed("SettingView", owner: self, options: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.pick.dataSource = self
        self.pick.delegate = self
        
        nativeLanguage = ""
        nativeShort = ""
        
        self.imageLanguage.layer.cornerRadius = 15
        self.imageLanguage.clipsToBounds = true
        self.imageLanguage.layer.borderWidth = 1
        self.imageLanguage.layer.borderColor = UIColor(hex: "b2b2b2").CGColor
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
        self.title = "Settings"
        let database: COpaquePointer = connectdb1("gpchat", type: "sqlite")
        let statement: COpaquePointer = db_select("SELECT * FROM NativeLanguage", database: database)
        while sqlite3_step(statement) == SQLITE_ROW {
            let rowdata = sqlite3_column_text(statement, 0)
            let navShort = String.fromCString(UnsafePointer<CChar>(rowdata))
            nativeShort = navShort
            
            let rowdata1 = sqlite3_column_text(statement, 1)
            let navLan = String.fromCString(UnsafePointer<CChar>(rowdata1))
            nativeLanguage = navLan
        }
        sqlite3_finalize(statement)
        sqlite3_close(database)
        self.labelLanguage.text = nativeLanguage
        self.imageLanguage.image = UIImage(named: nativeShort)
    }
    
    // Picker view ---------------------------------------------------------------------
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return language.count
    }
    
    /* func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return language[row]
    } */
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let quocgia = self.storyboard?.instantiateViewControllerWithIdentifier("QuocgiaView") as! QuocGiaViewController
        quocgia.view.frame = CGRectMake(0, 0, 190, 34)
        quocgia.quocki.image = UIImage(named: languageImg[row])
        quocgia.tennuoc.text = language[row]
        return quocgia.view
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 34
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.labelLanguage.text = language[row]
        self.imageLanguage.image = UIImage(named: languageImg[row])
        let query = "UPDATE main.NativeLanguage SET nativeShort = '\(languageImg[row])', nativeLan = '\(language[row])' WHERE rowid = 1 "
        let database: COpaquePointer = connectdb1("gpchat", type: "sqlite")
        self.db_query(query, database: database)
        sqlite3_close(database)
        
    }
    
    // Table view ----------------------------------------------------------------------
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){ return 1 }
        if(section == 1){ return 4 }
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if ((indexPath.section == 0) && (indexPath.row == 0)){return 88}
        return 44
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if ((indexPath.section == 0) && (indexPath.row == 0)){return languageCell!}
        if ((indexPath.section == 1) && (indexPath.row == 0)){return rateCell!}
        if ((indexPath.section == 1) && (indexPath.row == 1)){return guideCell!}
        if ((indexPath.section == 1) && (indexPath.row == 2)){return shareCell!}
        if ((indexPath.section == 1) && (indexPath.row == 3)){return aboutCell!}
        return rateCell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if ((indexPath.section == 0) && (indexPath.row == 0)){
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.3)
            pickerView.frame = CGRectMake(0, self.view.bounds.height - 250, self.view.bounds.width, 250)
            UIView.commitAnimations()
        }
        if ((indexPath.section == 1) && (indexPath.row == 0)){
            let alert: UIAlertView = UIAlertView(title: nil, message: "Coming soon", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
        if ((indexPath.section == 1) && (indexPath.row == 1)){
            let introView = self.storyboard?.instantiateViewControllerWithIdentifier("IntroView")
            self.presentViewController(introView!, animated: true, completion: nil)
        }
        if ((indexPath.section == 1) && (indexPath.row == 2)){
            let activityViewController = UIActivityViewController(
                activityItems: [NSURL(string: "http://gpaddy.com/home.html")!],
                applicationActivities: nil)
            self.presentViewController(activityViewController, animated: true, completion: nil)
        }
        if ((indexPath.section == 1) && (indexPath.row == 3)){
            UIApplication.sharedApplication().openURL(NSURL(string : "http://gpaddy.com/home.html")!)
        }
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
