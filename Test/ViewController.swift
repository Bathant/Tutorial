//
//  ViewController.swift
//  Test
//
//  Created by Bathanti on 8/15/17.
//  Copyright © 2017 Bathanti. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate , UISearchBarDelegate,UIScrollViewDelegate , UITabBarDelegate {

    
    
    
    //for pagination 
    var isDataLoading = false
    var page :Int = 1
    //end
    
    var searchstring : String!
    var cachevar : NSCache<AnyObject, AnyObject>!
    
    
    @IBOutlet weak var tableview: UITableView!
    var indicator : UIActivityIndicatorView = UIActivityIndicatorView()
    let fh : FlickrHelper = FlickrHelper()
    var PhotosArray : NSMutableArray = NSMutableArray()
    var appdelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("<<<<<<<<<<<<<<<<<<<<<< view did load called >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
        tableview.delegate = self 
        tableview.dataSource = self
        //this makes the cells have no lines when the array is empty
        tableview.tableFooterView = UIView(frame : .zero)
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        activityIndicator()
        indicator.startAnimating()
        indicator.backgroundColor = UIColor.white
        PhotosArray = []
        tableview.reloadData()
        page = 1
        cachevar = appdelegate.cachevar
        searchstring = appdelegate.searchString
        guard  let str = searchstring else { print("please type anything");  return}
        print(str)
        let pageskey = "\(str)pages"
        if self.cachevar.object(forKey: str as AnyObject) != nil{
            print("*************It was cached before***********")
            PhotosArray = (self.cachevar.object(forKey: str as AnyObject))! as! NSMutableArray
            
            DispatchQueue.main.async {
                self.tableview.reloadData()
                self.indicator.stopAnimating()
                self.indicator.hidesWhenStopped = true
            }
        }
        else{
            DispatchQueue.global(qos: .userInteractive).async {
                self.PhotosArray =   self.fh.getimages(txt_ownr:str ,check: true,pages: 1)
                print("It wasn't cached before and we download it from scratch !!!!!! ")
                
                self.cachevar.setObject(self.PhotosArray, forKey: str as AnyObject)
                self.cachevar.setObject(self.page as! AnyObject , forKey: pageskey as AnyObject)
                print(self.PhotosArray.count)
                DispatchQueue.main.async {
                    self.tableview.reloadData()
                    self.indicator.stopAnimating()
                    self.indicator.hidesWhenStopped = true
                }
            }
            
            
        }

    }
    func activityIndicator() {
        
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        indicator.center = self.view.center
        self.view.addSubview(indicator)
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
   

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
            // print("this is the last cell")
            let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
            
            self.tableview.tableFooterView = spinner
            self.tableview.tableFooterView?.isHidden = false
            let str = self.searchstring
            let pageskey = "\(str)pages"
            if let  p = (self.cachevar.object(forKey: pageskey as AnyObject)) as? Int
            {
                print("pages was cached before that ")
                page = p + 1
                self.cachevar.setObject(self.page as! AnyObject , forKey: pageskey as AnyObject)
            }
            else{
                page += 1
            }

            
            DispatchQueue.global(qos: .userInteractive).async {
                self.PhotosArray.addObjects(from: self.fh.getimages(txt_ownr: str!,check: true,pages: self.page) as! [Any])
                print(self.PhotosArray.count)
                DispatchQueue.main.async {
                    self.tableview.reloadData()
                    spinner.stopAnimating()
                    spinner.hidesWhenStopped = true
                }
            }
            
            
            
            
        }
    }


}
