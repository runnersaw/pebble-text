#import "PBSMSPebbleHelper.h"

#import "PBSMSHelper.h"

@interface PBSMSPebbleHelper ()

@property (nonatomic, copy) NSArray<NSString *> *presets;

@end

@implementation PBSMSPebbleHelper

+ (id)sharedHelper {
    static PebbleSMSHelper *sharedPebbleHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedPebbleHelper = [[self alloc] init];
    });
    return sharedPebbleHelper;
}

- (NSArray *)presets
{
    if ([presets count] == 0)
	{
        presets = @[ @"OK", 
        	@"Yes", 
        	@"No", 
        	@"Call me", 
        	@"Call you later", 
        	@"Thank you", 
        	@"See you soon", 
        	@"Running late", 
        	@"On my way", 
        	@"Busy right now - give me a second?" ];
    }


}

@end