//
//  TableViewController.swift
//  MemeMe
//
//  Created by Troy Tobin on 21/05/2015.
//  Copyright (c) 2015 ttobin. All rights reserved.

import UIKit

/// This class controls the view for showing saved memes in a table view.
/// NOTE: majority of this code and structure has resulted from
///       completing the "UIKit Fundamentals" Udacity course
class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  var Memes: [Meme]!
  @IBOutlet var TableView: UITableView!
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    /// Get the shared memes array
    let AppDelegateObject = UIApplication.sharedApplication().delegate as! AppDelegate
    Memes = AppDelegateObject.Memes
    
    /// Reload the memes in the table view
    TableView.reloadData()
  }
  
  /// Return the number of saved Meme images to show
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.Memes.count
  }
  
  /// Return the meme for the desired index
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let Cell = tableView.dequeueReusableCellWithIdentifier("MemeTableCell") as! UITableViewCell
    let Meme = self.Memes[indexPath.row]
    
    /// Set the meme label and image
    Cell.textLabel!.text = Meme.TopText as String
    Cell.imageView!.image = Meme.MemedImage
    
    return Cell
  }
  
  /// View the selected meme in the MemeViewController
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let MemeView = self.storyboard!.instantiateViewControllerWithIdentifier("MemeViewController") as! MemeViewController
    MemeView.SelectedMeme = self.Memes[indexPath.row]
    self.navigationController!.pushViewController(MemeView, animated: true)
  }
}