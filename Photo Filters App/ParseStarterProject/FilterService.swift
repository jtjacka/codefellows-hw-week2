//
//  FilterService.swift
//  ParseStarterProject
//
//  Created by Jeffrey Jacka on 8/10/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit

class FilterService {
  class func applySepiaFilter(image : UIImage, completion: (filteredImage : UIImage?) -> Void){
    let image = CIImage(image: image)
    let sepiaFilter = CIFilter(name: "CISepiaTone")
    sepiaFilter.setValue(image, forKey: kCIInputImageKey)
    
    
    //gpu context
    //copied from lecture
    let options = [kCIContextWorkingColorSpace : NSNull()]
    let eaglContext = EAGLContext(API: EAGLRenderingAPI.OpenGLES2)
    let gpuContext = CIContext(EAGLContext: eaglContext, options: options)
    
    //More from Lecture
    //Get final Image using GPU Rendering
    let outputImage = sepiaFilter.outputImage
    let extent = outputImage.extent()
    let cgImage = gpuContext.createCGImage(outputImage, fromRect: extent)
    if let finalImage = UIImage(CGImage: cgImage) {
      completion(filteredImage: finalImage)
    }
  }
  
  class func applyVibranceFilter(image : UIImage, completion: (filteredImage : UIImage?) -> Void) {
    let image = CIImage(image: image)
    let vibranceFilter = CIFilter(name: "CIPhotoEffectMono")
    vibranceFilter.setValue(image, forKey: kCIInputImageKey)
    
    
    //gpu context
    //copied from lecture
    let options = [kCIContextWorkingColorSpace : NSNull()]
    let eaglContext = EAGLContext(API: EAGLRenderingAPI.OpenGLES2)
    let gpuContext = CIContext(EAGLContext: eaglContext, options: options)
    
    //More from Lecture
    //Get final Image using GPU Rendering
    let outputImage = vibranceFilter.outputImage
    let extent = outputImage.extent()
    let cgImage = gpuContext.createCGImage(outputImage, fromRect: extent)
    if let finalImage = UIImage(CGImage: cgImage) {
      completion(filteredImage: finalImage)
    }
  }
  
  class func applyColorCubeFilter(image : UIImage, completion: (filteredImage : UIImage?) -> Void){
    let image = CIImage(image: image)
    let colorCube = CIFilter(name: "CIPhotoEffectTransfer")
    colorCube.setValue(image, forKey: kCIInputImageKey)
    
    
    //gpu context
    //copied from lecture
    let options = [kCIContextWorkingColorSpace : NSNull()]
    let eaglContext = EAGLContext(API: EAGLRenderingAPI.OpenGLES2)
    let gpuContext = CIContext(EAGLContext: eaglContext, options: options)
    
    //More from Lecture
    //Get final Image using GPU Rendering
    let outputImage = colorCube.outputImage
    let extent = outputImage.extent()
    let cgImage = gpuContext.createCGImage(outputImage, fromRect: extent)
    if let finalImage = UIImage(CGImage: cgImage) {
      completion(filteredImage: finalImage)
    }
  }
  
}