//
//  CollectionViewController.swift
//  MemeMe
//
//  Created by Troy Tobin on 23/05/2015.
//  Copyright (c) 2015 ttobin. All rights reserved.

import UIKit

class MemeCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
  
  var memes: [Meme]!
  @IBOutlet var CollectionView: UICollectionView!
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    println("view Will Appear Collection View")
    let object = UIApplication.sharedApplication().delegate
    let appDelegate = object as! AppDelegate
    memes = appDelegate.memes
    
    print("Memes count ")
    println(memes.count)
    CollectionView.reloadData()
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    println("CollectionView Count")
    return self.memes.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
    println("CollectionView CellForItemIndexPath")
    let MemeCell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
    let meme = self.memes[indexPath.row]
    
    // Set the name and image
    MemeCell.ImageView?.image = meme.MemedImage
    
    return MemeCell
  }
  
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
  {
    println("View the meme");
    let MemeView = self.storyboard!.instantiateViewControllerWithIdentifier("MemeViewController") as! MemeViewController
    println(MemeView)
    MemeView.meme = self.memes[indexPath.row]
    self.navigationController!.pushViewController(MemeView, animated: true)
  }
  
}

