#import "PBSMSNotificationsHelper.h"

#import "PBSMSNotification.h"
#import "PBSMSNotificationAction.h"
#import "PBSMSPebbleAction.h"

@implementation PBSMSNotificationsHelper

+ (PBSMSNotificationsHelper *)sharedHelper
{
    static PBSMSNotificationsHelper *sharedNotificationsHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedNotificationsHelper = [[self alloc] init];
    });
    return sharedNotificationsHelper;
}

// Notification handling
- (NSArray *)notificationsForAppIdentifier:(NSString *)appIdentifier
{

}

- (void)loadNotifications
{

}

- (void)saveNotifications
{

}

- (void)saveNotification:(PBSMSNotification *)notification
{

}

// Saving Pebble Actions
- (void)savePebbleAction:(PBSMSPebbleAction *)action
{

}

- (void)savePebbleActions
{

}

- (void)loadPebbleActions
{

}

- (PBSMSPebbleAction *)pebbleActionForPebbleActionId:(NSNumber *)pebbleActionId
{

}

// Action handling
- (void)saveActionToPerform:(PBSMSNotificationAction *)action
{

}

- (NSArray *)actionsToPerform
{

}

@end