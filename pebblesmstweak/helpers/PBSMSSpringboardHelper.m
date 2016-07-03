#import "PBSMSSpringboardHelper.h"

#import "PBSMSHelper.h"

@interface PBSMSSpringboardHelper ()

@end

@implementation PBSMSSpringboardHelper

+ (id)sharedHelper {
    static PBSMSSpringboardHelper *sharedSpringboardHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSpringboardHelper = [[self alloc] init];
    });
    return sharedSpringboardHelper;
}

@end