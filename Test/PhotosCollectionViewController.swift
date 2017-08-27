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
    var PhotosArray : NSMutableArray = NSMutableArray()
    var appdelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        PhotosArray = []
        collectionview.reloadData()
        page = 1
        searchtext = appdelegate.searchString
        cachevar = appdelegate.cachevar
        guard  let str = searchtext else { print("please type anything");  return}
        print(str)
        let pageskey = "\(str)pages"
        if self.cachevar.object(forKey: str as AnyObject) != nil{
            print("*************It was cached before***********")
            PhotosArray = (self.cachevar.object(forKey: str as AnyObject))! as! NSMutableArray
            
            DispatchQueue.main.async {
                self.collectionview.reloadData()
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
        return PhotosArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        let flickobj = PhotosArray[indexPath.row] as! FlickrPhoto
        cell.imageview.image = flickobj.ImageFlick
        
        let myattribute = [NSFontAttributeName : UIFont(name: "Chalkduster", size: 18.0 )!,NSForegroundColorAttributeName  : UIColor.white]
        let str = NSMutableAttributedString(string :flickobj.Title,attributes : myattribute )
        cell.labeltxt.attributedText = str
        cell.backgroundColor = UIColor.black
        
        // Configure the cell
    
        return cell
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.isDataLoading = false
        print("scrollViewWillBeginDragging")
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        print("scrollViewDidEndDragging")
        
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
        {
            if !isDataLoading{
                
                
                
                isDataLoading = true
                if  let str = self.searchtext{
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
                    self.PhotosArray.addObjects(from: self.fh.getimages(txt_ownr: str,check: true,pages: page) as! [Any])
                    print(self.PhotosArray.count)
                    print("pages >>> \(page)")
                    self.collectionview.reloadData()
                    
                }
                
                
                
                
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let flickobj = PhotosArray[indexPath.row] as! FlickrPhoto
        let owner = flickobj.Owner
        performSegue(withIdentifier: "collectionseqID", sender: owner)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! UserTableViewController
        dest.owner = sender as! String
    }
}
    extension PhotosCollectionViewController : FlickrLayoutDelegate
    {
        func collectionView(collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:NSIndexPath) -> CGFloat
        {
            
            let flickobj = PhotosArray[indexPath.row] as! FlickrPhoto
            
            return   CGFloat(flickobj.Height)
        }
        func collectionView(collectionView: UICollectionView,
                            heightForAnnotationAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
            let annotationPadding = CGFloat(4)
            let annotationHeaderHeight = CGFloat(17)
            let height = annotationPadding + annotationHeaderHeight  + annotationPadding
            
           
            return height
        }
        
        
        
        
        
        
        
    }












