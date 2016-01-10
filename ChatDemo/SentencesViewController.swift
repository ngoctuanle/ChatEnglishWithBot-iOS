//
//  SentencesViewController.swift
//  ChatDemo
//
//  Created by Tuan Le on 11/29/15.
//  Copyright © 2015 Tuan Le. All rights reserved.
//

import UIKit

class SentencesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var tabelView: UITableView!
    
    var id:[String]!
    var enSen:[String]!
    var viSen:[String]!
    var img:[String]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        id = []; enSen = []; viSen = []; img = []
        
        let database: COpaquePointer = connectdb("comsentences", type: "sqlite")
        let statement:COpaquePointer = db_select("SELECT * FROM category", database: database)
        while sqlite3_step(statement) == SQLITE_ROW {
            let rowid = sqlite3_column_text(statement, 0)
            let dataid = String.fromCString(UnsafePointer<CChar>(rowid))
            id.append(dataid!)
            
            let rowen = sqlite3_column_text(statement, 1)
            let dataen = String.fromCString(UnsafePointer<CChar>(rowen))
            enSen.append(dataen!)
            
            let rowvi = sqlite3_column_text(statement, 2)
            let datavi = String.fromCString(UnsafePointer<CChar>(rowvi))
            viSen.append(datavi!)
            
            let rowimg = sqlite3_column_text(statement, 3)
            let dataimg = String.fromCString(UnsafePointer<CChar>(rowimg))
            img.append(dataimg!)
        }
        sqlite3_finalize(statement)
        sqlite3_close(database)
        self.tabelView.delegate = self
        self.tabelView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.tintColor = nil
        self.title = "Common Sentences"
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return enSen.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tabelView.deselectRowAtIndexPath(indexPath, animated: true)
        let storyBroad = UIStoryboard(name: "Main", bundle: nil)
        let CourseView = storyBroad.instantiateViewControllerWithIdentifier("CourseView") as! CourseViewController
        var color: String! = "000000"
        switch("\(indexPath.row)"){
        case "0":
            color = "8ddb37"
            break
        case "1":
            color = "107ee0"
            break
        case "2":
            color = "64a81d"
            break
        case "3":
            color = "9c27b0"
            break
        case "4":
            color = "8d8d8d"
            break
        case "5":
            color = "f06493"
            break
        case "6":
            color = "a629e5"
            break
        case "7":
            color = "0277bd"
            break
        case "8":
            color = "2e7d32"
            break
        case "9":
            color = "e4dc9e"
            break
        case "10":
            color = "e91e63"
            break
        case "11":
            color = "006064"
            break
        case "12":
            color = "0f54ef"
            break
        case "13":
            color = "64a81d"
            break
        case "14":
            color = "0e9971"
            break
        case "15":
            color = "9c27b0"
            break
        case "16":
            color = "f44336"
            break
        case "17":
            color = "e91e63"
            break
        case "18":
            color = "006064"
            break
        case "19":
            color = "107ee0"
            break
        case "20":
            color = "107ee0"
            break
        case "21":
            color = "9c27b0"
            break
        case "22":
            color = "2e7d32"
            break
        case "23":
            color = "0f54ef"
            break
        default: break
        }
        CourseView.id_cate = id[indexPath.row]
        CourseView.color = color
        CourseView.category = enSen[indexPath.row]
        self.navigationController?.pushViewController(CourseView, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tabelView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! SentencesTableViewCell
        cell.img.image = UIImage(named: img[indexPath.row])
        cell.enLabel.text = enSen[indexPath.row]
        cell.viLabel.text = viSen[indexPath.row]
        return cell
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
