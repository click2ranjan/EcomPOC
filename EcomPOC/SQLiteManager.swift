//
//  SQLiteManager.swift
//  EcomPOC
//
//  Created by Ranjan Mallick on 07/12/17.
//  Copyright © 2017 Ranjan Mallick. All rights reserved.
//

import Foundation

import UIKit

class SQLiteManager: NSObject {
    
    var databasePath = NSString()
    var queue: FMDatabaseQueue?
    var database: FMDatabase? = nil
    
    private override init(){
        super.init()
        createAllTables()
    }
    
    class var sharedManager: SQLiteManager {
        struct Static {
            static let instance = SQLiteManager()
        }
        return Static.instance
    }
    
    //MARK: create table
    
    func createAllTables(){
        
        let filemgr = FileManager.default
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir = dirPaths[0]
        databasePath = (docsDir as NSString).appendingPathComponent("testing.sqlite") as NSString
        print("databasePath: \(databasePath)")
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        print("App Version is \(String(describing: appVersion))")
        
        if !filemgr.fileExists(atPath: databasePath as String) {
            self.createAll(isDataBaseExist: false)
        } else {
            self.createAll(isDataBaseExist: true)
        }
    }
    
   
    
    func insertRanking(rankings:NSArray)->Bool
    {
        
        
        var isInserted = Bool()
        queue?.inDatabase({ (db : FMDatabase!) -> Void in
            
            for i in 0 ..< rankings.count
            {
                
                let dict0 :NSDictionary = rankings.object(at:i) as! NSDictionary
                let rankingsname :String = dict0.value(forKey:"ranking") as! String
                let productslist :NSArray = dict0.value(forKey:"products") as! NSArray
                let rankid = i+1
                if productslist.count > 0
                {
                    isInserted = try! db!.executeUpdate("insert or replace into tblRankings (ID,ranking , products ) VALUES (?,?,?)", withArgumentsIn: [rankid,rankingsname,productslist])
                }
                
                //**********//ID integer, name TEXT, products TEXT , childcategories TEXT
                
            }
        })
        
        return isInserted
    }
    
    
    func insertCategory(category:NSArray)->Bool
    {
        self.createAll(isDataBaseExist: true)
        print(category)
        var isInserted = Bool()
        queue?.inDatabase({ (db : FMDatabase!) -> Void in
            
            for i in 0 ..< category.count
            {
                
                let dict0 :NSDictionary = category.object(at:i) as! NSDictionary
                let Catname :String = dict0.value(forKey:"name") as! String
                let CatID :NSNumber = dict0.value(forKey:"id") as! NSNumber
                
                
                let dict1 :NSArray = dict0.object(forKey:"products") as! NSArray
                let dict2 :NSArray = dict0.object(forKey:"child_categories") as! NSArray
                
                isInserted = try! db!.executeUpdate("insert or replace into tblCategories (ID, name,childcategories) VALUES (?,?,?)", withArgumentsIn: [CatID,Catname,dict2])
                
                if dict1.count > 0
                {
                    for j in 0 ..< dict1.count
                    {
                        
                        let dict3 :NSDictionary = dict1.object(at:j) as! NSDictionary
                        
                        let Productname :String = dict3.value(forKey:"name") as! String
                        let ProductID :NSNumber = dict3.value(forKey:"id") as! NSNumber
                        let dateadded :String = dict3.value(forKey:"date_added") as! String
                        let variants :NSArray = dict3.value(forKey:"variants") as! NSArray
                        let tax :NSDictionary = dict3.value(forKey:"tax") as! NSDictionary
                        
                        //print(dict1)
                        //isInserted = try! db!.executeUpdate("insert or replace into tblCategories (ID, name,products,childcategories) VALUES (?,?,?,?)", withArgumentsIn: [CatID,Catname,dict1,dict2])
                        
                        isInserted = try! db!.executeUpdate("insert or replace into tblProducts (ID, name ,dateadded ,variant ,tax ,catid) VALUES (?,?,?,?,?,?)", withArgumentsIn: [ProductID,Productname,dateadded,variants,tax,CatID])
                        
                        //isInserted = try! db!.executeUpdate("insert or replace into tblRankings (ranking , products ) VALUES (?,?,?,?,?,?)", withArgumentsIn: [ProductID,Productname,dateadded,variants,tax,CatID])
                        
                        
                        print(isInserted)
                    }
                    
                }
                
                //**********//ID integer, name TEXT, products TEXT , childcategories TEXT
                
            }
        })
        
        return isInserted
    }
    //MARK: get data from Payment table
    
    
    func getDataFromMostOptions(option:Int) -> NSMutableArray
    {
        let historyArray = NSMutableArray()
        let historyArray1 = NSMutableArray()
        
        queue?.inDatabase({ (db : FMDatabase!) -> Void in
            
            let resultSet : FMResultSet = (try! db.executeQuery("SELECT * FROM tblproducts  order by id ASC", values: nil))
            
            //yyyy-MM-dd HH:mm:ss
            
            while resultSet.next(){
                
                let historyDict = NSMutableDictionary()
                
                historyDict.setObject(resultSet.string(forColumn: "id")!, forKey: "id" as NSCopying)
                historyDict.setObject(resultSet.string(forColumn: "name")!, forKey: "name" as NSCopying)
                historyDict.setObject(resultSet.string(forColumn: "tax")!, forKey: "tax" as NSCopying)
                historyDict.setObject(resultSet.string(forColumn: "variant")!, forKey: "variant" as NSCopying)
                
                
                historyArray.add(historyDict)
            }
            resultSet.close()
            
        })
        
        
        queue?.inDatabase({ (db : FMDatabase!) -> Void in
            
            let resultSet1 : FMResultSet = (try! db.executeQuery("SELECT * FROM tblRankings  WHERE ID = ?  order by ID ASC", withArgumentsIn:[option]))!
            
            //yyyy-MM-dd HH:mm:ss
            
            while resultSet1.next(){
                
                let historyDict1 = NSMutableDictionary()
                
                historyDict1.setObject(resultSet1.string(forColumn: "ranking")!, forKey: "ranking" as NSCopying)
                historyDict1.setObject(resultSet1.string(forColumn: "products")!, forKey: "products" as NSCopying)
                historyArray1.add(historyDict1)
            }
            resultSet1.close()
            
        })
        
        //        let MProducts = historyArray1.object(at: 0) as! NSMutableDictionary
        //         let MProductsName = MProducts.value(forKey: "ranking") as! String
        //         let MProductsList = historyArray1.value(forKey: "products") as! NSArray
        //
        //        print(MProductsName)
        
        //        let b = historyArray.values.contains { (value) -> Bool in
        //            value as? String == ""
        //        }
        
        
        return historyArray
    }
    
    
    func getDataFromCategory() -> NSMutableArray
    {
        let historyArray = NSMutableArray()
        
        queue?.inDatabase({ (db : FMDatabase!) -> Void in
            
            let resultSet : FMResultSet = (try! db.executeQuery("SELECT * FROM tblCategories  order by id ASC", values: nil))
            
            //yyyy-MM-dd HH:mm:ss
            
            while resultSet.next(){
                
                let historyDict = NSMutableDictionary()
                
                historyDict.setObject(resultSet.string(forColumn: "id")!, forKey: "id" as NSCopying)
                historyDict.setObject(resultSet.string(forColumn: "name")!, forKey: "name" as NSCopying)
                //historyDict.setObject(resultSet.string(forColumn: "products")!, forKey: "products" as NSCopying)
                historyDict.setObject(resultSet.string(forColumn: "childcategories")!, forKey: "child_categories" as NSCopying)
                
                
                historyArray.add(historyDict)
            }
            resultSet.close()
            
        })
        return historyArray
    }
    
    
    func getDataFromProduct(category:Int) -> NSMutableArray
    {
        let historyArray = NSMutableArray()
        
        queue?.inDatabase({ (db : FMDatabase!) -> Void in
            
            let resultSet : FMResultSet = (try! db.executeQuery("SELECT * FROM tblproducts  WHERE catid = ?  order by id ASC", withArgumentsIn:[category]))!
            
            //yyyy-MM-dd HH:mm:ss
            
            while resultSet.next(){
                
                let historyDict = NSMutableDictionary()
                
                historyDict.setObject(resultSet.string(forColumn: "id")!, forKey: "id" as NSCopying)
                historyDict.setObject(resultSet.string(forColumn: "name")!, forKey: "name" as NSCopying)
                historyDict.setObject(resultSet.string(forColumn: "tax")!, forKey: "tax" as NSCopying)
                historyDict.setObject(resultSet.string(forColumn: "variant")!, forKey: "variant" as NSCopying)
                
                
                historyArray.add(historyDict)
            }
            resultSet.close()
            
        })
        return historyArray
    }
    
    @IBAction func btn_MostOptions(_ sender: Any)
    {
        
    }
    
    func createAll(isDataBaseExist:Bool){
        
        queue = FMDatabaseQueue(path: databasePath as String)
        
        queue?.inDatabase({ (db : FMDatabase!) -> Void in
            
            // 01 HISTORY TABLE
            
            print(db.userVersion)
            
            if(isDataBaseExist)
            {
                try! db.executeUpdate("drop table if exists tblCategories",  values: nil)
                try! db.executeUpdate("drop table if exists tblProducts",  values: nil)
                try! db.executeUpdate("drop table if exists tblVariant",  values: nil)
                try! db.executeUpdate("drop table if exists tblRankings",  values: nil)
            }
            
            //if(db .userVersion < 3)
            //{
            
            let sql_stmt = "create table if not exists tblCategories (ID integer, name TEXT, products TEXT , childcategories TEXT) ; create table if not exists tblRankings (ID integer,ranking TEXT , products TEXT) ; create table if not exists tblProducts (ID integer, name TEXT, dateadded TEXT, variant TEXT, tax TEXT, catid integer) ; create table if not exists tblVariant (ID integer, color TEXT, size TEXT , price TEXT)"
            
            db.executeStatements(sql_stmt)
            
            //IF ANY CHANGES IN DB STRUCTURE INCREMENT Pragma user_version BY 1
            
            let sql_stmtPr="Pragma user_version=3"
            try! db.executeUpdate(sql_stmtPr,  values: nil)
            
            print("i m here")
            
            //}
        })
    }
}
