//
//  MemeViewController.swift
//  MemeMe
//
//  Created by Troy Tobin on 23/05/2015.
//  Copyright (c) 2015 ttobin. All rights reserved.
//

import UIKit

/// This class controls the view for showing saved memes in a table view.
class MemeViewController : UIViewController {
  @IBOutlet weak var MemeImageView: UIImageView!
  var SelectedMeme: Meme!
  
  override func viewWillAppear(animated: Bool){
    super.viewWillAppear(animated)
    
    /// Hide the tab bar when viewing the meme
    self.tabBarController?.tabBar.hidden = true
    self.MemeImageView!.image = SelectedMeme.MemedImage
  }
  
  override func viewWillDisappear(animated: Bool){
    super.viewWillDisappear(animated)
    
    /// Show the tab bar after viewing the meme
    self.tabBarController?.tabBar.hidden = false
  }
}
