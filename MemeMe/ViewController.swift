//
//  ViewController.swift
//  MemeMe
//
//  Created by Troy Tobin on 21/04/2015.
//  Copyright (c) 2015 ttobin. All rights reserved.
//

import UIKit
import MobileCoreServices

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UIToolbarDelegate {

  @IBOutlet weak var ImageView: UIImageView!
  @IBOutlet weak var TopTextField: UITextField!
  @IBOutlet weak var BottomTextField: UITextField!
  var ImageSelected: Bool = false
  
  @IBOutlet weak var Toolbar: UIToolbar!
  
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    BottomTextField.hidden = true
    TopTextField.hidden = true
    // Subscribe to keyboard notifications to allow the view to raise when necessary
    self.subscribeToKeyboardNotifications()
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "rotated", name: UIDeviceOrientationDidChangeNotification, object: nil)

    BottomTextField.delegate = self
    TopTextField.delegate = self
    // Do any additional setup after loading the view, typically from a nib.
 }
  
  override func viewDidAppear(animated: Bool)
  {
    TopTextField.text = "Enter Meme Text"
    BottomTextField.text = "Enter Meme Text"
    rotated()
    if (!ImageSelected)
    {
      BottomTextField.hidden = true
      TopTextField.hidden = true
    }
    else
    {
      
      BottomTextField.hidden = false
      TopTextField.hidden = false
    }
  
  }
  
  
  func rotated()
  {
    if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation))
    {
      let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 30)!,
        NSStrokeWidthAttributeName : -3.0
      ]
      
      BottomTextField.defaultTextAttributes = memeTextAttributes
      TopTextField.defaultTextAttributes = memeTextAttributes
      BottomTextField.textAlignment = .Center
      TopTextField.textAlignment = .Center
    }
    
    if(UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation))
    {
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
    }
    print(BottomTextField.defaultTextAttributes)
    
  }
  
  // Unsubscribe
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    self.unsubscribeFromKeyboardNotifications()
  }
  
  func subscribeToKeyboardNotifications() {
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
  }
  
  
  func unsubscribeFromKeyboardNotifications() {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  func keyboardWillShow(notification: NSNotification) {
    if BottomTextField.isFirstResponder() {
      self.view.frame.origin.y = -getKeyboardHeight(notification)
    }
  }
  
  func keyboardWillHide(notification: NSNotification) {
    if BottomTextField.isFirstResponder() {
      self.view.frame.origin.y = 0
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
  
  @IBAction func CancelMeme(sender: AnyObject) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func ShareMeme(sender: AnyObject)
  {
    var NewMeme = Meme(topText:TopTextField.text, bottomText:BottomTextField.text, image:ImageView.image!, memedImage:GenerateMemeImage())
    let activityController = UIActivityViewController(activityItems: [NewMeme.MemedImage], applicationActivities: nil)
    
    activityController.completionWithItemsHandler = {
      activity, completed, returned, error in
      // Allows meme to be saved if activity is completed.
      if completed {
        self.dismissViewControllerAnimated(true, completion: nil)
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(NewMeme)
        print("in share meme -> number of memes ");
        println(appDelegate.memes.count)
      }
    }
    self.presentViewController(activityController, animated: true, completion: nil)
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
  }
  
  func GenerateMemeImage() -> UIImage!
  {
    // Hide the toolbar
    Toolbar.hidden = true;
    self.navigationController?.setNavigationBarHidden(true, animated: false)
    
    // Render view to an image
    UIGraphicsBeginImageContext(self.view.frame.size)
    self.view.drawViewHierarchyInRect(self.view.frame,
                                      afterScreenUpdates: true)
    let memedImage : UIImage =
    UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    // Un-hide the toolbar.
    Toolbar.hidden = false;
    self.navigationController?.setNavigationBarHidden(false, animated: false)
    
    return memedImage
    
  }
}

