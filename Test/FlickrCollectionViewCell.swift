//
//  FlickrCollectionViewCell.swift
//  Test
//
//  Created by Bathanti on 8/25/17.
//  Copyright © 2017 Bathanti. All rights reserved.
//

import UIKit
protocol FlickrLayoutDelegate {
    // 1 height of photo
func collectionView(collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:NSIndexPath) -> CGFloat
    func collectionView(collectionView : UICollectionView, heightForAnnotationAtIndexPath indexpath: NSIndexPath , withWidth: CGFloat) -> CGFloat
   
}
class FlickrCollectionViewCell: UICollectionViewLayout {
    
    // 1 refernce to delegate
    var delegate: FlickrLayoutDelegate!
    
    // 2 number of columns and cell padding
    var numberOfColumns = 1
    var cellpadding:CGFloat  = 6.0
    
    // 3 this array is used to cache the calculated attribute 
    private var cache = [UICollectionViewLayoutAttributes]()
    
    // 4
    private var contentHeight: CGFloat  = 0.0
    private var contentWidth: CGFloat {
        let inset = collectionView!.contentInset
    return collectionView!.bounds.width - (inset.left+inset.right)
    }
    
    
    
    override func prepare() {
        // 1
       
            // 2
            let columnWidth = contentWidth / CGFloat(numberOfColumns)
            var xOffset = [CGFloat]()
            for column in 0 ..< numberOfColumns {
                xOffset.append(CGFloat(column) * columnWidth )
            }
            var column = 0
            var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
            
            // 3
            for item in 0 ..< collectionView!.numberOfItems(inSection: 0) {
                
                let indexPath = NSIndexPath.init(item: item, section: 0)
                
                // 4
              let width = columnWidth - cellpadding*2
                let Photoheight = delegate.collectionView(collectionView: collectionView!, heightForPhotoAtIndexPath: indexPath)
               let annotaionheight = delegate.collectionView(collectionView: collectionView!, heightForAnnotationAtIndexPath: indexPath, withWidth: width)
                let height = cellpadding*2 + Photoheight + annotaionheight
                let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
              let frameInset = frame.insetBy(dx: cellpadding,dy: cellpadding)
                
                // 5
                let attributes = UICollectionViewLayoutAttributes.init(forCellWith: indexPath as IndexPath)
                attributes.frame = frameInset
                cache.append(attributes)
                
                // 6
                contentHeight = max(contentHeight, frame.maxY)
                yOffset[column] = yOffset[column] + height
                
               if column >= (numberOfColumns - 1) {column =  0} else{ column += 1}
            }
        
    }
    override var collectionViewContentSize: CGSize{
        return CGSize(width: contentWidth,height: contentHeight)
    }
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
   
    
}
