//
//  TableViewController.swift
//  MemeMe
//
//  Created by Troy Tobin on 21/05/2015.
//  Copyright (c) 2015 ttobin. All rights reserved.

import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  var memes: [Meme]!
  @IBOutlet var TableView: UITableView!
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    let object = UIApplication.sharedApplication().delegate
    let appDelegate = object as! AppDelegate
    memes = appDelegate.Memes
    TableView.reloadData()
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.memes.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableCell") as! UITableViewCell
    let meme = self.memes[indexPath.row]
    
    // Set the name and image
    cell.textLabel!.text = meme.TopText as String
    cell.imageView!.image = meme.MemedImage
    
    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let MemeView = self.storyboard!.instantiateViewControllerWithIdentifier("MemeViewController") as! MemeViewController
    MemeView.meme = self.memes[indexPath.row]
    self.navigationController!.pushViewController(MemeView, animated: true)
    
  }
}