//
//  ViewController.swift
//  Test
//
//  Created by Bathanti on 8/15/17.
//  Copyright © 2017 Bathanti. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate , UISearchBarDelegate{

    
    
    @IBOutlet weak var SearchStr: UISearchBar!
    
    @IBOutlet weak var tableview: UITableView!
  
    let fh : FlickrHelper = FlickrHelper()
    var PhotosArray : NSMutableArray = NSMutableArray()
    var cachevar : NSCache<AnyObject, AnyObject>?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self 
        tableview.dataSource = self
        SearchStr.delegate = self
        self.cachevar = NSCache()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func SearchBTN(_ sender: UIButton) {
        guard  let str = SearchStr.text else { print("please type anything");  return}
        print(str)
        if self.cachevar?.object(forKey: str as AnyObject) != nil{
            print("*************It was cached before***********")
            PhotosArray = (self.cachevar?.object(forKey: str as AnyObject))! as! NSMutableArray
            DispatchQueue.main.async {
                self.tableview.reloadData()
            }
        }
        else{
            DispatchQueue.global(qos: .userInteractive).async {
                self.PhotosArray =   self.fh.getimages(txt_ownr:str ,check: true)
                print("It wasn't cached before and we download it from scratch !!!!!! ")
                self.cachevar?.setObject(self.PhotosArray, forKey: str as AnyObject)
                 print(self.PhotosArray.count)
                DispatchQueue.main.async {
                    self.tableview.reloadData()
                }
            }
           
       
        }
       
      
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PhotosArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cells", for: indexPath) as! CustomCell
      let  FlickObj = PhotosArray[indexPath.row] as! FlickrPhoto
        cell.LabelCell.text = FlickObj.Title
        
        cell.ImageCell.image = FlickObj.ImageFlick
        
        
       
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let obj = PhotosArray[indexPath.row] as! FlickrPhoto
        let own = obj.Owner
        
        performSegue(withIdentifier: "segID", sender: own)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! UserTableViewController
        dest.owner = sender as! String
    }
    }

