//
//  FlickerHelper.swift
//  Test
//
//  Created by Bathanti on 8/15/17.
//  Copyright © 2017 Bathanti. All rights reserved.
//

import UIKit

class FlickerHelper: NSObject {

    class func getImageURL (imgurl: String) -> UIImage
    {
        
        var downloadImage : UIImage?
        let url = URL( string : imgurl)
        
        let task = URLSession.shared.dataTask(with: url!){(data,respnse,error) in
            if error != nil {
                downloadImage = UIImage(data : data!)!
                
            }
        }
        
        task.resume()
        
        
        return downloadImage!
        
        
        
    }

    
    
}
