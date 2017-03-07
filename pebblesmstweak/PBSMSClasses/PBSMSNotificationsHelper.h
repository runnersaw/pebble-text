

#import "../include.h"
#import "PBSMSNotification.h"
#import "PBSMSNotificationAction.h"
#import "PBSMSPebbleAction.h"

@interface PBSMSNotificationsHelper : NSObject

@property (nonatomic, readonly) NSArray *notifications;
@property (nonatomic, readonly) NSArray *pebbleActions;
@property (nonatomic, readonly) NSSet *enabledApps;

+ (PBSMSNotificationsHelper *)sharedHelper;

- (void)setNeedsDeleteNotificationSources:(BOOL)needsDelete;

// Notification handling
- (NSArray *)notificationsForAppIdentifier:(NSString *)appIdentifier;
- (PBSMSNotification *)notificationForBulletinId:(NSString *)bulletinId;
- (void)loadEnabledApps;
- (void)loadNotifications;
- (void)saveNotifications;
- (void)saveNotificationForBulletin:(BBBulletin *)bulletin;
- (void)addActiveBulletinID:(NSString *)bulletinID;
- (void)removeActiveBulletinID:(NSString *)bulletinID;

// Saving Pebble Actions
- (void)savePebbleAction:(PBSMSPebbleAction *)action;
- (PBSMSPebbleAction *)pebbleActionForPebbleActionId:(NSNumber *)pebbleActionId;
- (PBSMSPebbleAction *)pebbleActionForANCSIdentifier:(NSString *)ancsIdentifier;
- (PBSMSPebbleAction *)pebbleActionForANCSIdentifier:(NSString *)ancsIdentifier test:(BOOL)test;

// // Action handling
- (BOOL)performAction:(PBSMSPebbleAction *)action;

@end