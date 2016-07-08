#import "PBSMSHelper.h"

#import <objc/runtime.h>
#import "../include.h"

NSString * const sendMessageCommand = @"messageNeedsSending";
NSString * const openMessagesCommand = @"messagesNeedsOpening";
NSString * const performNotificationActionCommand = @"performNotificationAction";
NSString * const messageSendNotification = @"pebbleMessageSend";
NSString * const messageFailedNotification = @"pebbleMessageFailed";

NSString * const rocketbootstrapSmsCenterName = @"com.sawyervaughan.pebblesms.sms";
NSString * const rocketbootstrapSpringboardCenterName = @"com.sawyervaughan.pebblesms.springboard";
NSString * const distributedCenterName = @"com.sawyervaughan.pebblesms.pebble";

NSString * const notificationsFileLocation = @"/var/mobile/Library/Preferences/com.sawyervaughan.pebblesms.notifications.plist";
NSString * const actionsToPerformFileLocation = @"/var/mobile/Library/Preferences/com.sawyervaughan.pebblesms.perform-action.plist";
NSString * const messagesFileLocation = @"/var/mobile/Library/Preferences/com.sawyervaughan.pebblesms.messages.plist";
NSString * const recentFileLocation = @"/var/mobile/Library/Preferences/com.sawyervaughan.pebblesms.recent.plist";

@implementation PBSMSHelper : NSObject

+ (void)dumpMethods:(Class)c
{
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
}

+ (NSArray *)installedApplications
{
    log(@"%@", [[ALApplicationList sharedApplicationList] applications];
    return [NSArray array];
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