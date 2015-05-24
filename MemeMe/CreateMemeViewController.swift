//
//  CreateMemeViewController.swift
//  MemeMe
//
//  Created by Troy Tobin on 21/04/2015.
//  Copyright (c) 2015 ttobin. All rights reserved.
//

import UIKit
import MobileCoreServices

/// This class controls the view for creating a meme.
/// NOTE: majority of this code and structure has resulted from
///       completing the "UIKit Fundamentals" Udacity course
class CreateMemeViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UIToolbarDelegate {
  /// Outlets for items in the view
  @IBOutlet weak var ImageView: UIImageView!
  @IBOutlet weak var TopTextField: UITextField!
  @IBOutlet weak var BottomTextField: UITextField!
  @IBOutlet weak var ShareIcon: UIBarButtonItem!
  @IBOutlet weak var CancelIcon: UIBarButtonItem!
  @IBOutlet weak var CameraIcon: UIBarButtonItem!
  @IBOutlet weak var Toolbar: UIToolbar!
  
  /// Flag indicating if an image has been selected
  var ImageSelected: Bool = false
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    /// Set us to be the delegate for the meme text fields
    BottomTextField.delegate = self
    TopTextField.delegate = self
    
    /// If no image has been selected then don't show the meme text fields
    /// and don't show the share icon.
    /// Only show these items if an image has been selected.
    BottomTextField.hidden = !ImageSelected
    TopTextField.hidden    = !ImageSelected
    ShareIcon.enabled      = ImageSelected
    
    /// Subscribe to necessary notifications:
    ///    - Keyboard
    ///    - Screen Rotation
    self.SubscribeToNotifications()
    
    /// Enable/Disable the camera icon depending on whether or not the
    /// hardware supports the camera mode.
    CameraIcon.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
  }
  
  override func viewDidAppear(animated: Bool) {
    /// Set the default text for the Meme text fields
    TopTextField.text = "Enter Meme Text"
    BottomTextField.text = "Enter Meme Text"
    
    /// Configure the text for the current screen orientation
    ScreenRotated()
    
    /// If no image has been selected then don't show the meme text fields
    /// and don't show the share icon.
    /// Only show these items if an image has been selected.
    BottomTextField.hidden = !ImageSelected
    TopTextField.hidden    = !ImageSelected
    ShareIcon.enabled      = ImageSelected
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    self.UnsubscribeFromNotifications()
  }
  
  /// Subscribe to notifications including keyboard show/hide and
  /// screen rotation
  func SubscribeToNotifications() {
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "KeyboardWillShow:", name: UIKeyboardWillShowNotification,object: nil)
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "KeyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "ScreenRotated", name: UIDeviceOrientationDidChangeNotification, object: nil)
  }
  
  /// Unsubscribe from the notifications including keyboard show/hide and
  /// screen rotation
  func UnsubscribeFromNotifications() {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  /// Handle screen rotation event, but adjusting the meme text attributes
  func ScreenRotated() {
    var TextSize: CGFloat = 40.0
    if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation)) {
      /// If in landscape we want the text to be slightly smaller than
      /// when in portrait
      TextSize = 30.0
    }
    
    /// Set the default meme text attributes
    let MemeTextAttributes = [
      NSStrokeColorAttributeName : UIColor.blackColor(),
      NSForegroundColorAttributeName : UIColor.whiteColor(),
      NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: TextSize)!,
      NSStrokeWidthAttributeName : -3.0
    ]
    BottomTextField.defaultTextAttributes = MemeTextAttributes
    TopTextField.defaultTextAttributes = MemeTextAttributes
    
    /// Center the text in each meme text field
    BottomTextField.textAlignment = .Center
    TopTextField.textAlignment = .Center
  }
  
  /// When the keyboard will appear and caused by the bottom text field
  /// we want to move the screen up the same height as the keyboard
  ///
  /// :param: notification The notification causing the method invocation
  func KeyboardWillShow(notification: NSNotification) {
    if BottomTextField.isFirstResponder() {
      /// Offset the view by the same amount as the keyboard height
      self.view.frame.origin.y = -GetKeyboardHeight(notification)
    }
  }
  
  /// Get the keyboard height
  ///
  /// :param: notification The notification causing this method invocation
  func GetKeyboardHeight(notification: NSNotification) -> CGFloat {
    let UserInfo = notification.userInfo
    let KeyboardSize = UserInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
    return KeyboardSize.CGRectValue().height
  }
  
  /// When the keyboard will disappear and caused by the bottom text field
  /// we want to reset the view's origin
  func KeyboardWillHide(notification: NSNotification) {
    if BottomTextField.isFirstResponder() {
      self.view.frame.origin.y = 0
    }
  }
  
  /// Once the text field starts editing, reset the text field text so the
  /// user starts fresh
  func textFieldDidBeginEditing(textField: UITextField) {
    textField.text = ""
  }
  
  /// In landscape, the keyboard can be hidden.  At this point the view needs
  /// to be reset to the origin.
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    if BottomTextField.isFirstResponder() {
      self.view.frame.origin.y = 0
    }
    /// dismiss the keyboard
    return textField.resignFirstResponder()
  }
  
  /// Open the Photo Album and pick an image for the meme
  @IBAction func OpenAlbum(sender: AnyObject) {
    /// Create a new image picker, setting the source to be the PhotoLibrary
    var ImagePicker = UIImagePickerController()
    ImagePicker.delegate = self
    ImagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
    self.presentViewController(ImagePicker, animated: true, completion: nil)
  }
  
  /// Open the Camera and pick and image for the meme
  @IBAction func OpenCamera(sender: AnyObject) {
    /// Create a new image picker, setting the source to be the Camera
    var ImagePicker = UIImagePickerController()
    ImagePicker.delegate = self
    ImagePicker.sourceType = UIImagePickerControllerSourceType.Camera
    /// Only allow still images to be used
    ImagePicker.mediaTypes = [kUTTypeImage]
    /// Don't allow the image to be editied
    ImagePicker.allowsEditing = false
    self.presentViewController(ImagePicker, animated: true, completion: nil)
  }
  
  /// Cancel the meme creation by dismissing the view controller
  @IBAction func CancelMeme(sender: AnyObject) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  /// Share the created meme
  @IBAction func ShareMeme(sender: AnyObject)
  {
    /// Instantiate a new Meme object
    var NewMeme = Meme(TopText: TopTextField.text, BottomText: BottomTextField.text, Image: ImageView.image!, MemedImage: GenerateMemeImage())
    
    /// Create an Activity View Controller for sms, saving, etc capabilities
    /// Pass in the created Meme Image for such purposes
    let ActivityViewController = UIActivityViewController(activityItems: [NewMeme.MemedImage], applicationActivities: nil)
    
    /// Callback for AactivityViewCompletion.
    ///
    /// :param: Activity The type of service
    /// :param: Completed Indicates if the action was completed
    /// :param: ReturnedIems Items changed during the activity action
    /// :param: Error Object returned if Activity Action failed
    func ActivityCompleted(Activity: String!, Completed: Bool, ReturnedItems: [AnyObject]!, Error: NSError!) -> Void {
      if (Completed) {
        self.dismissViewControllerAnimated(true, completion: nil)
        let AppDelegateObject = UIApplication.sharedApplication().delegate as! AppDelegate
        AppDelegateObject.Memes.append(NewMeme)
      }
    }
    
    ActivityViewController.completionWithItemsHandler = ActivityCompleted
    self.presentViewController(ActivityViewController, animated: true, completion: nil)
  }
  
  /// Callback for image picker once the image has been selected.
  /// Dismiss the view and set the selected image.
  ///
  /// :param: picker The image picker controller
  /// :param: didFinishPickingImage The image selected in teh Image Picker
  /// :param: editingInfo Editing information
  func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
    self.dismissViewControllerAnimated(true, completion: nil)
    ImageView.image = image
    ImageSelected = true
  }
  
  
  /// Generate the meme image by taking a screenshot containing the
  /// selected image, top and bottom text fields.
  func GenerateMemeImage() -> UIImage! {
    // Hide the toolbar
    Toolbar.hidden = true;
    self.navigationController?.setNavigationBarHidden(true, animated: false)
    
    // Render view to an image
    UIGraphicsBeginImageContext(self.view.frame.size)
    self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
    let MemedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    // Un-hide the toolbar.
    Toolbar.hidden = false;
    self.navigationController?.setNavigationBarHidden(false, animated: false)
    
    return MemedImage
  }
}