//
//  FlickrHelper.swift
//  Test
//
//  Created by Bathanti on 8/15/17.
//  Copyright © 2017 Bathanti. All rights reserved.
//

import UIKit

class FlickrHelper : NSObject {
    
    
    func getUrl(txt_ownr : String,check : Bool ,page : Int) -> URLComponents
    {
        var component = URLComponents()
        component.host="api.flickr.com"
        component.path="/services/rest"
        component.scheme = "https"
        component.queryItems=[URLQueryItem]()
        
        
        let q1 = URLQueryItem(name : "method",value : "flickr.photos.search")
        let q2 = URLQueryItem(name : "api_key",value : "f6738329744e8a24a79ae57f6de986c6")
        let q3 : URLQueryItem
        if check==true{
         q3 = URLQueryItem(name : "text",value : txt_ownr)
        }else
        {
            q3 = URLQueryItem(name : "user_id",value : txt_ownr)
        }
        let q4 = URLQueryItem(name : "extras",value : "url_m")
        let q5 = URLQueryItem(name : "per_page",value : "5")
        let q6 = URLQueryItem(name : "format",value : "json")
        let q7 = URLQueryItem(name : "nojsoncallback",value : "1")
        let q8 = URLQueryItem(name : "page",value : String(page))

        
            component.queryItems?.append(q1)
            component.queryItems?.append(q2)
            component.queryItems?.append(q3)
            component.queryItems?.append(q4)
            component.queryItems?.append(q5)
            component.queryItems?.append(q6)
            component.queryItems?.append(q7)
        component.queryItems?.append(q8)
        print("Component !!!!!!!!!!!!!!!! \(component.url!)")
        return component
        
    }
    
    
    
    func getimages(txt_ownr : String , check : Bool ,pages : Int) -> NSMutableArray
    {
        
        let flickerphotos : NSMutableArray = NSMutableArray()
        do{
            
            let component = getUrl(txt_ownr: txt_ownr, check: check, page: pages)
           let  StringJSONResult = try String.init(contentsOf: component.url!, encoding: String.Encoding.utf8)
            print(StringJSONResult)
            //convert StringJSONResult into data to get  real json
            let data = StringJSONResult.data(using: String.Encoding.utf8, allowLossyConversion: false)
            
            
            let parsedData : [String : AnyObject]!
            do{
                parsedData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String : AnyObject]
                print(parsedData)
                let dic = parsedData["photos"]
                let max_pages = dic?["pages"] as! Int
                print(max_pages)
                if(max_pages < pages){
                    print("we can't produce more than that !!")
                }
                else {
                let photoarray = dic?["photo"] as! [[String : AnyObject]]
                print(photoarray)
               
                print(photoarray.count)
                for photo in photoarray
                {
                    let FP : FlickrPhoto = FlickrPhoto()
                    FP.Title = photo["title"] as! String
                    FP.Owner = photo["owner"] as! String
                    guard   let str = photo["url_m"] as? String else{print("there's no url :( "); continue}
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
