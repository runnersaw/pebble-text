//
//  WatchDelegate.swift
//  PebbleSMS
//
//  Created by Sawyer Vaughan on 3/3/16.
//  Copyright © 2016 Sawyer Vaughan. All rights reserved.
//

import Foundation
import PebbleKit

class WatchDelegate : NSObject, PBWatchDelegate {
    static let sharedDelegate = WatchDelegate()
    
    func watch(watch: PBWatch, handleError error: NSError) {
        PSMSLogger().log("PEBBLESMS: handleError \(error.debugDescription)")
    }
    
    func watchDidCloseSession(watch: PBWatch) {
        PSMSLogger().log("PEBBLESMS: watchDidCloseSession \(watch.name)")
    }
    
    func watchDidDisconnect(watch: PBWatch) {
        PSMSLogger().log("PEBBLESMS: watchDidDisconnect \(watch.name)")
    }
    
    func watchDidOpenSession(watch: PBWatch) {
        PSMSLogger().log("PEBBLESMS: watchDidOpenSession \(watch.name)")
    }
    
    func watchWillResetSession(watch: PBWatch) {
        PSMSLogger().log("PEBBLESMS: watchWillResetSession \(watch.name)")
    }
    
}