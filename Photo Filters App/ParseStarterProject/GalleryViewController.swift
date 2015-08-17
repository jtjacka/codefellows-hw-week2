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
  var thumbnailSize = CGSize(width: 200, height: 200)
  var targetImageSize = CGSize(width: 600, height: 600)
  weak var delegate : ImageSelectedDelegate?
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      //Fetch PHAsset Array from Photos Framework - Taken from Lecture
      fetchResult = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: nil)


      collectionView.dataSource = self
      collectionView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    options.normalizedCropRect = CGRect(x: 0, y: 0, width: 600, height: 600)
    options.resizeMode = PHImageRequestOptionsResizeMode.Exact
    
    if let asset = fetchResult[indexPath.row] as? PHAsset {
      PHCachingImageManager.defaultManager().requestImageForAsset(asset, targetSize: targetImageSize, contentMode: .AspectFill, options: options, resultHandler: { (returnImage, info) -> Void in
        self.delegate?.controllerDidSelectImage(returnImage)
        self.navigationController?.popViewControllerAnimated(true)
      })
    }
  }
}
