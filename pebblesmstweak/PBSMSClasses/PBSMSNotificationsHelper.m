#import "PBSMSNotificationsHelper.h"

#import "../include.h"
#import "PBSMSHelper.h"
#import "PBSMSNotification.h"
#import "PBSMSNotificationAction.h"
#import "PBSMSPebbleAction.h"

static NSTimeInterval

@interface PBSMSNotificationsHelper ()

@property (nonatomic, strong) NSMutableArray *mutableNotifications;
@property (nonatomic, strong) NSMutableArray *mutablePebbleActions;
@property (nonatomic, strong) NSMutableDictionary *bulletins;

@end

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

- (instancetype)init
{
	self = [super init];
	if (self)
	{
		_mutableNotifications = [NSMutableArray array];
		_mutablePebbleActions = [NSMutableArray array];
		_bulletins = [NSMutableDictionary dictionary];
	}
	return self;
}

- (NSArray *)notifications
{
	return [self.mutableNotifications copy];
}

- (NSArray *)notificationsForAppIdentifier:(NSString *)appIdentifier
{
	NSMutableArray *notifications = [NSMutableArray array];

	for (PBSMSNotification *notification in self.mutableNotifications)
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

	if (!arr)
	{
		return;
	}

	[self.mutableNotifications removeAllObjects];
	for (id object in arr)
	{
		PBSMSNotification *notification = [PBSMSNotification deserializeFromObject:object];
		if (notification)
		{
			[self.mutableNotifications addObject:notification];
		}
	}
}

- (void)saveNotifications
{
	NSMutableArray *notificationsArr = [NSMutableArray array];

	for (PBSMSNotification *notification in self.mutableNotifications)
	{
		if (![notification isExpired])
		{
			[notificationsArr addObject:[notification serializeToDictionary]];
		}
	}

    [notificationsArr writeToFile:notificationsFileLocation atomically:YES];
}

- (void)saveNotificationForBulletin:(BBBulletin *)bulletin
{
    NSString *bulletinID = [bulletin bulletinID];
    if ([self.bulletins objectForKey:bulletinID])
	{
    	return;
    }
    [self.bulletins setObject:bulletin forKey:bulletinID];

    NSString *appIdentifier = [bulletin sectionID];
    BBContent *content = [bulletin content];
    NSString *title = [content title];
    NSString *subtitle = [content subtitle];
    NSString *message = [content message];
    NSDate *timestamp = [NSDate date];

    BOOL hasActions = NO;
    NSMutableArray *actions = [NSMutableArray array];
    for (BBAction *action in [bulletin supplementaryActionsForLayout:1])
	{
        NSString *actionIdentifier = [action identifier];
        NSString *actionTitle = [(BBAppearance *)[action appearance] title];
        BOOL isQuickReply = ([action behavior] == 1);
        if (![action isAuthenticationRequired] && actionIdentifier && actionTitle)
		{
	        PBSMSNotificationAction *notificationAction = [[PBSMSNotificationAction alloc] initWithTitle:actionTitle
				actionIdentifier:actionIdentifier
				isQuickReply:isQuickReply];

	        [actions addObject:notificationAction];

	        hasActions = YES;
        }

    }

    if (!hasActions)
	{
        return;
    }

    if (!appIdentifier ||
        !bulletinId ||
        !message)
    {
        return nil;
    }

    PBSMSNotification *notification = [[PBSMSNotification alloc] initWithAppIdentifier:appIdentifier
		bulletinId:bulletinId
		title:title
		subtitle:subtitle
		message:message
		timestamp:timestamp
		actions:actions]

	[self.mutableNotifications addObject:notification];

	[self saveNotifications];
}

// - (NSArray *)pebbleActions
// {
// 	return [self.mutablePebbleActions copy];
// }

// - (void)savePebbleAction:(PBSMSPebbleAction *)action
// {
// 	[self.mutablePebbleActions addObject:action];
// 	[self saveNotifications];
// }

// - (void)savePebbleActions
// {

// }

// - (void)loadPebbleActions
// {

// }

// - (PBSMSPebbleAction *)pebbleActionForPebbleActionId:(NSNumber *)pebbleActionId
// {

// }

// // Action handling
// - (void)saveActionToPerform:(PBSMSNotificationAction *)action
// {

// }

// - (NSArray *)actionsToPerform
// {

// }

@end