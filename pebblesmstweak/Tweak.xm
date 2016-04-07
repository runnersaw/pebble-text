#import <CoreTelephony/CTMessageCenter.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
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
    
    [[UIApplication sharedApplication] launchApplicationWithIdentifier:@"com.apple.MobileSMS" suspended:YES];

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

    NSLog(@"PB SMSApplication didFinishLaunchingWithOptions");

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
    NSString *num = [@"+" stringByAppendingString:[[number componentsSeparatedByCharactersInSet: [[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""]];

    CKConversationList *conversationList = [CKConversationList sharedConversationList];
    CKConversation *conversation = [conversationList conversationForExistingChatWithGroupID:num];

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

@interface NSString (Levenshtein)

// calculate the smallest distance between all words in stringA and stringB
- (CGFloat) compareWithString: (NSString *) stringB matchGain:(NSInteger)gain missingCost:(NSInteger)cost;

// calculate the distance between two string treating them each as a single word
- (NSInteger) compareWithWord:(NSString *) stringB matchGain:(NSInteger)gain missingCost:(NSInteger)cost;
@end

@implementation NSString (Levenshtein)

// default match: 0
// default cost: 1

// calculate the mean distance between all words in stringA and stringB
- (CGFloat) compareWithString: (NSString *) stringB matchGain:(NSInteger)gain missingCost:(NSInteger)cost {
    CGFloat averageSmallestDistance = 0.0;
    CGFloat smallestDistance;
    
    NSString *mStringA = [self stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    NSString *mStringB = [stringB stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    
    NSArray *arrayA = [mStringA componentsSeparatedByString: @" "];
    NSArray *arrayB = [mStringB componentsSeparatedByString: @" "];
    
    for (NSString *tokenA in arrayA) {
        smallestDistance = 99999999.0;
        
        for (NSString *tokenB in arrayB) {
            smallestDistance = MIN((CGFloat) [tokenA compareWithWord:tokenB matchGain:gain missingCost:cost], smallestDistance);
        }
        
        averageSmallestDistance += smallestDistance;
    }
    
    return averageSmallestDistance / (CGFloat) [arrayA count];
}


// calculate the distance between two string treating them eash as a single word
- (NSInteger) compareWithWord:(NSString *) stringB matchGain:(NSInteger)gain missingCost:(NSInteger)cost {
    // normalize strings
    NSString * stringA = [NSString stringWithString: self];
    stringA = [[stringA stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
    stringB = [[stringB stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];    
    
    // Step 1
    NSInteger k, i, j, change, *d, distance;
    
    NSUInteger n = [stringA length];
    NSUInteger m = [stringB length];    
    
    if( n++ != 0 && m++ != 0 ) {
        d = (NSInteger *)malloc( sizeof(NSInteger) * m * n );
        
        // Step 2
        for( k = 0; k < n; k++)
            d[k] = k;
        
        for( k = 0; k < m; k++)
            d[ k * n ] = k;
        
        // Step 3 and 4
        for( i = 1; i < n; i++ ) {
            for( j = 1; j < m; j++ ) {
                
                // Step 5
                if([stringA characterAtIndex: i-1] == [stringB characterAtIndex: j-1]) {
                    change = -gain;
                } else {
                    change = cost;
                }
                
                // Step 6
                d[ j * n + i ] = MIN(d [ (j - 1) * n + i ] + 1, MIN(d[ j * n + i - 1 ] +  1, d[ (j - 1) * n + i -1 ] + change));
            }
        }
        
        distance = d[ n * m - 1 ];
        free( d );
        return distance;
    }
    
    return 0;
}

@end

@interface PBContact

+ (id)contactWithRecordRef:(void *)fp8;
- (void *)recordRef;
- (id)phoneNumbers;
- (id)nickname;
- (id)companyName;
- (id)nameSuffix;
- (id)lastName;
- (id)middleName;
- (id)firstName;
- (id)namePrefix;
- (int)identifier;
- (id)fullName;
- (id)initWithRecordRef:(void *)fp8;
- (id)init;
- (id)actionSubtitle;
- (id)actionTitle;
- (void)performActionOnAddressBookQuerySession:(id)fp8;
+ (NSString *)phoneWithPrefix:(NSString *)number;

@end

%hook PBContact

%new
+ (NSString *)phoneWithPrefix:(NSString *)number {
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
    if ([number rangeOfString:@"+"].location == NSNotFound) {
        NSLog(@"PB prefix %@", callingCode);
        if (callingCode != NULL) {
            n = [callingCode stringByAppendingString:number];
        } else {
            n = [@"1" stringByAppendingString:number];
        }
    } else {
        n = number;
    }
    NSString *num = [@"+" stringByAppendingString:[[n componentsSeparatedByCharactersInSet: [[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""]];

    return num;
}

%end

@interface PBAddressBook

+ (id)addressBook;
- (void *)addressBookRef;
- (id)allContacts;
- (id)contactWithIdentifier:(int)fp8;
- (id)initWithAddressBookRef:(void *)fp8;
- (id)init;
- (id)contactsMatchingQuery:(id)fp8;
- (id)searchContacts:(NSString *)search tries:(int)tries;

@end

@interface PBWatch

- (void)appMessagesPushUpdate:(id)fp8 onSent:(id)fp1001 uuid:(void *)fp12 launcher:(id)fp16;
- (void)send:(id)fp8 onDone:(id)fp1001 onTimeout:(void *)fp12 processInQueue:(id)fp10301;
- (NSMutableDictionary *)getContactSearchResponse:(NSString *)name tries:(int)tries;
- (NSMutableDictionary *)getSentResponse;
- (NSMutableDictionary *)getConnectionResponse;
- (NSMutableDictionary *)getRecentContactsResponse;
- (NSMutableDictionary *)getPresets;
+ (void)sendSMS:(NSString *)number withText:(NSString *)text;

@end

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
#define IS_PEBBLE_SMS_KEY [NSNumber numberWithInt:94375]

#define BEGINNING_STATE [NSNumber numberWithInt:0]
#define DICTATED_NAME_STATE [NSNumber numberWithInt:1]
#define CHECKING_CONTACT_STATE [NSNumber numberWithInt:2]
#define CREATING_FINAL_MESSAGE_STATE [NSNumber numberWithInt:3]
#define CONFIRMING_FINAL_MESSAGE_STATE [NSNumber numberWithInt:4]
#define FINAL_MESSAGE_STATE [NSNumber numberWithInt:5]
#define GETTING_RECENT_CONTACTS_STATE [NSNumber numberWithInt:6]
#define GETTING_PRESETS_STATE [NSNumber numberWithInt:7]

%hook PBWatch

%new
- (NSMutableDictionary *)getContactSearchResponse:(NSString *)name tries:(int)tries {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];

    NSMutableDictionary *contact = [[%c(PBAddressBook) addressBook] searchContacts:name tries:tries];
    [dict setObject:[contact objectForKey:@"name"] forKey:CONTACT_NAME_KEY];
    NSString *num = [%c(PBContact) phoneWithPrefix:[contact objectForKey:@"number"]];
    [dict setObject:num forKey:CONTACT_NUMBER_KEY];

    return dict;
}

%new
- (NSMutableDictionary *)getSentResponse {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];

    [dict setObject:@"Sent" forKey:MESSAGE_CONFIRMATION_KEY];
    
    return dict;
}

%new
- (NSMutableDictionary *)getConnectionResponse {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];

    [dict setObject:@"Connected" forKey:CONNECTION_TEST_KEY];
    
    return dict;
}

%new
- (NSMutableDictionary *)getRecentContactsResponse {
    loadRecentRecipients();

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];

    [dict setObject:[names componentsJoinedByString:@"\n"] forKey:RECENT_CONTACTS_NAME_KEY];
    [dict setObject:[phones componentsJoinedByString:@"\n"] forKey:RECENT_CONTACTS_NUMBER_KEY];
    
    return dict;
}

%new
- (NSMutableDictionary *)getPresets {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];

    [dict setObject:[@[@"Yes", @"No", @"OK"] componentsJoinedByString:@"\n"] forKey:PRESETS_KEY];
    
    return dict;
}

- (void)appMessagesPushUpdate:(id)fp8 onSent:(id)fp1001 uuid:(void *)fp12 launcher:(id)fp16 {
    NSMutableDictionary *message = (NSMutableDictionary *)fp8;
    id isSMS = [message objectForKey:IS_PEBBLE_SMS_KEY];
    if (isSMS != NULL && [isSMS intValue] == [[NSNumber numberWithInt:1] intValue]) {
        NSMutableDictionary *response;
        BOOL initialized = NO;
        
        id connectionTest = [message objectForKey:CONNECTION_TEST_KEY];
        NSNumber *state = [message objectForKey:STATE_KEY];
        if (connectionTest != NULL) {
            response = [self getConnectionResponse];
            initialized = YES;
        }

        if (state != NULL) {
            if ([state intValue] == [GETTING_RECENT_CONTACTS_STATE intValue]) {
                response = [self getRecentContactsResponse];
                initialized = YES;
            }
            
            if ([state intValue] == [GETTING_PRESETS_STATE intValue]) {
                response = [self getPresets];
                initialized = YES;
            }
            
            if ([state intValue] == [CHECKING_CONTACT_STATE intValue]) {
                NSNumber *tries = [message objectForKey:ATTEMPT_NUMBER_KEY];
                NSString *name = [message objectForKey:DICTATED_NAME_KEY];
                if (tries != NULL && name != NULL) {
                    response = [self getContactSearchResponse:name tries: [tries intValue]];
                    initialized = YES;
                }
            }
            
            if ([state intValue] == [FINAL_MESSAGE_STATE intValue]) {
                NSString *number = [message objectForKey:CONTACT_NUMBER_KEY];
                NSString *m = [message objectForKey:FINAL_MESSAGE_KEY];
                if (number != NULL && m != NULL) {
                    [%c(PBWatch) sendSMS:[%c(PBContact) phoneWithPrefix:number] withText:m];
                    response = [self getSentResponse];
                    initialized = YES;
                }
            }
        }

        if (initialized) {
            NSLog(@"PBWatch response %@", [response description]);
            %orig(response, fp1001, fp12, fp16); 
        } else {
            %orig;
        }
    } else {
        %orig;
    }
}

%new
+ (void)sendSMS:(NSString *)number withText:(NSString *)text {
    // launch messages
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)messageNotificationString, nil, nil, YES);

    // send message after 5 seconds
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"PEBBLESMS: Sending rocketbootstrap");
        CPDistributedMessagingCenter *c = [%c(CPDistributedMessagingCenter) centerNamed:@"com.sawyervaughan.pebblesms"];
        rocketbootstrap_distributedmessagingcenter_apply(c);
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:text, @"message", number, @"recipient", nil];
        [c sendMessageName:@"messageWithInfo" userInfo:dict]; 
    });

}

%end

@interface PBLabeledValue

- (id)value;
- (id)label;
- (id)identifier;
- (id)description;

@end

@interface PBPhoneNumber

+ (id)phoneNumberWithStringValue:(id)fp8;
- (BOOL)isValid;
- (id)stringValue;
- (id)sanitizePhoneNumber:(id)fp8;
- (BOOL)isPhoneNumberStringValid:(id)fp8;
- (id)description;
- (id)cleanedStringValue;
- (id)init;
- (id)initWithStringValue:(id)fp8;

@end

%hook PBAddressBook

%new
- (id)searchContacts:(NSString *)search tries:(int)tries {
    NSMutableArray *results = [NSMutableArray array];

    for (id item in (NSArray *)[self allContacts]) {
        // note the modified weighting, this ends up working similiar to Alfred / TextMate searching method
        // TextMate takes into account camelcase while matching and is a little smarter, but you get the idea
        NSInteger score0 = [[search lowercaseString] compareWithWord:[[item fullName] lowercaseString] matchGain:10 missingCost:1];
        NSInteger score1 = [[search lowercaseString] compareWithWord:[[item firstName] lowercaseString] matchGain:10 missingCost:1];
        NSInteger score2 = [[search lowercaseString] compareWithWord:[[item lastName] lowercaseString] matchGain:10 missingCost:1];
        NSInteger score3 = [[search lowercaseString] compareWithWord:[[item nickname] lowercaseString] matchGain:10 missingCost:1];
        NSInteger score4 = [[search lowercaseString] compareWithWord:[[item middleName] lowercaseString] matchGain:10 missingCost:1];

        NSInteger min = score0;
        if (score1 < min) {
            min = score1;
        }
        if (score2 < min) {
            min = score2;
        }
        if (score3 < min) {
            min = score3;
        }
        if (score4 < min) {
            min = score4;
        }

        [results addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:min], @"score", item, @"item", nil]];
    }

    // sort list
    NSArray *res = [results sortedArrayUsingComparator: (NSComparator)^(id obj1, id obj2) {
        return [[obj1 valueForKey:@"score"] compare:[obj2 valueForKey:@"score"]];
    }];

    int i = 0;
    int contactIndex = 0;
    NSString *name;
    NSString *number;
    while (i <= tries) {
        PBContact *c = [[res objectAtIndex:contactIndex] objectForKey:@"item"];
        contactIndex++;
        for (int j=0;j<[[c phoneNumbers] count];j++) {
            name = [c fullName];
            number = [(PBPhoneNumber *)[(PBLabeledValue *)[[c phoneNumbers] objectAtIndex:j] value] stringValue];
            i++;
            if (i == tries+1) {
                break;
            }
        }
    }
    return [NSDictionary dictionaryWithObjectsAndKeys:name, @"name", number, @"number", nil];
}

%end

@interface PBAddressBookAuthorizationManager
+ (void)requestAuthorizationWithCompletion:(id)completion;
@end

@interface PBSMSReplyManager

- (id)SMSProviders;
- (id)linkedAccountsManager;
- (id)notificationSourceManager;
- (void)setHasLinkedSMSAccount:(BOOL)fp8;
- (BOOL)hasLinkedSMSAccount;
- (void)removeDisabledProvidersIfNecessary;
- (unsigned char)linkedSMSProvider;
- (void)handleCarrierOverrideDidChangeNotification:(id)fp8;
- (void)disableSMSActions;
- (void)enableSMSActions;
- (BOOL)isCarrierProviderEnabled;
- (void)setSMSActionsEnabled:(BOOL)fp8;
- (unsigned char)providerFromCarrier;
- (id)linkedSMSAccount;
- (void)removeSMSAccount;
- (void)setSMSAccount:(id)fp8;
- (void)dealloc;
- (id)initWithNotificationSourceManager:(id)fp8 linkedAccountsManager:(id)fp12;

@end

@interface PBSMSSessionManager

+ (void)sendSMS:(NSString *)number withText:(NSString *)text;
- (id)sendSMSSendRequestWithMessage:(id)fp8 account:(id)fp12 transactionID:(id)fp16;
- (id)initWithBaseURL:(id)fp8 sessionConfiguration:(id)fp12;

@end

@interface PBSMSApiClient

+ (id)client;
- (id)smsReplyManager;
- (id)linkedAccountsManager;
- (id)SMSSessionManager;
- (void)sendSMS:(NSString *)number withText:(NSString *)text;
- (id)sendSMSWithRecipients:(id)fp8 text:(id)fp12 transactionID:(id)fp16;
- (id)initWithLinkedAccountsManager:(id)fp8 smsReplyManager:(id)fp12;

@end

@interface PBSMSMessage

+ (id)recipientsJSONTransformer;
+ (id)JSONKeyPathsByPropertyKey;
+ (id)messageWithRecipients:(id)fp8 text:(id)fp12;
- (id)text;
- (id)recipients;

@end

@interface PBLinkedAccountsRequest

+ (id)credentialsJSONTransformer;
+ (id)JSONKeyPathsByPropertyKey;
+ (id)requestWithCredentials:(id)fp8;
- (id)credentials;

@end

@interface PBLinkedAccountsSessionManager

- (id)revokeLinkedAccount:(id)fp8;
- (id)refreshLinkedAccount:(id)fp8;
- (id)authorizationURLRequestForProvider:(unsigned char)fp8;
- (id)initWithBaseURL:(id)fp8 sessionConfiguration:(id)fp12;

@end

@interface PBLinkedAccount

+ (id)credentialsJSONTransformer;
+ (id)settingsJSONTransformer;
+ (id)providerJSONTransformer;
+ (id)uuidJSONTransformer;
+ (id)encodingBehaviorsByPropertyKey;
+ (id)JSONKeyPathsByPropertyKey;
- (void)setCredentials:(id)fp8;
- (id)credentials;
- (void)setSettings:(id)fp8;
- (id)settings;
- (unsigned char)provider;
- (id)uuid;
- (id)queryParameters:(id)fp8 key:(id)fp12 toResultClass:(id)fp16;
- (BOOL)isAccountExpired;
- (id)initWithProvider:(unsigned char)fp8 queryParameters:(id)fp12;

@end

@interface PBLinkedAccountCredentials

+ (id)expirationJSONTransformer;
+ (id)JSONKeyPathsByPropertyKey;
- (id)expiration;
- (id)apiData;

@end

@interface PBLinkedAccountsManager

+(id) providerToString:(unsigned char)arg1;
+(unsigned char) stringToProvider:(id)arg;
-(BOOL) addLinkedAccount:(id)arg;
-(BOOL) hasLinkedAccountForProvider:(unsigned char)arg;
-(BOOL) removeLinkedAccountForProvider:(unsigned char)arg;
-(id) linkedAccountForProvider:(unsigned char)arg;
-(BOOL) isProviderEnabled:(unsigned char)arg;
-(id) APIClient;
-(id) enabledProviders;
-(void) refreshLinkedAccountForProvider:(unsigned char)arg1 withForceRefresh:(BOOL)arg2 completion:(id)arg3;
-(id) linkedAccountsValet;
-(id) init;

@end

%hook PBSMSSessionManager

- (id)sendSMSSendRequestWithMessage:(id)fp8 account:(id)fp12 transactionID:(id)fp16 {
    %log; 

    PBSMSMessage *message = (PBSMSMessage *)fp8;
    NSString *text = [message text];
    NSString *number = (NSString *)[(PBPhoneNumber *)[[message recipients] objectAtIndex:0] stringValue];
    [%c(PBSMSSessionManager) sendSMS:[%c(PBContact) phoneWithPrefix:number] withText:text];
    return NULL;
}

%new
+ (void)sendSMS:(NSString *)number withText:(NSString *)text {

    // launch messages
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)messageNotificationString, nil, nil, YES);

    // send message after 5 seconds
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"PEBBLESMS: Sending rocketbootstrap");
        CPDistributedMessagingCenter *c = [%c(CPDistributedMessagingCenter) centerNamed:@"com.sawyervaughan.pebblesms"];
        rocketbootstrap_distributedmessagingcenter_apply(c);
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:text, @"message", number, @"recipient", nil];
        [c sendMessageName:@"messageWithInfo" userInfo:dict]; 
    });

}

%end

@interface PBAppDelegate

+ (id)applicationDelegate;
- (void)setHockeyApp:(id)fp8;
- (id)hockeyApp;
- (void)setBluetoothStuckLocalNotification:(id)fp8;
- (id)bluetoothStuckLocalNotification;
- (void)setConnectedFirstWatchNotification:(id)fp8;
- (id)connectedFirstWatchNotification;
- (void)setShowingBluetoothStuckAlert:(BOOL)fp8;
- (BOOL)showingBluetoothStuckAlert;
- (void)setFileURLRouter:(id)fp8;
- (id)fileURLRouter;
- (void)setBackgroundFetchManager:(id)fp8;
- (id)backgroundFetchManager;
- (void)setRemoteNotificationManager:(id)fp8;
- (id)remoteNotificationManager;
- (void)setDependencies:(id)fp8;
- (id)dependencies;
- (void)setWindow:(id)fp8;
- (id)window;
- (void)setupInitiallyConnectedWatches;
- (void)initializeJSApps;
- (void)setupWebRequestCache;
- (void)handleDisconnect:(id)fp8;
- (void)handleConnect:(id)fp8;
- (void)getVersionInfo:(id)fp8;
- (void)bluetoothSessionStuckNotificationReceived;
- (void)watch:(id)fp8 handleError:(id)fp12;
- (void)pebbleCentral:(id)fp8 watchDidConnect:(id)fp12 isNew:(BOOL)fp16;
- (void)pebbleCentral:(id)fp8 watchDidDisconnect:(id)fp12;
- (void)application:(id)fp8 performFetchWithCompletionHandler:(id)fp1;
- (void)application:(id)fp8 didFinishLaunchingWithLocalNotification:(id)fp12;
- (void)application:(id)fp8 didFinishLaunchingWithRemoteNotification:(id)fp12;
- (void)application:(id)fp8 didReceiveRemoteNotification:(id)fp12 fetchCompletionHandler:(id)fp1;
- (void)application:(id)fp8 didReceiveRemoteNotification:(id)fp12;
- (void)application:(id)fp8 didFailToRegisterForRemoteNotificationsWithError:(id)fp12;
- (void)application:(id)fp8 didRegisterForRemoteNotificationsWithDeviceToken:(id)fp12;
- (void)application:(id)fp8 didRegisterUserNotificationSettings:(id)fp12;
- (void)applicationProtectedDataDidBecomeAvailable:(id)fp8;
- (void)applicationProtectedDataWillBecomeUnavailable:(id)fp8;
- (void)application:(id)fp8 didReceiveLocalNotification:(id)fp12;
- (void)applicationWillTerminate:(id)fp8;
- (void)applicationDidBecomeActive:(id)fp8;
- (void)applicationWillEnterForeground:(id)fp8;
- (void)applicationDidEnterBackground:(id)fp8;
- (void)applicationWillResignActive:(id)fp8;
- (void)applicationDidReceiveMemoryWarning:(id)fp8;
- (BOOL)application:(id)fp8 shouldRestoreApplicationState:(id)fp12;
- (BOOL)application:(id)fp8 shouldSaveApplicationState:(id)fp12;
- (BOOL)application:(id)fp8 openURL:(id)fp12 sourceApplication:(id)fp16 annotation:(id)fp20;
- (BOOL)application:(id)fp8 didFinishLaunchingWithOptions:(id)fp12;
- (BOOL)application:(id)fp8 willFinishLaunchingWithOptions:(id)fp12;

@end

@interface PBLockerAppManager

+ (id)currentUserLockerAppManager;
- (id)applicationWithUUID:(id)fp8;
- (void)setApplications:(id)fp8;
- (id)watchfaces;
- (id)watchapps;
- (id)applications;
- (void)dealloc;
- (id)init;
- (id)initWithUserAccountID:(id)fp8 localAppsStorage:(id)fp12 lockerSessionManager:(id)fp16 timelineBlobMapperConfigurationCache:(id)fp20;

@end

@interface PBLockerSessionManager

+ (id)lockerCache;

@end

%hook PBAppDelegate

- (void)applicationDidBecomeActive:(id)fp8 {
    %orig;

    NSLog(@"PEBBLESMS: Trying to request authorization");
    [%c(PBAddressBookAuthorizationManager) requestAuthorizationWithCompletion:NULL];
}

%end
