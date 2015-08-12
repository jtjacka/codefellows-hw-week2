//
//  FilterService.swift
//  ParseStarterProject
//
//  Created by Jeffrey Jacka on 8/10/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit

class FilterService {
  class func setUpFilter(filterName : String, image: UIImage) -> UIImage? {
    let image = CIImage(image: image)
    let filter = CIFilter(name: filterName)
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
  
  class func applySepiaFilter(image : UIImage, completion: (filteredImage : UIImage?) -> Void){
    let filterName = "CISepiaTone"
    
    if let finalImage = self.setUpFilter(filterName, image: image) {
      completion(filteredImage: finalImage)
    }
  }
  
  class func applyVibranceFilter(image : UIImage, completion: (filteredImage : UIImage?) -> Void) {
    let filterName = "CIPhotoEffectMono"
    
    if let finalImage = self.setUpFilter(filterName, image: image) {
      completion(filteredImage: finalImage)
    }
    
  }
  
  class func applyColorCubeFilter(image : UIImage, completion: (filteredImage : UIImage?) -> Void){
    let filterName = "CIPhotoEffectTransfer"
    
    if let finalImage = self.setUpFilter(filterName, image: image) {
      completion(filteredImage: finalImage)
    }
  }
}