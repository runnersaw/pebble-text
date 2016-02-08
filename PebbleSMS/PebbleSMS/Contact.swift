//
//  Contact.swift
//  PebbleSMS
//
//  Created by Sawyer Vaughan on 2/5/16.
//  Copyright © 2016 Sawyer Vaughan. All rights reserved.
//

import Foundation

class Contact {
    var name = ""
    var phones = Array<String>()
    
    init(name: String, phone: String) {
        self.name = name
        self.phones = [phone]
    }
    
    init(name: String, phones: [String]) {
        self.name = name
        self.phones = phones
    }
}