

@interface PBSMSNotificationsHelper : NSObject

@property (nonatomic, copy) NSArray *notifications;

+ (PBSMSTextHelper *)sharedHelper;

// Notification handling
- (NSArray *)notificationsForAppIdentifier:(NSString *)appIdentifier;
- (void)loadNotifications;
- (void)saveNotifications;
- (void)saveNotification:(PBSMSNotification *)notification;

// Saving Pebble Actions
- (void)savePebbleAction

// Action handling
- (void)saveActionToPerform:(PBSMSNotificationAction *)action;
- (NSArray *)actionsToPerform:

@end