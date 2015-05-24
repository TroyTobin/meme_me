//
//  CollectionViewController.swift
//  MemeMe
//
//  Created by Troy Tobin on 23/05/2015.
//  Copyright (c) 2015 ttobin. All rights reserved.

import UIKit

/// This class controls the view for showing saved memes in a collection view.
/// NOTE: majority of this code and structure has resulted from
///       completing the "UIKit Fundamentals" Udacity course
class MemeCollectionViewController: UIViewController,
                                    UICollectionViewDataSource,
                                    UICollectionViewDelegate
{
  
  var Memes: [Meme]!
  @IBOutlet var CollectionView: UICollectionView!
  
  
  override func viewWillAppear(animated: Bool)
  {
    super.viewWillAppear(animated)
    
    /// Set this class to be the delegate
    self.CollectionView?.delegate = self
    self.CollectionView?.dataSource = self
    
    /// Get the shared memes array
    let AppDelegateObject = UIApplication.sharedApplication().delegate as! AppDelegate
    Memes = AppDelegateObject.Memes
    if (Memes.count == 0 && AppDelegateObject.Entry)
    {
      println("here")
      let CreateMemeView = self.storyboard!.instantiateViewControllerWithIdentifier("CreateMemeNavController") as! UINavigationController
      self.navigationController?.presentViewController(CreateMemeView, animated: true, completion: nil)
    }
    AppDelegateObject.Entry = false
    /// Reload the memes in the collection view
    CollectionView.reloadData()
  }
  
  /// Return the number of saved Meme images to show
  ///
  /// :param: collectionView The collection view controller
  /// :param: section The index into the collection view
  func collectionView(collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int
  {
    return self.Memes.count
  }
  
  /// Return the meme for the desired index
  ///
  /// :param: collectionView The collection view controller
  /// :param: indexPath The index of the item in the collection view
  func collectionView(collectionView: UICollectionView,
                      cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
  {
    
    let MemeCell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
    let Meme = self.Memes[indexPath.row]
    
    /// Set the meme label and image
    MemeCell.ImageView?.image = Meme.MemedImage
    
    return MemeCell
  }
  
  /// View the selected meme in the MemeViewController
  ///
  /// :param: collectionView The collection view controller
  /// :param: indexPath The index of the item selected
  func collectionView(collectionView: UICollectionView,
                      didSelectItemAtIndexPath indexPath:NSIndexPath)
  {
    let MemeView = self.storyboard!.instantiateViewControllerWithIdentifier("MemeViewController") as! MemeViewController
    MemeView.SelectedMeme = self.Memes[indexPath.row]
    self.navigationController!.pushViewController(MemeView, animated: true)
  }
}

