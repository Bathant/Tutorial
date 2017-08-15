//
//  ViewController.swift
//  Test
//
//  Created by Bathanti on 8/15/17.
//  Copyright © 2017 Bathanti. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,UITableViewDataSource,UIWebViewDelegate{

    @IBOutlet weak var viewTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cells", for: indexPath) as! CustomCell
        cell.LabelCell.text = "What !! "
        cell.ImageCell.image = UIImage(named: "images.jpeg")
        
       
        return cell
    }

}

