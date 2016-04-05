//
//  ContactsHandler.swift
//  PebbleSMS
//
//  Created by Sawyer Vaughan on 2/4/16.
//  Copyright © 2016 Sawyer Vaughan. All rights reserved.
//

import Foundation
import Contacts
import AddressBook

class ContactHandler {
    var adbk : ABAddressBook?
    static var contacts = ContactHandler.getAllContacts()
    
    class func searchContacts(name: String, tries: Int=1) -> Contact {
        if tries == 0 {
            for contact in contacts {
                contact.computeLevenshtein(name)
            }
            contacts.sortInPlace({ (c1, c2) -> Bool in
                return c1.currentLevenshtein < c2.currentLevenshtein
            })
        }
        
        return contacts[tries % contacts.count]
    }
    
    class func getAllContacts() -> Array<Contact> {
        let contactStore = CNContactStore()
        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
        
        // Get all the containers
        var allContainers: [CNContainer] = []
        do {
            allContainers = try contactStore.containersMatchingPredicate(nil)
        } catch {
            PSMSLogger().log("Error fetching containers")
        }
        
        var results: [CNContact] = []
        
        // Iterate all containers and append their contacts to our results array
        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainerWithIdentifier(container.identifier)
            
            do {
                let containerResults = try contactStore.unifiedContactsMatchingPredicate(fetchPredicate, keysToFetch: keys)
                results.appendContentsOf(containerResults)
            } catch {
                PSMSLogger().log("Error fetching results for container")
            }
        }
        
        var res = Array<Contact>()
        for i in results.enumerate() {
            var phones = [String]()
            for p in i.element.phoneNumbers {
                if let num = (p.value as? CNPhoneNumber)?.valueForKey("digits") as? String, countryCode = (p.value as? CNPhoneNumber)?.valueForKey("countryCode") as? String {
                    let n = NumberHandler.phoneFromNumber(num, countryCode: countryCode)
                    phones.append(n)
                }
            }
            if (phones.count > 0) {
                res.append(Contact(name: i.element.givenName + " " + i.element.familyName, phones: phones))
            }
        }
        
        return res
    }
    
    class func getRecentNamesCompressed() -> String {
        let recentHandler = PSMSRecentContactHandler()
        let names = recentHandler.getRecentNames() as AnyObject as! [String]
        return names.joinWithSeparator("\n")
    }
    
    class func getRecentPhonesCompressed() -> String {
        let recentHandler = PSMSRecentContactHandler()
        let phones = recentHandler.getRecentPhones() as AnyObject as! [String]
        var p = [String]()
        for phone in phones {
            p.append(NumberHandler.phoneFromNumberNoCountry(phone))
        }
        return p.joinWithSeparator("\n")
    }
    
    
    func createAddressBook() -> Bool {
        // creates the address book if it doesn't exist
        if self.adbk != nil {
            return true
        }
        var err : Unmanaged<CFError>? = nil
        let adbk : ABAddressBook? = ABAddressBookCreateWithOptions(nil, &err).takeRetainedValue()
        if adbk == nil {
            PSMSLogger().log(err.debugDescription)
            self.adbk = nil
            return false
        }
        self.adbk = adbk
        return true
    }
    
    func determineStatus(callback: (Bool -> Void)) {
        // checks if the user has given authorization for the app to look at contacts
        let status = ABAddressBookGetAuthorizationStatus()
        switch status {
        case .Authorized:
            self.createAddressBook()
            callback(true)
        case .NotDetermined:
            ABAddressBookRequestAccessWithCompletion(nil) { (granted, err) in
                dispatch_async(dispatch_get_main_queue()) {
                    if granted {
                        self.createAddressBook()
                    }
                    callback(granted)
                }
            }
        case .Restricted:
            self.adbk = nil
            callback(false)
        case .Denied:
            self.adbk = nil
            callback(false)
        }
    }
    
    func getAllContactsOld() -> [Contact] {
        // gets all the contacts from the address book
        self.determineStatus({success in })
        if let adbk: ABAddressBook = self.adbk {
            var allContacts = [Contact]()
            
            let people: NSArray = ABAddressBookCopyArrayOfAllPeople(adbk).takeRetainedValue()
            for record: ABRecordRef in people {
                let contact: ABRecordRef = record
                let contactName = ABRecordCopyCompositeName(contact).takeRetainedValue()
                let phones: ABMultiValueRef = ABRecordCopyValue(contact, kABPersonPhoneProperty).takeRetainedValue()
                var phonesArr = [String]()
                
                for (var i: CFIndex = 0; i < ABMultiValueGetCount(phones); i++) {
                    let phoneNumberRef: CFStringRef = ABMultiValueCopyValueAtIndex(phones, i).takeUnretainedValue() as! CFStringRef
                    let phoneNumber : String? = phoneNumberRef as String?
                    if phoneNumber != nil && phoneNumber != "" {
                        phonesArr.append(phoneNumber!)
                    }
                    /*if (String(loclabel) == String(kABPersonPhoneMainLabel)) {
                        phonesArr.append(phone)
                        foundPhone = true
                    }
                    if (String(loclabel) == String(kABPersonPhoneIPhoneLabel)) {
                        phonesArr.append(phone)
                        foundPhone = true
                    }
                    if (String(loclabel) == String(kABPersonPhoneMobileLabel)) {
                        phonesArr.append(phone)
                        foundPhone = true
                    }
                    if (String(loclabel) == String(kABHomeLabel)) {
                        phonesArr.append(phone)
                        foundPhone = true
                    }
                    if (String(loclabel) == String(kABWorkLabel)) {
                        phonesArr.append(phone)
                        foundPhone = true
                    }*/
                }
                if phonesArr.count > 0 {
                    allContacts.append(Contact(name: contactName as String, phones: phonesArr))
                }
            }
            return allContacts
        }
        return [Contact]()
    }
}
