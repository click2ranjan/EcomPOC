//
//  Productpage.swift
//  EcomPOC
//
//  Created by Ranjan Mallick on 07/12/17.
//  Copyright © 2017 Ranjan Mallick. All rights reserved.
//

import UIKit

class Productpage: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var productcount: UILabel!
    @IBOutlet weak var catname: UILabel!
    @IBOutlet weak var mytableview: UITableView!
    var sectionDateArray = NSMutableArray()
    var CatgoryName = String()
    var CatID = Int()
    var MostOption = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(self.CatgoryName)
        print(self.CatID)
        
        self.title = self.CatgoryName
        self.webServiceMethod(category: CatID)
        
        
        
        
        
        //myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "myCell")
        
        //self.view.addSubview(myTableView)
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.sectionDateArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = mytableview.dequeueReusableCell(withIdentifier: "productcellid", for: indexPath as IndexPath) as! productcell
        
        let searchDetailsDict : NSDictionary = self.sectionDateArray.object(at: indexPath.row) as! NSDictionary
        
        //let searchDetailsDict1 : NSDictionary = searchDetailsDict.value(forKey: "products") as! NSDictionary
        
        cell.lbl_ProductName.text = searchDetailsDict.value(forKey: "name") as! String
        //cell.lbl_cardNumber.text = searchDetailsDict.value(forKey: "id") as! String
        
        return cell
    }
    
    
    
    
    @IBAction func btn_backClicked(_ sender: Any)
    {
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath)
    {
        //print("User selected table row \(indexPath.row) and item \(itemsToLoad[indexPath.row])")
        
    }
    
    
    func webServiceMethod(category:Int) -> Void
    {
        
        
        
        self.sectionDateArray = SQLiteManager.sharedManager.getDataFromProduct(category: category)
        print(self.sectionDateArray)
        self.mytableview.dataSource = self
        self.mytableview.delegate = self
        self.mytableview.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}



