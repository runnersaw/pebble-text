#import <ChatKit/CKEntity.h>
#import <ChatKit/CKConversation.h>
#import <ChatKit/CKConversationList.h>
#import <ChatKit/CKComposition.h>
#import <IMCore/IMPerson.h>
#import <IMCore/IMHandle.h>
#import <AddressBook/AddressBook.h>
#import <AppSupport/CPDistributedMessagingCenter.h>
#import <UIKit/UIApplication.h>
#import <AppList/AppList.h>

// NS EXTENSIONS

@interface NSUserDefaults (PebbleSMS)
- (id)objectForKey:(NSString *)key inDomain:(NSString *)domain;
- (void)setObject:(id)value forKey:(NSString *)key inDomain:(NSString *)domain;
@end

@interface NSString (Levenshtein)
// calculate the smallest distance between all words in stringA and stringB
- (CGFloat) compareWithString:(NSString *) stringB matchGain:(NSInteger)gain missingCost:(NSInteger)cost;
// calculate the distance between two string treating them each as a single word
- (NSInteger) compareWithWord:(NSString *) stringB matchGain:(NSInteger)gain missingCost:(NSInteger)cost;
@end

@interface NSDistributedNotificationCenter
+ (id)defaultCenter;
- (void)addObserver:(id)notificationObserver selector:(SEL)notificationSelector name:(NSString *)notificationName object:(NSString *)notificationSender;
- (void)postNotificationName:(NSString *)notificationName object:(NSString *)notificationSender userInfo:(NSDictionary *)userInfo deliverImmediately:(BOOL)deliverImmediately;
- (void)postNotificationName:(NSString *)notificationName object:(NSString *)notificationSender;
@end

@interface NSManagedObject : NSObject
@end

@interface NSManagedObjectContext : NSObject
- (void)deleteObject:(NSManagedObject *)object;
@end

@interface UIApplication (PebbleSMS)
+(id)sharedApplication;
-(BOOL)launchApplicationWithIdentifier:(id)arg1 suspended:(BOOL)arg2;
@end

// SPRINGBOARD

@interface SpringBoard
- (void)handleMessageNamed:(NSString *)name withUserInfo:(NSDictionary *)userinfo;
@end

@interface SBBulletinBannerController : NSObject
@property(readonly, copy) NSString *debugDescription;
@property(readonly, copy) NSString *description;
+ (id)sharedInstanceIfExists;
+ (id)sharedInstance;
+ (id)_sharedInstanceCreateIfNecessary:(_Bool)arg1;
- (void)_showTestBanner:(_Bool)arg1;
- (id)init;
- (void)observer:(id)arg1 removeBulletin:(id)arg2;
- (void)observer:(id)arg1 addBulletin:(id)arg2 forFeed:(unsigned long long)arg3 playLightsAndSirens:(_Bool)arg4 withReply:(id)arg5;
- (void)observer:(id)arg1 addBulletin:(id)arg2 forFeed:(unsigned long long)arg3;
@end

// SMS STUFF HEADERS

@interface CKMessage : NSObject
@end

@interface SMSApplication : UIApplication
- (BOOL)application:(id)arg1 didFinishLaunchingWithOptions:(id)arg2;
@end

@interface IMMessage
- (NSDate *)timeDelivered;
@end

@interface IMChat
-(NSArray *)participants;
-(IMHandle *)recipient;
-(IMMessage *)lastMessage;
@end

@interface CKConversation (PebbleSMS)
- (void)saveRecipient;
@end

@interface IMDaemonListener
- (void)account:(id)arg1 chat:(id)arg2 style:(unsigned char)arg3 chatProperties:(id)arg4 messageReceived:(id)arg5;
@end

@interface IMMessageItem : NSObject
-(id)sender;
-(BOOL)isFromMe;
@end

// BULLETIN BOARD

@interface BBBulletin : NSObject
+ (id)addBulletinToCache:(id)arg1;
+ (id)bulletinReferenceDateFromDate:(id)arg1;
+ (id)bulletinWithBulletin:(id)arg1;
- (id)acknowledgeAction;
- (id)actionForResponse:(id)arg1;
- (id)actionWithIdentifier:(id)arg1;
- (id)actions;
- (void)addObserver:(id)arg1;
- (id)bulletinID;
- (id)bulletinVersionID;
- (id)buttons;
- (id)content;
- (id)context;
- (id)date;
- (id)description;
- (id)dismissAction;
- (id)dismissalID;
- (id)init;
- (id)message;
- (unsigned int)messageNumberOfLines;
- (id)observers;
- (id)publicationDate;
- (id)publisherBulletinID;
- (id)publisherMatchID;
- (id)raiseAction;
- (id)recencyDate;
- (id)recordID;
- (id)responseForAcknowledgeAction;
- (id)responseForAction:(id)arg1;
- (id)responseForButtonActionAtIndex:(unsigned int)arg1;
- (id)responseForDefaultAction;
- (id)responseForExpireAction;
- (id)responseForRaiseAction;
- (id)responseForSnoozeAction;
- (id)responseSendBlock;
- (id)section;
- (id)sectionDisplayName;
- (id)sectionID;
- (id)sectionIcon;
- (int)sectionSubtype;
- (void)setAcknowledgeAction:(id)arg1;
- (void)setActions:(id)arg1;
- (void)setBulletinID:(id)arg1;
- (void)setBulletinVersionID:(id)arg1;
- (void)setButtons:(id)arg1;
- (void)setContent:(id)arg1;
- (void)setContext:(id)arg1;
- (void)setDate:(id)arg1;
- (void)setDefaultAction:(id)arg1;
- (void)setDismissAction:(id)arg1;
- (void)setDismissalID:(id)arg1;
- (void)setMessage:(id)arg1;
- (void)setObservers:(id)arg1;
- (void)setPublicationDate:(id)arg1;
- (void)setPublisherBulletinID:(id)arg1;
- (void)setRaiseAction:(id)arg1;
- (void)setRecordID:(id)arg1;
- (void)setSection:(id)arg1;
- (void)setSectionID:(id)arg1;
- (void)setSectionSubtype:(int)arg1;
- (void)setSubtitle:(id)arg1;
- (void)setSupplementaryActionsByLayout:(id)arg1;
- (void)setTitle:(id)arg1;
- (id)shortDescription;
- (id)subsectionIDs;
- (id)subtitle;
- (id)supplementaryActions;
- (id)supplementaryActionsByLayout;
- (id)supplementaryActionsForLayout:(int)arg1;
- (id)title;
- (id)uniqueIdentifier;
- (BOOL)_isPushOrLocalNotification;
- (id)_launchURLForAction:(id)arg1 context:(id)arg2;
- (id)_responseForAction:(id)arg1 withOrigin:(int)arg2 context:(id)arg3;
- (id)actionBlockForAction:(id)arg1;
- (id)actionBlockForAction:(id)arg1 withOrigin:(int)arg2;
- (id)actionBlockForAction:(id)arg1 withOrigin:(int)arg2 context:(id)arg3;
- (id)actionBlockForButton:(id)arg1;
@end

@interface BBContent : NSObject
+ (id)contentWithTitle:(id)arg1 subtitle:(id)arg2 message:(id)arg3;
- (id)description;
- (BOOL)isEqualToContent:(id)arg1;
- (id)message;
- (id)subtitle;
- (id)title;

@end

@interface BBResponse : NSObject
- (id)actionID;
- (int)actionType;
- (id)bulletinID;
- (id)buttonID;
- (id)context;
- (id)replyText;
- (void)send;
- (id /* block */)sendBlock;
- (void)setActionID:(id)arg1;
- (void)setActionType:(int)arg1;
- (void)setBulletinID:(id)arg1;
- (void)setContext:(id)arg1;
- (void)setReplyText:(id)arg1;
- (void)setSendBlock:(id /* block */)arg1;
@end

@interface BBAppearance : NSObject
- (id)title;
@end

@interface BBAction : NSObject
+ (id)action;
+ (id)actionWithAppearance:(id)arg1;
+ (id)actionWithCallblock:(id)arg1;
+ (id)actionWithIdentifier:(id)arg1;
+ (id)actionWithIdentifier:(id)arg1 title:(id)arg2;
+ (id)actionWithLaunchBundleID:(id)arg1;
+ (id)actionWithLaunchBundleID:(id)arg1 callblock:(id)arg2;
+ (id)actionWithLaunchURL:(id)arg1;
+ (id)actionWithLaunchURL:(id)arg1 callblock:(id)arg2;
- (int)actionType;
- (id)appearance;
- (int)behavior;
- (id)behaviorParameters;
- (id)bundleID;
- (BOOL)canBypassPinLock;
- (BOOL)deliverResponse:(id)arg1;
- (id)description;
- (id)identifier;
- (id)init;
- (id)initWithIdentifier:(id)arg1;
- (BOOL)isAuthenticationRequired;
- (BOOL)isEqual:(id)arg1;
- (id)launchBundleID;
- (BOOL)launchCanBypassPinLock;
- (id)launchURL;
- (id)partialDescription;
- (void)setActionType:(int)arg1;
- (void)setAppearance:(id)arg1;
- (void)setAuthenticationRequired:(BOOL)arg1;
- (void)setBehavior:(int)arg1;
- (void)setBehaviorParameters:(id)arg1;
- (void)setCallblock:(id)arg1;
- (void)setCanBypassPinLock:(BOOL)arg1;
- (void)setIdentifier:(id)arg1;
- (void)setInternalBlock:(id)arg1;
- (void)setLaunchBundleID:(id)arg1;
- (void)setLaunchCanBypassPinLock:(BOOL)arg1;
- (void)setLaunchURL:(id)arg1;
- (void)setShouldDismissBulletin:(BOOL)arg1;
- (BOOL)shouldDismissBulletin;
- (id)url;
@end

@interface BBObserver : NSObject
- (void)getBulletinsWithCompletion:(id /* block */)arg1;
- (void)noteServerReceivedResponseForBulletin:(id)arg1;
- (void)sendResponse:(id)arg1;
- (id)init;
- (id)initWithQueue:(id)arg1;
- (id)initWithQueue:(id)arg1 asGateway:(id)arg2 priority:(unsigned int)arg3;
- (id)initWithQueue:(id)arg1 forGateway:(id)arg2;
- (void)updateBulletin:(id)arg1 forFeeds:(unsigned int)arg2 withReply:(id /* block */)arg3;
@end

// PEBBLE HEADERS

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

// 3.12
+(id)fallbackName;
-(id)computeOrderableName;
-(id)orderableName;

@end

@interface PBLabeledValue
- (id)value;
- (id)label;
- (id)identifier;
- (id)description;
@end

@interface PBPhoneNumber : NSObject
// Pebble 3.11
+ (id)phoneNumberWithStringValue:(id)fp8;
- (BOOL)isValid;
- (id)stringValue;
- (id)sanitizePhoneNumber:(id)fp8;
- (BOOL)isPhoneNumberStringValid:(id)fp8;
- (id)description;
- (id)cleanedStringValue;
- (id)init;
- (id)initWithStringValue:(id)fp8;

// Pebble 3.12
-(NSString *)rawStringValue;
-(NSNumber *)countryCallingCode;
-(NSString *)stringRepresentationForWatch;
-(NSString *)stringRepresentationForWeb;
-(BOOL)isEqual:(id)arg1;
@end

@interface PBAddressBook
+ (id)addressBook;
- (void *)addressBookRef;
- (id)allContacts;
- (id)contactWithIdentifier:(int)fp8;
- (id)initWithAddressBookRef:(void *)fp8;
- (id)init;
- (id)contactsMatchingQuery:(id)fp8;
@end

@interface PBPebbleCentral
+(id) defaultCentral;
-(id) appUUID;
-(id) connectedWatches;
-(void) setAppUUID:(id)arg1;
-(id) registeredWatches;
-(id) lastConnectedWatch;
-(id) appUUIDs;
-(void) addAppUUID:(id)arg;
-(BOOL) currentAppIsThePebbleApp;
-(id) endpointsByUUID;
-(void) handleApplicationWillResignActiveNotification:(id)arg;
-(void) setAppUUIDs:(id)arg;
-(BOOL) hasValidAppUUID;
-(void) setDelegate:(id)arg;
-(id) delegate;
-(id) _init;
-(void) run;
-(BOOL) running;
-(unsigned long long) capabilities;
@end

@interface PBWatch
- (void)appMessagesPushUpdate:(id)fp8 onSent:(id)fp1001 uuid:(id)fp12 launcher:(id)fp16;
- (void)appMessagesPushUpdate:(id)arg1 onSent:(id)arg2;
- (void)appMessagesPushUpdate:(id)arg1 withUUID:(id)arg2 onSent:(id)arg3;
- (void)send:(id)fp8 onDone:(id)fp1001 onTimeout:(void *)fp12 processInQueue:(id)fp10301;
@end

@interface PBAppDelegate

+ (id)applicationDelegate;
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
- (void)sentCallbackWithNotification:(NSNotification *)myNotification;
- (void)failedCallbackWithNotification:(NSNotification *)myNotification;
@end

@interface PBLockerAppManager
+ (id)currentUserLockerAppManager;
- (id)applicationWithUUID:(id)fp8;
- (void)setApplications:(id)fp8;
- (id)watchfaces;
- (id)watchapps;
- (id)applications;
- (id)init;
- (id)initWithUserAccountID:(id)fp8 localAppsStorage:(id)fp12 lockerSessionManager:(id)fp16 timelineBlobMapperConfigurationCache:(id)fp20;
@end

@interface PBAddressBookAuthorizationManager
+ (void)requestAuthorizationWithCompletion:(id)completion;
+ (int)authorizationStatus;
@end

@interface PBPhoneApp : NSObject
+(id)appWithSystemPhoneApp:(unsigned long long)arg1;
+(unsigned long long)systemPhoneAppFromBundleIdentifier:(id)arg1;
-(BOOL)isInstalled;
-(NSString *)localizedName;
-(NSString *)appBundleIdentifier;
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
- (id)initWithNotificationSourceManager:(id)fp8 linkedAccountsManager:(id)fp12;

// 3.12
-(id)linkedServicesSessionManager;
-(id)initWithNotificationSourceManager:(id)arg1 linkedAccountsManager:(id)arg2 modalCoordinator:(id)arg3 userDefaults:(id)arg4 linkedServicesSessionManager:(id)arg5;
-(id)smsApp;//PBPhoneApp
-(void)prepareSMSSetup;
-(id)currentCarrier;
-(void)setLastKnownCarrier:(id)arg1;
-(NSUserDefaults *)smsUserDefaults;
-(BOOL)checkIfProviderIsSupported:(unsigned char)arg1 forCarrier:(id)arg2 linkedAccount:(id)arg3;
-(BOOL)needToShowSMSSetup;
-(id)lastKnownCarrier;
-(NSSet *)smsApps;
-(NSSet *)ancsReplyEnabledApps;
-(id)networkInfo;

@end

@interface PBSMSSessionManager
- (id)sendSMSSendRequestWithMessage:(id)fp8 account:(id)fp12 transactionID:(id)fp16;
@end

@interface PBSMSApiClient
+ (id)client;
- (id)smsReplyManager;
- (id)linkedAccountsManager;
- (id)SMSSessionManager;
- (id)sendSMSWithRecipients:(id)fp8 text:(id)fp12 transactionID:(id)fp16;
- (id)initWithLinkedAccountsManager:(id)fp8 smsReplyManager:(id)fp12;

// 3.12
+(id)clientWithMessage:(id)arg1 transactionID:(id)arg2;
-(id)initWithLinkedAccountsManager:(id)arg1 smsReplyManager:(id)arg2 message:(id)arg3 transactionID:(id)arg4;
-(id)smsApp;
-(id)phoneApp;
-(id)SMSSessionManager;
-(id)message;
-(id)sendRequest;

@end

@interface PBSMSMessage
+ (id)messageWithRecipients:(id)fp8 text:(id)fp12;
- (id)text;
- (id)recipients;
@end

@interface PBLinkedAccountsRequest
+ (id)requestWithCredentials:(id)fp8;
- (id)credentials;
@end

@interface PBLinkedAccount
- (void)setCredentials:(id)fp8;
- (id)credentials;
- (void)setSettings:(id)fp8;
- (id)settings;
- (unsigned char)provider;
- (id)uuid;
- (id)queryParameters:(id)fp8 key:(id)fp12 toResultClass:(id)fp16;
- (BOOL)isAccountExpired;
- (id)initWithProvider:(unsigned char)fp8 queryParameters:(id)fp12;

// 3.12
-(BOOL)isExpired;
@end

@interface PBLinkedAccountCredentials
- (id)expiration;
- (id)apiData;
@end

@interface PBLinkedAccountsManager
// 3.6
+(id) providerToString:(unsigned char)arg1;
+(unsigned char) stringToProvider:(id)arg;
-(BOOL) addLinkedAccount:(id)arg;
-(BOOL) hasLinkedAccountForProvider:(unsigned char)arg;
-(BOOL) removeLinkedAccountForProvider:(unsigned char)arg;
-(id) linkedAccountForProvider:(unsigned char)arg;
-(BOOL) isProviderEnabled:(unsigned char)arg;
-(id) APIClient;
-(NSSet *)enabledProviders;
-(void) refreshLinkedAccountForProvider:(unsigned char)arg1 withForceRefresh:(BOOL)arg2 completion:(id)arg3;
-(id) linkedAccountsValet;
-(id) init;

// 3.12
-(id)refreshLinkedAccountsAssociatedWithApp:(id)arg1 withForceRefresh:(BOOL)arg2;
-(id)linkedAccountsForApp:(id)arg1;
-(id)linkedAccountRefreshSignal:(id)arg1 forApp:(id)arg2;
-(BOOL)hasLinkedAccountForApp:(id)arg1;
-(BOOL)addLinkedAccount:(id)arg1 toApp:(id)arg2;
-(BOOL)removeLinkedAccount:(id)arg1 forApp:(id)arg2;
-(id)linkedAccountsSessionManager;
@end

@interface PBSendSMSActionHandler : NSObject
+ (id)handlerWithDelegate:(id)fp8;
- (id)addressBookQuerySession;
- (id)SMSAPIClient;
- (id)SMSReplyManager;
- (id)preferredPhoneManager;
- (id)delegate;
- (void)handleActionWithActionIdentifier:(unsigned char)fp8 attributes:(id)fp12;
- (void)startHandlingInvokeActionMessage:(id)fp8;
- (id)initWithDelegate:(id)fp8 SMSReplyManager:(id)fp12 contactPreferredPhoneManager:(id)fp16;

// 3.12
+(id)actionHandlerWithDelegate:(id)arg1;
+(id)handlerWithNotificationSourceIdentifier:(id)arg1 delegate:(id)arg2;
-(NSString *)notificationSourceIdentifier;
-(id)initWithNotificationSourceIdentifier:(id)arg1 delegate:(id)arg2 SMSReplyManager:(id)arg3 contactPreferredPhoneManager:(id)arg4 sendSMSService:(id)arg5;
-(id)sendSMSService;
@end

@interface PBTimelineAttribute : NSObject
+ (id)attributeWithType:(id)fp8 content:(id)fp12 specificType:(int)fp16;
+ (id)attributeWithType:(id)fp8 content:(id)fp12;
- (int)specificType;
- (id)content;
- (id)type;
- (id)description;
- (BOOL)isEqual:(id)fp8;
- (id)initWithType:(id)fp8 content:(id)fp12 specificType:(int)fp16;
- (id)init;
@end

@interface PBCannedResponseManager : NSObject
+ (id)userDefaults;
- (id)cannedResponseDefaults;
- (id)defaultResponses;
- (id)cannedResponsesForAppIdentifier:(id)fp8;
- (void)setCannedResponses:(id)fp8 forAppIdentifier:(id)fp12;
- (id)initWithUserDefaults:(id)fp8;
- (id)init;
@end

@interface PBTimelineItemAttributeBlob
-(void)encodeToDataWriter:(id)arg1 ;
-(id)initWithSequentialDataReader:(id)arg1 ;
-(NSString *)description;
-(unsigned char)type;
-(NSData *)content;
-(id)initWithType:(unsigned char)arg1 content:(id)arg2 ;
@end

@interface PBAddressBookQuerySession
+ (id)addressBookQuerySessionWithIdentifier:(id)fp8 query:(id)fp12 delegate:(id)fp16;
- (id)actions;
- (void)setNextActionId:(unsigned char)fp8;
- (unsigned char)nextActionId;
- (id)contactPreferredPhoneManager;
- (id)addressBook;
- (id)addressBookManager;
- (id)delegate;
- (void)setSelectedLabeledValue:(id)fp8;
- (id)selectedLabeledValue;
- (void)setSelectedContact:(id)fp8;
- (id)selectedContact;
- (void)handleActionWithIdentifier:(unsigned char)fp8;
- (id)newActionWithType:(id)fp8 attributes:(id)fp12 content:(id)fp16;
- (void)selectAddressLabeledValue:(id)fp8;
- (void)selectContact:(id)fp8;
- (void)runInitialQuery;
- (id)initWithIdentifier:(id)fp8 query:(id)fp12 delegate:(id)fp16 addressBookManager:(id)fp20 contactPreferredPhoneManager:(id)fp24;
- (id)init;
@end

@interface PBTimelineInvokeANCSActionMessage : NSObject
-(NSUUID *)ANCSIdentifier;
-(NSString *)notificationSender;
-(NSString *)notificationSubtitle;
-(NSString *)notificationBody;
-(unsigned char)actionID;
-(NSString *)actionTitle;
-(NSString *)appIdentifier;
@end

@interface PBANCSActionHandler
+(id)actionHandlerWithDelegate:(id)arg1;
-(void)dealloc;
-(NSUUID *)handlingIdentifier;
-(void)setHandlingIdentifier:(NSUUID *)arg1;
-(void)sendResponse:(unsigned char)arg1 withAttributes:(id)arg2 actions:(id)arg3 forItemIdentifier:(id)arg4;
-(NSDictionary *)actionHandlersByAppIdentifier;
-(void)setCurrentActionHandler:(id)arg1;
-(id)currentActionHandler;
-(void)handleActionWithActionIdentifier:(unsigned char)arg1 attributes:(id)arg2;
-(id)backgroundColorForNotificationHandler:(id)arg1;
-(id)timelineWatchService;
-(void)notificationHandler:(id)arg1 didSendResponse:(unsigned char)arg2 withAttributes:(id)arg3 actions:(id)arg4;
-(void)notificationHandler:(id)arg1 didSendError:(id)arg2 withTitle:(id)arg3 icon:(id)arg4;
-(BOOL)isHandlingNotificationWithIdentifier:(id)arg1;
-(void)handleInvokeANCSActionMessage:(id)arg1;
-(id)delegate;
-(id)initWithDelegate:(id)arg1;
@end

@interface PBSMSNotificationActionHandler
+ (id)handlerWithDelegate:(id)fp8;
- (void)setAddressBookQuerySession:(id)fp8;
- (id)addressBookQuerySession;
- (id)SMSAPIClient;
- (id)SMSReplyManager;
- (id)preferredPhoneManager;
- (id)delegate;
- (void)handleActionWithActionIdentifier:(unsigned char)fp8 attributes:(id)fp12;
- (void)startHandlingInvokeActionMessage:(id)fp8;
- (id)initWithDelegate:(id)fp8 SMSReplyManager:(id)fp12 contactPreferredPhoneManager:(id)fp16;
@end

@interface PBSendTextAppActionHandler : NSObject
+(id)handlerWithDelegate:(id)arg1;
-(id)timelineWatchService;
-(id)initWithSMSReplyManager:(id)arg1 delegate:(id)arg2 sendSMSService:(id)arg3;
-(id)SMSReplyManager;
-(id)sendSMSService;
-(id)phoneNumberFromAttributes:(id)arg1;
-(id)responseFromAttributes:(id)arg1;
-(void)notifyUserWithError:(id)arg1;
-(BOOL)handlesAction:(unsigned char)arg1 forItem:(id)arg2;
-(void)handleAction:(unsigned char)arg1 forItemIdentifier:(id)arg2 attributes:(id)arg3;
-(id)init;
-(id)delegate;
-(NSIndexSet *)actions;
@end

// TODO HERE
@interface PBTimelineActionsWatchService : NSObject
+(id)watchServiceForWatch:(id)arg1 watchServicesSet:(id)arg2;
-(id)contactPreferredPhoneManager;
-(id)addressBookManager;
-(id)timelineWatchService;
-(void)ANCSActionHandler:(id)arg1 didSendResponse:(unsigned char)arg2 withAttributes:(id)arg3 actions:(id)arg4 forItemIdentifier:(id)arg5;
-(id)timelineManager;
-(id)initWithWatch:(id)arg1 watchServicesSet:(id)arg2 timelineManager:(id)arg3 currentUserLockerAppManager:(id)arg4;
-(id)addressBookQuerySession;
-(void)setAddressBookQuerySession:(id)arg1;
-(void)sendTextAppActionHandler:(id)arg1 didSendResponse:(unsigned char)arg2 withAttributes:(id)arg3 forItemIdentifier:(id)arg4;
-(void)registerInvokeActionHandler;
-(void)registerInvokeANCSActionHandler;
-(id)invokeActionHandler;
-(id)ANCSActionHandler;
-(void)handleANCSActionForInvokeActionMessage:(id)arg1;
-(void)handleActionForItemIdentifier:(id)arg1 actionIdentifier:(unsigned char)arg2 attributes:(id)arg3;
-(id)notificationHandler;
-(id)sendTextAppActionHandler;
-(void)handleActionForItem:(id)arg1 actionIdentifier:(unsigned char)arg2 attributes:(id)arg3;
-(void)sendResponseForItemIdentifier:(id)arg1 response:(unsigned char)arg2 attributes:(id)arg3 actions:(id)arg4;
-(void)processAction:(id)arg1 forItem:(id)arg2 attributes:(id)arg3;
-(void)sendResponseForItem:(id)arg1 response:(unsigned char)arg2 attributes:(id)arg3;
-(id)subtitleAttributeForLocalizedString:(id)arg1;
-(void)sendResponseForItem:(id)arg1 response:(unsigned char)arg2 subtitle:(id)arg3 icon:(id)arg4;
-(id)subtitleWithMuted:(BOOL)arg1 forDataSourceUUID:(id)arg2;
-(NSString *)accountUserID;
-(id)httpActionSessionManager;
-(id)subtitleAttributeForString:(id)arg1;
-(void)sendResponseForItem:(id)arg1 response:(unsigned char)arg2 subtitle:(id)arg3 icon:(id)arg4 specificType:(long long)arg5;
-(void)sendResponseForItemIdentifier:(id)arg1 response:(unsigned char)arg2 attributes:(id)arg3 actions:(id)arg4 mapperSignal:(id)arg5;
-(void)sendResponseForItem:(id)arg1 response:(unsigned char)arg2 attributes:(id)arg3 actions:(id)arg4;
-(void)sendANCSResponseForItemIdentifier:(id)arg1 response:(unsigned char)arg2 attributes:(id)arg3 actions:(id)arg4;
-(void)sendResponseForItem:(id)arg1 response:(unsigned char)arg2;
-(id)init;
-(id)watch;
@end

@interface PBTimelineAttributeContentLocalizedString : NSObject
-(id)initWithLocalizationKey:(id)arg1;
-(id)initWithLocalizationKey:(id)arg1 placeholderKeyPaths:(id)arg2;
-(NSArray *)placeholderKeyPaths;
-(id)localizedStringWithLocalizedBundle:(id)arg1 binding:(id)arg2;
-(id)init;
-(NSString *)localizationKey;
@end

@interface PBManagedTimelineItemAction : NSObject
@end

@interface PBTimelineAction : NSObject
+(id)timelineActionFromManagedTimelineItemAction:(id)arg1;
+(BOOL)isSystemIdentifier:(unsigned char)arg1;
+(id)systemActionWithIdentifier:(unsigned char)arg1;
-(id)initWithIdentifier:(id)arg1 type:(id)arg2 attributes:(id)arg3;
-(NSNumber *)identifier;
-(NSString *)type;
-(NSArray *)attributes;
@end

@interface _PBManagedTimelineItemActionable : NSObject
-(void)removeActions:(id)arg1 ;
-(void)addActionsObject:(id)arg1 ;
-(void)removeActionsObject:(id)arg1 ;
-(void)insertObject:(id)arg1 inActionsAtIndex:(unsigned long long)arg2 ;
-(void)removeObjectFromActionsAtIndex:(unsigned long long)arg1 ;
-(void)insertActions:(id)arg1 atIndexes:(id)arg2 ;
-(void)removeActionsAtIndexes:(id)arg1 ;
-(void)replaceObjectInActionsAtIndex:(unsigned long long)arg1 withObject:(id)arg2 ;
-(void)replaceActionsAtIndexes:(id)arg1 withActions:(id)arg2 ;
-(void)addActions:(id)arg1 ;
-(id)actionsSet;
@end

@interface PBManagedTimelineItemActionable : _PBManagedTimelineItemActionable
-(BOOL)updateActionsWithActions:(id)arg1 ;
-(id)findOrCreateActionWithIdentifier:(id)arg1 ;
@end

@interface _PBManagedNotificationSource : PBManagedTimelineItemActionable
@end

@interface PBManagedNotificationSource : _PBManagedNotificationSource
@end

@interface PBNotificationSource : NSObject
+(id)notificationSourceFromManagedEntry:(id)arg1 ;
+(id)blobEntryModelFromBlobEntry:(id)arg1 ;
+(id)notificationSourceWithBlob:(id)arg1 mapper:(id)arg2 ;
+(id)notificationSourceWithAppIdentifier:(id)arg1 flags:(unsigned)arg2 version:(unsigned short)arg3 attributes:(id)arg4 actions:(id)arg5 ;
-(PBTimelineAttribute *)authAttribute;
-(id)initWithManagedNotificationSource:(id)arg1 ;
-(NSString *)modelIdentifier;
-(id)blobRepresentationWithMapper:(id)arg1 ;
-(id)initWithAppIdentifier:(id)arg1 flags:(unsigned)arg2 version:(unsigned short)arg3 attributes:(id)arg4 actions:(id)arg5 ;
-(PBTimelineAttribute *)muteAttribute;
-(PBTimelineAttribute *)appNameAttribute;
-(PBTimelineAttribute *)lastUpdatedAttribute;
-(unsigned char)muteDaysOfWeekFlag;
-(id)notificationSourceByApplyingMuteDaysOfWeekFlag:(unsigned char)arg1 ;
-(id)notificationSourceByRemovingAuthCode;
-(NSString *)description;
-(NSArray *)actions;
-(unsigned short)version;
-(NSArray *)attributes;
-(NSDate *)lastUpdated;
-(NSString *)appIdentifier;
-(unsigned)flags;
-(NSString *)appName;
@end

@interface PBCoreDataManager : NSObject
@property (nonatomic,readonly) NSPersistentStoreCoordinator * persistentStoreCoordinator;
@property (nonatomic,readonly) NSURL * storageFileURL;
@property (nonatomic,readonly) NSManagedObjectContext * managedObjectContext;
+(id)defaultMyPebbleCoreDataManager;
+(id)storageFileName;
+(id)mutateManagedObjectModel:(id)arg1 ;
-(NSManagedObjectContext *)managedObjectContext;
@end

@interface RACSignal : NSObject
- (id)subscribeNext:(void(^)(id))nextBlock;
@end

@interface PBNotificationSourceManager : NSObject
-(void)deleteAllLocalNotificationSources;
-(PBCannedResponseManager *)cannedResponseManager;
-(id)initWithCannedResponseManager:(id)arg1 ;
-(void)entryModelWasAdded:(id)arg1 ;
-(void)watch:(id)arg1 didAddEntryModel:(id)arg2 ;
-(id)actionByReplacingCannedResponsesForAction:(id)arg1 forAppIdentifier:(id)arg2 ;
-(void)setActions:(id)arg1 forAppIdentifier:(id)arg2 ;
-(void)handleCannedResponseDidChangeNotification:(id)arg1 ;
-(void)updateCannedResponsesForAppIdentifier:(id)arg1 ;
-(void)sendNotificationSourceCreationToAnalytics:(id)arg1 ;
-(id)findNotificationSourceForAppIdentifier:(id)arg1 ;
-(RACSignal *)notificationSourcesSignal;
-(void)setMuteFlag:(unsigned char)arg1 forAppIdentifier:(id)arg2 ;
-(void)dealloc;
@end

// Pebble 3.14
@interface PBEmailAppManager : NSObject
+ (id)manager;
- (id)linkedAccountsManager;
- (id)initWithLinkedAccountsManager:(id)arg1 ;
- (NSArray *)emailApps;
- (id)supportedProvidersForEmailApp:(id)arg1 ;
- (NSArray *)availableEmailApps;
- (id)init;
@end
