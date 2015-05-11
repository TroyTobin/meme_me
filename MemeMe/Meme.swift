//
//  Meme.swift
//  MemeMe
//
//  Created by Troy Tobin on 11/05/2015.
//  Copyright (c) 2015 ttobin. All rights reserved.
//

import UIKit

class Meme
{
  var TopText: NSString!
  var BottomText: NSString!
  var Image: UIImage!
  var MemedImage: UIImage!
  
  init(topText:NSString, bottomText:NSString, image:UIImage, memedImage:UIImage)
  {
    TopText = topText
    BottomText = bottomText
    Image = image
    MemedImage = memedImage
  }
  
}
