#import <objc/runtime.h>

#define DEBUG 1

#define SEND_DELAY 4.0
#define SECOND_SEND_DELAY 10.0
#define NOTIFICATION_DELAY 0.2
#define MESSAGE_SEND_TIMEOUT 20.0
#define HAS_ACTIONS_IDENTIFIER 30
#define DISMISS_IDENTIFIER HAS_ACTIONS_IDENTIFIER+1

#define DICTATED_NAME_KEY [NSNumber numberWithInt:0]
#define IS_CONTACT_CORRECT_KEY [NSNumber numberWithInt:1]
#define IS_NUMBER_CORRECT_KEY [NSNumber numberWithInt:2]
#define FINAL_MESSAGE_KEY [NSNumber numberWithInt:3]
#define STATE_KEY [NSNumber numberWithInt:4]
#define CONTACT_NAME_KEY [NSNumber numberWithInt:5]
#define CONTACT_NUMBER_KEY [NSNumber numberWithInt:6]
#define MESSAGE_CONFIRMATION_KEY [NSNumber numberWithInt:7]
#define ATTEMPT_NUMBER_KEY [NSNumber numberWithInt:8]
#define CONNECTION_TEST_KEY [NSNumber numberWithInt:9]
#define RECENT_CONTACTS_NAME_KEY [NSNumber numberWithInt:10]
#define RECENT_CONTACTS_NUMBER_KEY [NSNumber numberWithInt:11]
#define PRESETS_KEY [NSNumber numberWithInt:12]
#define RECIEVED_FINAL_MESSAGE_KEY [NSNumber numberWithInt:13]
#define CONTACT_NAMES_KEY [NSNumber numberWithInt:14]
#define CONTACT_NUMBERS_KEY [NSNumber numberWithInt:15]
#define CONTACT_IDS_KEY [NSNumber numberWithInt:16]
#define CONTACT_ID_KEY [NSNumber numberWithInt:17]
#define IS_PEBBLE_SMS_KEY [NSNumber numberWithInt:94375]

#define BEGINNING_STATE [NSNumber numberWithInt:0]
#define DICTATED_NAME_STATE [NSNumber numberWithInt:1]
#define CHECKING_CONTACT_STATE [NSNumber numberWithInt:2]
#define CREATING_FINAL_MESSAGE_STATE [NSNumber numberWithInt:3]
#define CONFIRMING_FINAL_MESSAGE_STATE [NSNumber numberWithInt:4]
#define FINAL_MESSAGE_STATE [NSNumber numberWithInt:5]
#define GETTING_RECENT_CONTACTS_STATE [NSNumber numberWithInt:6]
#define GETTING_PRESETS_STATE [NSNumber numberWithInt:7]
#define SENDING_FINAL_MESSAGE_STATE [NSNumber numberWithInt:8]

extern NSString *sendMessageCommand;
extern NSString *openMessagesCommand;
extern NSString *performNotificationActionCommand;
extern NSString *messageSendNotification;
extern NSString *messageFailedNotification;

extern NSString *rocketbootstrapSmsCenterName;
extern NSString *rocketbootstrapSpringboardCenterName;
extern NSString *distributedCenterName;

extern NSString *notificationsFileLocation;
extern NSString *actionsToPerformFileLocation;
extern NSString *messagesFileLocation;
extern NSString *recentFileLocation;

#ifdef DEBUG
	#define log( s, ... ) NSLog( @"<%@:%d> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__,  [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
	#define log( s, ... )
#endif

void dumpMethods(Class clz)
{
    unsigned int methodCount = 0;
    Method *methods = class_copyMethodList(clz, &methodCount);

    log(@"Found %d methods on '%s'\n", methodCount, class_getName(clz));

    for (unsigned int i = 0; i < methodCount; i++) {
        Method method = methods[i];

        log(@"\t'%s' has method named '%s' of encoding '%s'\n",
            class_getName(clz),
            sel_getName(method_getName(method)),
            method_getTypeEncoding(method));
    }

    free(methods);
}

#ifdef DEBUG
	#define dumpInstanceMethods( c ) dumpMethods(c)
	#define dumpClassMethods( c ) dumpMethods(object_getClass(c))
#else
	#define dumpInstanceMethods( c )
	#define dumpClassMethods( c )
#endif

@interface NSDictionary (PBSMS)
- (id)safeObjectForKey:(id)key ofType:(Class)type;
@end