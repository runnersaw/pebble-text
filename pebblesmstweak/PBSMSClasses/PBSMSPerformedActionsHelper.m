#import "PBSMSPerformedActionsHelper.h"

#import "PBSMSHelper.h"

@interface PBSMSPerformedActionsHelper ()

@end

@implementation PBSMSPerformedActionsHelper

+ (id)sharedHelper {
    static PBSMSPerformedActionsHelper *sharedPerformedActionsHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedPerformedActionsHelper = [[self alloc] init];
    });
    return sharedPerformedActionsHelper;
}

@end