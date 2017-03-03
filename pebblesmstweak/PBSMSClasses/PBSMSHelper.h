

//#define DEBUG 0

#define MAX_CONTACTS 10
#define MAX_CONTACTS_TO_SEND 10

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

extern NSString * const sendMessageCommand;
extern NSString * const openMessagesCommand;
extern NSString * const performNotificationActionCommand;
extern NSString * const messageSendNotification;
extern NSString * const messageFailedNotification;
extern NSString * const bulletinAddedNotification;
extern NSString * const bulletinRemovedNotification;
extern NSString * const notificationSourcesDeletedNotification;

extern NSString * const activeBulletinIdKey;

extern NSString * const rocketbootstrapSmsCenterName;
extern NSString * const rocketbootstrapSpringboardCenterName;
extern NSString * const distributedCenterName;

extern NSString * const notificationsFileLocation;
extern NSString * const enabledAppsFileLocation;
extern NSString * const pebbleActionsFileLocation;
extern NSString * const actionsToPerformFileLocation;
extern NSString * const messagesFileLocation;
extern NSString * const recentFileLocation;
extern NSString * const needsDeleteNotificationSourcesFileLocation;

#if DEBUG
	#define log( s, ... ) NSLog( @"<%@:%d> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__,  [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
	#define log( s, ... )
#endif

@interface PBSMSHelper : NSObject
+ (instancetype)sharedHelper;
+ (void)dumpMethods:(Class)c;
- (NSArray *)installedApplications;
@end

@interface NSDictionary (PBSMS)
- (id)safeObjectForKey:(id)key ofType:(Class)type;
@end
