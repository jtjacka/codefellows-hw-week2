//
//  ViewController.swift
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

import UIKit
import Parse

class PhotoEditorViewController : UIViewController {
  
  @IBOutlet weak var mainImage: UIImageView!
  @IBOutlet weak var actionButton: UIButton!
  @IBOutlet weak var collectionViewConstraint: NSLayoutConstraint!
  @IBOutlet weak var collectionView: UICollectionView!

    var thumbnail : UIImage?
  
  
  var originalImage : UIImage! {
    didSet {
      displayImage = originalImage
      thumbnail = ImageResizer.resizeImage(displayImage)
      collectionView.reloadData()
    }
  }
  
    var displayImage : UIImage! {
        didSet {
            mainImage.image = displayImage
        }
    }
  
  let imagePicker = UIImagePickerController()
  
  let filterFunctions = [FilterService.applyBWEffect, FilterService.applyChromeEffect, FilterService.applyNoirEffect, FilterService.applySepiaFilter, FilterService.applyVibranceFilter, FilterService.applyVignetteEffect, FilterService.applyVintageEffect, FilterService.applyHefeEffect]
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    
    imagePicker.delegate = self
    imagePicker.allowsEditing = true
    collectionView.dataSource = self
    collectionView.delegate = self
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
      self.goToFilterMode()
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
    
    //Popover for iPad
    action.modalPresentationStyle = UIModalPresentationStyle.Popover
    
    if let popover = action.popoverPresentationController {
      popover.sourceView = view
      popover.sourceRect = actionButton.frame
    }

    
    //Present the Alert Controller
    self.presentViewController(action, animated: true, completion: nil)
    
  }
  
  func goToFilterMode() {
    //Collection View Constraint
    collectionViewConstraint.constant = 0
    
    UIView.animateWithDuration(0.5) { () -> Void in
      self.view.layoutIfNeeded()
    }
    
    let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "exitFilterMode")
    navigationItem.rightBarButtonItem = doneButton
    navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    
  }
  
  func exitFilterMode() {
    println("Exit filter mode")
    
    navigationItem.rightBarButtonItem = nil
    
    collectionViewConstraint.constant = -100
    UIView.animateWithDuration(0.3) { () -> Void in
      self.view.layoutIfNeeded()
    }
    
  }
  
}

extension PhotoEditorViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  //
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
    let image = (info[UIImagePickerControllerEditedImage] as? UIImage)!
    originalImage = image
    imagePicker.dismissViewControllerAnimated(true, completion: nil)
    
    goToFilterMode()
    
  }
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    println("Image Picker Canceled")
    self.imagePicker.dismissViewControllerAnimated(true, completion: nil)
  }
  
}

//Extend and subclass PhotoEditorViewController
extension PhotoEditorViewController : UICollectionViewDataSource {
  
  //Code borrowed from
  //http://www.raywenderlich.com/78550/beginning-ios-collection-views-swift-part-1
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return filterFunctions.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FilterCell", forIndexPath: indexPath) as! FilterCell
    cell.filterName?.text = "Filter"
    
    let filterFunction = filterFunctions[indexPath.row]
    
    if let image = thumbnail {
      filterFunction(image, completion: { (filteredImage, filterName) -> Void in
        cell.filterPreview?.image = filteredImage
        cell.filterName?.text = filterName
      })
    }

    // Configure the cell
    return cell
  }
  
}

extension PhotoEditorViewController : UICollectionViewDelegate {
  
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    let filter = filterFunctions[indexPath.row]
    
    if let image = originalImage {
      filter(image, completion: { (filteredImage, name) -> Void in
        self.displayImage = filteredImage
      })
    }

  
  }
  
}


