//
//  PhotosCollectionViewController.swift
//  Test
//
//  Created by Bathanti on 8/25/17.
//  Copyright © 2017 Bathanti. All rights reserved.
//

import UIKit






class PhotosCollectionViewController: UICollectionViewController {
    //for pagination
    var isDataLoading = false
    var page :Int = 1
    //end
    var searchtext : String!
    var cachevar : NSCache<AnyObject, AnyObject>!
    var indicator : UIActivityIndicatorView = UIActivityIndicatorView()
    let fh : FlickrHelper = FlickrHelper()
    var PhotosArr : NSMutableArray = NSMutableArray()
    var finished : Bool!
    var appdelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        finished = true
        let layout = collectionViewLayout as! FlickrCollectionViewCell
        layout.delegate = self as! FlickrLayoutDelegate
        layout.numberOfColumns = 2
    }
    
    func activityIndicator() {
        
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        indicator.center = self.view.center
        self.view.addSubview(indicator)
    }
    @IBOutlet var collectionview: UICollectionView!
    override func viewWillAppear(_ animated: Bool) {
        activityIndicator()
        indicator.startAnimating()
        indicator.backgroundColor = UIColor.white
        PhotosArr = []
        collectionview.reloadData()
        page = 1
        searchtext = appdelegate.searchString
        cachevar = appdelegate.cachevar
        guard  let str = searchtext else { print("please type anything");  return}
        print(str)
        let pageskey = "\(str)pages"
        if self.cachevar.object(forKey: str as AnyObject) != nil{
            print("*************It was cached before***********")
            PhotosArr = (self.cachevar.object(forKey: str as AnyObject))! as! NSMutableArray
            
            DispatchQueue.main.async {
                self.collectionview.reloadData()
                self.indicator.stopAnimating()
                self.indicator.hidesWhenStopped = true
            }
        }
        else{
            DispatchQueue.global(qos: .userInteractive).async {
                self.PhotosArr  = self.fh.getimages(txt_ownr:str ,check: true,pages: 1)
                print("It wasn't cached before and we download it from scratch !!!!!! ")
                
                self.cachevar.setObject(self.PhotosArr, forKey: str as AnyObject)
                self.cachevar.setObject(self.page as! AnyObject , forKey: pageskey as AnyObject)
                print(self.PhotosArr.count)
                DispatchQueue.main.async {
                    self.collectionview.reloadData()
                    self.indicator.stopAnimating()
                    self.indicator.hidesWhenStopped = true
                }
            }
            
            
        }
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        let numofcells = PhotosArr.count + 1
        print(numofcells)
        return numofcells
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       // print("entered here ??? ")
        if indexPath.item <= PhotosArr.count - 1  {
        //    print(indexPath.item)
            let  cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
            
            
            
            let flickobj = PhotosArr[indexPath.row] as! FlickrPhoto
            
            cell.imageview.image = flickobj.ImageFlick
            
            let myattribute = [NSFontAttributeName : UIFont(name: "Chalkduster", size: 18.0 )!,NSForegroundColorAttributeName  : UIColor.white]
            let str = NSMutableAttributedString(string :flickobj.Title,attributes : myattribute )
            cell.labeltxt.attributedText = str
            cell.backgroundColor = UIColor.black
            return cell
        }
        else{
          //  print ("entered else ")
            let  cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "loadercell", for: indexPath) as! LoadingCollectionViewCell
            cell2.awakeFromNib()
            return cell2
        }
        
        
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.item + 1 == PhotosArr.count
        {
            let str = self.searchtext
            let pageskey = "\(str!)pages"
           
            
            if self.finished{
                self.finished = false
            print ("number of page is before caching \(page)")
            DispatchQueue.global(qos: .userInteractive).async {
                let p = (self.cachevar.object(forKey: pageskey as AnyObject)) as! Int
                print("pages was cached before that ")
                self.page = p + 1
                self.cachevar.setObject(self.page as! AnyObject , forKey: pageskey as AnyObject)
                print ("number of page is after caching \(self.page)")
                self.PhotosArr.addObjects(from: self.fh.getimages(txt_ownr: str!,check: true,pages: self.page) as! [Any])
                print(self.PhotosArr.count)
                
                DispatchQueue.main.async {
                    self.collectionview.reloadData()
                   self.finished = true
                }
            
            }
                
                
            }
            
            
            
            
        }
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let flickobj = PhotosArr[indexPath.row] as! FlickrPhoto
        let owner = flickobj.Owner
        performSegue(withIdentifier: "collectionseqID", sender: owner)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nav = segue.destination as! UINavigationController
        let dest = nav.viewControllers.first! as! UserTableViewController
        dest.owner = sender as! String
    }
}

extension PhotosCollectionViewController : FlickrLayoutDelegate
{
    func collectionView(collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:NSIndexPath) -> CGFloat
    {
        var height : CGFloat! = 0
        if indexPath.row <= PhotosArr.count - 1{
            let flickobj = self.PhotosArr[indexPath.row] as! FlickrPhoto
            height = CGFloat(flickobj.Height)
            
            return   height
        }
        else{
            return height + 100
        }
    }
    func collectionView(collectionView: UICollectionView,
                        heightForAnnotationAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
        
        return 100
    }
    
    
    
    
    
    
    
}












