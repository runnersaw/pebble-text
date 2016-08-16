#import "PBSMSNotificationsHelper.h"

#import "../include.h"
#import "PBSMSHelper.h"
#import "PBSMSNotification.h"
#import "PBSMSNotificationAction.h"
#import "PBSMSPebbleAction.h"

@interface PBSMSNotificationsHelper ()

@property (nonatomic, strong) NSMutableArray *mutableNotifications;
@property (nonatomic, strong) NSMutableArray *mutableActionEnabledApps;
@property (nonatomic, strong) NSMutableArray *mutablePebbleActions;
@property (nonatomic, strong) NSMutableDictionary *bulletins;
@property (nonatomic, strong) NSMutableArray *activeBulletinIDs;

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
		_mutableActionEnabledApps = [NSMutableArray array];
		_mutablePebbleActions = [NSMutableArray array];
		_bulletins = [NSMutableDictionary dictionary];
		_activeBulletinIDs = [NSMutableArray array];
		
		[self loadEnabledApps];
	}
	return self;
}

- (NSArray *)notificationsForAppIdentifier:(NSString *)appIdentifier
{
	NSMutableArray *notifications = [NSMutableArray array];

	for (PBSMSNotification *notification in self.mutableNotifications)
	{
		if ([notification.appIdentifier isEqualToString:appIdentifier] && [self.activeBulletinIDs containsObject:notification.bulletinId])
		{
			[notifications addObject:notification];
		}
	}

	return [notifications copy];
}

- (PBSMSNotification *)notificationForBulletinId:(NSString *)bulletinId
{
	for (PBSMSNotification *notification in self.mutableNotifications)
	{
		if ([notification.bulletinId isEqualToString:bulletinId])
		{
			return notification;
		}
	}

	return nil;
}

- (void)loadEnabledApps
{
	NSMutableArray *arr = [NSMutableArray arrayWithContentsOfFile:enabledAppsFileLocation];

	if (!arr)
	{
		return;
	}

	self.mutableActionEnabledApps = arr;
}

- (NSSet *)enabledApps
{
	return [NSSet setWithArray:[self.mutableActionEnabledApps copy]];
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
		PBSMSNotification *notification = [PBSMSNotification deserializeNotificationFromObject:object];
		if (notification && ![notification isExpired])
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

	[self.mutableActionEnabledApps writeToFile:enabledAppsFileLocation atomically:NO];
    [notificationsArr writeToFile:notificationsFileLocation atomically:NO];
}

- (void)saveNotificationForBulletin:(BBBulletin *)bulletin
{
    NSString *bulletinId = [bulletin bulletinID];
    if ([self.bulletins objectForKey:bulletinId])
	{
    	return;
    }
    [self.bulletins setObject:bulletin forKey:bulletinId];

    NSString *appIdentifier = [bulletin sectionID];
    BBContent *content = [bulletin content];
    NSString *title = [content title];
    NSString *subtitle = [content subtitle];
    NSString *message = [content message];
    NSDate *timestamp = [NSDate date];

    BOOL hasActions = NO;
    NSMutableArray *actions = [NSMutableArray array];
    log(@"%@", [bulletin supplementaryActionsForLayout:1]);
    for (BBAction *action in [bulletin supplementaryActionsForLayout:1])
	{
        NSString *actionIdentifier = [action identifier];
        NSString *actionTitle = [(BBAppearance *)[action appearance] title];
        BOOL isQuickReply = ([action behavior] == 1);
        log(@"%@ %@ %d %d %d %@", [action identifier], actionTitle, [action behavior], [action isAuthenticationRequired], [action canBypassPinLock], [action behaviorParameters]);
        if (actionIdentifier && actionTitle)
		{
	        PBSMSNotificationAction *notificationAction = [[PBSMSNotificationAction alloc] initWithTitle:actionTitle
				actionIdentifier:actionIdentifier
				isQuickReply:isQuickReply];

			log(@"Adding action %@", actionTitle);
	        [actions addObject:notificationAction];

	        hasActions = YES;
	    }
    }

    if (!hasActions)
	{
        log(@"no actions");
        return;
    }

    if (!appIdentifier ||
        !bulletinId ||
        !message)
    {
        log(@"no data");
        return;
    }

    PBSMSNotification *notification = [[PBSMSNotification alloc] initWithAppIdentifier:appIdentifier
		bulletinId:bulletinId
		title:title
		subtitle:subtitle
		message:message
		timestamp:timestamp
		actions:actions];

	[self.mutableNotifications addObject:notification];
	if (![self.mutableActionEnabledApps containsObject:appIdentifier])
	{
		[self.mutableActionEnabledApps addObject:appIdentifier];
	}

	[self saveNotifications];
}

- (void)addActiveBulletinID:(NSString *)bulletinID
{
	log(@"addActiveBulletinID %@", bulletinID);
	if (![self.activeBulletinIDs containsObject:bulletinID])
	{
		[self.activeBulletinIDs addObject:bulletinID];
	}
}

- (void)removeActiveBulletinID:(NSString *)bulletinID
{
	log(@"removeActiveBulletinID %@", bulletinID);
	[self.activeBulletinIDs removeObject:bulletinID];
}

- (void)savePebbleAction:(PBSMSPebbleAction *)action
{
	[self.mutablePebbleActions addObject:action];
}

- (PBSMSPebbleAction *)pebbleActionForANCSIdentifier:(NSString *)ancsIdentifier
{
	for (PBSMSPebbleAction *action in self.mutablePebbleActions)
	{
		if ([ancsIdentifier isEqualToString:action.ANCSIdentifier])
		{
			return action;
		}
	}

	return nil;
}

- (PBSMSPebbleAction *)pebbleActionForPebbleActionId:(NSNumber *)pebbleActionId
{
	for (PBSMSPebbleAction *action in self.mutablePebbleActions)
	{
		if ([pebbleActionId isEqual:action.pebbleActionId])
		{
			return action;
		}
	}

	return nil;
}

- (NSArray *)pebbleActions
{
	return [self.mutablePebbleActions copy];
}

- (BOOL)performAction:(PBSMSPebbleAction *)action
{
	BOOL success = NO;
	log(@"performAction %@", action.actionIdentifier);

	BBBulletin *bulletin = [self.bulletins objectForKey:action.bulletinIdentifier];
	NSLog(@"OHYESHERE %@", bulletin);
	if (bulletin)
	{
		for (BBAction *bbAction in [bulletin supplementaryActionsForLayout:1])
		{
			if ([[bbAction identifier] isEqualToString:action.actionIdentifier])
			{
				BBResponse *bbResponse = [bulletin responseForAction:bbAction];
				if (bbResponse)
				{
					NSLog(@"%@", bbResponse);
					if (action.isReplyAction)
					{
						NSDictionary *dict = @{ @"UIUserNotificationActionResponseTypedTextKey" : action.replyText };
						NSDictionary *finalDict = @{ @"userResponseInfo" : dict };
						[bbResponse setContext:finalDict];
					}

					SBBulletinBannerController *bannerController = [%c(SBBulletinBannerController) sharedInstance];
					NSLog(@"bulletinQueue %@", MSHookIvar<NSMutableArray *>(bannerController, "_bulletinQueue"));
					NSLog(@"bannerController %@", bannerController);
					if (bannerController)
					{
						id observer = MSHookIvar<id>(bannerController, "_observer");
						if (observer)
						{
							NSLog(@"observer %@", observer);
							[observer getBulletinsWithCompletion:^(NSArray *bulletins) {
								NSLog(@"bulletins %@", bulletins);
							}];
							if ([observer isKindOfClass:%c(BBObserver)])
							{
								BBObserver *bbObserver = (BBObserver *)observer;
								[bbObserver sendResponse:bbResponse];
								NSLog(@"SENT RESPONSE");
								success = YES;
							}
						}
					}
				}
			}
		}
	}

	return success;
}

@end