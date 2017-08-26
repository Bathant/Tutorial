//
//  PhotosCollectionViewController.swift
//  Test
//
//  Created by Bathanti on 8/25/17.
//  Copyright © 2017 Bathanti. All rights reserved.
//

import UIKit


class PhotosCollectionViewController: UICollectionViewController {
    let fh : FlickrHelper = FlickrHelper()
    var PhotosArray : NSMutableArray = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.PhotosArray = self.fh.getimages(txt_ownr:"Forest" ,check: true,pages: 1)
        
        let layout = collectionViewLayout as! FlickrCollectionViewCell
        layout.delegate = self as! FlickrLayoutDelegate
        layout.numberOfColumns = 2
       

       
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
        
    
        // Configure the cell
    
        return cell
    }

}
    extension PhotosCollectionViewController : FlickrLayoutDelegate
    {
        func collectionView(collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:NSIndexPath) -> CGFloat
        {
             let flickobj = PhotosArray[indexPath.row] as! FlickrPhoto
            return   CGFloat(flickobj.Height)
        }
    }
    


