//
//  ViewController.swift
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

import UIKit
import Parse



class PhotoEditorViewController : UIViewController {
  
  //Outlets
  @IBOutlet weak var editorControls: UIView!
  @IBOutlet weak var mainImage: UIImageView!
  @IBOutlet weak var actionButton: UIButton!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var editorViewConstraint: NSLayoutConstraint!
  @IBOutlet weak var uploadCloudButton: UIButton!
  @IBOutlet weak var useCameraButton: UIButton!
  @IBOutlet weak var selectFromGalleryButton: UIButton!
  @IBOutlet weak var commentField: UITextField!
  @IBOutlet weak var editorSlider: UISlider!
  @IBOutlet weak var editButton: UIButton!

  //Properties
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
  
  //Constants
  let kAnimationDuration = 0.3
  let kEditorViewHidden : CGFloat = -100
  let kEditorViewShow : CGFloat = 0
  
  
  let imagePicker = UIImagePickerController()
  
  //Array of all functions from Filter Service
  let filterFunctions = [FilterService.applyBWEffect, FilterService.applyChromeEffect, FilterService.applyNoirEffect, FilterService.applySepiaFilter, FilterService.applyVibranceFilter, FilterService.applyVignetteEffect, FilterService.applyVintageEffect, FilterService.applyHefeEffect]
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //Register Notification Observers for Keyboard
    //Code borrowed from http://stackoverflow.com/questions/25693130/move-textfield-when-keyboard-appears-swift
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWasShown:"), name:UIKeyboardWillShowNotification, object: nil);
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardHasHidden:"), name:UIKeyboardWillHideNotification, object: nil);
    
    //Hide Elements for Editor Mode
    commentField.hidden = true
    editorSlider.hidden = true
    

    imagePicker.delegate = self
    imagePicker.allowsEditing = true
    collectionView.dataSource = self
    collectionView.delegate = self
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "showGallery" {
      if let galleryViewController = segue.destinationViewController as? GalleryViewController {
        galleryViewController.delegate = self
      }
    }
  }
  
  //MARK: Camera Action
  @IBAction func useCamera(sender: AnyObject) {
    self.imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
    self.presentViewController(self.imagePicker, animated: true, completion: nil)
  }
  
  //MARK: Choose Image From Gallery
  @IBAction func imageFromGallery(sender: AnyObject) {
    self.performSegueWithIdentifier("showGallery", sender: self)
  }
  
  //MARK: Upload Image to Parse
  @IBAction func uploadToParse(sender: AnyObject) {
    if let image = self.mainImage.image {
      if commentField.hasText() {
        ParseService.uploadImageToParse(image, comment: commentField.text, completion: { (result) -> Void in
          println("\(result)")
        })
      } else {
        ParseService.uploadImageToParse(image, comment: "No Comment!", completion: { (result) -> Void in
          println("\(result)")
        })
      }

    }
  }
  
  //MARK: Enter Edit Mode Through Button
  @IBAction func editButtonAction(sender: AnyObject) {
    goToFilterMode()
  }
  
  //MARK: Enter Filter Mode
  func goToFilterMode() {
    //Collection View Constraint
    editorViewConstraint.constant = kEditorViewShow
    
    //Disable Some Buttons
    uploadCloudButton.enabled = false
    useCameraButton.enabled = false
    selectFromGalleryButton.enabled = false
    editButton.hidden = true
    
    //Enable Comment Field
    commentField.hidden = false
    commentField.enabled = true
    
    UIView.animateWithDuration(0.3) { () -> Void in
      self.view.layoutIfNeeded()
    }
    
    let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "exitFilterMode")
    navigationItem.rightBarButtonItem = doneButton
    navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    
  }
  
  //MARK: Exit Filter Mode
  func exitFilterMode() {
    println("Exit filter mode")
    
    //Re-enable Buttons
    uploadCloudButton.enabled = true
    useCameraButton.enabled = true
    selectFromGalleryButton.enabled = true
    editButton.hidden = false
    
    //Enable Comment Field
    commentField.enabled = false
    commentField.hidden = true
    
    navigationItem.rightBarButtonItem = nil
    
    editorViewConstraint.constant = kEditorViewHidden
    UIView.animateWithDuration(kAnimationDuration) { () -> Void in
      self.view.layoutIfNeeded()
    }
    
  }
  
  //MARK: Keyboard will show
  //Code borrowed from http://stackoverflow.com/questions/25693130/move-textfield-when-keyboard-appears-swift
  func keyboardWasShown(notification: NSNotification) {
    var info = notification.userInfo!
    var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
    
    UIView.animateWithDuration(kAnimationDuration, animations: { () -> Void in
      self.editorViewConstraint.constant = keyboardFrame.size.height
    })
  }
  
  //MARK: Keyboard will hide
  func keyboardHasHidden(notification: NSNotification) {
    var info = notification.userInfo!
    var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
    
    UIView.animateWithDuration(kAnimationDuration, animations: { () -> Void in
      self.editorViewConstraint.constant = self.kEditorViewShow
    })
  }
  
}

//MARK: Image Picker
extension PhotoEditorViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
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

//MARK: Extend UICollectionViewDataSource
//Extend and subclass PhotoEditorViewController
extension PhotoEditorViewController : UICollectionViewDataSource {
  
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

//MARK: Extend UICollectionViewDelegate
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

//MARK: Extend ImageSelectedDelegate
extension PhotoEditorViewController : ImageSelectedDelegate {
  func controllerDidSelectImage(receivedImage : UIImage) {
    
    println("Received Image : \(receivedImage.size)")
    self.originalImage = receivedImage
    
    goToFilterMode()
  }
}


