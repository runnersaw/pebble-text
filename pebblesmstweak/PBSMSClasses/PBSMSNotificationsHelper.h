

#import "../include.h"
#import "PBSMSNotification.h"
#import "PBSMSNotificationAction.h"
#import "PBSMSPebbleAction.h"

@interface PBSMSNotificationsHelper : NSObject

@property (nonatomic, readonly) NSArray *notifications;
@property (nonatomic, readonly) NSArray *pebbleActions;

+ (PBSMSNotificationsHelper *)sharedHelper;

// Notifications
- (NSSet *)appIdentifiers;

// Notification handling
- (NSArray *)notificationsForAppIdentifier:(NSString *)appIdentifier;
- (PBSMSNotification *)notificationForBulletinId:(NSString *)bulletinId;
- (void)loadNotifications;
- (void)saveNotifications;
- (void)saveNotificationForBulletin:(BBBulletin *)bulletin;

// Saving Pebble Actions
// - (void)savePebbleAction:(PBSMSPebbleAction *)action;
// - (void)loadPebbleActions;
// - (void)savePebbleActions;
// - (PBSMSPebbleAction *)pebbleActionForPebbleActionId:(NSNumber *)pebbleActionId;

// // Action handling
// - (void)saveActionToPerform:(PBSMSNotificationAction *)action;
// - (NSArray *)actionsToPerform;

@end