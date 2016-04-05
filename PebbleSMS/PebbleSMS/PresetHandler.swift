//
//  PresetHandler.swift
//  PebbleSMS
//
//  Created by Sawyer Vaughan on 2/12/16.
//  Copyright © 2016 Sawyer Vaughan. All rights reserved.
//

import Foundation

class PresetHandler {
    static let sharedHandler = PresetHandler()
    static let PRESET_KEY = "PebbleSMSPresets"
    
    var presets : [String] = ["Hey", "How are you?", "I'm good"]
    
    init() {
        let p = NSUserDefaults.standardUserDefaults().arrayForKey(PresetHandler.PRESET_KEY)
        if let presets = p as? [String] {
            self.presets = presets
        }
    }
    
    class func getPreset(index: Int) -> String {
        return sharedHandler.presets[index]
    }
    
    class func setPresets(presets: [String]) {
        sharedHandler.presets = presets
        savePresets()
    }
    
    class func setPreset(preset: String, index: Int) {
        sharedHandler.presets[index] = preset
        savePresets()
    }
    
    class func insertPreset(preset: String, index: Int) {
        sharedHandler.presets.insert(preset, atIndex: index)
        savePresets()
    }
    
    class func movePreset(from: Int, to: Int) {
        let preset = getPreset(from)
        removePreset(from)
        insertPreset(preset, index: to)
        savePresets()
    }
    
    class func removePreset(index: Int) {
        sharedHandler.presets.removeAtIndex(index)
        savePresets()
    }
    
    class func addPreset(preset: String) {
        sharedHandler.presets.append(preset)
        savePresets()
    }
    
    class func savePresets() {
        NSUserDefaults.standardUserDefaults().setObject(sharedHandler.presets, forKey: PresetHandler.PRESET_KEY)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func compressPresets() -> String {
        return sharedHandler.presets.joinWithSeparator("\n")
    }
}