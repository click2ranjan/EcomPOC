//
//  ViewController.swift
//  EcomPOC
//
//  Created by Ranjan Mallick on 07/12/17.
//  Copyright © 2017 Ranjan Mallick. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    
    
    @IBOutlet weak var productcount: UILabel!
    @IBOutlet weak var catname: UILabel!
    
    @IBOutlet weak var mytableview: UITableView!
    var sectionDateArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webServiceMethod()
        
        
        
        
        
        //myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "myCell")
        
        //self.view.addSubview(myTableView)
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.sectionDateArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = mytableview.dequeueReusableCell(withIdentifier: "testcellid", for: indexPath as IndexPath) as! tblcell
        
        let searchDetailsDict : NSDictionary = self.sectionDateArray.object(at: indexPath.row) as! NSDictionary
        
        //let searchDetailsDict1 : NSDictionary = searchDetailsDict.value(forKey: "products") as! NSDictionary
        
        cell.lbl_time.text = searchDetailsDict.value(forKey: "name") as! String
        //cell.lbl_cardNumber.text = searchDetailsDict.value(forKey: "id") as! String
        
        return cell
    }
    
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //print("User selected table row \(indexPath.row) and item \(itemsToLoad[indexPath.row])")
        let searchDetailsDict : NSDictionary = self.sectionDateArray.object(at: indexPath.row) as! NSDictionary
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Productpagevcid") as! Productpage
        vc.CatgoryName = searchDetailsDict.value(forKey: "name") as! String
        let int98: Int = Int(searchDetailsDict.value(forKey: "id") as! String)!
        vc.CatID = int98
        vc.MostOption = 0
        navigationController?.pushViewController(vc,animated: true)
    }
    
    
    func webServiceMethod() -> Void
    {
        
        
        
        request("https://stark-spire-93433.herokuapp.com/json", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON
            {
                (response) in
                
                let JSON = response.result.value
                if JSON != nil
                {
                    
                    let code = response.response?.statusCode
                    var mainDict : Dictionary<String,AnyObject> = JSON as! Dictionary<String, AnyObject>
                    
                    if code == 200
                    {
                        let categories = mainDict["categories"] as! NSArray
                        let rankings = mainDict["rankings"] as! NSArray
                        
                        
                        if(categories.count > 0)
                        {
                            print("Error0")
                            SQLiteManager.sharedManager.insertCategory(category: categories)
                            self.sectionDateArray = SQLiteManager.sharedManager.getDataFromCategory()
                            print(self.sectionDateArray)
                            self.mytableview.dataSource = self
                            self.mytableview.delegate = self
                            self.mytableview.reloadData()
                        }
                        if(rankings.count > 0)
                        {
                            SQLiteManager.sharedManager.insertRanking(rankings: rankings)
                        }
                        else
                        {
                            //    self.view.hideToastActivity()
                            
                            print("Error1")
                            
                            
                        }
                        
                    }
                }
                else
                {
                    print("Error2")
                    
                    
                }
        }
        
    }
    
    @IBAction func btnmordered(_ sender: Any)
    {
        
        let searchDetailsDict : NSMutableArray = SQLiteManager.sharedManager.getDataFromMostOptions(option: 1)
        //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //        let vc = storyboard.instantiateViewController(withIdentifier: "Productpagevcid") as! Productpage
        //        vc.CatgoryName = searchDetailsDict.value(forKey: "name") as! String
        //        let int98: Int = Int(searchDetailsDict.value(forKey: "id") as! String)!
        //        vc.CatID = int98
        //        vc.MostOption = 0
        //        navigationController?.pushViewController(vc,animated: true)
        
    }
    @IBAction func btnmshared(_ sender: Any) {
        
        let searchDetailsDict : NSMutableArray = SQLiteManager.sharedManager.getDataFromMostOptions(option: 2)
        //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //        let vc = storyboard.instantiateViewController(withIdentifier: "Productpagevcid") as! Productpage
        //        vc.CatgoryName = searchDetailsDict.value(forKey: "name") as! String
        //        let int98: Int = Int(searchDetailsDict.value(forKey: "id") as! String)!
        //        vc.CatID = int98
        //        vc.MostOption = 0
        //        navigationController?.pushViewController(vc,animated: true)
    }
    @IBAction func btnmviewed(_ sender: Any) {
        
        let searchDetailsDict : NSMutableArray = SQLiteManager.sharedManager.getDataFromMostOptions(option: 3)
        //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //        let vc = storyboard.instantiateViewController(withIdentifier: "Productpagevcid") as! Productpage
        //        vc.CatgoryName = searchDetailsDict.value(forKey: "name") as! String
        //        let int98: Int = Int(searchDetailsDict.value(forKey: "id") as! String)!
        //        vc.CatID = int98
        //        vc.MostOption = 0
        //        navigationController?.pushViewController(vc,animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

