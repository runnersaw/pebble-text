#import <CoreTelephony/CTMessageCenter.h>
#import <ChatKit/CKEntity.h>
#import <ChatKit/CKConversation.h>
#import <ChatKit/CKConversationList.h>
#import <ChatKit/CKComposition.h>
#import <AddressBook/AddressBook.h>
#import <AppSupport/CPDistributedMessagingCenter.h>
#import <UIKit/UIApplication.h>
#import "rocketbootstrap.h"

static NSString *bundleId = @"com.sawyervaughan.pebblesms";
static NSString *messageNotificationString = @"com.sawyervaughan.pebblesms-messageNeedsSending";

static _Bool autolaunchEnabled = YES;
static int maxContacts = 5;

// recent contacts
static NSMutableArray *names = [NSMutableArray array];
static NSMutableArray *phones = [NSMutableArray array];

@interface NSUserDefaults (PebbleSMS)
- (id)objectForKey:(NSString *)key inDomain:(NSString *)domain;
- (void)setObject:(id)value forKey:(NSString *)key inDomain:(NSString *)domain;
@end

static void loadRecentRecipients() {
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.sawyervaughan.pebblesms.plist"];

    [names removeAllObjects];
    [phones removeAllObjects];

    for (int i=0; i<maxContacts; i++) {
        NSString *name = [dict objectForKey:[NSString stringWithFormat:@"name%d", i]];
        NSString *phone = [dict objectForKey:[NSString stringWithFormat:@"phone%d", i]];

        if (name != nil && phone != nil) {
            [names addObject:name];
            [phones addObject:phone];
        }
    }
}

static void saveRecentRecipient(NSString *name, NSString *phone) {
    if (![names containsObject:name] && ![phones containsObject:phone]) {
        [names insertObject:name atIndex:0];
        while ([names count] > 5) {
            [names removeLastObject];
        }

        [phones insertObject:phone atIndex:0];
        while ([phones count] > 5) {
            [phones removeLastObject];
        }

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

        for (int i=0; i<[names count]; i++) {
            NSString *name = [names objectAtIndex:i];
            NSString *phone = [phones objectAtIndex:i];

            [defaults setObject:name forKey:[NSString stringWithFormat:@"name%d", i] inDomain:bundleId];
            [defaults setObject:phone forKey:[NSString stringWithFormat:@"phone%d", i] inDomain:bundleId];
        }

        [defaults synchronize];
    }
}

@interface UIApplication (PebbleSMS)

+(id)sharedApplication;
-(BOOL)launchApplicationWithIdentifier:(id)arg1 suspended:(BOOL)arg2;

@end

static void openMessages() {
    [[UIApplication sharedApplication] launchApplicationWithIdentifier:@"com.apple.MobileSMS" suspended:YES];
}
 
%ctor {

    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)openMessages, (CFStringRef)messageNotificationString, NULL, CFNotificationSuspensionBehaviorCoalesce);

}

%hook SpringBoard

- (void)applicationDidFinishLaunching:(id)application {

    %orig;
    
    if (autolaunchEnabled) {
        NSLog(@"PEBBLESMS: Autolaunched");
        [[UIApplication sharedApplication] launchApplicationWithIdentifier:@"com.sawyervaughan.PebbleSMS" suspended:YES];
    }

}

%end

@interface SMSApplication : UIApplication

- (_Bool)application:(id)arg1 didFinishLaunchingWithOptions:(id)arg2;
- (void)sendMessageTo:(NSString *)number withText:(NSString *)text;
- (void)handleMessageNamed:(NSString *)name withUserInfo:(NSDictionary *)userinfo;
- (void)handleSimpleMessageNamed:(NSString *)name;
@end

%hook SMSApplication 

- (_Bool)application:(id)arg1 didFinishLaunchingWithOptions:(id)arg2 {

    BOOL s = %orig;

    // register to recieve notifications when messages need to be sent
    CPDistributedMessagingCenter *c = [%c(CPDistributedMessagingCenter) centerNamed:@"com.sawyervaughan.pebblesms"];
    rocketbootstrap_distributedmessagingcenter_apply(c);
    [c runServerOnCurrentThread];
    [c registerForMessageName:@"messageWithInfo" target:self selector:@selector(handleMessageNamed:withUserInfo:)];

    return s;
}

%new
- (void)sendMessageTo:(NSString *)number withText:(NSString *)text {
    //Get the conversation
    CKConversationList *conversationList = [CKConversationList sharedConversationList];
    CKConversation *conversation = [conversationList conversationForExistingChatWithGroupID:number];

    //Make a new composition
    NSAttributedString* t = [[NSAttributedString alloc] initWithString:text];
    CKComposition* composition = [[CKComposition alloc] initWithText:t subject:nil];

    // make message and send
    CKMessage *message = (CKMessage *)[conversation messageWithComposition:composition];
    [conversation sendMessage:message newComposition:YES];
}
 
%new
- (void)handleMessageNamed:(NSString *)name withUserInfo:(NSDictionary *)userinfo {
    // Process userinfo (simple dictionary) and send message
    NSString *recipient = [userinfo objectForKey:@"recipient"];
    NSString *message = [userinfo objectForKey:@"message"];

    [self sendMessageTo:recipient withText:message];
}

%end

@interface IMMessage

- (NSDate *)timeDelivered;

@end

@interface IMHandle

-(id)_formattedPhoneNumber;
-(id)fullName;
-(id)phoneNumberRef;

@end

@interface IMChat

-(NSArray *)participants;
-(IMHandle *)recipient;
-(IMMessage *)lastMessage;
- (void)_postNotification:(id)arg1 userInfo:(id)arg2;
- (void)_postNotification:(id)arg1 userInfo:(id)arg2 shouldLog:(BOOL)arg3;

@end

@interface CKConversation (PebbleSMS)

- (void)saveRecipient;

@end

%hook CKConversation

- (void)sendMessage:(id)arg1 onService:(id)arg2 newComposition:(BOOL)arg3 {
    %orig;
    [self saveRecipient];
}

%new
- (void)saveRecipient {

    if ([[self handles] count] == 1) {
        IMHandle *handle = (IMHandle *)[[self handles] objectAtIndex:0];
        NSString *phone = (NSString *)[[handle phoneNumberRef] description];
        NSString *name = (NSString *)[handle fullName];
        saveRecentRecipient(name, phone);
    }

}

%end

@interface SMSSender : NSObject

- (void)sendSMS:(NSString *)number withText:(NSString *)text;

@end

%hook SMSSender

- (void)sendSMS:(NSString *)number withText:(NSString *)text {

    // launch messages
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)messageNotificationString, nil, nil, YES);

    // do original stuff
    %orig;

    // send message after 5 seconds
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CPDistributedMessagingCenter *c = [%c(CPDistributedMessagingCenter) centerNamed:@"com.sawyervaughan.pebblesms"];
        rocketbootstrap_distributedmessagingcenter_apply(c);
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:text, @"message", number, @"recipient", nil];
        [c sendMessageName:@"messageWithInfo" userInfo:dict]; 
    });

}

%end

@interface PSMSRecentContactHandler : NSObject

- (NSMutableArray *)getRecentNames;
- (NSMutableArray *)getRecentPhones;

@end

%hook PSMSRecentContactHandler

- (NSMutableArray *)getRecentNames {
    loadRecentRecipients();

    NSMutableArray *arr = [NSMutableArray array];
    [arr addObjectsFromArray:names];
    return arr;
}

- (NSMutableArray *)getRecentPhones {
    loadRecentRecipients();

    NSMutableArray *arr = [NSMutableArray array];
    [arr addObjectsFromArray:phones];
    return arr;
}

%end

@interface IMDaemonListener

- (void)account:(id)arg1 chat:(id)arg2 style:(unsigned char)arg3 chatProperties:(id)arg4 messageReceived:(id)arg5;

@end

@interface IMMessageItem : NSObject

-(id)sender;
-(BOOL)isFromMe;

@end

%hook IMDaemonListener

- (void)account:(id)arg1 chat:(id)arg2 style:(unsigned char)arg3 chatProperties:(id)arg4 messageReceived:(id)arg5 {
    if ([arg5 isKindOfClass:[IMMessageItem class]]) {
        NSString *sender = [(IMMessageItem *)arg5 sender];
        if (![arg5 isFromMe]) {
            CKConversationList *conversationList = [CKConversationList sharedConversationList];
            CKConversation *conversation = [conversationList conversationForExistingChatWithGroupID:sender];
            [conversation saveRecipient];
        }
    }
    %orig;
}

%end