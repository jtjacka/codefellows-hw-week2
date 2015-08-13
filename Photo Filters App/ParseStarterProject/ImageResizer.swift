//
//  ImageResizer.swift
//  ParseStarterProject
//
//  Created by Jeffrey Jacka on 8/12/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

//Code from Week 1 Project and NSHipster

import UIKit
import ImageIO

class ImageResizer {
  class func resizeImage(image : UIImage) -> UIImage {
    var size : CGSize
    
    //Pick Screen Size
    switch UIScreen.mainScreen().scale {
    case 2:
      size = CGSize(width: 160, height: 160)
    case 3:
      size = CGSize(width: 240, height: 240)
    default:
      size = CGSize(width: 80, height: 80)
    }
    
    UIGraphicsBeginImageContext(size)
    image.drawInRect(CGRect(x: 0, y: 0, width: size.width, height: size.height))
    let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return resizedImage
  }
  
//  class func resizeImageIO(image: UIImage) -> UIImage {
//    
//
//    if let image = CGImageCreateWithJPEGDataProvider(image, decode: nil, shouldInterpolate: true, intent: CGColorRenderingIntent) {
//      let options: CFDictionary = [
//        kCGImageSourceThumbnailMaxPixelSize: max(size.width, size.height) / 2.0,
//        kCGImageSourceCreateThumbnailFromImageIfAbsent: true
//      ]
//      
//      return CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options).flatMap
//    }
//  }
}
