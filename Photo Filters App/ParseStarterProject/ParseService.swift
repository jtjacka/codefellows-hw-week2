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
    
    var userPhoto = PFObject(className:"Image")
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
  
  class func downloadImagesFromParse(completion:(imagesFromParse : [UIImage]) -> Void) {
    let query = PFQuery(className: "Image")
    
    var imagesFromQuery : [UIImage] = []
    
    query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
      if let error = error {
        println(error.localizedDescription)
      } else if let images = results as? [PFObject] {
        println("Images received: \(images.count)")
        for image in images {
          if let imageFile = image["image"] as? PFFile {
            imageFile.getDataInBackgroundWithBlock({ (data, error) -> Void in
              if let error = error {
                println(error.localizedDescription)
              } else if let data = data,
                image = UIImage(data: data) {
                  imagesFromQuery.append(image)
              }
            })
          }
        }
        //Send Images Array Back to the View Controller
        completion(imagesFromParse: imagesFromQuery)
      }
    }
  }
}
