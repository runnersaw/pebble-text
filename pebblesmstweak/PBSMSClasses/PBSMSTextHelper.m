#import "PBSMSTextHelper.h"

#import "PBSMSHelper.h"
#import "PBSMSTextMessage.h"

@interface PBSMSTextHelper ()

@end

@implementation PBSMSTextHelper

+ (id)sharedHelper {
    static PBSMSTextHelper *sharedTextHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedTextHelper = [[self alloc] init];
    });
    return sharedTextHelper;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _messagesSent = [NSMutableArray array];
    }
    return self;
}

- (NSArray *)presets
{
    if (_presets.count == 0)
    {
        _presets = @[ @"OK",
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

    return _presets;
}

@end