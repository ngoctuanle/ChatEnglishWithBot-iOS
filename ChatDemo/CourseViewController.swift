//
//  CourseViewController.swift
//  ChatDemo
//
//  Created by Tuan Le on 11/30/15.
//  Copyright © 2015 Tuan Le. All rights reserved.
//

import UIKit
import AVFoundation

class CourseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    var id_cate: String!
    var color: String!
    var category: String!
    var enSen: [String]!
    var viSen: [String]!
    let synth = AVSpeechSynthesizer()

    override func viewDidLoad() {
        super.viewDidLoad()
        enSen = []; viSen = []
        
        let query:String = "SELECT * FROM data WHERE id_cate = " + id_cate
        let database:COpaquePointer = self.connectdb("comsentences", type: "sqlite")
        let statement:COpaquePointer = db_select(query, database: database)
        while sqlite3_step(statement) == SQLITE_ROW{
            
            let rowdata = sqlite3_column_text(statement, 2)
            let cau = String.fromCString(UnsafePointer<CChar>(rowdata))
            enSen.append(cau!)
            
            let rowdata1 = sqlite3_column_text(statement, 3)
            let cau1 = String.fromCString(UnsafePointer<CChar>(rowdata1))
            viSen.append(cau1!)
        }
        sqlite3_finalize(statement)
        sqlite3_close(database)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = UIColor(hex: color)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        self.navigationController?.navigationBar.tintColor = UIColor(hex: "007aff")
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        synth.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return enSen.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 143
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CourseTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.viewCell.backgroundColor = UIColor(hex: color)
        cell.enText.text = "\(indexPath.row+1). \(enSen[indexPath.row].capitalizeFirst)"
        cell.enText.textColor = UIColor.whiteColor()
        cell.enText.font = UIFont.systemFontOfSize(16)
        cell.viText.text = viSen[indexPath.row].capitalizeFirst
        cell.viText.font = UIFont.systemFontOfSize(16)
        
        cell.usButton.tag = indexPath.row
        cell.usButton.addTarget(self, action: #selector(CourseViewController.usVoice(_:)), forControlEvents: .TouchUpInside)
        
        cell.ukButton.tag = indexPath.row
        cell.ukButton.addTarget(self, action: #selector(CourseViewController.ukVoice(_:)), forControlEvents: .TouchUpInside)
        
        cell.copyButton.tag = indexPath.row
        cell.copyButton.addTarget(self, action: #selector(CourseViewController.copySen(_:)), forControlEvents: .TouchUpInside)
        
        return cell
    }
    
    @IBAction func usVoice(sender: UIButton){
        let textString = enSen[sender.tag]
        let myUtterance = AVSpeechUtterance(string: textString)
        myUtterance.voice = AVSpeechSynthesisVoice(language: "en-us")
        let sysver = UIDevice.currentDevice().systemVersion
        if(sysver[sysver.startIndex] != Character("9")){
            myUtterance.rate = AVSpeechUtteranceMinimumSpeechRate
        }else{
            myUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
            print(AVSpeechUtteranceMinimumSpeechRate)
        }
        synth.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
        synth.speakUtterance(myUtterance)
    }
    
    @IBAction func ukVoice(sender: UIButton){
        let textString = enSen[sender.tag]
        let myUtterance = AVSpeechUtterance(string: textString)
        myUtterance.voice = AVSpeechSynthesisVoice(language: "en-gb")
        let sysver = UIDevice.currentDevice().systemVersion
        if(sysver[sysver.startIndex] != Character("9")){
            myUtterance.rate = AVSpeechUtteranceMinimumSpeechRate
        }else{
            myUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
            print(AVSpeechUtteranceMinimumSpeechRate)
        }
        synth.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
        synth.speakUtterance(myUtterance)
    }
    
    @IBAction func copySen(sender: UIButton){
        let textString = enSen[sender.tag]
        UIPasteboard.generalPasteboard().string = textString
        Toast.appearance.blurStyle = .Dark
        Toast.appearance.textColor = UIColor.whiteColor()
        Toast.makeText("Copied to clipbroad!", duration: Toast.LENGTH_LONG).show()
    }
    
    func db_select(query:String, database:COpaquePointer)->COpaquePointer{
        var statement:COpaquePointer = nil
        sqlite3_prepare_v2(database, query, -1, &statement, nil)
        return statement
    }
    
    func connectdb( dbName:String, type:String)->COpaquePointer{
        var database:COpaquePointer = nil
        let dbPath = NSBundle.mainBundle().pathForResource(dbName, ofType:type)
        let result = sqlite3_open(dbPath!, &database)
        if result != SQLITE_OK {
            sqlite3_close(database)
            print("Failed to open database")
        }
        return database
    }
}
