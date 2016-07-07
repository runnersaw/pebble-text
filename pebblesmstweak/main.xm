#import <CoreTelephony/CTMessageCenter.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <ChatKit/CKEntity.h>
#import <ChatKit/CKConversation.h>
#import <ChatKit/CKConversationList.h>
#import <ChatKit/CKComposition.h>
#import <IMCore/IMPerson.h>
#import <IMCore/IMHandle.h>
#import <AddressBook/AddressBook.h>
#import <AppSupport/CPDistributedMessagingCenter.h>
#import <UIKit/UIApplication.h>
#import <substrate.h>
#import "rocketbootstrap.h"

// My headers

#import "PBSMSClasses/PBSMSHelper.h"
#import "PBSMSClasses/PBSMSNotification.h"
#import "PBSMSClasses/PBSMSNotificationAction.h"
#import "PBSMSClasses/PBSMSNotificationsHelper.h"
#import "PBSMSClasses/PBSMSRecentContactHelper.h"
#import "PBSMSClasses/PBSMSTextMessage.h"
#import "PBSMSClasses/PBSMSTextHelper.h"

// Include

#import "include.h"

@interface SMSApplication (PebbleSMS)
// new
- (void)sendMessagesForTextSender;
- (void)sendMessageForTextSender:(PBSMSTextMessage *)message;
- (void)sendMessageTo:(NSNumber *)personId number:(NSString *)number withText:(NSString *)text notify:(BOOL)notify;
- (void)sendMessageToNumber:(NSString *)number recordId:(NSNumber *)recordId withText:(NSString *)text notify:(BOOL)notify;
- (void)sendMessageToNewNumber:(NSString *)number withText:(NSString *)text notify:(BOOL)notify;
- (void)sendNewMessageTo:(NSNumber *)personId number:(NSString *)number withText:(NSString *)text notify:(BOOL)notify;
- (void)handleMessageNamed:(NSString *)name withUserInfo:(NSDictionary *)userinfo;
@end

@interface PBContact (PebbleSMS)
//new
+ (NSString *)phoneWithPrefix:(NSString *)number;
- (NSNumber *)recordId;
@end

@interface PBPhoneNumber (PebbleSMS)
// new
-(NSString *)getStringRepresentationForTextSender;
@end

@interface PBAddressBook (PebbleSMS)
// new
- (id)searchContacts:(NSString *)search tries:(int)tries;
- (id)searchContactsList:(NSString *)search tries:(int)tries;
- (id)contactWithPhoneNumber:(PBPhoneNumber *)phoneNumber;
- (id)contactWithPrefixedPhoneNumber:(NSString *)phoneNumber;
@end

@interface PBWatch (PebbleSMS)
// new
- (NSMutableDictionary *)getContactSearchResponse:(NSString *)name tries:(int)tries;
- (NSMutableDictionary *)getSentResponse;
- (NSMutableDictionary *)getFailedResponse;
- (NSMutableDictionary *)getFinalRecievedResponse;
- (NSMutableDictionary *)getConnectionResponse;
- (NSMutableDictionary *)getRecentContactsResponse;
- (NSMutableDictionary *)getPresets;
+ (void)sendSMS:(NSNumber *)recordId number:(NSString *)number withText:(NSString *)text;
@end

@interface PBAppDelegate (PebbleSMS)
// new
+ (NSNumber *)majorAppVersion;
+ (NSNumber *)minorAppVersion;
@end

@interface PBSMSSessionManager (PebbleSMS)
// new
+ (void)sendSMS:(NSString *)number withText:(NSString *)text;
@end

@interface PBSMSApiClient (PebbleSMS)
// new
+ (void)sendSMS:(NSNumber *)recordId number:(NSString *)number withText:(NSString *)text;
@end

@interface PBANCSActionHandler (PebbleSMS)
// new
+ (void)performAction:(NSString *)actionID forBulletinID:(NSString *)bulletinID;
+ (void)performReply:(NSString *)reply forAction:(NSString *)actionID andBulletinID:(NSString *)bulletinID;
+ (NSString *)bulletinIdentifierForInvokeANCSMessage:(PBTimelineInvokeANCSActionMessage *)message;
@end

@interface PBNotificationSource (PebbleSMS)
// new
+ (PBNotificationSource *)notificationSourceWithAddedActionsFromNotificationSource:(PBNotificationSource *)orig;
@end

static NSUUID *appUUID = [[NSUUID alloc] initWithUUIDString:@"36BF8B7A-A043-4E1B-8518-B6BB389EC110"];

static NSNumber *currentContactId = NULL;
static BOOL isRecentContact = NO;


static long long currentNumber = HAS_ACTIONS_IDENTIFIER + 2;

static NSMutableArray *actionsToPerform = [NSMutableArray array];
static NSMutableArray *appsArray = [NSMutableArray array];

static NSMutableDictionary *actionsToPerformDictionary = [NSMutableDictionary dictionary];
static NSMutableDictionary *bulletinsDict = [NSMutableDictionary dictionary];

static void loadActionsToPerform()
{
	NSArray *arr = [NSArray arrayWithContentsOfFile:actionsToPerformFileLocation];

	if (arr)
	{
		[actionsToPerform setArray:arr];
	}
}

static void saveActionToPerform(NSString *actionID, NSString *bulletinID, BOOL isReply, NSString *replyText)
{
	loadActionsToPerform();

	NSDictionary *dict = @{ @"actionID" : actionID, 
							@"bulletinID" : bulletinID,
							@"isReply" : @( isReply ),
							@"replyText" : replyText };
	[actionsToPerform addObject:dict];

	[actionsToPerform writeToFile:actionsToPerformFileLocation atomically:NO];
}

static void removeActionsToPerform()
{
	[actionsToPerform setArray:[NSArray array]];
}

static void removeActionToPerform(NSString *actionID, NSString *bulletinID)
{
	loadActionsToPerform();

	for (int i=[actionsToPerform count]-1;i>=0;i--)
	{
		NSDictionary *dict = [actionsToPerform objectAtIndex:i];
		if ([(NSString *)[dict objectForKey:@"actionID"] isEqualToString:actionID])
		{
			if ([(NSString *)[dict objectForKey:@"bulletinID"] isEqualToString:bulletinID])
			{
				[actionsToPerform removeObjectAtIndex:i];
			}
		}
	}
	[bulletinsDict removeObjectForKey:bulletinID];

	[actionsToPerform writeToFile:actionsToPerformFileLocation atomically:YES];
}

// LEVENSCHTEIN

@implementation NSString (Levenshtein)

// default match: 0
// default cost: 1

// calculate the mean distance between all words in stringA and stringB
- (CGFloat) compareWithString: (NSString *)stringB matchGain:(NSInteger)gain missingCost:(NSInteger)cost
{
    CGFloat averageSmallestDistance = 0.0;
    CGFloat smallestDistance;
    
    NSString *mStringA = [self stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    NSString *mStringB = [stringB stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    
    NSArray *arrayA = [mStringA componentsSeparatedByString: @" "];
    NSArray *arrayB = [mStringB componentsSeparatedByString: @" "];
    
    for (NSString *tokenA in arrayA)
	{
        smallestDistance = 99999999.0;
        
        for (NSString *tokenB in arrayB)
		{
            smallestDistance = MIN((CGFloat) [tokenA compareWithWord:tokenB matchGain:gain missingCost:cost], smallestDistance);
        }
        
        averageSmallestDistance += smallestDistance;
    }
    
    return averageSmallestDistance / (CGFloat) [arrayA count];
}


// calculate the distance between two string treating them eash as a single word
- (NSInteger) compareWithWord:(NSString *)stringB matchGain:(NSInteger)gain missingCost:(NSInteger)cost
{
    // normalize strings
    NSString * stringA = [NSString stringWithString: self];
    stringA = [[stringA stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
    stringB = [[stringB stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];    
    
    // Step 1
    NSInteger k, i, j, change, *d, distance;
    
    NSUInteger n = [stringA length];
    NSUInteger m = [stringB length];    
    
    if( n++ != 0 && m++ != 0 )
	{
        d = (NSInteger *)malloc( sizeof(NSInteger) * m * n );
        
        // Step 2
        for( k = 0; k < n; k++)
        {
            d[k] = k;
        }
        
        for( k = 0; k < m; k++)
        {
            d[k * n] = k;
        }
        
        // Step 3 and 4
        for(i=1; i < n; i++)
		{
            for(j=1; j < m; j++)
			{
                
                // Step 5
                if([stringA characterAtIndex: i-1] == [stringB characterAtIndex: j-1])
				{
                    change = -gain;
                }
                else
				{
                    change = cost;
                }
                
                // Step 6
                d[j * n + i] = MIN(d[(j - 1)*n + i] + 1, MIN(d[j*n + i - 1] + 1, d[(j - 1)*n + i - 1] + change));
            }
        }
        
        distance = d[ n * m - 1 ];
        free(d);
        return distance;
    }
    
    return 0;
}

@end

%group SpringboardHooks

%hook SpringBoard

- (void)applicationDidFinishLaunching:(id)application
{
    %orig;

    // register to recieve notifications when messages need to be sent
    CPDistributedMessagingCenter *c = [%c(CPDistributedMessagingCenter) centerNamed:rocketbootstrapSpringboardCenterName];
    rocketbootstrap_distributedmessagingcenter_apply(c);
    [c runServerOnCurrentThread];
    [c registerForMessageName:openMessagesCommand target:self selector:@selector(messagesMessageNamed:withUserInfo:)];
    [c registerForMessageName:performNotificationActionCommand target:self selector:@selector(notificationsMessageNamed:withUserInfo:)];
}
 
%new
- (void)messagesMessageNamed:(NSString *)name withUserInfo:(NSDictionary *)userinfo
{
    [[%c(UIApplication) sharedApplication] launchApplicationWithIdentifier:@"com.apple.MobileSMS" suspended:YES];
}

%new
- (void)notificationsMessageNamed:(NSString *)name withUserInfo:(NSDictionary *)userinfo
{
	log(@"notificationsMessageNamed");
	loadActionsToPerform();
	// NSLog(@"%@", actionsToPerform);
	// NSLog(@"%@", bulletinsDict);
    NSLog(@"Saved, %@", bulletinsDict);

	for (NSDictionary *dict in actionsToPerform)
	{
		NSString *bulletinID = [dict objectForKey:@"bulletinID"];
		NSString *actionID = [dict objectForKey:@"actionID"];
		BOOL isReply = [(NSNumber *)dict[@"isReply"] boolValue];
		NSString *replyText = dict[@"replyText"];

		if (bulletinID && actionID)
		{
			BBBulletin *bulletin = [bulletinsDict objectForKey:bulletinID];
			NSLog(@"OHYESHERE %@", bulletin);
			if (bulletin)
			{
				for (BBAction *action in [bulletin supplementaryActionsForLayout:1])
				{
					if ([[action identifier] isEqualToString:actionID])
					{
						BBResponse *response = [bulletin responseForAction:action];
						if (response)
						{
							NSLog(@"%@", response);
							if (isReply)
							{
								NSDictionary *dict = @{ @"UIUserNotificationActionResponseTypedTextKey" : replyText };
								NSDictionary *finalDict = @{ @"userResponseInfo" : dict };
								[response setContext:finalDict];
							}
							// removeActionToPerform(actionID, bulletinID);

							SBBulletinBannerController *bannerController = [%c(SBBulletinBannerController) sharedInstance];
							NSLog(@"bannerController %@", bannerController);
							if (bannerController)
							{
								id observer = MSHookIvar<id>(bannerController, "_observer");
								if (observer)
								{
									NSLog(@"observer");
									NSLog(@"observer2 %@", observer);
									if ([observer isKindOfClass:%c(BBObserver)])
									{
										BBObserver *bbObserver = (BBObserver *)observer;
										NSLog(@"observer3 %@", bbObserver);
										[observer sendResponse:response];
										NSLog(@"SENT RESPONSE");
										removeActionToPerform(actionID, bulletinID);
									}
								}
							}
						}
					}
				}
			}
		}
	}
}

%end

%hook BBBulletin

+ (id)addBulletinToCache:(id)arg1
{
    id r = %orig; 
    if (![r isMemberOfClass:%c(BBBulletinRequest)])
	{
    	[[PBSMSNotificationsHelper sharedHelper] saveNotificationForBulletin:[%c(BBBulletin) bulletinWithBulletin:(BBBulletin *)r]];
    }
    return r; 
}

%end

%end

// MOBILESMS TWEAKING

%group MobileSMSHooks

%hook SMSApplication 

- (BOOL)application:(id)arg1 didFinishLaunchingWithOptions:(id)arg2
{
    BOOL s = %orig;

    [self sendMessagesForTextSender];

    // register to recieve notifications when messages need to be sent
    CPDistributedMessagingCenter *c = [%c(CPDistributedMessagingCenter) centerNamed:rocketbootstrapSmsCenterName];
    rocketbootstrap_distributedmessagingcenter_apply(c);
    [c runServerOnCurrentThread];
    [c registerForMessageName:sendMessageCommand target:self selector:@selector(handleMessageNamed:withUserInfo:)];

    return s;
}
 
%new
- (void)handleMessageNamed:(NSString *)name withUserInfo:(NSDictionary *)userinfo
{
    log(@"handleMessageNamed %@", [userinfo description]);
    if ([name isEqualToString:sendMessageCommand])
	{
        [self sendMessagesForTextSender];
    }
}

%new
- (void)sendMessageForTextSender:(PBSMSTextMessage *)message
{
	log(@"sendMessageForTextSender %@", message);
    if (message.isRecentContact && !message.isReply)
	{
        [self sendMessageToNumber:message.number recordId:message.recordId withText:message.messageText notify:message.shouldNotify];
    }
    else
	{
        [self sendMessageTo:message.recordId number:message.number withText:message.messageText notify:message.shouldNotify];
    }

    [[PBSMSTextHelper sharedHelper] removeMessage:message];
}

%new
- (void)sendMessagesForTextSender
{
	log(@"sendMessagesForTextSender");
	NSArray *messages = [[PBSMSTextHelper sharedHelper] messages];
    for (PBSMSTextMessage *message in messages)
	{
		[self sendMessageForTextSender:message];
    }
}

%new
- (void)sendMessageTo:(NSNumber *)personId number:(NSString *)number withText:(NSString *)text notify:(BOOL)notify
{
    IMPerson *person = [[IMPerson alloc] initWithABRecordID:(ABRecordID)[personId intValue]];
    NSArray *handles = [%c(IMHandle) imHandlesForIMPerson:person];

    NSString *finalPhone = NULL;
    int highestCount = 0;
    for (int i=0;i<[handles count];i++)
	{
        IMHandle *h = [handles objectAtIndex:i];

        if ([h phoneNumberRef] != NULL)
		{
            NSString *p = [NSMutableString stringWithString:[[h phoneNumberRef] description]];
            NSString *phone = [@"+" stringByAppendingString:[[p componentsSeparatedByCharactersInSet: [[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""]];

            if ([phone isEqualToString:number])
			{
                finalPhone = [NSMutableString stringWithString:phone];
                break;
            }

            int iterate = MIN([phone length], [number length]);
            int i;
            for (i=0;i<iterate; i++)
			{
                int phoneIndex = [phone length] - i - 1;
                int numberIndex = [number length] - i - 1;
                if ([phone characterAtIndex:phoneIndex] != [number characterAtIndex:numberIndex])
				{
                    break;
                }
            }
            if (i>highestCount)
			{
                highestCount = i;
                finalPhone = [NSMutableString stringWithString:phone];
            }
        }
    }
    log(@"finalPhone %@", finalPhone);

    if (finalPhone == NULL)
	{
        if (notify)
		{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(NOTIFICATION_DELAY * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // NSLog(@"PB Send not success");
                NSDistributedNotificationCenter *center = [NSDistributedNotificationCenter defaultCenter];
                [center postNotificationName:messageFailedNotification object:distributedCenterName userInfo:nil deliverImmediately:YES];
            });
        }
        return;
    }

    CKConversationList *conversationList = [%c(CKConversationList) sharedConversationList];
    CKConversation *conversation = [conversationList conversationForExistingChatWithGroupID:finalPhone];

    if (conversation == NULL)
	{
        [self sendNewMessageTo:personId number:finalPhone withText:text notify:notify];
        return;
    }

    //Make a new composition
    NSAttributedString* t = [[NSAttributedString alloc] initWithString:text];
    CKComposition* composition = [[CKComposition alloc] initWithText:t subject:nil];

    // make message and send
    CKMessage *message = (CKMessage *)[conversation messageWithComposition:composition];
    [conversation sendMessage:message newComposition:YES];

    // send success
    if (notify)
	{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(NOTIFICATION_DELAY * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // NSLog(@"PEBBLESMS: Send success");
            NSDistributedNotificationCenter *center = [NSDistributedNotificationCenter defaultCenter];
            [center postNotificationName:messageSendNotification object:distributedCenterName userInfo:nil deliverImmediately:YES];
        });
    }
}

%new
- (void)sendMessageToNumber:(NSString *)number recordId:(NSNumber *)recordId withText:(NSString *)text notify:(BOOL)notify
{
    // NSLog(@"PEBBLESMS: sendMessageToNumber withText notify");
    // NSLog(@"PB sendmessageto number");
    NSString *num = [@"+" stringByAppendingString:[[number componentsSeparatedByCharactersInSet: [[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""]];

    CKConversationList *conversationList = [%c(CKConversationList) sharedConversationList];
    CKConversation *conversation = [conversationList conversationForExistingChatWithGroupID:num];
    // NSLog(@"PEBBLESMS: conversation %@", [conversation class]);

    if (conversation == NULL)
	{
        [self sendNewMessageTo:recordId number:number withText:text notify:notify];
        return;
    }

    //Make a new composition
    NSAttributedString* t = [[NSAttributedString alloc] initWithString:text];
    CKComposition* composition = [[CKComposition alloc] initWithText:t subject:nil];

    // make message and send
    CKMessage *message = (CKMessage *)[conversation messageWithComposition:composition];
    [conversation sendMessage:message newComposition:YES];

    // send success
    if (notify)
	{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(NOTIFICATION_DELAY * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // NSLog(@"PEBBLESMS: Send success");
            NSDistributedNotificationCenter *center = [NSDistributedNotificationCenter defaultCenter];
            [center postNotificationName:messageSendNotification object:distributedCenterName userInfo:nil deliverImmediately:YES];
        });
    }
}

%new
- (void)sendNewMessageTo:(NSNumber *)personId number:(NSString *)number withText:(NSString *)text notify:(BOOL)notify
{
    // NSLog(@"PEBBLESMS: sendNewMessageTo number withText notify");
    // NSLog(@"PB sendmessageto personId");
    // NSLog(@"PEBBLESMS: sendNewMessageTo");
    IMPerson *person = [[IMPerson alloc] initWithABRecordID:(ABRecordID)[personId intValue]];
    NSArray *handles = [%c(IMHandle) imHandlesForIMPerson:person];

    IMHandle *finalHandle = NULL;
    int highestCount = 0;
    for (int i=0;i<[handles count];i++)
	{
        IMHandle *h = [handles objectAtIndex:i];

        if ([h phoneNumberRef] != NULL)
		{
            NSString *p = [NSMutableString stringWithString:[[h phoneNumberRef] description]];
            NSString *phone = [@"+" stringByAppendingString:[[p componentsSeparatedByCharactersInSet: [[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""]];

            if ([phone isEqualToString:number])
			{
                finalHandle = h;
                break;
            }

            int iterate = MIN([phone length], [number length]);
            int i;
            for (i=0;i<iterate; i++)
			{
                int phoneIndex = [phone length] - i - 1;
                int numberIndex = [number length] - i - 1;
                if ([phone characterAtIndex:phoneIndex] != [number characterAtIndex:numberIndex])
				{
                    break;
                }
            }
            if (i>highestCount)
			{
                highestCount = i;
                finalHandle = h;
            }
        }
    }
    // NSLog(@"PEBBLESMS: finalHandle == NULL %d", (finalHandle == NULL));

    if (finalHandle == NULL)
	{
        if (notify)
		{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(NOTIFICATION_DELAY * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // NSLog(@"PB Send not success");
                NSDistributedNotificationCenter *center = [NSDistributedNotificationCenter defaultCenter];
                [center postNotificationName:messageFailedNotification object:distributedCenterName userInfo:nil deliverImmediately:YES];
            });
        }
        return;
    }

    CKConversationList *conversationList = [%c(CKConversationList) sharedConversationList];
    CKConversation *conversation = [conversationList conversationForHandles:@[finalHandle] displayName:[finalHandle nickname] joinedChatsOnly:NO create:YES];
    // NSLog(@"PB new conversation %@", [conversation class]);

    NSAttributedString* t = [[NSAttributedString alloc] initWithString:text];
    CKComposition* composition = [[CKComposition alloc] initWithText:t subject:nil];

    // make message and send
    CKMessage *message = (CKMessage *)[conversation messageWithComposition:composition];
    [conversation sendMessage:message newComposition:YES];

    // send success
    if (notify)
	{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(NOTIFICATION_DELAY * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // NSLog(@"PB Send success");
            NSDistributedNotificationCenter *center = [NSDistributedNotificationCenter defaultCenter];
            [center postNotificationName:messageSendNotification object:distributedCenterName userInfo:nil deliverImmediately:YES];
        });
    }
}

%end

// SENDING MESSAGE STUFF

%hook CKConversation

- (void)sendMessage:(id)arg1 onService:(id)arg2 newComposition:(BOOL)arg3
{
    // NSLog(@"PEBBLESMS: sendMessage");
    %orig;
    
    // NSLog(@"PEBBLESMS: sentMessage");
    [self saveRecipient];
    // NSLog(@"PEBBLESMS: savedRecipient");
}

%new
- (void)saveRecipient
{
    // NSLog(@"PEBBLESMS: saveRecipient");

    NSArray *handles = [self handles];
    // NSLog(@"PEBBLESMS: handles %@", [handles class]);
    if (handles != NULL)
	{
        if ([handles count] == 1)
		{
            IMHandle *handle = (IMHandle *)[handles objectAtIndex:0];
            // NSLog(@"PEBBLESMS: handle == NULL %d", (handle == NULL));
            id p = [handle phoneNumberRef];
            if (p)
			{
                NSString *phone = [NSString stringWithString:(NSString *)[p description]];
                NSString *name = [NSString stringWithString:(NSString *)[handle fullName]];

                PBSMSContact *contact = [[PBSMSContact alloc] initWithName:name phone:phone];
                [[PBSMSRecentContactHelper sharedHelper] addContact:contact];
            }
        }
    }
}

%end

// LISTENING FOR NEW MESSAGES

%hook IMDaemonListener

- (void)account:(id)arg1 chat:(id)arg2 style:(unsigned char)arg3 chatProperties:(id)arg4 messageReceived:(id)arg5
{
    // NSLog(@"PEBBLESMS: account chat style chatProperties messageReceived");
    if ([arg5 isKindOfClass:[IMMessageItem class]])
{
        NSString *sender = [(IMMessageItem *)arg5 sender];
        // NSLog(@"PEBBLESMS: sender %@", [sender class]);
        if (![arg5 isFromMe])
{
            CKConversationList *conversationList = [%c(CKConversationList) sharedConversationList];
            if (conversationList != NULL)
{
                CKConversation *conversation = [conversationList conversationForExistingChatWithGroupID:sender];
                // NSLog(@"PEBBLESMS: conversation %@", [conversation class]);
                if (conversation != NULL)
{
                    [conversation saveRecipient];
                }
            }
        }
    }
    %orig;
}

%end

%end

// CONTACT HANDLING

%group PebbleMain

%hook PBPhoneNumber

%new
-(NSString *)getStringRepresentationForTextSender
{
    // NSLog(@"PEBBLESMS: getStringRepresentationForTextSender");
    if ([self respondsToSelector:@selector(stringValue)])
{
        return [NSString stringWithString:[self stringValue]];
    } else
{
        // NSLog(@"PEBBLESMS: %@ %@ %@ %@", [self rawStringValue], [self countryCallingCode], [self stringRepresentationForWatch], [self stringRepresentationForWeb]);
        if ([self stringRepresentationForWeb] != NULL && ![[self stringRepresentationForWeb] isEqual:@""])
{
            return [NSString stringWithString:[self stringRepresentationForWeb]];
        }
        if ([self rawStringValue] != NULL)
{
            return [NSString stringWithString:[self rawStringValue]];
        }
        return @"";
    }
}

%end

%hook PBContact

%new
+ (NSString *)phoneWithPrefix:(NSString *)number
{
    // NSLog(@"PEBBLESMS: phoneWithPrefix");
    NSDictionary *dictCodes = [NSDictionary dictionaryWithObjectsAndKeys:
        @"93",@"AF",@"355",@"AL",@"213",@"DZ",@"1",@"AS", @"376",@"AD",@"244",@"AO",@"1",@"AI",@"1",@"AG",@"54",@"AR",@"374",@"AM",@"297",@"AW",@"61",@"AU",@"43",@"AT",@"994",@"AZ",@"1",@"BS",@"973",@"BH",
        @"880",@"BD",@"1",@"BB",@"375",@"BY",@"32",@"BE",@"501",@"BZ",@"229",@"BJ",@"1",@"BM",@"975",@"BT",@"387",@"BA",@"267",@"BW",@"55",@"BR",@"246",@"IO",@"359",@"BG",@"226",@"BF",@"257",@"BI",@"855",@"KH",
        @"237",@"CM",@"1",@"CA",@"238",@"CV",@"345",@"KY",@"236",@"CF",@"235",@"TD",@"56",@"CL",@"86",@"CN",@"61",@"CX",@"57",@"CO",@"269",@"KM",@"242",@"CG",@"682",@"CK",@"506",@"CR",@"385",@"HR",@"53",@"CU",
        @"537",@"CY",@"420",@"CZ",@"45",@"DK",@"253",@"DJ",@"1",@"DM",@"1",@"DO",@"593",@"EC",@"20",@"EG",@"503",@"SV",@"240",@"GQ",@"291",@"ER",@"372",@"EE",@"251",@"ET",@"298",@"FO",@"679",@"FJ",@"358",@"FI",
        @"33",@"FR",@"594",@"GF",@"689",@"PF",@"241",@"GA",@"220",@"GM",@"995",@"GE",@"49",@"DE",@"233",@"GH",@"350",@"GI",@"30",@"GR",@"299",@"GL",@"1",@"GD",@"590",@"GP",@"1",@"GU",@"502",@"GT",@"224",@"GN",
        @"245",@"GW",@"595",@"GY",@"509",@"HT",@"504",@"HN",@"36",@"HU",@"354",@"IS",@"91",@"IN",@"62",@"ID",@"964",@"IQ",@"353",@"IE",@"972",@"IL",@"39",@"IT",@"1",@"JM",@"81",@"JP",@"962",@"JO",@"77",@"KZ",
        @"254",@"KE",@"686",@"KI",@"965",@"KW",@"996",@"KG",@"371",@"LV",@"961",@"LB",@"266",@"LS",@"231",@"LR",@"423",@"LI",@"370",@"LT",@"352",@"LU",@"261",@"MG",@"265",@"MW",@"60",@"MY",@"960",@"MV",@"223",@"ML",
        @"356",@"MT",@"692",@"MH",@"596",@"MQ",@"222",@"MR",@"230",@"MU",@"262",@"YT",@"52",@"MX",@"377",@"MC",@"976",@"MN",@"382",@"ME",@"1",@"MS",@"212",@"MA",@"95",@"MM",@"264",@"NA",@"674",@"NR",@"977",@"NP",
        @"31",@"NL",@"599",@"AN",@"687",@"NC",@"64",@"NZ",@"505",@"NI",@"227",@"NE",@"234",@"NG",@"683",@"NU",@"672",@"NF",@"1",@"MP",@"47",@"NO",@"968",@"OM",@"92",@"PK",@"680",@"PW",@"507",@"PA",@"675",@"PG",
        @"595",@"PY",@"51",@"PE",@"63",@"PH",@"48",@"PL",@"351",@"PT",@"1",@"PR",@"974",@"QA",@"40",@"RO",@"250",@"RW",@"685",@"WS",@"378",@"SM",@"966",@"SA",@"221",@"SN",@"381",@"RS",@"248",@"SC",@"232",@"SL",
        @"65",@"SG",@"421",@"SK",@"386",@"SI",@"677",@"SB",@"27",@"ZA",@"500",@"GS",@"34",@"ES",@"94",@"LK",@"249",@"SD",@"597",@"SR",@"268",@"SZ",@"46",@"SE",@"41",@"CH",@"992",@"TJ",@"66",@"TH",@"228",@"TG",
        @"690",@"TK",@"676",@"TO",@"1",@"TT",@"216",@"TN",@"90",@"TR",@"993",@"TM",@"1",@"TC",@"688",@"TV",@"256",@"UG",@"380",@"UA",@"971",@"AE",@"44",@"GB",@"1",@"US",@"598",@"UY",@"998",@"UZ",@"678",@"VU",
        @"681",@"WF",@"967",@"YE",@"260",@"ZM",@"263",@"ZW",@"591",@"BO",@"673",@"BN",@"61",@"CC",@"243",@"CD",@"225",@"CI",@"500",@"FK",@"44",@"GG",@"379",@"VA",@"852",@"HK",@"98",@"IR",@"44",@"IM",@"44",@"JE",
        @"850",@"KP",@"82",@"KR",@"856",@"LA",@"218",@"LY",@"853",@"MO",@"389",@"MK",@"691",@"FM",@"373",@"MD",@"258",@"MZ",@"970",@"PS",@"872",@"PN",@"262",@"RE",@"7",@"RU",@"590",@"BL",@"290",@"SH",@"1",@"KN",
        @"1",@"LC",@"590",@"MF",@"508",@"PM",@"1",@"VC",@"239",@"ST",@"252",@"SO",@"47",@"SJ",@"963",@"SY",@"886",@"TW",@"255",@"TZ",@"670",@"TL",@"58",@"VE",@"84",@"VN",@"1",@"VG",@"1",@"VI",@"672",@"AQ",
        @"358",@"AX",@"47",@"BV",@"599",@"BQ",@"599",@"CW",@"689",@"TF",@"1",@"SX",@"211",@"SS",@"212",@"EH",@"972",@"IL", nil];

    NSLocale *locale = [NSLocale currentLocale];
    NSString *countryCode = [locale objectForKey: NSLocaleCountryCode];
    NSString *callingCode = [dictCodes objectForKey:countryCode];

    NSString *n;
    if ([number rangeOfString:@"+"].location == NSNotFound && callingCode != NULL)
{
        // NSLog(@"PB prefix %@", callingCode);
        n = [callingCode stringByAppendingString:number];
    } else
{
        n = number;
    }
    NSString *num = [@"+" stringByAppendingString:[[n componentsSeparatedByCharactersInSet: [[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""]];

    return num;
}

%new
- (NSNumber *)recordId
{
    // NSLog(@"PEBBLESMS: recordId");
    return [NSNumber numberWithInt:(int)ABRecordGetRecordID([self recordRef])];
}

%end

%hook PBAddressBook

%new
- (id)contactWithPhoneNumber:(PBPhoneNumber *)phoneNumber
{
    // NSLog(@"PEBBLESMS: contactWithPhoneNumber");
    for (PBContact *contact in (NSArray *)[self allContacts])
{
        for (PBLabeledValue *label in (NSArray *)[contact phoneNumbers])
{
            NSString *contactPhone = [(PBPhoneNumber *)[label value] getStringRepresentationForTextSender];
            if ([contactPhone isEqualToString:[phoneNumber getStringRepresentationForTextSender]])
{
                return contact;
            }
        }
    }
    return NULL;
}

%new
- (id)contactWithPrefixedPhoneNumber:(NSString *)phoneNumber
{
    // NSLog(@"PEBBLESMS: contactWithPrefixedPhoneNumber");
    PBContact *finalContact = NULL;
    int highestCount = 0;

    for (PBContact *contact in (NSArray *)[self allContacts])
	{
        for (PBLabeledValue *label in (NSArray *)[contact phoneNumbers])
		{

            NSString *number = [%c(PBContact) phoneWithPrefix:[(PBPhoneNumber *)[label value] getStringRepresentationForTextSender]];
            NSString *phone = [@"+" stringByAppendingString:[[phoneNumber componentsSeparatedByCharactersInSet: [[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""]];

            if ([phone isEqualToString:number])
			{
                return contact;
            }

            int iterate = MIN([phone length], [number length]);
            int i;
            for (i=0;i<iterate; i++)
			{
                int phoneIndex = [phone length] - i - 1;
                int numberIndex = [number length] - i - 1;
                if ([phone characterAtIndex:phoneIndex] != [number characterAtIndex:numberIndex])
				{
                    break;
                }
            }
            if (i>highestCount)
			{
                highestCount = i;
                finalContact = contact;
            }
        }
    }

    // NSLog(@"PEBBLESMS: finalContact == NULL %d", (finalContact == NULL));
    if (highestCount >= 6)
	{ // just double check that there was actually a find
        return finalContact;
    }

    return NULL;
}

%new
- (id)searchContactsList:(NSString *)search tries:(int)tries
{
    // NSLog(@"PEBBLESMS: searchContactsList");
    NSMutableArray *results = [NSMutableArray array];

    for (id item in (NSArray *)[self allContacts])
	{
        // note the modified weighting, this ends up working similiar to Alfred / TextMate searching method
        // TextMate takes into account camelcase while matching and is a little smarter, but you get the idea
        NSInteger score0 = [[search lowercaseString] compareWithWord:[[item fullName] lowercaseString] matchGain:10 missingCost:1];
        NSInteger score1 = [[search lowercaseString] compareWithWord:[[item firstName] lowercaseString] matchGain:10 missingCost:1];
        NSInteger score2 = [[search lowercaseString] compareWithWord:[[item lastName] lowercaseString] matchGain:10 missingCost:1];
        NSInteger score3 = [[search lowercaseString] compareWithWord:[[item nickname] lowercaseString] matchGain:10 missingCost:1];
        NSInteger score4 = [[search lowercaseString] compareWithWord:[[item middleName] lowercaseString] matchGain:10 missingCost:1];

        NSInteger min = score0;
        if (score1 < min)
		{
            min = score1;
        }
        if (score2 < min)
		{
            min = score2;
        }
        if (score3 < min)
		{
            min = score3;
        }
        if (score4 < min)
		{
            min = score4;
        }

        [results addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:min], @"score", item, @"item", nil]];
    }

    // sort list
    NSArray *res = [results sortedArrayUsingComparator: (NSComparator)^(id obj1, id obj2)
	{
        return [[obj1 valueForKey:@"score"] compare:[obj2 valueForKey:@"score"]];
    }];

    PBContact *c;
    NSString *number;

    int i = 0;
    int contactIndex = 0;

    while (i < tries * MAX_CONTACTS_TO_SEND && contactIndex < [res count])
	{
        c = [[res objectAtIndex:contactIndex] objectForKey:@"item"];
        contactIndex++;
        for (int j=0;j<[[c phoneNumbers] count];j++)
		{
            number = [(PBPhoneNumber *)[(PBLabeledValue *)[[c phoneNumbers] objectAtIndex:j] value] getStringRepresentationForTextSender];
            i++;
            if (i == tries+1)
			{
                break;
            }
        }
    }

    NSMutableArray *contacts = [NSMutableArray array];
    NSMutableArray *numbers = [NSMutableArray array];
    for (int k = i; i < k+MAX_CONTACTS_TO_SEND;)
	{
        // NSLog(@"i %d", i);
        c = [[res objectAtIndex:contactIndex] objectForKey:@"item"];
        contactIndex++;
        for (int j=0;j<[[c phoneNumbers] count];j++)
		{
            number = [(PBPhoneNumber *)[(PBLabeledValue *)[[c phoneNumbers] objectAtIndex:j] value] getStringRepresentationForTextSender];
            // NSLog(@"i %d %@ %@", i, [c fullName], number);
            [contacts addObject:c];
            [numbers addObject:number];
            i++;
            if (i == tries+1)
			{
                break;
            }
        }
    }

    return [NSDictionary dictionaryWithObjectsAndKeys:contacts, @"contacts", numbers, @"numbers", nil];
}

%new
- (id)searchContacts:(NSString *)search tries:(int)tries
{
    // NSLog(@"PEBBLESMS: searchContacts tries");
    NSMutableArray *results = [NSMutableArray array];

    for (id item in (NSArray *)[self allContacts])
	{
        // note the modified weighting, this ends up working similiar to Alfred / TextMate searching method
        // TextMate takes into account camelcase while matching and is a little smarter, but you get the idea
        NSInteger score0 = [[search lowercaseString] compareWithWord:[[item fullName] lowercaseString] matchGain:10 missingCost:1];
        NSInteger score1 = [[search lowercaseString] compareWithWord:[[item firstName] lowercaseString] matchGain:10 missingCost:1];
        NSInteger score2 = [[search lowercaseString] compareWithWord:[[item lastName] lowercaseString] matchGain:10 missingCost:1];
        NSInteger score3 = [[search lowercaseString] compareWithWord:[[item nickname] lowercaseString] matchGain:10 missingCost:1];
        NSInteger score4 = [[search lowercaseString] compareWithWord:[[item middleName] lowercaseString] matchGain:10 missingCost:1];

        NSInteger min = score0;
        if (score1 < min)
		{
            min = score1;
        }
        if (score2 < min)
		{
            min = score2;
        }
        if (score3 < min)
		{
            min = score3;
        }
        if (score4 < min)
		{
            min = score4;
        }

        [results addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:min], @"score", item, @"item", nil]];
    }

    // sort list
    NSArray *res = [results sortedArrayUsingComparator: (NSComparator)^(id obj1, id obj2){
        return [[obj1 valueForKey:@"score"] compare:[obj2 valueForKey:@"score"]];
    }];

    PBContact *c;
    NSString *number;

    int i = 0;
    int contactIndex = 0;

    while (i <= tries && contactIndex < [res count])
	{
        c = [[res objectAtIndex:contactIndex] objectForKey:@"item"];
        contactIndex++;
        for (int j=0;j<[[c phoneNumbers] count];j++)
		{
            number = [(PBPhoneNumber *)[(PBLabeledValue *)[[c phoneNumbers] objectAtIndex:j] value] getStringRepresentationForTextSender];
            i++;
            if (i == tries+1)
			{
                break;
            }
        }
    }

    return [NSDictionary dictionaryWithObjectsAndKeys:c, @"contact", number, @"number", nil];
}

%end

// APP COMMUNICATION

%hook PBWatch

%new
- (NSMutableDictionary *)getContactSearchResponse:(NSString *)name tries:(int)tries
{
    // NSLog(@"PEBBLESMS: getContactSearchResponse");
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    NSMutableDictionary *contactInfo = [[%c(PBAddressBook) addressBook] searchContacts:name tries:tries];
    NSMutableDictionary *contactsInfo = [[%c(PBAddressBook) addressBook] searchContactsList:name tries:tries];
    PBContact *c = [contactInfo objectForKey:@"contact"];
    NSString *num = [contactInfo objectForKey:@"number"];
    if (c != NULL && num != NULL && contactsInfo != NULL)
	{
        // to maintain compatibility with old watchapp versions (<=v1.1)
        [dict setObject:[c fullName] forKey:CONTACT_NAME_KEY];
        [dict setObject:num forKey:CONTACT_NUMBER_KEY];
        currentContactId = [c recordId];

        // for newer watchapp models (>v1.1)
        NSMutableArray *contacts = [contactsInfo objectForKey:@"contacts"];
        NSMutableArray *numbers = [contactsInfo objectForKey:@"numbers"];

        NSMutableArray *names = [NSMutableArray array];
        NSMutableArray *phones = [NSMutableArray array];
        NSMutableArray *ids = [NSMutableArray array];

        for (int i=0; i<[contacts count]; i++)
		{
            [names addObject:[[contacts objectAtIndex:i] fullName]];
        }
        for (int i=0; i<[contacts count]; i++)
		{
            [ids addObject:[NSNumber numberWithInt:[[[contacts objectAtIndex:i] recordId] intValue]]];
        }
        for (int i=0; i<[numbers count]; i++)
		{
            [phones addObject:[numbers objectAtIndex:i]];
        }

        [dict setObject:[names componentsJoinedByString:@"\n"] forKey:CONTACT_NAMES_KEY];
        [dict setObject:[phones componentsJoinedByString:@"\n"] forKey:CONTACT_NUMBERS_KEY];
        [dict setObject:[ids componentsJoinedByString:@"\n"] forKey:CONTACT_IDS_KEY];
    }
    else
	{
        [dict setObject:@"No more contacts" forKey:CONTACT_NAME_KEY];
        [dict setObject:@"" forKey:CONTACT_NUMBER_KEY];
    }

    isRecentContact = NO;
    // NSLog(@"PB isRecentContact NO");
    // NSLog(@"PB Response %@", dict);

    return dict;
}

%new
- (NSMutableDictionary *)getFinalRecievedResponse
{
    // NSLog(@"PEBBLESMS: getFinalRecievedResponse");
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    [dict setObject:@"Sending..." forKey:RECIEVED_FINAL_MESSAGE_KEY];
    
    return dict;
}

%new
- (NSMutableDictionary *)getSentResponse
{
    // NSLog(@"PEBBLESMS: getSentResponse");
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    [dict setObject:@"Sent" forKey:MESSAGE_CONFIRMATION_KEY];
    [dict setObject:[NSNumber numberWithInt:1] forKey:IS_PEBBLE_SMS_KEY];
    
    return dict;
}

%new
- (NSMutableDictionary *)getFailedResponse
{
    // NSLog(@"PEBBLESMS: getFailedResponse");
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    [dict setObject:@"Sending failed" forKey:MESSAGE_CONFIRMATION_KEY];
    [dict setObject:[NSNumber numberWithInt:1] forKey:IS_PEBBLE_SMS_KEY];
    
    return dict;
}

%new
- (NSMutableDictionary *)getConnectionResponse
{
    // NSLog(@"PEBBLESMS: getConnectionResponse");
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    [dict setObject:@"Connected" forKey:CONNECTION_TEST_KEY];
    
    return dict;
}

%new
- (NSMutableDictionary *)getRecentContactsResponse
{
	[[PBSMSRecentContactHelper sharedHelper] loadContacts];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([PBSMSRecentContactHelper sharedHelper].contacts.count != 0)
	{
        [dict setObject:[[PBSMSRecentContactHelper sharedHelper].names componentsJoinedByString:@"\n"] forKey:RECENT_CONTACTS_NAME_KEY];
        [dict setObject:[[PBSMSRecentContactHelper sharedHelper].phones componentsJoinedByString:@"\n"] forKey:RECENT_CONTACTS_NUMBER_KEY];
        isRecentContact = YES;
    }

    log(@"getRecentContactsResponse %@", @( [PBSMSRecentContactHelper sharedHelper].contacts.count ));
    
    return dict;
}

%new
- (NSMutableDictionary *)getPresets
{
	log(@"presets2 %@", [PBSMSTextHelper sharedHelper].presets);
	return [NSMutableDictionary dictionaryWithDictionary:@{ PRESETS_KEY : [PBSMSTextHelper sharedHelper].presets }];
}

- (void)appMessagesPushUpdate:(id)fp8 onSent:(id)fp1001 uuid:(id)fp12 launcher:(id)fp16
{
    // NSLog(@"PEBBLESMS: appMessagesPushUpdate");
    NSMutableDictionary *message = (NSMutableDictionary *)fp8;
    id isSMS = [message objectForKey:IS_PEBBLE_SMS_KEY];
    if (isSMS != NULL && [isSMS intValue] == [[NSNumber numberWithInt:1] intValue])
	{
        NSMutableDictionary *response;
        BOOL initialized = NO;
        
        id connectionTest = [message objectForKey:CONNECTION_TEST_KEY];
        if (connectionTest != NULL)
		{
            response = [self getConnectionResponse];
            initialized = YES;
        }

        id confirmation = [message objectForKey:MESSAGE_CONFIRMATION_KEY];
        if (confirmation != NULL)
		{
            // NSLog(@"PB sending confirmation %@", [message description]);
            %orig;
            return;
        }

        NSNumber *state = [message objectForKey:STATE_KEY];
        if (state != NULL)
		{
            if ([state intValue] == [GETTING_RECENT_CONTACTS_STATE intValue])
			{
                response = [self getRecentContactsResponse];
                initialized = YES;
            }
            
            if ([state intValue] == [GETTING_PRESETS_STATE intValue])
			{
                response = [self getPresets];
                initialized = YES;
            }
            
            if ([state intValue] == [CHECKING_CONTACT_STATE intValue])
			{
                NSNumber *tries = [message objectForKey:ATTEMPT_NUMBER_KEY];
                NSString *name = [message objectForKey:DICTATED_NAME_KEY];
                if (tries != NULL && name != NULL)
				{
                    response = [self getContactSearchResponse:name tries: [tries intValue]];
                    initialized = YES;
                }
            }
            
            if ([state intValue] == [SENDING_FINAL_MESSAGE_STATE intValue])
			{
                NSString *number = [message objectForKey:CONTACT_NUMBER_KEY];
                NSString *m = [message objectForKey:FINAL_MESSAGE_KEY];

                if (number != NULL && m != NULL)
				{
                    NSString *contactId = [message objectForKey:CONTACT_ID_KEY];
                    NSNumber *finalContactId = NULL;
                    if (contactId != NULL && ![contactId isEqual:@""])
					{
                        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                        f.numberStyle = NSNumberFormatterDecimalStyle;
                        finalContactId = [f numberFromString:contactId];
                    }

                    // NSLog(@"finalContactId %@", finalContactId);

                    if (finalContactId != NULL)
					{
                        [%c(PBWatch) sendSMS:finalContactId number:[%c(PBContact) phoneWithPrefix:number] withText:m];
                    }
                    else
					{
                        [%c(PBWatch) sendSMS:currentContactId number:[%c(PBContact) phoneWithPrefix:number] withText:m];
                    }
                    response = [self getFinalRecievedResponse];
                    initialized = YES;
                }
            }
        }

        if (initialized)
		{
            // NSLog(@"PEBBLESMS: %@", response);
            %orig(response, fp1001, fp12, fp16); 
        }
        else
		{
            %orig;
        }
    }
    else
	{
        %orig;
    }
}

%new
+ (void)sendSMS:(NSNumber *)recordId number:(NSString *)number withText:(NSString *)text
{
    NSNumber *rId;
    if (isRecentContact)
	{
        PBContact *c = [[%c(PBAddressBook) addressBook] contactWithPrefixedPhoneNumber:number];
        rId = [NSNumber numberWithInt:[[c recordId] intValue]];
    }
    else
	{
        rId = [NSNumber numberWithInt:[recordId intValue]];
    }

    PBSMSTextMessage *message = [[PBSMSTextMessage alloc] initWithNumber:number
		messageText:text
		uuid:[[NSUUID UUID] UUIDString]
		recordId:rId
		isRecentContact:isRecentContact
		isReply:NO
		shouldNotify:YES
		isNewNumber:NO
		expirationDate:[NSDate dateWithTimeIntervalSinceNow:MESSAGE_SEND_TIMEOUT]];

    [[PBSMSTextHelper sharedHelper] saveMessageToSend:message];

    NSDictionary *userInfo = [message serializeToDictionary];

    CPDistributedMessagingCenter *c = [%c(CPDistributedMessagingCenter) centerNamed:rocketbootstrapSpringboardCenterName];
    rocketbootstrap_distributedmessagingcenter_apply(c);
    [c sendMessageName:openMessagesCommand userInfo:NULL];

    // send message after 5 seconds
    // TODO: Think about changing these to static vars?
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(SEND_DELAY * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CPDistributedMessagingCenter *c = [%c(CPDistributedMessagingCenter) centerNamed:rocketbootstrapSmsCenterName];
        rocketbootstrap_distributedmessagingcenter_apply(c);
        [c sendMessageName:sendMessageCommand userInfo:userInfo];
    });

    // send message after 10 seconds
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(SECOND_SEND_DELAY * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CPDistributedMessagingCenter *c = [%c(CPDistributedMessagingCenter) centerNamed:rocketbootstrapSmsCenterName];
        rocketbootstrap_distributedmessagingcenter_apply(c);
        [c sendMessageName:sendMessageCommand userInfo:userInfo];
    });
}

%end

// REPLY HANDLING

%hook PBSMSSessionManager

- (id)sendSMSSendRequestWithMessage:(id)fp8 account:(id)fp12 transactionID:(id)fp16
{
    // NSLog(@"PEBBLESMS: sendSMSSendRequestWithMessage");
    PBSMSMessage *message = (PBSMSMessage *)fp8;
    NSString *text = [message text];
    PBPhoneNumber *number = [[message recipients] objectAtIndex:0];
    PBContact *contact = [[%c(PBAddressBook) addressBook] contactWithPhoneNumber:number];
    [%c(PBSMSSessionManager) sendSMS:[contact recordId] number:[number getStringRepresentationForTextSender] withText:text];
    return NULL;
}

%new
+ (void)sendSMS:(NSNumber *)recordId number:(NSString *)number withText:(NSString *)text
{
    PBSMSTextMessage *message = [[PBSMSTextMessage alloc] initWithNumber:number
		messageText:text
		uuid:[[NSUUID UUID] UUIDString]
		recordId:recordId
		isRecentContact:NO
		isReply:YES
		shouldNotify:NO
		isNewNumber:NO
		expirationDate:[NSDate dateWithTimeIntervalSinceNow:MESSAGE_SEND_TIMEOUT]];

    [[PBSMSTextHelper sharedHelper] saveMessageToSend:message];

    NSDictionary *userInfo = [message serializeToDictionary];

    CPDistributedMessagingCenter *c = [%c(CPDistributedMessagingCenter) centerNamed:rocketbootstrapSpringboardCenterName];
    rocketbootstrap_distributedmessagingcenter_apply(c);
    [c sendMessageName:openMessagesCommand userInfo:NULL];

    // send message after 5 seconds
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(SEND_DELAY * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CPDistributedMessagingCenter *c = [%c(CPDistributedMessagingCenter) centerNamed:rocketbootstrapSmsCenterName];
        rocketbootstrap_distributedmessagingcenter_apply(c);
        [c sendMessageName:sendMessageCommand userInfo:userInfo];
    });

    // send message after 10 seconds
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(SECOND_SEND_DELAY * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CPDistributedMessagingCenter *c = [%c(CPDistributedMessagingCenter) centerNamed:rocketbootstrapSmsCenterName];
        rocketbootstrap_distributedmessagingcenter_apply(c);
        [c sendMessageName:sendMessageCommand userInfo:userInfo];
    });

}

%end

// SETUP IN PEBBLE APP

%hook PBAppDelegate

- (void)applicationDidBecomeActive:(id)fp8
{
    %orig;

    if ([%c(PBAddressBookAuthorizationManager) authorizationStatus] == kABAuthorizationStatusNotDetermined)
{
        [%c(PBAddressBookAuthorizationManager) requestAuthorizationWithCompletion:^(BOOL granted,CFErrorRef error){}];
    }
}

- (BOOL)application:(id)arg1 didFinishLaunchingWithOptions:(id)arg2
{

    // NSLog(@"PB pebble got launched");

    BOOL s = %orig;

    // register to recieve notifications when messages need to be sent
    NSDistributedNotificationCenter *center = [NSDistributedNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(sentCallbackWithNotification:) name:messageSendNotification object:distributedCenterName];
    [center addObserver:self selector:@selector(failedCallbackWithNotification:) name:messageFailedNotification object:distributedCenterName];

    return s;
}

%new
- (void)sentCallbackWithNotification:(NSNotification *)myNotification
{
    PBPebbleCentral *central = [%c(PBPebbleCentral) defaultCentral];
    for (int i=0; i<[[central connectedWatches] count]; i++)
	{
        PBWatch *watch = [[central connectedWatches] objectAtIndex:i];
        [watch appMessagesPushUpdate:[watch getSentResponse] onSent:^(PBWatch *watch, NSDictionary *update, NSError *error){} uuid:appUUID launcher:NULL];
    }
}

%new
- (void)failedCallbackWithNotification:(NSNotification *)myNotification
{
    PBPebbleCentral *central = [%c(PBPebbleCentral) defaultCentral];
    for (int i=0; i<[[central connectedWatches] count]; i++)
	{
        PBWatch *watch = [[central connectedWatches] objectAtIndex:i];
        [watch appMessagesPushUpdate:[watch getFailedResponse] onSent:^(PBWatch *watch, NSDictionary *update, NSError *error){} uuid:appUUID launcher:NULL];
    }
}

%new
+ (NSNumber *)majorAppVersion
{
	NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
	NSString *version = infoDictionary[@"CFBundleShortVersionString"];
	NSArray *versionArray = [version componentsSeparatedByString:@"."];

	NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
	f.numberStyle = NSNumberFormatterDecimalStyle;
	return [f numberFromString:versionArray[0]];
}

%new
+ (NSNumber *)minorAppVersion
{
	NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
	NSString *version = infoDictionary[@"CFBundleShortVersionString"];
	NSArray *versionArray = [version componentsSeparatedByString:@"."];

	NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
	f.numberStyle = NSNumberFormatterDecimalStyle;
	return [f numberFromString:versionArray[1]];
}

%end

%hook PBCannedResponseManager

- (id)cannedResponsesForAppIdentifier:(id)fp8
{
    id r = %orig;
	log(@"cannedResponses %@ %@", fp8, r);
    if ([(NSString *)fp8 isEqualToString:@"com.apple.MobileSMS"])
	{
        [PBSMSTextHelper sharedHelper].presets = (NSArray *)r;
    }
    return r; 
}
- (void)setCannedResponses:(id)fp8 forAppIdentifier:(id)fp12
{
    if ([(NSString *)fp12 isEqualToString:@"com.apple.MobileSMS"])
	{
        [PBSMSTextHelper sharedHelper].presets = (NSArray *)fp8;
    }
	log(@"setCannedResponses %@ %@", fp12, fp8);
    %orig; 
}

%end

%hook PBSendSMSActionHandler

- (void)handleActionWithActionIdentifier:(unsigned char)fp8 attributes:(id)fp12
{
	log(@"handleActionWithActionIdentifier %@ %@", @( fp8 ), fp12);
    if (fp8 == 2)
	{
        NSData *d = [(PBTimelineItemAttributeBlob *)[(NSArray *)fp12 objectAtIndex:0] content];
        NSString *reply = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
        PBContact *contact = [[self addressBookQuerySession] selectedContact];
        PBPhoneNumber *pbPhoneNumber = (PBPhoneNumber *)[(PBLabeledValue *)[[self addressBookQuerySession] selectedLabeledValue] value];
        NSString *phone = [pbPhoneNumber getStringRepresentationForTextSender];
        PBTimelineAttributeContentLocalizedString *localString = [[%c(PBTimelineAttributeContentLocalizedString) alloc] initWithLocalizationKey:@"Sending..."];
        PBTimelineAttribute *attr = [%c(PBTimelineAttribute) attributeWithType:@"subtitle" content:localString];
        [(PBANCSActionHandler *)[self delegate] notificationHandler:self didSendResponse:15 withAttributes:@[attr] actions:NULL];
        [%c(PBSMSSessionManager) sendSMS:[contact recordId] number:phone withText:reply];
    }
    else
	{
        %orig; 
    }
}

%end

%hook PBSendTextAppActionHandler

-(void)handleAction:(unsigned char)arg1 forItemIdentifier:(id)arg2 attributes:(id)arg3
{
	log(@"handleAction %@ %@ %@", @( arg1 ), arg2, arg3);
    if (arg1 == 2)
	{
        NSData *responseData = [(PBTimelineItemAttributeBlob *)[self responseFromAttributes:arg3] content];
        NSData *phoneData = [(PBTimelineItemAttributeBlob *)[self phoneNumberFromAttributes:arg3] content];

        NSString *response = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSString *phone = [[NSString alloc] initWithData:phoneData encoding:NSUTF8StringEncoding];

        PBPhoneNumber *pbPhone = [[%c(PBPhoneNumber) alloc] initWithStringValue:phone];
        PBContact *contact = [[%c(PBAddressBook) addressBook] contactWithPhoneNumber:pbPhone];

        PBContact *finalContact;
        if (contact == NULL)
		{
            NSString *prefixedPhone = [%c(PBContact) phoneWithPrefix:phone];
            finalContact = [[%c(PBAddressBook) addressBook] contactWithPrefixedPhoneNumber:prefixedPhone];
        }
        else
		{
            finalContact = contact;
        }

        if (finalContact != NULL)
		{
            PBTimelineAttributeContentLocalizedString *localString = [[%c(PBTimelineAttributeContentLocalizedString) alloc] initWithLocalizationKey:@"Sending..."];
            PBTimelineAttribute *attr = [%c(PBTimelineAttribute) attributeWithType:@"subtitle" content:localString];
            [(PBTimelineActionsWatchService *)[self delegate] sendTextAppActionHandler:self didSendResponse:0 withAttributes:@[attr] forItemIdentifier:arg2];
            [%c(PBSMSSessionManager) sendSMS:[finalContact recordId] number:phone withText:response];
        }
        else
		{
            NSString *message = [NSString stringWithFormat:@"Sending failed to %@", phone];
            PBTimelineAttribute *attr = [%c(PBTimelineAttribute) attributeWithType:@"subtitle" content:message];
            [(PBTimelineActionsWatchService *)[self delegate] sendTextAppActionHandler:self didSendResponse:0 withAttributes:@[attr] forItemIdentifier:arg2];
        }
    }
    else
	{
        %orig; 
    }
}

%end

// THIS PART IS FOR ACTIONABLE NOTIFICATIONS

%hook PBSMSReplyManager
-(NSSet *)ancsReplyEnabledApps
{
	NSSet *r = %orig;
	NSMutableSet *set = [NSMutableSet setWithCapacity:3];
	[set setSet:r];
	[set addObjectsFromArray:appsArray];
	return set;
}
%end

%hook PBCannedResponseManager
-(id)defaultResponsesForAppIdentifier:(id)arg1
{
	NSArray *enabledApps = @[ @"com.apple.MobileSMS", 
		@"com.apple.mobilephone", 
		@"com.pebble.sendText" ];
	if ([enabledApps containsObject:(NSString *)arg1])
	{
		return %orig;
	}
	else
	{
		return [NSMutableArray array];
	}
}
%end

%hook PBANCSActionHandler

-(NSDictionary *)actionHandlersByAppIdentifier
{
	NSDictionary * r = %orig;
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:r];

	for (NSString *app in appsArray)
	{
		[dict setObject:[%c(PBANCSActionHandler) actionHandlerWithDelegate:self] forKey:app];
	}

	return dict; 
}
-(void)handleActionWithActionIdentifier:(unsigned char)arg1 attributes:(id)arg2
{
	NSLog(@"PBANCSActionHandler");
    if (arg1 == 10)
	{
        // NSLog(@"HANDLING");
        NSData *d = [(PBTimelineItemAttributeBlob *)[(NSArray *)arg2 objectAtIndex:0] content];
        NSString *reply = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
        NSLog(@"reply %@", reply);

        NSUUID *ancsIdentifier = [self handlingIdentifier];
        NSLog(@"ANCSIdentifier %@", ancsIdentifier);

        for (NSNumber *actionNumber in [actionsToPerformDictionary allKeys])
        {
        	NSDictionary *dict = actionsToPerformDictionary[actionNumber];
        	NSUUID *ancsId = dict[@"ANCSIdentifier"];

        	if ([ancsId isEqual:ancsIdentifier])
        	{
        		NSString *actionID = dict[@"actionIdentifier"];
        		NSString *bulletinID = dict[@"bulletinIdentifier"];

				[%c(PBANCSActionHandler) performReply:reply forAction:actionID andBulletinID:bulletinID];

				PBTimelineAttribute *attr = [[%c(PBTimelineAttribute) alloc] initWithType:@"subtitle" content:@"Reply sent" specificType:0];
				[self sendResponse:15 withAttributes:@[ attr ] actions:NULL forItemIdentifier:ancsIdentifier];
				return;
        	}
        }
    }
    else
	{
        %orig; 
    }
}
-(BOOL)isHandlingNotificationWithIdentifier:(id)arg1
{
	%log;

	NSArray *actionsToPerformKeys = [actionsToPerformDictionary allKeys];

	for (NSNumber *key in actionsToPerformKeys)
	{
		NSDictionary *actionToPerformDict = [actionsToPerformDictionary objectForKey:key];
		NSUUID *actionID = actionToPerformDict[@"ANCSIdentifier"];
		NSLog(@"actionID %@", actionToPerformDict);
		if ([actionID isEqual:(NSUUID *)arg1])
		{
			[self setHandlingIdentifier:actionID];
			return YES;
		}
	}

	BOOL r = %orig;

	NSLog(@"isHandlingNotificationWithIdentifier %d", r);

	return r;
}

-(void)handleInvokeANCSActionMessage:(id)arg1
{
	PBTimelineInvokeANCSActionMessage *m = (PBTimelineInvokeANCSActionMessage *)arg1;
	log(@"handleInvokeANCSActionMessage %@ %@ %@", m, @( [m actionID] ), [m appIdentifier]);
	log(@"%@ %@ %@ %@", [m notificationSender], [m notificationSubtitle], [m notificationBody], [m actionTitle]);
	log(@"%@", [[PBSMSNotificationsHelper sharedHelper] notificationsForAppIdentifier:[m appIdentifier]]);

	if ([m actionID] == HAS_ACTIONS_IDENTIFIER || [m actionID] == 10)
	{
		[[PBSMSNotificationsHelper sharedHelper] loadNotifications];

		log(@"loaded");
	    NSMutableArray *actions = [NSMutableArray array];

		log(@"Adding dismiss action");
	    // Add dismiss actions
		PBTimelineAttribute *a1 = [[%c(PBTimelineAttribute) alloc] initWithType:@"title" content:@"Dismiss" specificType:0];
		PBTimelineAttribute *a2 = [[%c(PBTimelineAttribute) alloc] initWithType:@"subtitle" content:@"" specificType:0];
		[actions addObject:[[%c(PBTimelineAction) alloc] initWithIdentifier:@(DISMISS_IDENTIFIER) type:@"ANCSResponse" attributes:@[ a1, a2 ]]];

		log(@"getting bulletin id");
		NSString *bulletinId = [%c(PBANCSActionHandler) bulletinIdentifierForInvokeANCSMessage:m];
		if (!bulletinId)
		{
			PBTimelineAttribute *attr = [[%c(PBTimelineAttribute) alloc] initWithType:@"subtitle" content:@"Action failed!" specificType:0];
			[self sendResponse:15 withAttributes:@[ attr ] actions:NULL forItemIdentifier:[m ANCSIdentifier]];
			return;
		}
		log(@"got bulletin id %@", bulletinId);

	    PBSMSNotification *notification = [[PBSMSNotificationsHelper sharedHelper] notificationForBulletinId:bulletinId];
	    if (!notification)
	    {
			PBTimelineAttribute *attr = [[%c(PBTimelineAttribute) alloc] initWithType:@"subtitle" content:@"Action failed!" specificType:0];
			[self sendResponse:15 withAttributes:@[ attr ] actions:NULL forItemIdentifier:[m ANCSIdentifier]];
			return;
	    }
		log(@"got notification %@", notification);

		for (PBSMSNotificationAction *action in notification.actions)
		{
			PBTimelineAttribute *attr1 = [[%c(PBTimelineAttribute) alloc] initWithType:@"title" content:action.title specificType:0];
			PBTimelineAttribute *attr2 = [[%c(PBTimelineAttribute) alloc] initWithType:@"subtitle" content:@"" specificType:0];

			[actions addObject:[[%c(PBTimelineAction) alloc] initWithIdentifier:@(currentNumber) type:@"ANCSResponse" attributes:@[ attr1, attr2 ]]];

			NSDictionary *actionToPerform = @{ @"actionIdentifier" : action.actionIdentifier,
											   @"bulletinIdentifier" : bulletinId,
											   @"ANCSIdentifier" : [m ANCSIdentifier],
											   @"isComposeAction" : @( action.isQuickReply ),
											   @"replyText" : @"" };
			[actionsToPerformDictionary setObject:actionToPerform forKey:@(currentNumber)];

			currentNumber = currentNumber + 1;
		}

		PBTimelineAttribute *attr1 = [[%c(PBTimelineAttribute) alloc] initWithType:@"title" content:@"Action" specificType:0];
		PBTimelineAttribute *attr2 = [[%c(PBTimelineAttribute) alloc] initWithType:@"subtitle" content:@"Action" specificType:0];
		[self sendResponse:16 withAttributes:@[ attr1, attr2 ] actions:actions forItemIdentifier:[m ANCSIdentifier]];
		return;
	}
	else if ([m actionID] == DISMISS_IDENTIFIER)
	{
		PBTimelineAttribute *attr = [[%c(PBTimelineAttribute) alloc] initWithType:@"subtitle" content:@"Dismissed" specificType:0];
		[self sendResponse:15 withAttributes:@[ attr ] actions:NULL forItemIdentifier:[m ANCSIdentifier]];
		return;
	}
	else if ([m actionID] > DISMISS_IDENTIFIER)
	{
		NSDictionary *actionToPerformDict = [actionsToPerformDictionary objectForKey:@([m actionID])];

		NSLog(@"actionToPerformDict %@", actionToPerformDict);
		NSString *actionID = [actionToPerformDict objectForKey:@"actionIdentifier"];
		NSString *bulletinID = [actionToPerformDict objectForKey:@"bulletinIdentifier"];
		BOOL isComposeAction = [(NSNumber *)actionToPerformDict[@"isComposeAction"] boolValue];

		if (actionID && bulletinID)
		{
			if (isComposeAction)
			{
				PBTimelineAttribute *attr = [[%c(PBTimelineAttribute) alloc] initWithType:@"subtitle" content:@"Reply" specificType:0];
				[self sendResponse:21 withAttributes:@[ attr ] actions:NULL forItemIdentifier:[m ANCSIdentifier]];
				return;
			}
			else
			{
				[%c(PBANCSActionHandler) performAction:actionID forBulletinID:bulletinID];

				PBTimelineAttribute *attr = [[%c(PBTimelineAttribute) alloc] initWithType:@"subtitle" content:@"Action done" specificType:0];
				[self sendResponse:15 withAttributes:@[ attr ] actions:NULL forItemIdentifier:[m ANCSIdentifier]];
				return;
			}
		}
		else
		{
			PBTimelineAttribute *attr = [[%c(PBTimelineAttribute) alloc] initWithType:@"subtitle" content:@"Action failed!" specificType:0];
			[self sendResponse:15 withAttributes:@[ attr ] actions:NULL forItemIdentifier:[m ANCSIdentifier]];
			return;
		}
	}

	%orig; 
}

%new
+ (void)performAction:(NSString *)actionID forBulletinID:(NSString *)bulletinID
{
	saveActionToPerform(actionID, bulletinID, NO, @"");

    CPDistributedMessagingCenter *c = [%c(CPDistributedMessagingCenter) centerNamed:rocketbootstrapSpringboardCenterName];
    rocketbootstrap_distributedmessagingcenter_apply(c);
    [c sendMessageName:performNotificationActionCommand userInfo:NULL];

    // send message after 5 seconds
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(SEND_DELAY * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CPDistributedMessagingCenter *c = [%c(CPDistributedMessagingCenter) centerNamed:rocketbootstrapSpringboardCenterName];
        rocketbootstrap_distributedmessagingcenter_apply(c);
        [c sendMessageName:performNotificationActionCommand userInfo:NULL];
    });

    // send message after 10 seconds
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(SECOND_SEND_DELAY * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CPDistributedMessagingCenter *c = [%c(CPDistributedMessagingCenter) centerNamed:rocketbootstrapSpringboardCenterName];
        rocketbootstrap_distributedmessagingcenter_apply(c);
        [c sendMessageName:performNotificationActionCommand userInfo:NULL];
    });

    // send message after 12 seconds
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((SECOND_SEND_DELAY+2.) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    	removeActionsToPerform();
    });
}

%new
+ (void)performReply:(NSString *)reply forAction:(NSString *)actionID andBulletinID:(NSString *)bulletinID
{
	saveActionToPerform(actionID, bulletinID, YES, reply);

    CPDistributedMessagingCenter *c = [%c(CPDistributedMessagingCenter) centerNamed:rocketbootstrapSpringboardCenterName];
    rocketbootstrap_distributedmessagingcenter_apply(c);
    [c sendMessageName:performNotificationActionCommand userInfo:NULL];

    // send message after 5 seconds
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(SEND_DELAY * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CPDistributedMessagingCenter *c = [%c(CPDistributedMessagingCenter) centerNamed:rocketbootstrapSpringboardCenterName];
        rocketbootstrap_distributedmessagingcenter_apply(c);
        [c sendMessageName:performNotificationActionCommand userInfo:NULL];
    });

    // send message after 10 seconds
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(SECOND_SEND_DELAY * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CPDistributedMessagingCenter *c = [%c(CPDistributedMessagingCenter) centerNamed:rocketbootstrapSpringboardCenterName];
        rocketbootstrap_distributedmessagingcenter_apply(c);
        [c sendMessageName:performNotificationActionCommand userInfo:NULL];
    });

    // send message after 12 seconds
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((SECOND_SEND_DELAY+2.) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    	removeActionsToPerform();
    });
}

%new
+ (NSString *)bulletinIdentifierForInvokeANCSMessage:(PBTimelineInvokeANCSActionMessage *)message
{
	NSMutableArray *matchingNotifications = [NSMutableArray array];
    [[PBSMSNotificationsHelper sharedHelper] loadNotifications];
    log(@"all notifications %@", [[PBSMSNotificationsHelper sharedHelper] notificationsForAppIdentifier:[message appIdentifier]]);
	NSArray *notificationsArray = [[PBSMSNotificationsHelper sharedHelper] notificationsForAppIdentifier:[message appIdentifier]];
	for (PBSMSNotification *notification in notificationsArray)
	{
        log(@"notification %@ %@ %@", notification, notification.message, notification.bulletinId);
        log(@"message %@ %@", message, [message notificationBody]);
		if ([notification.message isEqualToString:[message notificationBody]])
		{
			[matchingNotifications addObject:@{ @"bulletinID" : notification.bulletinId, @"timestamp" : notification.timestamp }];
		}
	}
	NSLog(@"matchingNotifications %@", matchingNotifications);

	NSString *finalBulletinID = nil;
	NSDate *earliestTimestamp = nil;
	for (NSDictionary *dict in matchingNotifications)
	{
		NSString *bulletinID = dict[@"bulletinID"];
		NSDate *timestamp = dict[@"timestamp"];
		NSLog(@"%@ %@ %@ %@", finalBulletinID, earliestTimestamp, bulletinID, timestamp);
		if (earliestTimestamp == nil)
		{
			finalBulletinID = bulletinID;
			continue;
		}
		if ([timestamp compare:earliestTimestamp] == NSOrderedDescending)
		{
			earliestTimestamp = timestamp;
			finalBulletinID = bulletinID;
		}
	}

	return finalBulletinID;
}

%end

%hook _PBManagedTimelineItemActionable
-(void)removeActions:(id)arg1{%log;%orig;}
-(void)addActionsObject:(id)arg1{%log;%orig;}
-(void)removeActionsObject:(id)arg1{%log;%orig;}
-(void)insertObject:(id)arg1 inActionsAtIndex:(unsigned long long)arg2{%log;%orig;}
-(void)removeObjectFromActionsAtIndex:(unsigned long long)arg1{%log;%orig;}
-(void)insertActions:(id)arg1 atIndexes:(id)arg2{%log;%orig;}
-(void)removeActionsAtIndexes:(id)arg1{%log;%orig;}
-(void)replaceObjectInActionsAtIndex:(unsigned long long)arg1 withObject:(id)arg2{%log;%orig;}
-(void)replaceActionsAtIndexes:(id)arg1 withActions:(id)arg2{%log;%orig;}
-(void)addActions:(id)arg1{%log;%orig;}
-(id)actionsSet{%log;return %orig;}
%end

%hook PBManagedTimelineItemActionable
-(BOOL)updateActionsWithActions:(id)arg1{%log;return %orig;}
-(id)findOrCreateActionWithIdentifier:(id)arg1{%log;return %orig;}
%end

%hook PBNotificationSource

+(id)notificationSourceFromManagedEntry:(id)arg1
{
	PBNotificationSource *orig = %orig;

    log(@"notificationSourceFromManagedEntry %@ %@", arg1, [arg1 performSelector:@selector(actionsSet)]);
    NSArray *actionsArr = [(NSSet *)[arg1 performSelector:@selector(actionsSet)] allObjects];
    if (actionsArr.count == 1)
    {
        PBManagedTimelineItemAction *managedAction = actionsArr[0];
        PBTimelineAction *action = [%c(PBTimelineAction) timelineActionFromManagedTimelineItemAction:managedAction];
        log(@"action %@", action);
        for (PBTimelineAttribute *attribute in [action attributes])
        {
            if (![[attribute content] isKindOfClass:[NSString class]])
            {
                continue;
            }
            if ([(NSString *)[attribute content] isEqualToString:@"Action"])
            {
                // We're going to replace the actions, so delete the managed object
                [%c(PBSMSCoreDataHelper) deleteObject:arg1];
                break;
            }
        }
    }

	return [%c(PBNotificationSource) notificationSourceWithAppIdentifier:orig.appIdentifier
		flags:orig.flags
		version:orig.version
		attributes:orig.attributes
		actions:orig.actions];
}

+(id)notificationSourceWithBlob:(id)arg1 mapper:(id)arg2
{
    %log;
    log(@"%@ %@ %@ %@", arg1, arg2, [arg1 class], [arg2 class]);
    id r = %orig;
    log(@"%@", r);
    if ([r respondsToSelector:@selector(actions)])
    {
        log(@"%@", [r performSelector:@selector(actions)]);
    }
    return r;
}

+(id)notificationSourceWithAppIdentifier:(id)arg1 flags:(unsigned)arg2 version:(unsigned short)arg3 attributes:(id)arg4 actions:(id)arg5
{
	log(@"notificationSourceWithAppIdentifier %@", arg1);
	PBNotificationSource *orig = (PBNotificationSource *)%orig;
	BOOL shouldAddAction = NO;
	if ([[orig actions] count] == 0)
	{
		shouldAddAction = YES;
	}
	if ([[orig actions] count] == 1)
	{
		PBTimelineAction *action = [[orig actions] objectAtIndex:0];
		for (PBTimelineAttribute *attribute in [action attributes])
		{
			if (![[attribute content] isKindOfClass:[NSString class]])
			{
				continue;
			}
			if ([(NSString *)[attribute content] isEqualToString:@"Action"])
			{
				shouldAddAction = YES;
				break;
			}
		}
	}

	if (!shouldAddAction)
	{
		return orig;
	}

	log(@"Adding actions to %@", orig);

	NSString *appID = orig.appIdentifier;
	if (![appsArray containsObject:appID])
	{
		[appsArray addObject:appID];
	}

	PBTimelineAttribute *attr1 = [[%c(PBTimelineAttribute) alloc] initWithType:@"title" content:@"Action" specificType:0];
	PBTimelineAction *b = [[%c(PBTimelineAction) alloc] initWithIdentifier:@(HAS_ACTIONS_IDENTIFIER) type:@"ANCSResponse" attributes:@[ attr1 ]];
	return %orig(arg1, arg2, arg3, arg4, @[ b ]);
}

%end

%hook PBTimelineActionsWatchService
-(id)timelineWatchService{
	%log;
	id r = %orig;
	log(@"%@", r);
	return r;
}
-(void)ANCSActionHandler:(id)arg1 didSendResponse:(unsigned char)arg2 withAttributes:(id)arg3 actions:(id)arg4 forItemIdentifier:(id)arg5{
	%log;
	%orig;
}
-(void)sendTextAppActionHandler:(id)arg1 didSendResponse:(unsigned char)arg2 withAttributes:(id)arg3 forItemIdentifier:(id)arg4{
	%log;
	%orig;
}
-(void)registerInvokeActionHandler{
	%log;
	%orig;
}
-(void)registerInvokeANCSActionHandler{
	%log;
	%orig;
}
-(id)invokeActionHandler{
	%log;
	id r = %orig;
	log(@"%@", r);
	return r;
}
-(id)ANCSActionHandler{
	%log;
	id r = %orig;
	log(@"%@", r);
	return r;
}
-(void)handleANCSActionForInvokeActionMessage:(id)arg1{
	%log;
	PBTimelineInvokeANCSActionMessage *message = (PBTimelineInvokeANCSActionMessage *)arg1;
	log(@"%@", [%c(PBANCSActionHandler) bulletinIdentifierForInvokeANCSMessage:message]);
	%orig;
}
-(void)handleActionForItemIdentifier:(id)arg1 actionIdentifier:(unsigned char)arg2 attributes:(id)arg3{
	%log;
	%orig;
}
-(id)notificationHandler{
	%log;
	id r = %orig;
	log(@"%@", r);
	return r;
}
-(id)sendTextAppActionHandler{
	%log;
	id r = %orig;
	log(@"%@", r);
	return r;
}
-(void)handleActionForItem:(id)arg1 actionIdentifier:(unsigned char)arg2 attributes:(id)arg3{
	%log;
	%orig;
}
-(void)sendResponseForItemIdentifier:(id)arg1 response:(unsigned char)arg2 attributes:(id)arg3 actions:(id)arg4{
	%log;
	%orig;
}
-(void)processAction:(id)arg1 forItem:(id)arg2 attributes:(id)arg3{
	%log;
	%orig;
}
-(void)sendResponseForItem:(id)arg1 response:(unsigned char)arg2 attributes:(id)arg3{
	%log;
	%orig;
}
-(id)subtitleAttributeForLocalizedString:(id)arg1{
	%log;
	id r = %orig;
	log(@"%@", r);
	return r;
}
-(void)sendResponseForItem:(id)arg1 response:(unsigned char)arg2 subtitle:(id)arg3 icon:(id)arg4{
	%log;
	%orig;
}
-(NSString *)accountUserID{
	%log;
	id r = %orig;
	log(@"%@", r);
	return r;
}
-(id)httpActionSessionManager{
	%log;
	id r = %orig;
	log(@"%@", r);
	return r;
}
-(id)subtitleAttributeForString:(id)arg1{
	%log;
	id r = %orig;
	log(@"%@", r);
	return r;
}
-(void)sendResponseForItem:(id)arg1 response:(unsigned char)arg2 subtitle:(id)arg3 icon:(id)arg4 specificType:(long long)arg5{
	%log;
	%orig;
}
-(void)sendResponseForItemIdentifier:(id)arg1 response:(unsigned char)arg2 attributes:(id)arg3 actions:(id)arg4 mapperSignal:(id)arg5{
	%log;
	%orig;
}
-(void)sendResponseForItem:(id)arg1 response:(unsigned char)arg2 attributes:(id)arg3 actions:(id)arg4{
	%log;
	%orig;
}
-(void)sendANCSResponseForItemIdentifier:(id)arg1 response:(unsigned char)arg2 attributes:(id)arg3 actions:(id)arg4{
	%log;
	%orig;
}
-(void)sendResponseForItem:(id)arg1 response:(unsigned char)arg2{
	%log;
	%orig;
}
%end

%end

%ctor
{
    if ([%c(PBAppDelegate) class])
	{
        %init(PebbleMain);
        log(@"major %@", [%c(PBAppDelegate) majorAppVersion]);
        log(@"minor %@", [%c(PBAppDelegate) minorAppVersion]);
    }
    else if ([%c(SpringBoard) class])
	{
        %init(SpringboardHooks);
    }
    else if ([%c(SMSApplication) class])
	{
        %init(MobileSMSHooks);
    }
    %init;
}