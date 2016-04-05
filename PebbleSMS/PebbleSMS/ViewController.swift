//
//  ViewController.swift
//  PebbleSMS
//
//  Created by Sawyer Vaughan on 2/3/16.
//  Copyright © 2016 Sawyer Vaughan. All rights reserved.
//

import UIKit
import PebbleKit

class ViewController: UIViewController {
    
    var titleLabel: UILabel?
    var descriptionLabel: UILabel?
    var installButton: UIButton?
    var presetsButton: UIButton?
    var interactionController: UIDocumentInteractionController?
    
    let side_margin: CGFloat = 10
    let top_margin: CGFloat = 20
    let label_height: CGFloat = 28
    let label_font_size: CGFloat = 24
    let description_height: CGFloat = 150
    let description_font_size: CGFloat = 16
    let button_height: CGFloat = 40
    let button_font_size: CGFloat = 20
    
    let appTitle = "TextSender for Pebble"
    let install_text = "Install app"
    let preset_text = "Set presets"
    let description_text = "Press \"Install app\" below and click \"Copy to Pebble Time\" to install the app on your Pebble. Click \"Set presets\" to edit your preset messages."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.whiteColor()
        
        let width = self.view.frame.size.width - 2*side_margin
        let titleY = 20 + top_margin
        self.titleLabel = UILabel(frame: CGRect(x: side_margin, y: titleY, width: width, height: label_height))
        self.titleLabel?.text = appTitle
        self.titleLabel?.font = UIFont.systemFontOfSize(label_font_size)
        self.titleLabel?.textAlignment = .Center
        
        let descriptionY = titleY + side_margin + label_height
        self.descriptionLabel = UILabel(frame: CGRect(x: side_margin, y: descriptionY, width: width, height: description_height))
        self.descriptionLabel?.text = description_text
        self.descriptionLabel?.font = UIFont.systemFontOfSize(description_font_size)
        self.descriptionLabel?.textAlignment = .Center
        self.descriptionLabel?.numberOfLines = 10
        
        let installY = descriptionY + side_margin + description_height
        self.installButton = UIButton(frame: CGRect(x: side_margin, y: installY, width: width, height: button_height))
        self.installButton?.setTitle(install_text, forState: .Normal)
        self.installButton?.setTitleColor(UIColor.blueColor(), forState: .Normal)
        self.installButton?.addTarget(self, action: "installClicked", forControlEvents: .TouchUpInside)
        self.installButton?.titleLabel?.font = UIFont.systemFontOfSize(button_font_size)
        
        let presetsY = installY + side_margin + button_height
        self.presetsButton = UIButton(frame: CGRect(x: side_margin, y: presetsY, width: width, height: button_height))
        self.presetsButton?.setTitle(preset_text, forState: .Normal)
        self.presetsButton?.setTitleColor(UIColor.blueColor(), forState: .Normal)
        self.presetsButton?.addTarget(self, action: "presetsClicked", forControlEvents: .TouchUpInside)
        self.presetsButton?.titleLabel?.font = UIFont.systemFontOfSize(button_font_size)
        
        self.view.addSubview(self.titleLabel!)
        self.view.addSubview(self.descriptionLabel!)
        self.view.addSubview(self.installButton!)
        self.view.addSubview(self.presetsButton!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func installClicked() {
        let url = NSURL(string: "http://sawyervaughan.com/files/pebble-sms-pebble.pbw")!
        Downloader.loadFileAsync(url, completion: { (path, error) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                let fileUrl = NSURL(fileURLWithPath: path)
                self.interactionController = UIDocumentInteractionController(URL: fileUrl)
                self.interactionController!.presentOpenInMenuFromRect(self.view.frame, inView: self.view, animated: true)
            })
        })
    }
    
    func presetsClicked() {
        transitionToPreset()
    }

    func transitionToPreset() {
        let preset = PresetViewController()
        let nav = UINavigationController(rootViewController: preset)
        self.presentViewController(nav, animated: true, completion: nil)
    }
}

