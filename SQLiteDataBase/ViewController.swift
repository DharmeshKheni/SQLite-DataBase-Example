//
//  ViewController.swift
//  SQLiteDataBase
//
//  Created by Anil on 02/02/15.
//  Copyright (c) 2015 Variya Soft Solutions. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var status: UILabel!
    var databasePath = NSString()
    override func viewDidLoad() {
        super.viewDidLoad()

        let filemgr = NSFileManager.defaultManager()
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        
        let docsDir = dirPaths[0] as String
        databasePath = docsDir.stringByAppendingPathComponent("contacts.db")
        
        if  !filemgr.fileExistsAtPath(databasePath){
            
            let contactDB = FMDatabase(path: databasePath)
            
            if contactDB == nil{
                
                println("Error: \(contactDB.lastErrorMessage())")
            }
            
            if contactDB.open(){
                
                let sql_stmt = "CREATE TABLE IF NOT EXISTS CONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, ADDRESS TEXT, PHONE TEXT)"
                if !contactDB.executeStatements(sql_stmt){
                    
                    println("Error: \(contactDB.lastErrorMessage())")
                }
                contactDB.close()
            }else{
                
                println("Error: \(contactDB.lastErrorMessage())")
            }
        }
    }
    
    @IBAction func saveData(sender: AnyObject) {
        
        let contactDB = FMDatabase(path: databasePath)
        if contactDB.open(){
            
            var insertSQL = "INSERT INTO CONTACTS (name, address, phone) VALUES ('\(name.text)', '\(address.text)', '\(phone.text)')"
            let result = contactDB.executeUpdate(insertSQL, withArgumentsInArray: nil)
            
            if !result{
                
                status.text = "Failed to add contact"
                println("Error: \(contactDB.lastErrorMessage())")
            }else{
                
                status.text = "Contact Added"
                name.text = ""
                address.text = ""
                phone.text = ""
            }
        }else{
            
            println("Error: \(contactDB.lastErrorMessage())")
        }
    }
    
    @IBAction func findContact(sender: AnyObject) {
        
        let contactDB = FMDatabase(path: databasePath)
        if contactDB.open() {
            let querySQL = "SELECT address, phone FROM CONTACTS WHERE name = '\(name.text)'"
            
            let results:FMResultSet? = contactDB.executeQuery(querySQL, withArgumentsInArray: nil)
            
            if results?.next() == true {
                address.text = results?.stringForColumn("address")
                phone.text = results?.stringForColumn("phone")
                status.text = "Record Found"
            } else {
                status.text = "Record not found"
                address.text = ""
                phone.text = ""
            }
            contactDB.close()
        } else {
            println("Error: \(contactDB.lastErrorMessage())")
        }
    }

}

