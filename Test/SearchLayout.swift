//
//  SearchLayout.swift
//  Test
//
//  Created by Bathanti on 8/26/17.
//  Copyright © 2017 Bathanti. All rights reserved.
//

import UIKit

class SearchLayout: UIViewController {

   
    @IBOutlet weak var searchtext: UITextField!
     var cachevar : NSCache<AnyObject, AnyObject> = NSCache()
    var appdelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    @IBAction func SearchBtn(_ sender: UIButton) {
        
        
        cachevar = appdelegate.cachevar
         appdelegate.searchString = searchtext.text!
            
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
