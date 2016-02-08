//
//  SEEPhoneNumberFormatter.m
//  Seesaw
//
//  Created by Caleb Davenport on 2/26/13.
//  Copyright (c) 2013 Seesaw. All rights reserved.
//

#import "SEEPhoneNumberFormatter.h"
#import <UIKit/UIKit.h>

/**
 Based on
 http://www.codeproject.com/Tips/452170/How-to-use-libphonenumber-for-iPhone-apps
 and http://www.phoneformat.com
 */

@interface SEEPhoneNumberFormatter () <UIWebViewDelegate> {
	UIWebView *_webView;
	BOOL _isWebViewLoaded;
}

@end

@implementation SEEPhoneNumberFormatter

#pragma mark - Private

- (id)init {
	if ((self = [super init])) {
		
		_webView = [[UIWebView alloc] init];
		_webView.delegate = self;
		
		NSURL *URL = [[NSBundle mainBundle] URLForResource:NSStringFromClass([self class]) withExtension:@"html"];
		NSURLRequest *request = [[NSURLRequest alloc] initWithURL:URL];
		[_webView loadRequest:request];
		
	}
	return self;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	NSLog(@"[%@]: Unable to load web view: %@", NSStringFromClass([self class]), error);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	_isWebViewLoaded = YES;
}

- (NSString *)formatPhoneNumber:(NSString *)number withCountryCode:(NSString *)country style:(SEEPhoneNumberFormatterType)type {
	
	// main thread
	if (![NSThread isMainThread]) {
		__block NSString *value = nil;
		dispatch_sync(dispatch_get_main_queue(), ^{
			value = [self formatPhoneNumber:number withCountryCode:country style:type];
		});
		return value;
	}
	
	// run web stuff
	if (!_isWebViewLoaded) {
		NSLog(@"[%@]: Requested formatted number before web view has loaded", NSStringFromClass([self class]));
		return number;
	}
	NSString *string = [NSString stringWithFormat:
						@"%@('%@', '%@');",
						[[self class] javascriptFunctionForFormat:type],
						country,
						number];
	return [_webView stringByEvaluatingJavaScriptFromString:string];
}

+ (NSString *)javascriptFunctionForFormat:(SEEPhoneNumberFormatterType)type {
	if (type == SEEPhoneNumberFormatterTypeInternational) {
		return @"formatInternational";
	}
	else if (type == SEEPhoneNumberFormatterTypeLocal) {
		return @"formatLocal";
	}
	else if (type == SEEPhoneNumberFormatterTypeE164) {
		return @"formatE164";
	}
	return @"";
}

#pragma mark - Public

+ (instancetype)sharedFormatter {
	static id formatter = nil;
	static dispatch_once_t token;
	dispatch_once(&token, ^{
		formatter = [[[self class] alloc] init];
	});
	return formatter;
}

+ (NSString *)formatPhoneNumber:(NSString *)number withLocale:(NSLocale *)locale {
	if (locale == nil) { locale = [NSLocale currentLocale]; }
	NSString *country = [locale objectForKey:NSLocaleCountryCode];
	return [self formatPhoneNumber:number withCountryCode:country];
}

+ (NSString *)formatPhoneNumber:(NSString *)number withCountryCode:(NSString *)country {
	return [[[self class] sharedFormatter]
			formatPhoneNumber:number
			withCountryCode:country
			style:SEEPhoneNumberFormatterTypeInternational];
}

+ (NSString *)formatPhoneNumber:(NSString *)number
					 withLocale:(NSLocale *)locale
						 style:(SEEPhoneNumberFormatterType)type {
	if (locale == nil) { locale = [NSLocale currentLocale]; }
	NSString *country = [locale objectForKey:NSLocaleCountryCode];
	return [self formatPhoneNumber:number withCountryCode:country style:type];
}

+ (NSString *)formatPhoneNumber:(NSString *)number
				withCountryCode:(NSString *)country
						 style:(SEEPhoneNumberFormatterType)type {
	return [[[self class] sharedFormatter]
			formatPhoneNumber:number
			withCountryCode:country
			style:type];
}

@end
