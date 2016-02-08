//
//  SEEPhoneNumberFormatter.h
//  Seesaw
//
//  Created by Caleb Davenport on 2/26/13.
//  Copyright (c) 2013 Seesaw. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SEEPhoneNumberFormatterType) {
	SEEPhoneNumberFormatterTypeInternational,
	SEEPhoneNumberFormatterTypeLocal,
	SEEPhoneNumberFormatterTypeE164
};

@interface SEEPhoneNumberFormatter : NSObject

+ (instancetype)sharedFormatter;

/**
 Get a formatted phone number with the "international" format type. Pass nil
 for locale to use the current locale.
 */
+ (NSString *)formatPhoneNumber:(NSString *)number
					 withLocale:(NSLocale *)locale;
+ (NSString *)formatPhoneNumber:(NSString *)number
				withCountryCode:(NSString *)country;

/**
 Get a formatted phone number with the given format type. Pass nil for locale
 to use the current locale.
 */
+ (NSString *)formatPhoneNumber:(NSString *)number
					 withLocale:(NSLocale *)locale
						 style:(SEEPhoneNumberFormatterType)type;
+ (NSString *)formatPhoneNumber:(NSString *)number
				withCountryCode:(NSString *)country
						 style:(SEEPhoneNumberFormatterType)type;

@end
