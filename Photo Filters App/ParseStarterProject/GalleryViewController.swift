//
//  GalleryViewController.swift
//  
//
//  Created by Jeffrey Jacka on 8/13/15.
//
//

import UIKit
import Photos

//TODO - Declare protocol here
protocol ImageSelectedDelegate : class {
  func controllerDidSelectImage(UIImage) -> ()
}

class GalleryViewController: UIViewController {

  //Outlets
  @IBOutlet var collectionView: UICollectionView!
  
  //Properties
  var fetchResult : PHFetchResult!
  var thumbnailSize = CGSize(width: 400, height: 400)
  weak var delegate : ImageSelectedDelegate?
  var startingScale : CGFloat = 0
  var scale : CGFloat = 1
  var targetImageSize = CGSize(width: 600, height: 600)
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      //Fetch PHAsset Array from Photos Framework - Taken from Lecture
      fetchResult = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: nil)

      
      //Create Gesture Recognizer
      //Taken from lecture
      let pinchGesture = UIPinchGestureRecognizer(target: self, action: "pinchRecognized:")
      collectionView.addGestureRecognizer(pinchGesture)

      collectionView.dataSource = self
      collectionView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  
  //MARK: Use Gesture Recognizer to Resize
  //Code borrowed from lecture
  func pinchRecognized(pinch : UIPinchGestureRecognizer) {
    //println(pinch.scale)
    
    if pinch.state == UIGestureRecognizerState.Began {
      println("began!")
      startingScale = pinch.scale
    }
    
    if pinch.state == UIGestureRecognizerState.Changed {
      println("changed!")
    }
    
    if pinch.state == UIGestureRecognizerState.Ended {
      println("ended!")
      scale = startingScale * pinch.scale
      let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
      let newSize = CGSize(width: layout.itemSize.width * scale, height: layout.itemSize.height * scale)
      
      collectionView.performBatchUpdates({ () -> Void in
        layout.itemSize = newSize
        layout.invalidateLayout()
        }, completion: nil )
      
    }
  }


}


//MARK: Extend UICollectionView Datasource
extension GalleryViewController : UICollectionViewDataSource {
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return fetchResult.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("GalleryCell", forIndexPath: indexPath) as! GalleryCell
    
    if let asset = fetchResult[indexPath.row] as? PHAsset {
      PHCachingImageManager.defaultManager().requestImageForAsset(asset, targetSize: thumbnailSize, contentMode: PHImageContentMode.AspectFit, options: nil, resultHandler: { (returnImage, info) -> Void in
        
        if let image =  returnImage {
          cell.cellImage.image = image
        }
        
      })
    }
    
    
    return cell
  }
}

//MARK: Extend UICollectionViewDelegate
extension GalleryViewController : UICollectionViewDelegate {
  
  
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    
    var options = PHImageRequestOptions()
    options.synchronous = true
    options.normalizedCropRect = CGRect(x: 0, y: 0, width: 600*scale, height: 600*scale)
    options.resizeMode = PHImageRequestOptionsResizeMode.Exact
    
    if let asset = fetchResult[indexPath.row] as? PHAsset {
      PHCachingImageManager.defaultManager().requestImageForAsset(asset, targetSize: targetImageSize, contentMode: .AspectFill, options: options, resultHandler: { (returnImage, info) -> Void in
        self.delegate?.controllerDidSelectImage(returnImage)
        self.navigationController?.popViewControllerAnimated(true)
      })
    }
  }
}
