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
    var currentLevenshtein = 0
    
    init(name: String, phone: String) {
        self.name = name
        self.phones = [phone]
    }
    
    init(name: String, phones: [String]) {
        self.name = name
        self.phones = phones
    }
    
    func computeLevenshtein(word: String) {
        self.currentLevenshtein = -1
        
        var names = self.name.componentsSeparatedByString(" ")
        if (names.contains("")) {
            names.removeAtIndex(names.indexOf("")!)
        }
        if (!names.contains(self.name)) {
            names.append(self.name)
        }
        
        for n in names {
            let a = Array(n.lowercaseString.utf16)
            let b = Array(word.lowercaseString.utf16)
            
            if (a.count == 0 || b.count == 0) {
                self.currentLevenshtein = 100 // don't use this comparison
                continue
            }
            
            let cols = a.count + 1
            let rows = b.count + 1
            
            var matrix = Array<Int>(count:cols*rows, repeatedValue:0)
            
            func getValue(col: Int, _ row: Int) -> Int {
                return matrix[cols*row + col]
            }
            
            func setValue(col: Int, _ row: Int, _ value: Int) {
                matrix[cols*row + col] = value
            }
            
            for i in 1...a.count {
                setValue(i, 0, i)
            }
            
            for j in 1...b.count {
                setValue(0,j,j)
            }
            
            for i in 1...a.count {
                for j in 1...b.count {
                    if a[i-1] == b[j-1] {
                        setValue(i,j,getValue(i-1,j-1))  // noop
                    } else {
                        setValue(i, j, min(
                            getValue(i-1, j) + 1,  // deletion
                            getValue(i, j-1) + 1,  // insertion
                            getValue(i-1, j-1) + 1  // substitution
                        ))
                    }
                }
            }
            
            let current = getValue(a.count, b.count)
            if (self.currentLevenshtein == -1 || self.currentLevenshtein > current) {
                self.currentLevenshtein = current
            }
        }
    }
}