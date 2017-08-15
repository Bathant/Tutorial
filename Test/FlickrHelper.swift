//
//  FlickrHelper.swift
//  Test
//
//  Created by Bathanti on 8/15/17.
//  Copyright © 2017 Bathanti. All rights reserved.
//

import UIKit

class FlickrHelper : NSObject {
     func getimages(search : String) -> NSMutableArray
    {
         let flickerphotos : NSMutableArray = NSMutableArray()
        let APIkey = "f6738329744e8a24a79ae57f6de986c6"
      let  ApiRequestURL =  "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(APIkey)&text=\(search)&extras=url_m&per_page=20&format=json&nojsoncallback=1"
        let url : URL = URL(string : ApiRequestURL)!
        let StringJSONResult: String
        do{
             StringJSONResult = try String.init(contentsOf: url, encoding: String.Encoding.utf8)
            print(StringJSONResult)
            //convert StringJSONResult into data to get  real json
            let data = StringJSONResult.data(using: String.Encoding.utf8, allowLossyConversion: false)
            
            
            let parsedData : [String : AnyObject]!
            do{
                parsedData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String : AnyObject]
                print(parsedData)
                let dic = parsedData["photos"]
                let photoarray = dic?["photo"] as! [[String : AnyObject]]
                print(photoarray)
               
                print(photoarray.count)
                for photo in photoarray
                {
                    let FP : FlickrPhoto = FlickrPhoto()
                    FP.Title = photo["title"] as! String
                    FP.Owner = photo["owner"] as! String
                    let str = photo["url_m"] as! String
                    let Imageurl = URL(string : str)!
                    do{
                    let imagedata = try Data.init(contentsOf: Imageurl)
                        let image = UIImage(data : imagedata)
                        FP.ImageFlick = image!
                        flickerphotos.add(FP)
                        
                        
                        
                    }
                    catch
                    {
                        print("Couldn't get Image From URL ")
                    }
                    
        
                }
            }catch _
            {
                print("can't serialze json data ")
                
            }
            }
            
        catch{
            print("couldn't find the content of url ")
            
        }
        
    
       
        
        
        
        
        print(flickerphotos.count)
         return flickerphotos
    }
   
   

}
