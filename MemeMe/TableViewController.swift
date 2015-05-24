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
    if (Memes.count == 0 && AppDelegateObject.Entry) {
      let CreateMemeView = self.storyboard!.instantiateViewControllerWithIdentifier("CreateMemeNavController") as! UINavigationController
      self.navigationController?.presentViewController(CreateMemeView, animated: true, completion: nil)
    }
    AppDelegateObject.Entry = false
    /// Reload the memes in the table view
    TableView.reloadData()
  }
  
  /// Return the number of saved Meme images to show
  ///
  /// :param: tableView The table view controller
  /// :param: section The index into the table view
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.Memes.count
  }
  
  /// Return the meme for the desired index
  ///
  /// :param: tableView The table view controller
  /// :param: indexPath The index of the item in the table view
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let Cell = tableView.dequeueReusableCellWithIdentifier("MemeTableCell") as! UITableViewCell
    let Meme = self.Memes[indexPath.row]
    
    /// Set the meme label and image
    Cell.textLabel!.text = Meme.TopText as String
    Cell.imageView!.image = Meme.MemedImage
    
    return Cell
  }
  
  /// View the selected meme in the MemeViewController
  ///
  /// :param: tableView The table view controller
  /// :param: indexPath The index of the item selected
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let MemeView = self.storyboard!.instantiateViewControllerWithIdentifier("MemeViewController") as! MemeViewController
    MemeView.SelectedMeme = self.Memes[indexPath.row]
    self.navigationController!.pushViewController(MemeView, animated: true)
  }
}