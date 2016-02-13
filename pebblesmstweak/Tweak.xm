#import <CoreTelephony/CTMessageCenter.h>
#import <ChatKit/CKEntity.h>
#import <ChatKit/CKConversation.h>
#import <ChatKit/CKConversationList.h>
#import <ChatKit/CKComposition.h>
#import <AddressBook/AddressBook.h>
#import <AppSupport/CPDistributedMessagingCenter.h>
#import <UIKit/UIApplication.h>
#import "rocketbootstrap.h"

@interface UIApplication (PebbleSMS)

+(id)sharedApplication;
-(BOOL)launchApplicationWithIdentifier:(id)arg1 suspended:(BOOL)arg2;

@end

//static NSString *bundleId = @"com.sawyervaughan.pebblesms";
static NSString *messageNotificationString = @"com.sawyervaughan.pebblesms-messageNeedsSending";

static void loadPrefs() {
    NSLog(@"PEBBLESMS: com.sawyervaughan.pebblesms-messageNeedsSending");
    // delete message.plist so it only sends once
    [[UIApplication sharedApplication] launchApplicationWithIdentifier:@"com.apple.MobileSMS" suspended:YES];
}
 
%ctor {

    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, (CFStringRef)messageNotificationString, NULL, CFNotificationSuspensionBehaviorCoalesce);

}

@interface SMSApplication : UIApplication

- (_Bool)application:(id)arg1 didFinishLaunchingWithOptions:(id)arg2;
- (void)sendMessageTo:(NSString *)number withText:(NSString *)text;
- (void)handleMessageNamed:(NSString *)name withUserInfo:(NSDictionary *)userinfo;
- (void)handleSimpleMessageNamed:(NSString *)name;
@end

%hook SMSApplication 

- (_Bool)application:(id)arg1 didFinishLaunchingWithOptions:(id)arg2 {

    BOOL s = %orig;

    NSLog(@"PEBBLESMS: Registering for message");
    CPDistributedMessagingCenter *c = [%c(CPDistributedMessagingCenter) centerNamed:@"com.sawyervaughan.pebblesms"];
    rocketbootstrap_distributedmessagingcenter_apply(c);
    [c runServerOnCurrentThread];
    [c registerForMessageName:@"messageWithInfo" target:self selector:@selector(handleMessageNamed:withUserInfo:)];

    return s;
}

%new
- (void)sendMessageTo:(NSString *)number withText:(NSString *)text {
    //Get the shared conversation list
    CKConversationList *conversationList = [CKConversationList sharedConversationList];
    //Get the conversation for an address
    CKConversation *conversation = [conversationList conversationForExistingChatWithGroupID:number];

    //Make a new composition
    NSAttributedString* t = [[NSAttributedString alloc] initWithString:text];
    CKComposition* composition = [[CKComposition alloc] initWithText:t subject:nil];

    //A new message from the composition
    CKMessage *message = (CKMessage *)[conversation messageWithComposition:composition];
    //And finally, send the message in the conversation
    [conversation sendMessage:message newComposition:YES];
    NSLog(@"PEBBLESMS: SENDING MESSAGE MAYBE TO %@ WITH %@", number, text);
}
 
%new
- (void)handleMessageNamed:(NSString *)name withUserInfo:(NSDictionary *)userinfo {
    // Process userinfo (simple dictionary) and return a dictionary (or nil)
    NSLog(@"PEBBLESMS: handleMessageNamed");

    NSString *recipient = [userinfo objectForKey:@"recipient"];
    NSString *message = [userinfo objectForKey:@"message"];

    [self sendMessageTo:recipient withText:message];
}
%end

@interface SMSSender : NSObject

- (void)sendSMS:(NSString *)number withText:(NSString *)text;

@end

%hook SMSSender

- (void)sendSMS:(NSString *)number withText:(NSString *)text {
    NSLog(@"PEBBLESMS: Hooked into APP!");

    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)messageNotificationString, nil, nil, YES);

    %orig;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CPDistributedMessagingCenter *c = [%c(CPDistributedMessagingCenter) centerNamed:@"com.sawyervaughan.pebblesms"];
        rocketbootstrap_distributedmessagingcenter_apply(c);
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:text, @"message", number, @"recipient", nil];
        [c sendMessageName:@"messageWithInfo" userInfo:dict]; //send an NSDictionary here to pass data
        NSLog(@"PEBBLESMS: Sent message 4");
    });

}

%end