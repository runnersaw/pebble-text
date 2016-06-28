#import <Preferences/Preferences.h>

@interface PebbleSMSTweakListController: PSListController
{
}
@end

@implementation PebbleSMSTweakListController
- (id)specifiers
{
	if(_specifiers == nil)
	{
		_specifiers = [[self loadSpecifiersFromPlistName:@"pebblesmstweak" target:self] retain];
	}
	return _specifiers;
}
@end

// vim:ft=objc
