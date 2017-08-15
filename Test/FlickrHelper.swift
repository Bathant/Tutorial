//
//  FlickrHelper.swift
//  Test
//
//  Created by Bathanti on 8/15/17.
//  Copyright © 2017 Bathanti. All rights reserved.
//

import UIKit

class FlickrHelper : NSObject {
     func getimages(search : String)
    {
        let APIkey = "f6738329744e8a24a79ae57f6de986c6"
      let  ApiRequestURL =  "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(APIkey)&text=\(search)&extras=url_m&format=json&nojsoncallback=1"
        let url : URL = URL(string : ApiRequestURL)!
        let StringJSONResult: String
        do{
             StringJSONResult = try String.init(contentsOf: url, encoding: String.Encoding.utf8)
            print(StringJSONResult)
            
            }
            
        catch{
            print("couldn't find the content of url ")
            return
        }
        
        //convert StringJSONResult into data to get  real json
        let data = StringJSONResult.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        
        let parsedData : [String : AnyObject]!
        do{
        parsedData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String : AnyObject]
                }catch _
                {
                    print("can't serialze json data ")
                    return
                }
        print(parsedData)
        
        let dic = parsedData["Photos"] as! [[String: AnyObject]]
        
        
        
        
        
        
        
    }
   
    

}
