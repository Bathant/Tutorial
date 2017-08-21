//
//  UserTableViewController.swift
//  Test
//
//  Created by Bathanti on 8/16/17.
//  Copyright © 2017 Bathanti. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {
    
    
    @IBOutlet var viewtable: UITableView!
    
    var owner : String?
    var PhotosArray : NSMutableArray = NSMutableArray()
    let fh : FlickrHelper = FlickrHelper()
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.global(qos: .userInteractive).async {
            self.PhotosArray = self.fh.getimages(txt_ownr: self.owner!,check: false,pages: 1)
            DispatchQueue.main.async {
                self.viewtable.reloadData()
            }

        }
                   }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return PhotosArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cel", for: indexPath) as! CustomCell
        let  FlickObj = PhotosArray[indexPath.row] as! FlickrPhoto
        cell.LabelCell.text = FlickObj.Title
        
        cell.ImageCell.image = FlickObj.ImageFlick
        
        
        
        return cell

    }



}
