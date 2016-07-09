

#import "../include.h"
#import "PBSMSNotification.h"
#import "PBSMSNotificationAction.h"
#import "PBSMSPebbleAction.h"

@interface PBSMSNotificationsHelper : NSObject

@property (nonatomic, readonly) NSArray *notifications;
@property (nonatomic, readonly) NSArray *pebbleActions;
@property (nonatomic, readonly) NSArray *actionsToPerform;

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
- (void)savePebbleAction:(PBSMSPebbleAction *)action;
- (void)loadPebbleActions;
- (void)savePebbleActions;
- (PBSMSPebbleAction *)pebbleActionForPebbleActionId:(NSNumber *)pebbleActionId;
- (PBSMSPebbleAction *)pebbleActionForANCSIdentifier:(NSString *)ancsIdentifier;

// // Action handling
- (void)saveActionToPerform:(PBSMSPebbleAction *)action;
- (void)removeActionToPerform:(PBSMSPebbleAction *)action;
- (void)loadActionsToPerform;
- (void)saveActionsToPerform;
- (NSArray *)actionsToPerform;
- (BOOL)performAction:(PBSMSPebbleAction *)action;

@end