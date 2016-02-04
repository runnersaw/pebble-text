//
//  ContactsHandler.swift
//  PebbleSMS
//
//  Created by Sawyer Vaughan on 2/4/16.
//  Copyright © 2016 Sawyer Vaughan. All rights reserved.
//

import Foundation
import Contacts

class ContactsHandler {
    class func getAllContacts() -> Array<String> {
        let contactStore = CNContactStore()
        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey]
        
        // Get all the containers
        var allContainers: [CNContainer] = []
        do {
            allContainers = try contactStore.containersMatchingPredicate(nil)
        } catch {
            print("Error fetching containers")
        }
        
        var results: [CNContact] = []
        
        // Iterate all containers and append their contacts to our results array
        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainerWithIdentifier(container.identifier)
            
            do {
                let containerResults = try contactStore.unifiedContactsMatchingPredicate(fetchPredicate, keysToFetch: keys)
                results.appendContentsOf(containerResults)
            } catch {
                print("Error fetching results for container")
            }
        }
        
        var res = Array<String>()
        for i in results.enumerate() {
            res.append(i.element.givenName + " " + i.element.familyName)
        }
        
        return res
    }
}