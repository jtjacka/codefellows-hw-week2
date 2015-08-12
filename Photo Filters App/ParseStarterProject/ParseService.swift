//
//  ParseService.swift
//  ParseStarterProject
//
//  Created by Jeffrey Jacka on 8/11/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class ParseService {
  class func uploadImageToParse(image : UIImage, completion:(result : String) -> Void){
    //TODO: Optimize Photo Size Here
    
    //Taken mostly from Parse Documentation
    let imageData = UIImagePNGRepresentation(image)
    let imageFile = PFFile(name: "testphoto.png", data: imageData)
    
    var userPhoto = PFObject(className:"UserPhoto")
    userPhoto["imageName"] = "TestPhoto!"
    userPhoto["imageFile"] = imageFile
    
    userPhoto.saveInBackgroundWithBlock { (result, error) -> Void in
      if let error = error {
        completion(result: "error : \(error)")
      } else {
        completion(result: "Object uploaded!")
      }
    }
    
    
    
  }
  
  class func downloadImagesFromParse() {
    
  }
  
}
