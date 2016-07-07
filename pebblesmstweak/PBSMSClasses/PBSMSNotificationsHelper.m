

@implementation PBSMSNotificationsHelper : NSObject

@property (nonatomic, copy) NSArray *notifications;

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

// Action handling
- (void)saveActionToPerform:(PBSMSNotificationAction *)action;
- (NSArray *)actionsToPerform:

@end