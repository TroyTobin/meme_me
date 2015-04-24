//
//  ViewController.swift
//  MemeMe
//
//  Created by Troy Tobin on 21/04/2015.
//  Copyright (c) 2015 ttobin. All rights reserved.
//

import UIKit
import MobileCoreServices

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

  @IBOutlet weak var ImageView: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  @IBAction func OpenAlbum(sender: AnyObject) {
    var ImagePicker = UIImagePickerController()
    ImagePicker.delegate = self
    ImagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
    self.presentViewController(ImagePicker, animated: true, completion: nil)
  }
  
  
  @IBAction func OpenCamera(sender: AnyObject) {
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
      var ImagePicker = UIImagePickerController()
      ImagePicker.sourceType = UIImagePickerControllerSourceType.Camera
      ImagePicker.mediaTypes = [kUTTypeImage]
      ImagePicker.allowsEditing = false
      self.presentViewController(ImagePicker, animated: true, completion: nil)
    }
  }
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
    self.dismissViewControllerAnimated(true, completion: nil)
    ImageView.image = image
    
  }

}

