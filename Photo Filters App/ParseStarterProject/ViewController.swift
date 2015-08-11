//
//  ViewController.swift
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {
  
  @IBOutlet weak var mainImage: UIImageView!
  
  let imagePicker = UIImagePickerController()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    let testObject = PFObject(className: "TestObject")
    testObject["foo"] = "bar"
    testObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
      println("Object has been saved.")
    }
    
    
    self.imagePicker.delegate = self
    
  }
  
  
  
  @IBAction func buttonClicked(sender: AnyObject) {
    var action  = UIAlertController(title: "Choose Image", message: "Choose an image or select a filter", preferredStyle: .ActionSheet)
    
    let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {action -> Void in
      println("User canceled")
    }
    
    let choseImage = UIAlertAction(title: "Use Image from Library", style: UIAlertActionStyle.Default) { (action) -> Void in
      println("Choose Image")
      
      //Call Image Picker Controller
      self.imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
      self.presentViewController(self.imagePicker, animated: true, completion: nil)
      
    }
    
    let takePicture = UIAlertAction(title: "Take Photo", style: UIAlertActionStyle.Default) { (action) -> Void in
      println("Taking a picture")
      
      self.imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
      self.presentViewController(self.imagePicker, animated: true, completion: nil)
    }
    
    let applyFilter = UIAlertAction(title: "Choose Filter", style: UIAlertActionStyle.Default) { (action) -> Void in
      self.filterAlert()
    }
    
    let uploadToParse = UIAlertAction(title: "Upload to Parse", style: UIAlertActionStyle.Default) { (action) -> Void in
     //probably do something
      if let image = self.mainImage.image {
        ParseService.uploadImageToParse(image, completion: { (result) -> Void in
          println("\(result)")
        })
      }
    }
    
    
    
    //Logic for when to display actions
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
      action.addAction(takePicture)
    }
    
    
    if let image = self.mainImage.image {
      action.addAction(applyFilter)
      action.addAction(uploadToParse)
    }
    
    
    
    //Add Actions
    action.addAction(cancel)
    action.addAction(choseImage)
    
    //Present the Alert Controller
    self.presentViewController(action, animated: true, completion: nil)
    
  }
  
  func filterAlert() {
    var action = UIAlertController(title: "Choose Filter", message: "Choose a filter to apply to the image", preferredStyle: .ActionSheet)
    
    let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {action -> Void in
      println("User canceled")
    }
    
    let sepiaFilter = UIAlertAction(title: "Sepia", style: UIAlertActionStyle.Default) { (action) -> Void in
      if let mainImage = self.mainImage.image {
        FilterService.applySepiaFilter(mainImage, completion: { (filteredImage) -> Void in
          self.mainImage.image = filteredImage
        })
      }
      
      
    }
    
    let vibranceFilter = UIAlertAction(title: "Vibrance", style: UIAlertActionStyle.Default) { (action) -> Void in
      if let mainImage = self.mainImage.image {
        FilterService.applyVibranceFilter(mainImage, completion: { (filteredImage) -> Void in
          self.mainImage.image = filteredImage
        })
      }
      
    }
    
    let colorCubeFilter = UIAlertAction(title: "Color Cube", style: UIAlertActionStyle.Default) { (action) -> Void in
      if let mainImage = self.mainImage.image {
        FilterService.applyColorCubeFilter(mainImage, completion: { (filteredImage) -> Void in
          self.mainImage.image = filteredImage
        })
      }
      
    }
    
    
    action.addAction(cancel)
    action.addAction(sepiaFilter)
    action.addAction(vibranceFilter)
    action.addAction(colorCubeFilter)
    
    
    //Present Filter Alert
    self.presentViewController(action, animated: true, completion: nil)
  }
  
}

extension ViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  //
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
    let image = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
    self.mainImage.image = image
    self.imagePicker.dismissViewControllerAnimated(true, completion: nil)
    
  }
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    println("Image Picker Canceled")
    self.imagePicker.dismissViewControllerAnimated(true, completion: nil)
  }
  
}

