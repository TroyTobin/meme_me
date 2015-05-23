//
//  MemeViewController.swift
//  MemeMe
//
//  Created by Troy Tobin on 23/05/2015.
//  Copyright (c) 2015 ttobin. All rights reserved.
//

import UIKit

class MemeViewController : UIViewController {
  
  @IBOutlet weak var MemeImageView: UIImageView!
  
  var meme: Meme!
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    self.tabBarController?.tabBar.hidden = true
    
    self.MemeImageView!.image = meme.MemedImage
    //set contentMode to scale aspect to fit
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    self.tabBarController?.tabBar.hidden = false
  }
}
