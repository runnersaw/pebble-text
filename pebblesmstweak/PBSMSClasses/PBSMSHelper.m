

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