//
//  FilterService.swift
//  ParseStarterProject
//
//  Created by Jeffrey Jacka on 8/10/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit

class FilterService {
  private class func setUpFilter(filterName : String, parameters : [NSObject : AnyObject]?,  image : UIImage) -> UIImage? {
    let image = CIImage(image: image)
    let filter : CIFilter
    if let parameters = parameters {
      filter = CIFilter(name: filterName, withInputParameters: parameters)
    } else {
      filter = CIFilter(name: filterName)
    }
    
    filter.setValue(image, forKey: kCIInputImageKey)
    
    //gpu context
    //copied from lecture
    let options = [kCIContextWorkingColorSpace : NSNull()]
    let eaglContext = EAGLContext(API: EAGLRenderingAPI.OpenGLES2)
    let gpuContext = CIContext(EAGLContext: eaglContext, options: options)
    
    //More from Lecture
    //Get final Image using GPU Rendering
    let outputImage = filter.outputImage
    let extent = outputImage.extent()
    let cgImage = gpuContext.createCGImage(outputImage, fromRect: extent)
    if let finalImage = UIImage(CGImage: cgImage) {
      return finalImage
    } else {
      return nil
    }
  }
  
  class func applySepiaFilter(image : UIImage, completion: (filteredImage : UIImage?, name: String) -> Void){
    let filterName = "CISepiaTone"
    let displayName = "Sepia"
    
    if let finalImage = self.setUpFilter(filterName, parameters: nil, image: image) {
      completion(filteredImage: finalImage, name: displayName)
    }
  }
  
  class func applyVibranceFilter(image : UIImage, completion: (filteredImage : UIImage?, name: String) -> Void) {
    let filterName = "CIVibrance"
    let displayName = "Vibrance"
    
    let parameter = ["inputAmount" : 1.0]
    
    if let finalImage = self.setUpFilter(filterName, parameters : parameter, image: image) {
      completion(filteredImage: finalImage, name: displayName)
    }
    
  }
  
  class func applyVintageEffect(image : UIImage, completion: (filteredImage : UIImage?, name: String) -> Void){
    let filterName = "CIPhotoEffectTransfer"
    let displayName = "Vintage"
    
    if let finalImage = self.setUpFilter(filterName, parameters: nil, image: image) {
      completion(filteredImage: finalImage, name: displayName)
    }
  }
  
  class func applyBWEffect(image : UIImage, completion: (filteredImage : UIImage?, name: String) -> Void){
    let filterName = "CIPhotoEffectMono"
    let displayName = "B&W"
    
    if let finalImage = self.setUpFilter(filterName, parameters: nil, image: image) {
      completion(filteredImage: finalImage, name: displayName)
    }
  }
  
  class func applyNoirEffect(image : UIImage, completion: (filteredImage : UIImage?, name: String) -> Void){
    let filterName = "CIPhotoEffectNoir"
    let displayName = "Noir"
    
    if let finalImage = self.setUpFilter(filterName, parameters: nil, image: image) {
      completion(filteredImage: finalImage, name: displayName)
    }
  }
  
  class func applyChromeEffect(image : UIImage, completion: (filteredImage : UIImage?, name: String) -> Void){
    let filterName = "CIPhotoEffectChrome"
    let displayName = "Chrome"
    
    if let finalImage = self.setUpFilter(filterName, parameters: nil, image: image) {
      completion(filteredImage: finalImage, name: displayName)
    }
  }
  
  class func applyVignetteEffect(image : UIImage, completion: (filteredImage : UIImage?, name: String) -> Void){
    let filterName = "CIVignette"
    let displayName = "Vignette"
    
    let parameters = ["inputIntensity" : 1]
    
    if let finalImage = self.setUpFilter(filterName, parameters: parameters, image: image) {
      completion(filteredImage: finalImage, name: displayName)
    }
  }

  
}