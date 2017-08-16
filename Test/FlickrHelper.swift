//
//  FlickrHelper.swift
//  Test
//
//  Created by Bathanti on 8/15/17.
//  Copyright © 2017 Bathanti. All rights reserved.
//

import UIKit

class FlickrHelper : NSObject {
    
    
    func getUrl(text : String) -> URLComponents
    {
        var component = URLComponents()
        component.host="api.flickr.com"
        component.path="/services/rest"
        component.scheme = "https"
        component.queryItems=[URLQueryItem]()
        
        
        let q1 = URLQueryItem(name : "method",value : "flickr.photos.search")
        let q2 = URLQueryItem(name : "api_key",value : "f6738329744e8a24a79ae57f6de986c6")
        let q3 = URLQueryItem(name : "text",value : text)
        let q4 = URLQueryItem(name : "extras",value : "url_m")
        let q5 = URLQueryItem(name : "per_page",value : "20")
        let q6 = URLQueryItem(name : "format",value : "json")
        let q7 = URLQueryItem(name : "nojsoncallback",value : "1")
        
        
            component.queryItems?.append(q1)
            component.queryItems?.append(q2)
            component.queryItems?.append(q3)
            component.queryItems?.append(q4)
            component.queryItems?.append(q5)
            component.queryItems?.append(q6)
            component.queryItems?.append(q7)
        print("Component !!!!!!!!!!!!!!!! \(component.url!)")
        return component
        
    }
    
    
    
     func getimages(search : String) -> NSMutableArray
    {
        
        let flickerphotos : NSMutableArray = NSMutableArray()
        do{
            
            let component = getUrl(text : search)
           let  StringJSONResult = try String.init(contentsOf: component.url!, encoding: String.Encoding.utf8)
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
