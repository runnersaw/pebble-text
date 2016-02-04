//
//  AppDelegate.swift
//  PebbleSMS
//
//  Created by Sawyer Vaughan on 2/3/16.
//  Copyright © 2016 Sawyer Vaughan. All rights reserved.
//

import UIKit
import PebbleKit
import CoreTelephony

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PBPebbleCentralDelegate {

    var window: UIWindow?
    var controller = ViewController()
    var uuid = NSUUID(UUIDString: "6241e7d9-6f60-494a-896f-e585923c2c67")
    var connectedWatch : PBWatch?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        PBPebbleCentral.defaultCentral().delegate = self
        PBPebbleCentral.defaultCentral().appUUID = self.uuid
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.rootViewController = controller
        self.window!.makeKeyAndVisible()
        
        PBPebbleCentral.defaultCentral().run()
        
        print(ContactsHandler.getAllContacts())
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func pebbleCentral(central: PBPebbleCentral, watchDidConnect watch: PBWatch, isNew: Bool) {
        print("pebble connected \(watch.name)")
        self.connectedWatch = watch
        watch.appMessagesAddReceiveUpdateHandler({ (watch, message) -> Bool in
            print("recieved message \(message)")
            return true
        })
        watch.appMessagesLaunch { (watch, error) -> Void in
            if (error != nil) {
                print("Error launching app")
            } else {
                print("Launched app!")
                let dict : [NSNumber : AnyObject] = [0:"Hello"]
                watch.appMessagesPushUpdate(dict, onSent: { (watch, update, error) -> Void in
                    if (error != nil) {
                        print(error)
                    } else {
                        print("Update sent \(update)")
                    }
                })
            }
        }
    }
    
    func pebbleCentral(central: PBPebbleCentral, watchDidDisconnect watch: PBWatch) {
        print("pebble disconnected \(watch.name)")
    }
    
    func sendSMS() {
        //CTMessageCenter.sharedMessageCenter().sendSMSWithText("Hello", serviceCenter:nil, toAddress:"+!7208791626")
    }
}

