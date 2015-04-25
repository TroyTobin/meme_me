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
  var ImageSelected: Bool = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    // Subscribe to keyboard notifications to allow the view to raise when necessary
    self.subscribeToKeyboardNotifications()
    BottomTextField.delegate = self
    TopTextField.delegate = self
    // Do any additional setup after loading the view, typically from a nib.
    let memeTextAttributes = [
      NSStrokeColorAttributeName : UIColor.blackColor(),
      NSForegroundColorAttributeName : UIColor.whiteColor(),
      NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
      NSStrokeWidthAttributeName : -3.0
    ]
    
    BottomTextField.defaultTextAttributes = memeTextAttributes
    TopTextField.defaultTextAttributes = memeTextAttributes
    BottomTextField.textAlignment = .Center
    TopTextField.textAlignment = .Center
    if (!ImageSelected)
    {
      BottomTextField.hidden = true
      TopTextField.hidden = true
    }
 }
  
  // Unsubscribe
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    self.unsubscribeFromKeyboardNotifications()
  }
  
  func subscribeToKeyboardNotifications() {
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
  }
  
  
  func unsubscribeFromKeyboardNotifications() {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  func keyboardWillShow(notification: NSNotification) {
    if BottomTextField.isFirstResponder() {
      self.view.frame.origin.y = -getKeyboardHeight(notification)
      println(self.view.frame.origin.y)
    }
  }
  
  func textFieldDidBeginEditing(textField: UITextField) {
    textField.text = ""
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    if BottomTextField.isFirstResponder() {
      self.view.frame.origin.y = 0
    }
    textField.resignFirstResponder()
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
    ImageSelected = true
    TopTextField.hidden = false
    BottomTextField.hidden = false
  }

}

