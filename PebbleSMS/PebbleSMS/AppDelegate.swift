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

class AppDelegate: UIResponder, UIApplicationDelegate, PBPebbleCentralDelegate {
    static let DICTATED_NAME_KEY = 0
    static let IS_CONTACT_CORRECT_KEY = 1
    static let IS_NUMBER_CORRECT_KEY = 2
    static let FINAL_MESSAGE_KEY = 3
    static let STATE_KEY = 4
    static let CONTACT_NAME_KEY = 5
    static let CONTACT_NUMBER_KEY = 6
    static let MESSAGE_CONFIRMATION_KEY = 7
    static let ATTEMPT_NUMBER_KEY = 8
    static let CONNECTION_TEST_KEY = 9
    
    static let BEGINNING_STATE = 0
    static let DICTATED_NAME_STATE = 1
    static let CHECKING_CONTACT_STATE = 2
    static let CREATING_FINAL_MESSAGE_STATE = 3
    static let CONFIRMING_FINAL_MESSAGE_STATE = 4
    static let FINAL_MESSAGE_STATE = 5

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
        
        SEEPhoneNumberFormatter.sharedFormatter()
        
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
    
    func sendContactSearchResponse(watch: PBWatch, dictatedName: String, tries: Int) {
        let contact = ContactHandler.searchContacts(dictatedName, tries: tries)
        if (contact != nil) {
            let dict : [NSNumber : AnyObject] = [AppDelegate.CONTACT_NAME_KEY : contact!.name, AppDelegate.CONTACT_NUMBER_KEY : contact!.phones[0]]
            watch.appMessagesPushUpdate(dict, onSent: { (watch, update, error) -> Void in
                if (error != nil) {
                    print(error)
                } else {
                    print("Contact response sent \(update)")
                }
            })
        }
    }
    
    func sendSentResponse(watch: PBWatch) {
        let dict : [NSNumber : AnyObject] = [AppDelegate.MESSAGE_CONFIRMATION_KEY : "Sent"]
        watch.appMessagesPushUpdate(dict, onSent: { (watch, update, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                print("Contact response sent \(update)")
            }
        })
    }
    
    func sendConnectionResponse(watch: PBWatch) {
        let dict : [NSNumber : AnyObject] = [AppDelegate.CONNECTION_TEST_KEY : "Connected"]
        watch.appMessagesPushUpdate(dict, onSent: { (watch, update, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                print("Contact response sent \(update)")
            }
        })
    }

    func pebbleCentral(central: PBPebbleCentral, watchDidConnect watch: PBWatch, isNew: Bool) {
        print("pebble connected \(watch.name)")
        self.connectedWatch = watch
        
        self.sendConnectionResponse(self.connectedWatch!)
        
        watch.appMessagesAddReceiveUpdateHandler({ (watch, message) -> Bool in
            print("recieved message \(message)")
            
            if let _ = message[AppDelegate.CONNECTION_TEST_KEY] {
                self.sendConnectionResponse(watch)
                return true
            }
            
            if let state = message[AppDelegate.STATE_KEY] as? Int {
                print("Got state \(state)")
                
                if (state == AppDelegate.CHECKING_CONTACT_STATE) {
                    if let tries = message[AppDelegate.ATTEMPT_NUMBER_KEY] as? Int, name = message[AppDelegate.DICTATED_NAME_KEY] as? String {
                        self.sendContactSearchResponse(watch, dictatedName: name, tries: tries)
                    }
                }
                
                if (state == AppDelegate.FINAL_MESSAGE_STATE) {
                    if let number = message[AppDelegate.CONTACT_NUMBER_KEY] as? String, m = message[AppDelegate.FINAL_MESSAGE_KEY] as? String {
                        SMSSender().sendSMS(number, withText: m)
                        self.sendSentResponse(watch)
                    }
                }
            }
            
            return true
        })
        watch.appMessagesLaunch { (watch, error) -> Void in
            if (error != nil) {
                print("Error launching app")
            } else {
                print("Launched app!")
            }
        }
    }
    
    func pebbleCentral(central: PBPebbleCentral, watchDidDisconnect watch: PBWatch) {
        print("pebble disconnected \(watch.name)")
    }
}

