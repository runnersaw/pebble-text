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
	NSMutableArray *notifications = [NSMutableArray array];

	for (PBSMSNotification *notification in self.notifications)
	{
		if ([notification.appIdentifier isEqualToString:appIdentifier])
		{
			[notifications addObject:notification];
		}
	}

	return [notifications copy];
}

- (void)loadNotifications
{
	NSMutableArray *arr = [NSMutableArray arrayWithContentsOfFile:notificationsFileLocation];

	if (dict)
	{
		[notificationActionsDictionary setDictionary:dict];
	}
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