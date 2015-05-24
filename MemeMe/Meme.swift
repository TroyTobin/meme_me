//
//  Meme.swift
//  MemeMe
//
//  Created by Troy Tobin on 11/05/2015.
//  Copyright (c) 2015 ttobin. All rights reserved.
//

import UIKit

/// This class represents a single meme
class Meme
{
  var TopText: NSString!
  var BottomText: NSString!
  var Image: UIImage!
  var MemedImage: UIImage!
  
  /// Initialise the Meme Class.
  ///
  /// :param: topText The top text for the Meme
  /// :param: bottomText The bottom text for the Meme
  /// :param: image The image for the Meme
  /// :param: memedImage The combined Meme image, including the top text, 
  ///                    bottom text and the image.
  init(topText:NSString,
       bottomText:NSString,
       image:UIImage,
       memedImage:UIImage)
  {
    TopText = topText
    BottomText = bottomText
    Image = image
    MemedImage = memedImage
  }
}
