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
  class func uploadImageToParse(image : UIImage, comment : String, completion:(result : String) -> Void){
    //TODO: Optimize Photo Size Here
    
    //Taken mostly from Parse Documentation
    let imageData = UIImagePNGRepresentation(image)
    let imageFile = PFFile(name: "testphoto.png", data: imageData)
    
    var userPhoto = PFObject(className:"UserPhoto")
    userPhoto["imageName"] = "TestPhoto!"
    userPhoto["imageFile"] = imageFile
    userPhoto["comment"] = comment
    
    userPhoto.saveInBackgroundWithBlock { (result, error) -> Void in
      if let error = error {
        completion(result: "error : \(error)")
      } else {
        completion(result: "Object uploaded!")
      }
    }
    
    
    
  }
  
    //Download Images from Parse for use in time
    //Completion with a tuple, why not?
  class func downloadImagesFromParse(completion:(imagesFromParse : [(UIImage, String)]?) -> Void) {
    let query = PFQuery(className: "UserPhoto")
    
    var imagesFromQuery : [(UIImage, String)] = []
    
    
    //Taken from Lecture
    query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
      if let error = error {
        println(error.localizedDescription)
        completion(imagesFromParse: nil)
      } else if let images = results as? [PFObject] {
        println("Images received: \(images.count)")
        for image in images {
          if let imageFile = image["imageFile"] as? PFFile,
            comment = image["comment"] as? String{
            imageFile.getDataInBackgroundWithBlock({ (data, error) -> Void in
              if let error = error {
                println(error.localizedDescription)
              } else if let data = data,
                image = UIImage(data: data) {
                    imagesFromQuery.append(image, comment)
                    completion(imagesFromParse: imagesFromQuery)
              }
            })
          }
        }
        
      }
    }
  }
}
