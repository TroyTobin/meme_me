//
//  ViewController.swift
//  MemeMe
//
//  Created by Troy Tobin on 21/04/2015.
//  Copyright (c) 2015 ttobin. All rights reserved.
//

import UIKit
import MobileCoreServices

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {

  @IBOutlet weak var ImageView: UIImageView!
  @IBOutlet weak var TopTextField: UITextField!
  @IBOutlet weak var BottomTextField: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    // Subscribe to keyboard notifications to allow the view to raise when necessary
    self.subscribeToKeyboardNotifications()
    BottomTextField.delegate = self
    TopTextField.delegate = self
  }
  
  func subscribeToKeyboardNotifications() {
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
  }
  
  func keyboardWillShow(notification: NSNotification) {
    if BottomTextField.isFirstResponder() {
      self.view.frame.origin.y -= getKeyboardHeight(notification)
    }
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    if BottomTextField.isFirstResponder() {
      self.view.frame.origin.y = 0
    }
    self.view.endEditing(true)
    return true
  }
  
  func getKeyboardHeight(notification: NSNotification) -> CGFloat {
    let userInfo = notification.userInfo
    let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
    return keyboardSize.CGRectValue().height
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

