#import "PBSMSMessagesHelper.h"

#import "PBSMSHelper.h"

@interface PBSMSMessagesHelper ()

@end

@implementation PBSMSMessagesHelper

+ (id)sharedHelper {
    static PBSMSMessagesHelper *sharedMessagesHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMessagesHelper = [[self alloc] init];
    });
    return sharedMessagesHelper;
}

@end