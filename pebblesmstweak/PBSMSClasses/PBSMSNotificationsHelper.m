#import "PBSMSNotificationsHelper.h"

#import "../include.h"
#import "PBSMSHelper.h"
#import "PBSMSNotification.h"
#import "PBSMSNotificationAction.h"
#import "PBSMSPebbleAction.h"

@interface PBSMSNotificationsHelper ()

@property (nonatomic, strong) NSMutableArray *mutableNotifications;
@property (nonatomic, strong) NSMutableArray *mutablePebbleActions;
@property (nonatomic, strong) NSMutableArray *mutableActionsToPerform;
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

- (NSSet *)appIdentifiers
{
	NSMutableSet *appIdentifiersSet = [NSMutableSet set];

	for (PBSMSNotification *notification in self.mutableNotifications)
	{
		[appIdentifiersSet addObject:notification.appIdentifier];
	}

	return [appIdentifiersSet copy];
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

    [notificationsArr writeToFile:notificationsFileLocation atomically:YES];
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

	[self saveNotifications];
}

- (void)savePebbleAction:(PBSMSPebbleAction *)action
{
	[self.mutablePebbleActions addObject:action];

	[self savePebbleActions];
}

- (void)loadPebbleActions
{
	NSMutableArray *arr = [NSMutableArray arrayWithContentsOfFile:pebbleActionsFileLocation];

	if (!arr)
	{
		return;
	}

	[self.mutablePebbleActions removeAllObjects];
	for (id object in arr)
	{
		PBSMSPebbleAction *action = [PBSMSPebbleAction deserializeFromObject:object];
		if (action)
		{
			[self.mutablePebbleActions addObject:action];
		}
	}
}

- (void)savePebbleActions
{
	NSMutableArray *actionsArr = [NSMutableArray array];

	for (PBSMSPebbleAction *action in self.mutablePebbleActions)
	{
		[actionsArr addObject:[action serializeToDictionary]];
	}

    [actionsArr writeToFile:pebbleActionsFileLocation atomically:YES];
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

- (void)saveActionToPerform:(PBSMSPebbleAction *)action
{
	[self.mutableActionsToPerform addObject:action];
	[self saveActionsToPerform];
}

- (void)removeActionToPerform:(PBSMSPebbleAction *)action
{
	[self.mutableActionsToPerform removeObject:action];
	[self saveActionsToPerform];
}

- (void)loadActionsToPerform
{
	NSMutableArray *arr = [NSMutableArray arrayWithContentsOfFile:actionsToPerformFileLocation];

	if (!arr)
	{
		return;
	}

	[self.mutableActionsToPerform removeAllObjects];
	for (id object in arr)
	{
		PBSMSPebbleAction *action = [PBSMSPebbleAction deserializeFromObject:object];
		if (action && ![action isExpired])
		{
			[self.mutableActionsToPerform addObject:action];
		}
	}
	log(@"loadActionsToPerform %@", self.mutableActionsToPerform);
}

- (void)saveActionsToPerform
{
	NSMutableArray *actionsArr = [NSMutableArray array];

	for (PBSMSPebbleAction *action in self.mutableActionsToPerform)
	{
		if (![action isExpired])
		{
			[actionsArr addObject:[action serializeToDictionary]];
		}
	}
	log(@"saveActionsToPerform %@", actionsArr);

    [actionsArr writeToFile:actionsToPerformFileLocation atomically:YES];
}

- (NSArray *)actionsToPerform
{
	return [self.mutableActionsToPerform copy];
}

- (BOOL)performAction:(PBSMSPebbleAction *)action
{
	BOOL success = NO;
	log(@"performAction");
	[[PBSMSNotificationsHelper sharedHelper] loadActionsToPerform];
    NSArray *actionsToPerform = [[PBSMSNotificationsHelper sharedHelper] actionsToPerform];

	for (PBSMSPebbleAction *action in actionsToPerform)
	{
		BBBulletin *bulletin = [self.bulletins objectForKey:action.bulletinIdentifier];
		NSLog(@"OHYESHERE %@", bulletin);
		if (bulletin)
		{
			for (BBAction *action in [bulletin supplementaryActionsForLayout:1])
			{
				if ([[action identifier] isEqualToString:actionID])
				{
					BBResponse *response = [bulletin responseForAction:action];
					if (response)
					{
						NSLog(@"%@", response);
						if (action.isReplyAction)
						{
							NSDictionary *dict = @{ @"UIUserNotificationActionResponseTypedTextKey" : action.replyText };
							NSDictionary *finalDict = @{ @"userResponseInfo" : dict };
							[response setContext:finalDict];
						}

						SBBulletinBannerController *bannerController = [%c(SBBulletinBannerController) sharedInstance];
						NSLog(@"bannerController %@", bannerController);
						if (bannerController)
						{
							id observer = MSHookIvar<id>(bannerController, "_observer");
							if (observer)
							{
								NSLog(@"observer %@", observer);
								if ([observer isKindOfClass:%c(BBObserver)])
								{
									BBObserver *bbObserver = (BBObserver *)observer;
									[observer sendResponse:response];
									NSLog(@"SENT RESPONSE");
									[self removeActionToPerform:action];
									success = YES;
								}
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