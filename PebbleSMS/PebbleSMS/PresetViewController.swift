//
//  PresetViewController.swift
//  PebbleSMS
//
//  Created by Sawyer Vaughan on 2/12/16.
//  Copyright © 2016 Sawyer Vaughan. All rights reserved.
//

import Foundation
import UIKit

class PresetViewController : UITableViewController {
    
    static let maxPresets = 10
    
    let cellIdentifier = "PebbleSMSCell"
    let edit_title = "Edit message"
    let create_title = "Create preset message"
    let max_title = "Maximum reached"
    let max_message = "You can only create up to \(PresetViewController.maxPresets) preset messages."
    let confirm = "Confirm"
    let cancel = "Cancel"
    let viewTitle = "Presets"
    let okay = "Okay"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addPreset")
        self.navigationItem.rightBarButtonItem = addButton
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "doneWithPresets")
        self.navigationItem.leftBarButtonItem = doneButton
        
        self.title = viewTitle
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PresetHandler.sharedHandler.presets.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let alert = UIAlertController(title: self.edit_title, message: nil, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: confirm, style: .Default, handler: { action in
            let text = alert.textFields!.first!.text
            if text != nil {
                if text != "" {
                    PresetHandler.setPreset(text!, index: indexPath.row)
                    self.tableView.reloadData()
                } else {
                    PresetHandler.removePreset(indexPath.row)
                    self.tableView.reloadData()
                }
            }
        }))
        alert.addAction(UIAlertAction(title: cancel, style: .Cancel, handler: nil))
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.placeholder = "Preset message"
            textField.text = PresetHandler.getPreset(indexPath.row)
        })
        dispatch_async(dispatch_get_main_queue(), {
            self.presentViewController(alert, animated: true, completion: nil)
        })
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier)
        if (cell == nil) {
            cell = UITableViewCell(style: .Default, reuseIdentifier: self.cellIdentifier)
        }
        
        cell!.textLabel?.text = PresetHandler.getPreset(indexPath.row)
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            PresetHandler.removePreset(indexPath.row)
            self.tableView.reloadData()
        }
    }
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        PresetHandler.movePreset(sourceIndexPath.row, to: destinationIndexPath.row)
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func addPreset() {
        if (PresetHandler.sharedHandler.presets.count < PresetViewController.maxPresets) {
            let alert = UIAlertController(title: self.edit_title, message: nil, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: confirm, style: .Default, handler: { action in
                let text = alert.textFields!.first!.text
                if text != nil {
                    if text != "" {
                        PresetHandler.addPreset(text!)
                        self.tableView.reloadData()
                    }
                }
            }))
            alert.addAction(UIAlertAction(title: cancel, style: .Cancel, handler: nil))
            alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
                textField.placeholder = "Preset message"
            })
            dispatch_async(dispatch_get_main_queue(), {
                self.presentViewController(alert, animated: true, completion: nil)
            })
        } else {
            let alert = UIAlertController(title: self.max_title, message: self.max_message, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: okay, style: .Default, handler: nil))
            dispatch_async(dispatch_get_main_queue(), {
                self.presentViewController(alert, animated: true, completion: nil)
            })
        }
    }
    
    func doneWithPresets() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}