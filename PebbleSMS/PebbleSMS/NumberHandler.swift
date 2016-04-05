//
//  NumberHandler.swift
//  PebbleSMS
//
//  Created by Sawyer Vaughan on 2/6/16.
//  Copyright © 2016 Sawyer Vaughan. All rights reserved.
//

import Foundation

class NumberHandler {
    
    class func phoneFromNumber(phone: String, countryCode: String) -> String {
        return SEEPhoneNumberFormatter.formatPhoneNumber(phone, withCountryCode: countryCode, style: .E164)
    }
    
    class func phoneFromNumberNoCountry(phone: String) -> String {
        return SEEPhoneNumberFormatter.formatPhoneNumber(phone, withLocale: nil, style: .E164)
    }
    
    class func prefixFromCountryCode(countryCode: String) -> String {
        return ""
    }
}