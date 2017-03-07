#import "PBSMSHelper.h"

#import <objc/runtime.h>
#import "../include.h"

NSString * const sendMessageCommand = @"messageNeedsSending";
NSString * const openMessagesCommand = @"messagesNeedsOpening";
NSString * const performNotificationActionCommand = @"performNotificationAction";
NSString * const messageSendNotification = @"pebbleMessageSend";
NSString * const messageFailedNotification = @"pebbleMessageFailed";
NSString * const bulletinAddedNotification = @"bulletinAddedNotification";
NSString * const bulletinRemovedNotification = @"bulletinRemovedNotification";
NSString * const notificationSourcesDeletedNotification = @"notificationSourcesDeleted";

NSString * const activeBulletinIdKey = @"activeBulletinIdKey";

NSString * const rocketbootstrapSmsCenterName = @"com.sawyervaughan.pebblesms.sms";
NSString * const rocketbootstrapSpringboardCenterName = @"com.sawyervaughan.pebblesms.springboard";
NSString * const distributedCenterName = @"com.sawyervaughan.pebblesms.pebble";

NSString * const notificationsFileLocation = @"/var/mobile/Library/Preferences/com.sawyervaughan.pebblesms.notifications.plist";
NSString * const enabledAppsFileLocation = @"/var/mobile/Library/Preferences/com.sawyervaughan.pebblesms.enabled-apps.plist";
NSString * const pebbleActionsFileLocation = @"/var/mobile/Library/Preferences/com.sawyervaughan.pebblesms.pebble-actions.plist";
NSString * const actionsToPerformFileLocation = @"/var/mobile/Library/Preferences/com.sawyervaughan.pebblesms.perform-actions.plist";
NSString * const messagesFileLocation = @"/var/mobile/Library/Preferences/com.sawyervaughan.pebblesms.messages.plist";
NSString * const recentFileLocation = @"/var/mobile/Library/Preferences/com.sawyervaughan.pebblesms.recent.plist";
NSString * const needsDeleteNotificationSourcesFileLocation = @"/var/mobile/Library/Preferences/com.sawyervaughan.pebblesms.needs-delete.plist";

@interface PBSMSHelper ()

@property (nonatomic, strong) NSArray *applicationsArray;

@end

@implementation PBSMSHelper : NSObject

+ (id)sharedHelper {
    static PBSMSHelper *sharedHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedHelper = [[self alloc] init];
    });
    return sharedHelper;
}

+ (void)dumpMethods:(Class)c
{
#if PBSMS_DEBUG
    unsigned int methodCount = 0;
    Method *methods = class_copyMethodList(c, &methodCount);

    log(@"Found %d methods on '%s'\n", methodCount, class_getName(c));

    for (unsigned int i = 0; i < methodCount; i++) {
        Method method = methods[i];

        log(@"\t'%s' has method named '%s' of encoding '%s'\n",
            class_getName(c),
            sel_getName(method_getName(method)),
            method_getTypeEncoding(method));
    }

    free(methods);
#endif
}

- (NSArray *)installedApplications
{
    if (!self.applicationsArray)
    {
        NSDictionary *dict = [[ALApplicationList sharedApplicationList] applications];
        self.applicationsArray = [dict allKeys];
    }
    return self.applicationsArray;
}

@end

@implementation NSDictionary (PBSMS)

- (id)safeObjectForKey:(id)key ofType:(Class)type
{
	id object = [self objectForKey:key];
	if (!object || ![object isKindOfClass:type])
	{
		return nil;
	}
	return object;
}

@end