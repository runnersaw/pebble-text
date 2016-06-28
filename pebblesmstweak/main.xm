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
#import "rocketbootstrap.h"
#import <substrate.h>
//#import <objc/runtime.h>

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

@interface UIApplication (PebbleSMS)
+(id)sharedApplication;
-(BOOL)launchApplicationWithIdentifier:(id)arg1 suspended:(BOOL)arg2;
@end

// SPRINGBOARD

@interface SpringBoard
- (void)handleMessageNamed:(NSString *)name withUserInfo:(NSDictionary *)userinfo;
@end

// SMS STUFF HEADERS

@interface CKMessage : NSObject
@end

@interface SMSApplication : UIApplication
- (BOOL)application:(id)arg1 didFinishLaunchingWithOptions:(id)arg2;
- (void)sendMessagesForTextSender;
- (void)sendMessageTo:(NSNumber *)personId number:(NSString *)number withText:(NSString *)text notify:(BOOL)notify;
- (void)sendMessageToNumber:(NSString *)number recordId:(NSNumber *)recordId withText:(NSString *)text notify:(BOOL)notify;
- (void)sendMessageToNewNumber:(NSString *)number withText:(NSString *)text notify:(BOOL)notify;
- (void)sendNewMessageTo:(NSNumber *)personId number:(NSString *)number withText:(NSString *)text notify:(BOOL)notify;
- (void)handleMessageNamed:(NSString *)name withUserInfo:(NSDictionary *)userinfo;
@end

@interface IMMessage
- (NSDate *)timeDelivered;
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
+ (id)copyCachedBulletinWithBulletinID:(id)arg1;
+ (void)removeBulletinFromCache:(id)arg1;
+ (BOOL)supportsSecureCoding;
+ (id)validSortDescriptorsFromSortDescriptors:(id)arg1;
+ (void)vetSortDescriptor:(id)arg1;

- (id)_actionKeyForType:(int)arg1;
- (id)_actionWithID:(id)arg1 fromActions:(id)arg2;
- (id)_allActions;
- (id)_allSupplementaryActions;
- (id)_responseForAction:(id)arg1;
- (id)_safeDescription:(BOOL)arg1;
- (id)_sectionParameters;
- (id)_sectionSubtypeParameters;
- (id)accessoryIconMask;
- (id)acknowledgeAction;
- (id)actionForResponse:(id)arg1;
- (id)actionWithIdentifier:(id)arg1;
- (id)actions;
- (void)addLifeAssertion:(id)arg1;
- (void)addObserver:(id)arg1;
- (int)addressBookRecordID;
- (id)alertSuppressionAppIDs;
- (id)alertSuppressionAppIDs_deprecated;
- (id)alertSuppressionContexts;
- (BOOL)allowsAddingToLockScreenWhenUnlocked;
- (BOOL)allowsAutomaticRemovalFromLockScreen;
- (id)alternateAction;
- (id)alternateActionLabel;
- (id)attachments;
- (id)attachmentsCreatingIfNecessary:(BOOL)arg1;
- (id)bannerAccessoryRemoteServiceBundleIdentifier;
- (id)bannerAccessoryRemoteViewControllerClassName;
- (id)bulletinID;
- (id)bulletinVersionID;
- (id)buttons;
- (BOOL)canBeSilencedByMenuButtonPress;
- (BOOL)clearable;
- (BOOL)coalescesWhenLocked;
- (id)composedAttachmentImage;
- (id)composedAttachmentImageForKey:(id)arg1;
- (id)composedAttachmentImageForKey:(id)arg1 withObserver:(id)arg2;
- (id)composedAttachmentImageWithObserver:(id)arg1;
- (id)content;
- (id)context;
- (unsigned int)counter;
- (id)date;
- (int)dateFormatStyle;
- (BOOL)dateIsAllDay;
- (void)dealloc;
- (id)defaultAction;
- (id)description;
- (id)dismissAction;
- (id)dismissalID;
- (void)encodeWithCoder:(id)arg1;
- (id)endDate;
- (id)expirationDate;
- (unsigned int)expirationEvents;
- (id)expireAction;
- (BOOL)expiresOnPublisherDeath;
- (id)firstValidObserver;
- (id)fullAlternateActionLabel;
- (id)fullUnlockActionLabel;
- (BOOL)hasEventDate;
- (int)iPodOutAlertType;
- (BOOL)ignoresQuietMode;
- (BOOL)inertWhenLocked;
- (id)init;
- (id)initWithCoder:(id)arg1;
- (BOOL)isLoading;
- (id)lastInterruptDate;
- (id)lifeAssertions;
- (id)message;
- (unsigned int)messageNumberOfLines;
- (id)missedBannerDescriptionFormat;
- (id)modalAlertContent;
- (unsigned int)numberOfAdditionalAttachments;
- (unsigned int)numberOfAdditionalAttachmentsOfType:(int)arg1;
- (id)observers;
- (BOOL)orderSectionUsingRecencyDate;
- (id)parentSectionID;
- (BOOL)playsSoundForModify;
- (BOOL)preservesUnlockActionCase;
- (BOOL)preventLock;
- (int)primaryAttachmentType;
- (id)publicationDate;
- (id)publisherBulletinID;
- (id)publisherMatchID;
- (id)raiseAction;
- (unsigned int)realertCount;
- (unsigned int)realertCount_deprecated;
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
- (id)safeDescription;
- (id)secondaryContentRemoteServiceBundleIdentifier;
- (id)secondaryContentRemoteViewControllerClassName;
- (id)section;
- (id)sectionDisplayName;
- (BOOL)sectionDisplaysCriticalBulletins;
- (id)sectionID;
- (id)sectionIcon;
- (int)sectionSubtype;
- (void)setAccessoryIconMask:(id)arg1;
- (void)setAcknowledgeAction:(id)arg1;
- (void)setActions:(id)arg1;
- (void)setAddressBookRecordID:(int)arg1;
- (void)setAlertSuppressionAppIDs_deprecated:(id)arg1;
- (void)setAlertSuppressionContexts:(id)arg1;
- (void)setAlternateAction:(id)arg1;
- (void)setAttachments:(id)arg1;
- (void)setBulletinID:(id)arg1;
- (void)setBulletinVersionID:(id)arg1;
- (void)setButtons:(id)arg1;
- (void)setClearable:(BOOL)arg1;
- (void)setContent:(id)arg1;
- (void)setContext:(id)arg1;
- (void)setCounter:(unsigned int)arg1;
- (void)setDate:(id)arg1;
- (void)setDateFormatStyle:(int)arg1;
- (void)setDateIsAllDay:(BOOL)arg1;
- (void)setDefaultAction:(id)arg1;
- (void)setDismissAction:(id)arg1;
- (void)setDismissalID:(id)arg1;
- (void)setEndDate:(id)arg1;
- (void)setExpirationDate:(id)arg1;
- (void)setExpirationEvents:(unsigned int)arg1;
- (void)setExpireAction:(id)arg1;
- (void)setExpiresOnPublisherDeath:(BOOL)arg1;
- (void)setHasEventDate:(BOOL)arg1;
- (void)setLastInterruptDate:(id)arg1;
- (void)setLifeAssertions:(id)arg1;
- (void)setLoading:(BOOL)arg1;
- (void)setMessage:(id)arg1;
- (void)setModalAlertContent:(id)arg1;
- (void)setObservers:(id)arg1;
- (void)setParentSectionID:(id)arg1;
- (void)setPublicationDate:(id)arg1;
- (void)setPublisherBulletinID:(id)arg1;
- (void)setRaiseAction:(id)arg1;
- (void)setRealertCount_deprecated:(unsigned int)arg1;
- (void)setRecencyDate:(id)arg1;
- (void)setRecordID:(id)arg1;
- (void)setSection:(id)arg1;
- (void)setSectionID:(id)arg1;
- (void)setSectionSubtype:(int)arg1;
- (void)setShowsMessagePreview:(BOOL)arg1;
- (void)setSnoozeAction:(id)arg1;
- (void)setSound:(id)arg1;
- (void)setStarkBannerContent:(id)arg1;
- (void)setSubsectionIDs:(id)arg1;
- (void)setSubtitle:(id)arg1;
- (void)setSupplementaryActionsByLayout:(id)arg1;
- (void)setTimeZone:(id)arg1;
- (void)setTitle:(id)arg1;
- (void)setUniversalSectionID:(id)arg1;
- (void)setUnlockActionLabelOverride:(id)arg1;
- (void)setUsesExternalSync:(BOOL)arg1;
- (void)setWantsFullscreenPresentation:(BOOL)arg1;
- (id)shortDescription;
- (BOOL)showsContactPhoto;
- (BOOL)showsDateInFloatingLockScreenAlert;
- (BOOL)showsMessagePreview;
- (BOOL)showsSubtitle;
- (BOOL)showsUnreadIndicatorForNoticesFeed;
- (id)snoozeAction;
- (id)sound;
- (id)starkBannerContent;
- (id)subsectionIDs;
- (id)subtitle;
- (unsigned int)subtypePriority;
- (id)supplementaryActions;
- (id)supplementaryActionsByLayout;
- (id)supplementaryActionsForLayout:(int)arg1;
- (BOOL)suppressesAlertsWhenAppIsActive;
- (BOOL)suppressesMessageForPrivacy;
- (BOOL)suppressesTitle;
- (id)syncHash;
- (id)timeZone;
- (id)tintColor;
- (id)title;
- (id)topic;
- (id)uniqueIdentifier;
- (id)universalSectionID;
- (id)unlockActionLabel;
- (id)unlockActionLabelOverride;
- (BOOL)usesExternalSync;
- (BOOL)usesVariableLayout;
- (BOOL)visuallyIndicatesWhenDateIsInFuture;
- (BOOL)wantsFullscreenPresentation;

// Image: /System/Library/PrivateFrameworks/BulletinDistributorCompanion.framework/BulletinDistributorCompanion

- (id)dateOrRecencyDate;
- (BOOL)matchesPublisherBulletinID:(id)arg1 andRecordID:(id)arg2;
- (id)publishDate;
- (id)sectionMatchID;

// Image: /System/Library/PrivateFrameworks/SpringBoardUI.framework/SpringBoardUI

+ (void)killSounds;

- (id)_defaultActionWithFilter:(id)arg1;
- (BOOL)_isPushOrLocalNotification;
- (id)_launchURLForAction:(id)arg1 context:(id)arg2;
- (id)_responseForAction:(id)arg1 withOrigin:(int)arg2 context:(id)arg3;
- (id)actionBlockForAction:(id)arg1;
- (id)actionBlockForAction:(id)arg1 withOrigin:(int)arg2;
- (id)actionBlockForAction:(id)arg1 withOrigin:(int)arg2 context:(id)arg3;
- (id)actionBlockForButton:(id)arg1;
- (BOOL)bulletinAlertShouldOverridePocketMode;
- (BOOL)bulletinAlertShouldOverrideQuietMode;
- (BOOL)isPlayingSound;
- (void)killSound;
- (BOOL)playSound;
- (id)sb_minimalSupplementaryActions;
- (id)sb_nonPluginDefaultAction;
- (BOOL)sb_shouldSuppressMessageForPrivacy;
- (BOOL)sb_supportsRaiseAction;

@end

@interface BBContent : NSObject

+ (id)contentWithTitle:(id)arg1 subtitle:(id)arg2 message:(id)arg3;
+ (BOOL)supportsSecureCoding;
- (void)dealloc;
- (id)description;
- (void)encodeWithCoder:(id)arg1;
- (id)initWithCoder:(id)arg1;
- (BOOL)isEqualToContent:(id)arg1;
- (id)message;
- (void)setMessage:(id)arg1;
- (void)setSubtitle:(id)arg1;
- (void)setTitle:(id)arg1;
- (id)subtitle;
- (id)title;

@end

@interface BBResponse : NSObject
- (id)actionID;
- (int)actionType;
- (BOOL)activated;
- (id)bulletinID;
- (id)buttonID;
- (id)context;
- (void)dealloc;
- (void)encodeWithCoder:(id)arg1;
- (id)initWithCoder:(id)arg1;
- (id)lifeAssertions;
- (id)originID;
- (id)replyText;
- (void)send;
- (id /* block */)sendBlock;
- (void)setActionID:(id)arg1;
- (void)setActionType:(int)arg1;
- (void)setActivated:(BOOL)arg1;
- (void)setBulletinID:(id)arg1;
- (void)setButtonID:(id)arg1;
- (void)setContext:(id)arg1;
- (void)setLifeAssertions:(id)arg1;
- (void)setOriginID:(id)arg1;
- (void)setReplyText:(id)arg1;
- (void)setSendBlock:(id /* block */)arg1;
@end

@interface BBAppearance : NSObject
- (id)title;
@end

@interface BBAction : NSObject

+ (id)action;
+ (id)actionWithActivatePluginName:(id)arg1 activationContext:(id)arg2;
+ (id)actionWithAppearance:(id)arg1;
+ (id)actionWithCallblock:(id)arg1;
+ (id)actionWithIdentifier:(id)arg1;
+ (id)actionWithIdentifier:(id)arg1 title:(id)arg2;
+ (id)actionWithLaunchBundleID:(id)arg1;
+ (id)actionWithLaunchBundleID:(id)arg1 callblock:(id)arg2;
+ (id)actionWithLaunchURL:(id)arg1;
+ (id)actionWithLaunchURL:(id)arg1 callblock:(id)arg2;
+ (BOOL)supportsSecureCoding;

- (id)_nameForActionType:(int)arg1;
- (int)actionType;
- (id)activatePluginContext;
- (id)activatePluginName;
- (unsigned int)activationMode;
- (id)appearance;
- (int)behavior;
- (id)behaviorParameters;
- (id)bundleID;
- (BOOL)canBypassPinLock;
- (void)dealloc;
- (BOOL)deliverResponse:(id)arg1;
- (id)description;
- (void)encodeWithCoder:(id)arg1;
- (BOOL)hasInteractiveAction;
- (BOOL)hasLaunchAction;
- (BOOL)hasPluginAction;
- (BOOL)hasRemoteViewAction;
- (unsigned int)hash;
- (id)identifier;
- (id)init;
- (id)initWithCoder:(id)arg1;
- (id)initWithIdentifier:(id)arg1;
- (id)internalBlock;
- (BOOL)isAuthenticationRequired;
- (BOOL)isEqual:(id)arg1;
- (id)launchBundleID;
- (BOOL)launchCanBypassPinLock;
- (id)launchURL;
- (id)partialDescription;
- (id)remoteServiceBundleIdentifier;
- (id)remoteViewControllerClassName;
- (void)setActionType:(int)arg1;
- (void)setActivatePluginContext:(id)arg1;
- (void)setActivatePluginName:(id)arg1;
- (void)setActivationMode:(unsigned int)arg1;
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
- (void)setRemoteServiceBundleIdentifier:(id)arg1;
- (void)setRemoteViewControllerClassName:(id)arg1;
- (void)setShouldDismissBulletin:(BOOL)arg1;
- (BOOL)shouldDismissBulletin;
- (id)url;

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
+ (NSString *)phoneWithPrefix:(NSString *)number;
- (NSNumber *)recordId;

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

// mine
-(NSString *)getStringRepresentationForTextSender;
@end

@interface PBAddressBook
+ (id)addressBook;
- (void *)addressBookRef;
- (id)allContacts;
- (id)contactWithIdentifier:(int)fp8;
- (id)initWithAddressBookRef:(void *)fp8;
- (id)init;
- (id)contactsMatchingQuery:(id)fp8;
- (id)searchContacts:(NSString *)search tries:(int)tries;
- (id)searchContactsList:(NSString *)search tries:(int)tries;
- (id)contactWithPhoneNumber:(PBPhoneNumber *)phoneNumber;
- (id)contactWithPrefixedPhoneNumber:(NSString *)phoneNumber;
@end

@interface PBPebbleCentral
+(id) defaultCentral;
+(void) setDebugLogsEnabled:(BOOL)arg1;
+(void) setLogLevel:(unsigned int)arg1;
-(id) appUUID;
-(id) connectedWatches;
-(void) setAppUUID:(id)arg1;
-(void) setTransportFilterPredicate:(id)arg;
-(id) registeredWatches;
-(void) removeRegisteredWatch:(id)arg;
-(void) watchTransportManager:(id)arg1 didConnectTransport:(id)arg2;
-(void) watchTransportManager:(id)arg1 didDisconnectTransport:(id)arg2;
-(id) lastConnectedWatch;
-(id) appUUIDs;
-(void) registerForAutoReleaseOfSharedSessions;
-(void) addAppUUID:(id)arg;
-(void) candidateDidPair:(id)arg;
-(BOOL) currentAppIsThePebbleApp;
-(id) endpointsByUUID;
-(void) startReconnectionService;
-(id) reconnectionService;
-(id) internalConnectedWatches;
-(id) registerAndAddToConnectedWatchesForTransport:(id)arg;
-(id) removeFromConnectedWatchesForTransport:(id)arg;
-(id) findWatchForTransport:(id)arg1 inCollection:(id)arg2;
-(id) transportFilterPredicate;
-(id) dataLoggingService;
-(void) handleApplicationWillResignActiveNotification:(id)arg;
-(BOOL) isMobileAppInstalled;
-(void) installMobileApp;
-(void) unregisterAllWatches;
-(void) setAppUUIDs:(id)arg;
-(id) watchForTransport:(id)arg;
-(id) dataLoggingServiceForAppUUID:(id)arg;
-(id) classicWatchTransportManager;
-(BOOL) hasValidAppUUID;
-(id) store;
-(void) setDelegate:(id)arg;
-(void) dealloc;
-(id) delegate;
-(id) _init;
-(void) run;
-(id) internalQueue;
-(BOOL) running;
-(unsigned long long) capabilities;
@end

@interface PBWatch
- (void)appMessagesPushUpdate:(id)fp8 onSent:(id)fp1001 uuid:(id)fp12 launcher:(id)fp16;
- (void)appMessagesPushUpdate:(id)arg1 onSent:(id)arg2;
- (void)appMessagesPushUpdate:(id)arg1 withUUID:(id)arg2 onSent:(id)arg3;
- (void)send:(id)fp8 onDone:(id)fp1001 onTimeout:(void *)fp12 processInQueue:(id)fp10301;
- (NSMutableDictionary *)getContactSearchResponse:(NSString *)name tries:(int)tries;
- (NSMutableDictionary *)getSentResponse;
- (NSMutableDictionary *)getFailedResponse;
- (NSMutableDictionary *)getFinalRecievedResponse;
- (NSMutableDictionary *)getConnectionResponse;
- (NSMutableDictionary *)getRecentContactsResponse;
- (NSMutableDictionary *)getPresets;
+ (void)sendSMS:(NSNumber *)recordId number:(NSString *)number withText:(NSString *)text;
@end

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
- (void)dealloc;
- (id)init;
- (id)initWithUserAccountID:(id)fp8 localAppsStorage:(id)fp12 lockerSessionManager:(id)fp16 timelineBlobMapperConfigurationCache:(id)fp20;
@end

@interface PBLockerSessionManager
+ (id)lockerCache;
@end

@interface PBAddressBookAuthorizationManager
+ (void)requestAuthorizationWithCompletion:(id)completion;
+ (int)authorizationStatus;
@end

@interface PBPhoneApp : NSObject

+(id)appWithSystemPhoneApp:(unsigned long long)arg1 ;
+(unsigned long long)systemPhoneAppFromBundleIdentifier:(id)arg1 ;
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
- (void)dealloc;
- (id)initWithNotificationSourceManager:(id)fp8 linkedAccountsManager:(id)fp12;

// 3.12
-(id)linkedServicesSessionManager;
-(id)initWithNotificationSourceManager:(id)arg1 linkedAccountsManager:(id)arg2 modalCoordinator:(id)arg3 userDefaults:(id)arg4 linkedServicesSessionManager:(id)arg5;
-(id)smsApp;//PBPhoneApp
-(void)prepareSMSSetup;
-(id)currentCarrier;
-(void)setLastKnownCarrier:(id)arg1 ;
-(NSUserDefaults *)smsUserDefaults;
-(BOOL)checkIfProviderIsSupported:(unsigned char)arg1 forCarrier:(id)arg2 linkedAccount:(id)arg3;
-(BOOL)needToShowSMSSetup;
-(id)lastKnownCarrier;
-(NSSet *)smsApps;
-(NSSet *)ancsReplyEnabledApps;
-(id)networkInfo;

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
+ (void)sendSMS:(NSNumber *)recordId number:(NSString *)number withText:(NSString *)text;
- (id)sendSMSWithRecipients:(id)fp8 text:(id)fp12 transactionID:(id)fp16;
- (id)initWithLinkedAccountsManager:(id)fp8 smsReplyManager:(id)fp12;

// 3.12
+(id)clientWithMessage:(id)arg1 transactionID:(id)arg2;
-(id)initWithLinkedAccountsManager:(id)arg1 smsReplyManager:(id)arg2 message:(id)arg3 transactionID:(id)arg4;
-(id)smsApp;
-(id)phoneApp;
-(void)revokeAccounts:(id)arg1;
-(id)sendRequestWithRefreshedLinkedAccounts:(id)arg1;
-(void)revokeAccountsFromError:(id)arg1;
-(BOOL)needToRefreshLinkedAccountsForError:(id)arg1;
-(id)SMSSessionManager;
-(id)message;
-(id)transactionID;
-(id)sendRequest;

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

// 3.12
-(BOOL)isExpired;
@end

@interface PBLinkedAccountCredentials
+ (id)expirationJSONTransformer;
+ (id)JSONKeyPathsByPropertyKey;
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
-(void)migrateLinkedAccountsFrom3Dot6To3Dot7;
-(void)migrateSMSAccountFrom3Dot6To3Dot7ForProvider:(unsigned char)arg1;
@end

@interface PBSendSMSActionHandler : NSObject
+ (id)handlerWithDelegate:(id)fp8;
- (void)setAddressBookQuerySession:(id)fp8;
- (id)addressBookQuerySession;
- (id)SMSAPIClient;
- (id)SMSReplyManager;
- (id)preferredPhoneManager;
- (id)delegate;
- (void)addressBookQuerySession:(id)fp8 foundMultipleContactMatches:(id)fp12;
- (void)addressBookQuerySessionFailedWithNoContactAccess:(id)fp8;
- (void)addressBookQuerySessionFailedToFindContactMatch:(id)fp8;
- (void)addressBookQuerySession:(id)fp8 foundMultipleAddresses:(id)fp12;
- (void)addressBookQuerySession:(id)fp8 finishedWithContact:(id)fp12 labeledValue:(id)fp16;
- (void)handleActionWithActionIdentifier:(unsigned char)fp8 attributes:(id)fp12;
- (void)startHandlingInvokeActionMessage:(id)fp8;
- (id)initWithDelegate:(id)fp8 SMSReplyManager:(id)fp12 contactPreferredPhoneManager:(id)fp16;

// 3.12
+(id)actionHandlerWithDelegate:(id)arg1 ;
+(id)handlerWithNotificationSourceIdentifier:(id)arg1 delegate:(id)arg2;
-(NSString *)notificationSourceIdentifier;
-(id)initWithNotificationSourceIdentifier:(id)arg1 delegate:(id)arg2 SMSReplyManager:(id)arg3 contactPreferredPhoneManager:(id)arg4 sendSMSService:(id)arg5;
-(id)sendSMSService;
@end

@interface PBTimelineAttribute

+ (id)attributeWithType:(id)fp8 content:(id)fp12 specificType:(int)fp16;
+ (id)attributeWithType:(id)fp8 content:(id)fp12;
+ (id)timelineAttributesFromWebTimelineAttributable:(id)fp8;
+ (id)timelineAttributeFromManagedTimelineItemAttribute:(id)fp8;
+ (id)attributesForCalendarEvent:(id)fp8 withOptions:(unsigned int)fp12;
- (int)specificType;
- (id)content;
- (id)type;
- (id)description;
- (unsigned int)hash;
- (BOOL)isEqual:(id)fp8;
- (id)initWithType:(id)fp8 content:(id)fp12 specificType:(int)fp16;
- (id)init;
- (id)blobRepresentationWithMapper:(id)fp8;

@end

@interface PBCannedResponseManager
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
- (id)query;
- (void)setHasResolvedAmbiguity:(BOOL)fp8;
- (BOOL)hasResolvedAmbiguity;
- (void)setSelectedLabeledValue:(id)fp8;
- (id)selectedLabeledValue;
- (void)setSelectedContact:(id)fp8;
- (id)selectedContact;
- (id)sessionIdentifier;
- (id)cleanSearchQuery:(id)fp8;
- (BOOL)isQueryValidPhoneNumber:(id)fp8;
- (void)handleSingleContact:(id)fp8;
- (void)handleNoMatches;
- (void)handleMultipleAddresses:(id)fp8;
- (void)handleMultipleContacts:(id)fp8;
- (id)preferredPhoneForContact:(id)fp8;
- (void)handleActionWithIdentifier:(unsigned char)fp8;
- (id)newActionWithType:(id)fp8 attributes:(id)fp12 content:(id)fp16;
- (void)selectAddressLabeledValue:(id)fp8;
- (void)selectContact:(id)fp8;
- (void)runInitialQuery;
- (id)initWithIdentifier:(id)fp8 query:(id)fp12 delegate:(id)fp16 addressBookManager:(id)fp20 contactPreferredPhoneManager:(id)fp24;
- (id)init;

@end

@interface PBANCSActionHandler
+(id)actionHandlerWithDelegate:(id)arg1 ;
-(void)dealloc;
-(NSUUID *)handlingIdentifier;
-(void)setHandlingIdentifier:(NSUUID *)arg1 ;
-(void)sendResponse:(unsigned char)arg1 withAttributes:(id)arg2 actions:(id)arg3 forItemIdentifier:(id)arg4 ;
-(NSDictionary *)actionHandlersByAppIdentifier;
-(void)setCurrentActionHandler:(id)arg1 ;
-(id)currentActionHandler;
-(void)handleActionWithActionIdentifier:(unsigned char)arg1 attributes:(id)arg2 ;
-(id)backgroundColorForNotificationHandler:(id)arg1 ;
-(id)timelineWatchService;
-(void)notificationHandler:(id)arg1 didSendResponse:(unsigned char)arg2 withAttributes:(id)arg3 actions:(id)arg4 ;
-(void)notificationHandler:(id)arg1 didSendError:(id)arg2 withTitle:(id)arg3 icon:(id)arg4 ;
-(BOOL)isHandlingNotificationWithIdentifier:(id)arg1 ;
-(void)handleInvokeANCSActionMessage:(id)arg1 ;
-(id)delegate;
-(id)initWithDelegate:(id)arg1;

// new
+ (void)performAction:(NSString *)actionID forBulletinID:(NSString *)bulletinID;
+ (void)performReply:(NSString *)reply forAction:(NSString *)actionID andBulletinID:(NSString *)bulletinID;
@end

@interface PBSMSNotificationActionHandler

+ (id)handlerWithDelegate:(id)fp8;
- (void)setAddressBookQuerySession:(id)fp8;
- (id)addressBookQuerySession;
- (id)SMSAPIClient;
- (id)SMSReplyManager;
- (id)preferredPhoneManager;
- (id)delegate;
- (void)addressBookQuerySession:(id)fp8 foundMultipleContactMatches:(id)fp12;
- (void)addressBookQuerySessionFailedWithNoContactAccess:(id)fp8;
- (void)addressBookQuerySessionFailedToFindContactMatch:(id)fp8;
- (void)addressBookQuerySession:(id)fp8 foundMultipleAddresses:(id)fp12;
- (void)addressBookQuerySession:(id)fp8 finishedWithContact:(id)fp12 labeledValue:(id)fp16;
- (void)handleActionWithActionIdentifier:(unsigned char)fp8 attributes:(id)fp12;
- (void)startHandlingInvokeActionMessage:(id)fp8;
- (id)initWithDelegate:(id)fp8 SMSReplyManager:(id)fp12 contactPreferredPhoneManager:(id)fp16;

@end

@interface PBSendTextAppActionHandler : NSObject
+(id)handlerWithDelegate:(id)arg1;
+(void)load;
-(void)dealloc;
-(id)timelineWatchService;
-(id)initWithSMSReplyManager:(id)arg1 delegate:(id)arg2 sendSMSService:(id)arg3;
-(id)SMSReplyManager;
-(id)sendSMSService;
-(id)phoneNumberFromAttributes:(id)arg1;
-(id)responseFromAttributes:(id)arg1;
-(void)notifyUserWithError:(id)arg1;
-(BOOL)handlesAction:(unsigned char)arg1 forItem:(id)arg2;
-(void)handleAction:(unsigned char)arg1 forItemIdentifier:(id)arg2 attributes:(id)arg3;
-(id)currentTimelineItem;
-(void)setCurrentTimelineItem:(id)arg1;
-(id)init;
-(id)delegate;
-(NSIndexSet *)actions;
@end
@interface PBTimelineActionsWatchService : NSObject

+(id)watchServiceForWatch:(id)arg1 watchServicesSet:(id)arg2 ;
-(void)dealloc;
-(id)lockerAppManager;
-(id)keyedTokenGenerator;
-(id)contactPreferredPhoneManager;
-(id)addressBookManager;
-(id)timelineWatchService;
-(void)ANCSActionHandler:(id)arg1 didSendResponse:(unsigned char)arg2 withAttributes:(id)arg3 actions:(id)arg4 forItemIdentifier:(id)arg5 ;
-(id)timelineManager;
-(id)initWithWatch:(id)arg1 watchServicesSet:(id)arg2 timelineManager:(id)arg3 currentUserLockerAppManager:(id)arg4 ;
-(id)addressBookQuerySession;
-(void)setAddressBookQuerySession:(id)arg1 ;
-(void)sendTextAppActionHandler:(id)arg1 didSendResponse:(unsigned char)arg2 withAttributes:(id)arg3 forItemIdentifier:(id)arg4 ;
-(void)registerInvokeActionHandler;
-(void)registerInvokeANCSActionHandler;
-(id)invokeActionHandler;
-(id)ANCSActionHandler;
-(void)handleANCSActionForInvokeActionMessage:(id)arg1 ;
-(void)handleActionForItemIdentifier:(id)arg1 actionIdentifier:(unsigned char)arg2 attributes:(id)arg3 ;
-(id)notificationHandler;
-(id)sendTextAppActionHandler;
-(void)handleActionForItem:(id)arg1 actionIdentifier:(unsigned char)arg2 attributes:(id)arg3 ;
-(void)sendResponseForItemIdentifier:(id)arg1 response:(unsigned char)arg2 attributes:(id)arg3 actions:(id)arg4 ;
-(void)processAction:(id)arg1 forItem:(id)arg2 attributes:(id)arg3 ;
-(void)sendResponseForItem:(id)arg1 response:(unsigned char)arg2 attributes:(id)arg3 ;
-(id)subtitleAttributeForLocalizedString:(id)arg1 ;
-(void)sendResponseForItem:(id)arg1 response:(unsigned char)arg2 subtitle:(id)arg3 icon:(id)arg4 ;
-(id)subtitleWithMuted:(BOOL)arg1 forDataSourceUUID:(id)arg2 ;
-(void)processHTTPActionForItem:(id)arg1 actionAttributes:(id)arg2 ;
-(NSString *)accountUserID;
-(id)httpActionSessionManager;
-(id)subtitleAttributeForString:(id)arg1 ;
-(void)sendResponseForItem:(id)arg1 response:(unsigned char)arg2 subtitle:(id)arg3 icon:(id)arg4 specificType:(long long)arg5 ;
-(void)sendResponseForItemIdentifier:(id)arg1 response:(unsigned char)arg2 attributes:(id)arg3 actions:(id)arg4 mapperSignal:(id)arg5 ;
-(void)sendResponseForItem:(id)arg1 response:(unsigned char)arg2 attributes:(id)arg3 actions:(id)arg4 ;
-(void)sendANCSResponseForItemIdentifier:(id)arg1 response:(unsigned char)arg2 attributes:(id)arg3 actions:(id)arg4 ;
-(void)sendResponseForItem:(id)arg1 response:(unsigned char)arg2 ;
-(id)init;
-(void)deactivate;
-(id)watch;
@end

@interface PBTimelineAttributeContentLocalizedString : NSObject
+(BOOL)supportsSecureCoding;
-(id)initWithLocalizationKey:(id)arg1;
-(id)initWithLocalizationKey:(id)arg1 placeholderKeyPaths:(id)arg2;
-(NSArray *)placeholderKeyPaths;
-(id)localizedStringWithLocalizedBundle:(id)arg1 binding:(id)arg2;
-(id)initWithCoder:(id)arg1;
-(void)encodeWithCoder:(id)arg1;
-(id)init;
-(NSString *)localizationKey;
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

@interface PBTimelineInvokeANCSActionMessage : NSObject
-(NSUUID *)ANCSIdentifier;
-(NSString *)notificationSender;
-(NSString *)notificationSubtitle;
-(NSString *)notificationBody;
-(unsigned char)actionID;
-(NSString *)actionTitle;
-(NSString *)appIdentifier;
@end

@interface BBObserver : NSObject
- (void)noteServerReceivedResponseForBulletin:(id)arg1;
- (void)sendResponse:(id)arg1;
- (id)init;
- (id)initWithQueue:(id)arg1;
- (id)initWithQueue:(id)arg1 asGateway:(id)arg2 priority:(unsigned int)arg3;
- (id)initWithQueue:(id)arg1 forGateway:(id)arg2;
- (void)updateBulletin:(id)arg1 forFeeds:(unsigned int)arg2 withReply:(id /* block */)arg3;
@end

@interface SBBulletinBannerController : NSObject

+ (id)sharedInstanceIfExists;
+ (id)sharedInstance;
+ (id)_sharedInstanceCreateIfNecessary:(_Bool)arg1;
- (void)observer:(id)arg1 noteAlertBehaviorOverridesChanged:(unsigned long long)arg2;
- (void)observer:(id)arg1 noteServerReceivedResponseForBulletin:(id)arg2;
- (void)observer:(id)arg1 noteServerConnectionStateChanged:(_Bool)arg2;
- (void)observer:(id)arg1 noteInvalidatedBulletinIDs:(id)arg2;
- (id)observer:(id)arg1 composedAttachmentImageForType:(long long)arg2 thumbnailData:(id)arg3 key:(id)arg4;
- (id)observer:(id)arg1 thumbnailSizeConstraintsForAttachmentType:(long long)arg2;
- (_Bool)observerShouldFetchAttachmentImageBeforeBulletinDelivery:(id)arg1;
- (void)observer:(id)arg1 updateSectionInfo:(id)arg2;
- (void)observer:(id)arg1 removeBulletin:(id)arg2;
- (void)observer:(id)arg1 modifyBulletin:(id)arg2;
- (void)observer:(id)arg1 addBulletin:(id)arg2 forFeed:(unsigned long long)arg3 playLightsAndSirens:(_Bool)arg4 withReply:(id /*block*/)arg5;
- (void)observer:(id)arg1 addBulletin:(id)arg2 forFeed:(unsigned long long)arg3;
- (void)bannerTargetManager:(id)arg1 didRemoveTarget:(id)arg2;
- (void)bannerTargetManager:(id)arg1 didAddTarget:(id)arg2;
- (id)newBannerViewForContext:(id)arg1;
- (void)_syncLockScreenDismissalsForSeedBulletin:(id)arg1 additionalBulletins:(id)arg2;
- (id)dequeueNextBannerItemForTarget:(id)arg1;
- (id)peekNextBannerItemForTarget:(id)arg1;
- (void)_dismissWithdrawnBannerIfNecessaryFromBulletinIDs:(id)arg1;
- (void)_showTestBanner:(_Bool)arg1;
- (void)_removeNextBulletinIfNecessary;
- (void)_queueBulletin:(id)arg1;
- (_Bool)_replaceBulletin:(id)arg1;
- (void)_removeBulletin:(id)arg1;
- (unsigned long long)_indexOfQueuedBulletinID:(id)arg1;
- (void)handleVolumeDecrease;
- (void)handleVolumeIncrease;
- (void)_reloadVolumePressBanditPreference;
- (id)_bannerContextForBulletin:(id)arg1;
- (void)removeAllCachedBanners;
- (void)removeCachedBannerForBulletinID:(id)arg1;
- (void)cacheBannerForBulletin:(id)arg1 completion:(id /*block*/)arg2;
- (void)modallyPresentBannerForBulletin:(id)arg1 action:(id)arg2;
- (void)dealloc;
- (id)init;

// Remaining properties
@property(readonly, copy) NSString *debugDescription;
@property(readonly, copy) NSString *description;
@property(readonly) unsigned long long hash;
@property(readonly) Class superclass;

@end

#define SEND_DELAY 4.0
#define SECOND_SEND_DELAY 10.0
#define NOTIFICATION_DELAY 0.2
#define MESSAGE_SEND_TIMEOUT 20.0
#define HAS_ACTIONS_IDENTIFIER 10
#define DISMISS_IDENTIFIER 11

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

static NSString *sendMessageCommand = @"messageNeedsSending";
static NSString *openMessagesCommand = @"messagesNeedsOpening";
static NSString *performNotificationActionCommand = @"performNotificationAction";
static NSString *messageSendNotification = @"pebbleMessageSend";
static NSString *messageFailedNotification = @"pebbleMessageFailed";

static NSString *rocketbootstrapSmsCenterName = @"com.sawyervaughan.pebblesms.sms";
static NSString *rocketbootstrapSpringboardCenterName = @"com.sawyervaughan.pebblesms.springboard";
static NSString *distributedCenterName = @"com.sawyervaughan.pebblesms.pebble";

static NSString *notificationsFileLocation = @"/var/mobile/Library/Preferences/com.sawyervaughan.pebblesms.notifications.plist";
static NSString *actionsToPerformFileLocation = @"/var/mobile/Library/Preferences/com.sawyervaughan.pebblesms.perform-action.plist";
static NSString *messagesFileLocation = @"/var/mobile/Library/Preferences/com.sawyervaughan.pebblesms.messages.plist";
static NSString *recentFileLocation = @"/var/mobile/Library/Preferences/com.sawyervaughan.pebblesms.recent.plist";

static NSUUID *appUUID = [[NSUUID alloc] initWithUUIDString:@"36BF8B7A-A043-4E1B-8518-B6BB389EC110"];

static NSNumber *currentContactId = NULL;//[NSMutableArray array];
static BOOL isRecentContact = NO;

static int maxContacts = 10;
static int maxContactsToSend = 10;

static long long currentNumber = 12;

static NSMutableArray *presets = [NSMutableArray array];
static NSMutableArray *names = [NSMutableArray array];
static NSMutableArray *phones = [NSMutableArray array];
static NSMutableArray *messages = [NSMutableArray array];
static NSMutableArray *actionsToPerform = [NSMutableArray array];
static NSMutableArray *appsArray = [NSMutableArray array];

static NSMutableDictionary *notificationActionsDictionary = [NSMutableDictionary dictionary];
static NSMutableDictionary *actionsToPerformDictionary = [NSMutableDictionary dictionary];
static NSMutableDictionary *bulletinsDict = [NSMutableDictionary dictionary];

static void loadPrefs()
{
    if ([presets count] == 0)
   
{
        [presets addObject:@"OK"];
        [presets addObject:@"Yes"];
        [presets addObject:@"No"];
        [presets addObject:@"Call me"];
        [presets addObject:@"Call you later"];
        [presets addObject:@"Thank you"];
        [presets addObject:@"See you soon"];
        [presets addObject:@"Running late"];
        [presets addObject:@"On my way"];
        [presets addObject:@"Busy right now - give me a second?"];
    }
}

// RECENT MESSAGES

static void loadMessagesToSend()
{
    NSArray *arr = [NSArray arrayWithContentsOfFile:messagesFileLocation];

    if (arr)

	{
        [messages removeAllObjects];
        [messages addObjectsFromArray:arr];
    }
}

static void saveMessageForSending(NSDictionary *message)
{
    // check if already in messages to send
    loadMessagesToSend();

    for (NSDictionary *dict in messages)
	{
        if ([[dict objectForKey:@"uuid"] isEqualToString:[message objectForKey:@"uuid"]])
		{
            return;
        }
    }
        
    [messages addObject:message];
    [messages writeToFile:messagesFileLocation atomically:NO];
}

static void removeMessageAfterSending(NSString *message)
{
    loadMessagesToSend();

    for (int i=[messages count]-1; i>=0; i--)
	{
        NSDictionary *dict = [messages objectAtIndex:i];
        if ([[dict objectForKey:@"uuid"] isEqualToString:message])
		{
            [messages removeObjectAtIndex:i];
        }
    }

    [messages writeToFile:messagesFileLocation atomically:YES];
}

// RECENT CONTACTS

static void loadRecentRecipients()
{
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:recentFileLocation];

    [names removeAllObjects];
    [phones removeAllObjects];

    for (int i=0; i<maxContacts; i++)
	{
        NSString *name = [dict objectForKey:[NSString stringWithFormat:@"name%d", i]];
        NSString *phone = [dict objectForKey:[NSString stringWithFormat:@"phone%d", i]];

        if (name != nil && phone != nil)
		{
            [names addObject:name];
            [phones addObject:phone];
        }
    }
}

static void saveRecentRecipient(NSString *name, NSString *phone)
{
    loadRecentRecipients();

    for (int i=[names count]-1;i>=0;i--)
	{
        if ([[names objectAtIndex:i] isEqualToString:name] || [[phones objectAtIndex:i] isEqualToString:phone])
		{
            [names removeObjectAtIndex:i];
            [phones removeObjectAtIndex:i];
        }
    }

    [names insertObject:name atIndex:0];
    while ([names count] > maxContacts)
	{
        [names removeLastObject];
    }

    [phones insertObject:phone atIndex:0];
    while ([phones count] > maxContacts)
	{
        [phones removeLastObject];
    }

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];

    for (int i=0; i<[names count]; i++)
	{
        NSString *name = [names objectAtIndex:i];
        NSString *phone = [phones objectAtIndex:i];

        [dict setObject:name forKey:[NSString stringWithFormat:@"name%d", i]];
        [dict setObject:phone forKey:[NSString stringWithFormat:@"phone%d", i]];
    }

    [dict writeToFile:recentFileLocation atomically:YES];

    [dict release];
}

// FOR ACTIONABLE NOTIFICATIONS

static void loadNotificationActions()
{
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:notificationsFileLocation];

	if (dict)
	{
		[notificationActionsDictionary setDictionary:dict];
	}
}

static void saveNotificationAction(BBBulletin *bulletin)
{
    NSString *bulletinID = [bulletin bulletinID];
    if ([bulletinsDict objectForKey:bulletinID])
	{
    	return;
    }

    NSString *appIdentifier = [bulletin sectionID];
    [bulletinsDict setObject:bulletin forKey:bulletinID];

    if (!appIdentifier)
	{
        return;
    }

    NSMutableDictionary *appDict = [notificationActionsDictionary objectForKey:appIdentifier];
    if (!appDict)
	{
        appDict = [NSMutableDictionary dictionary];
    }

    if ([appDict objectForKey:bulletinID])
    {
        return;
    }

    BBContent *content = [bulletin content];
    NSString *title = [content title];
    NSString *subtitle = [content subtitle];
    NSString *message = [content message];
    NSDate *timestamp = [NSDate date];

    if (!bulletinID)
	{
        return;
    }

    BOOL hasActions = NO;
    NSMutableDictionary *actionsDict = [NSMutableDictionary dictionary];
    for (BBAction *action in [bulletin supplementaryActionsForLayout:1])
	{
        NSString *actionIdentifier = [action identifier];
        NSString *actionTitle = [(BBAppearance *)[action appearance] title];
        BOOL isQuickReply = ([action behavior] == 1);
        if (![action isAuthenticationRequired] && actionIdentifier && actionTitle)
		{
			NSDictionary *actionDict = @{ @"actionIdentifier" : actionIdentifier, @"isQuickReply" : @( isQuickReply )};
            [actionsDict setObject:actionDict forKey:actionTitle];
            hasActions = YES;
        }
    }

    if (!hasActions)
	{
        return;
    }

    // subtitle needs to go last in case it's null
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:timestamp, @"timestamp", actionsDict, @"actions", message, @"message", NULL];
    if (title != NULL)
	{
        [dict setObject:title forKey:@"title"];
    }
    if (subtitle != NULL)
	{
        [dict setObject:subtitle forKey:@"subtitle"];
    }

    [appDict setObject:dict forKey:bulletinID];
    [notificationActionsDictionary setObject:appDict forKey:appIdentifier];
    // NSLog(@"Saved bulletin %@", notificationActionsDictionary);

    [notificationActionsDictionary writeToFile:notificationsFileLocation atomically:YES];
}

static void removeActionsNotInBulletinsDict()
{
	[notificationActionsDictionary setDictionary:[NSDictionary dictionary]];
	NSArray *arr = [bulletinsDict allKeys];
	for (NSString *key in arr)
	{
		BBBulletin *bulletin = [bulletinsDict objectForKey:key];
		saveNotificationAction(bulletin);
	}
}

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
	// NSLog(@"notificationsMessageNamed");
	loadActionsToPerform();
	// NSLog(@"%@", actionsToPerform);
	// NSLog(@"%@", bulletinsDict);
    NSLog(@"Saved, %@", bulletinsDict);

	for (NSDictionary *dict in actionsToPerform)
	{
		NSString *bulletinID = [dict objectForKey:@"bulletinID"];
		NSString *actionID = [dict objectForKey:@"actionID"];

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
						NSLog(@"BBAction %@", action);
						NSLog(@"behavior %d", [action behavior]);
						BBResponse *response = [bulletin responseForAction:action];
						if (response)
						{
							NSLog(@"%@", response);
    						NSString *appIdentifier = [bulletin sectionID];
							if ([appIdentifier isEqualToString:@"com.atebits.Tweetie2"] && [actionID isEqualToString:@"reply"])
							{
								NSDictionary *dict = @{ @"UIUserNotificationActionResponseTypedTextKey" : @"Pebble reply" };
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
    	removeActionsNotInBulletinsDict();
        saveNotificationAction([%c(BBBulletin) bulletinWithBulletin:(BBBulletin *)r]);
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
    // NSLog(@"PEBBLESMS: messages launched");

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
- (void)sendMessagesForTextSender
{
    loadMessagesToSend();

    for (NSDictionary *message in messages)
	{
        NSString *number = [message objectForKey:@"number"];
        NSString *messageText = [message objectForKey:@"message"];
        NSNumber *notify = [message objectForKey:@"notify"];
        NSNumber *newNumber = [message objectForKey:@"newNumber"];
        NSNumber *recordId = [message objectForKey:@"recordId"];
        NSNumber *recent = [message objectForKey:@"isRecentContact"];
        NSNumber *reply = [message objectForKey:@"isReply"];
        NSString *uuid = [message objectForKey:@"uuid"];
        NSDate *expirationDate = [message objectForKey:@"expirationDate"];

        // timeout so message doesn't get sent super late
        if ([expirationDate compare:[NSDate date]] == NSOrderedAscending)
		{
            removeMessageAfterSending(uuid);
            return;
        }

        // TODO: find proper conditions
        if (number == NULL || messageText == NULL || notify == NULL || newNumber == NULL || recordId == NULL)
		{
            return;
        }

        if ([recent boolValue] && ![reply boolValue])
		{
            // NSLog(@"PEBBLESMS: sendMessageToNumber");
            [self sendMessageToNumber:number recordId:recordId withText:messageText notify:[notify boolValue]];
        //}
        //else if ([newNumber boolValue])
		//{
        //     [self sendMessageToNewNumber:number withText:message notify:[notify boolValue]];
        }
        else
		{
            // NSLog(@"PEBBLESMS: sendMessageTo number");
            [self sendMessageTo:recordId number:number withText:messageText notify:[notify boolValue]];
        }

        removeMessageAfterSending(uuid);
    }
}

%new
- (void)sendMessageTo:(NSNumber *)personId number:(NSString *)number withText:(NSString *)text notify:(BOOL)notify
{
    // NSLog(@"PEBBLESMS: sendMessageTo number withText notify");
    // NSLog(@"PB sendmessageto personId");
    // NSLog(@"PEBBLESMS: sendMessageTo %@", personId);
    IMPerson *person = [[IMPerson alloc] initWithABRecordID:(ABRecordID)[personId intValue]];
    NSArray *handles = [%c(IMHandle) imHandlesForIMPerson:person];
    [person release];
    // NSLog(@"PEBBLESMS: sendMessageTo %@", [handles class]);

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
    // NSLog(@"PEBBLESMS: finalPhone == NULL %d", (finalPhone == NULL));

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
    // NSLog(@"PEBBLESMS: conversation %@", [conversation class]);

    if (conversation == NULL)
	{
        [self sendNewMessageTo:personId number:finalPhone withText:text notify:notify];
        return;
    }

    //Make a new composition
    NSAttributedString* t = [[NSAttributedString alloc] initWithString:text];
    CKComposition* composition = [[CKComposition alloc] initWithText:t subject:nil];
    [t release];

    // make message and send
    CKMessage *message = (CKMessage *)[conversation messageWithComposition:composition];
    [conversation sendMessage:message newComposition:YES];
    [composition release];

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
    [t release];

    // make message and send
    CKMessage *message = (CKMessage *)[conversation messageWithComposition:composition];
    [conversation sendMessage:message newComposition:YES];
    [composition release];

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
    [person release];
    // NSLog(@"PEBBLESMS: sendMessageTo %@", [handles class]);

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
    [t release];

    // make message and send
    CKMessage *message = (CKMessage *)[conversation messageWithComposition:composition];
    [conversation sendMessage:message newComposition:YES];
    [composition release];

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
 
%new
- (void)handleMessageNamed:(NSString *)name withUserInfo:(NSDictionary *)userinfo
{
    // NSLog(@"PEBBLESMS: handleMessageNamed in MobileSMS");
    // NSLog(@"PB sendmessageto %@", [userinfo description]);
    // Process userinfo (simple dictionary) and send message
    if ([name isEqualToString:sendMessageCommand])
	{
        [self sendMessagesForTextSender];
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

                // NSLog(@"PEBBLESMS: phone %@", [phone class]);
                saveRecentRecipient(name, phone);
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

    while (i < tries * maxContactsToSend && contactIndex < [res count])
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
    for (int k = i; i < k+maxContactsToSend;)
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
    NSArray *res = [results sortedArrayUsingComparator: (NSComparator)^(id obj1, id obj2)
{
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
    } else
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
    // NSLog(@"PEBBLESMS: getRecentContactsResponse");
    loadRecentRecipients();

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    if ([names count] != 0 && [phones count] != 0)
{
        [dict setObject:[names componentsJoinedByString:@"\n"] forKey:RECENT_CONTACTS_NAME_KEY];
        [dict setObject:[phones componentsJoinedByString:@"\n"] forKey:RECENT_CONTACTS_NUMBER_KEY];
        isRecentContact = YES;
    }
    // NSLog(@"PB isRecentContact YES");
    
    return dict;
}

%new
- (NSMutableDictionary *)getPresets
{
    // NSLog(@"PEBBLESMS: getPresets");
    loadPrefs();

    // NSLog(@"PEBBLESMS: loadPrefs4 %@", presets);
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    // NSLog(@"PEBBLESMS: loadPrefs5");
    [dict setObject:[presets componentsJoinedByString:@"\n"] forKey:PRESETS_KEY];
    
    // NSLog(@"PEBBLESMS: loadPrefs6");
    return dict;
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
                        [f release];
                    }

                    // NSLog(@"finalContactId %@", finalContactId);

                    if (finalContactId != NULL)
{
                        [%c(PBWatch) sendSMS:finalContactId number:[%c(PBContact) phoneWithPrefix:number] withText:m];
                    } else
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
        } else
{
            %orig;
        }
    } else
{
        %orig;
    }
}

%new
+ (void)sendSMS:(NSNumber *)recordId number:(NSString *)number withText:(NSString *)text
{
    // NSLog(@"PEBBLESMS: sendSMS PBWatch");
    // launch messages
    // CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)messageNotificationString, nil, nil, YES);

    NSNumber *rId;
    if (isRecentContact)
{
        PBContact *c = [[%c(PBAddressBook) addressBook] contactWithPrefixedPhoneNumber:number];
        rId = [NSNumber numberWithInt:[[c recordId] intValue]];
    } else
{
        rId = [NSNumber numberWithInt:[recordId intValue]];
    }
    NSNumber *r = [NSNumber numberWithBool:isRecentContact];
    NSString *n = [NSMutableString stringWithString:number];
    NSString *t = [NSMutableString stringWithString:text];

    NSDictionary *dict = [[[NSDictionary alloc] initWithObjectsAndKeys:
        t, @"message", 
        n, @"number", 
        [NSNumber numberWithBool:YES], @"notify", 
        [NSNumber numberWithBool:NO], @"newNumber", 
        rId, @"recordId", 
        r, @"isRecentContact",
        [NSNumber numberWithBool:NO], @"isReply",
        [[NSUUID UUID] UUIDString], @"uuid",
        [NSDate dateWithTimeIntervalSinceNow:MESSAGE_SEND_TIMEOUT], @"expirationDate",
        nil] autorelease];

    saveMessageForSending(dict);

    CPDistributedMessagingCenter *c = [%c(CPDistributedMessagingCenter) centerNamed:rocketbootstrapSpringboardCenterName];
    rocketbootstrap_distributedmessagingcenter_apply(c);
    [c sendMessageName:openMessagesCommand userInfo:NULL];

    // send message after 5 seconds
    // TODO: Think about changing these to static vars?
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(SEND_DELAY * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CPDistributedMessagingCenter *c = [%c(CPDistributedMessagingCenter) centerNamed:rocketbootstrapSmsCenterName];
        rocketbootstrap_distributedmessagingcenter_apply(c);
        [c sendMessageName:sendMessageCommand userInfo:NULL];
    });

    // send message after 10 seconds
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(SECOND_SEND_DELAY * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CPDistributedMessagingCenter *c = [%c(CPDistributedMessagingCenter) centerNamed:rocketbootstrapSmsCenterName];
        rocketbootstrap_distributedmessagingcenter_apply(c);
        [c sendMessageName:sendMessageCommand userInfo:NULL];
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
    // NSLog(@"PEBBLESMS: sendSMS PBSMSSessionManager");
    // launch messages
    // CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)messageNotificationString, nil, nil, YES);

    NSString *n = [NSMutableString stringWithString:number];
    NSString *t = [NSMutableString stringWithString:text];
    NSNumber *rId = [NSNumber numberWithInt:[recordId intValue]];

    NSMutableDictionary *dict = [[[NSMutableDictionary alloc] initWithObjectsAndKeys:
        t, @"message", 
        n, @"number", 
        [NSNumber numberWithBool:NO], @"notify", 
        [NSNumber numberWithBool:NO], @"newNumber", 
        rId, @"recordId", 
        [NSNumber numberWithBool:NO], @"isRecentContact",
        [NSNumber numberWithBool:YES], @"isReply",
        [[NSUUID UUID] UUIDString], @"uuid",
        [NSDate dateWithTimeIntervalSinceNow:MESSAGE_SEND_TIMEOUT], @"expirationDate",
        nil] autorelease];

    saveMessageForSending(dict);

    CPDistributedMessagingCenter *c = [%c(CPDistributedMessagingCenter) centerNamed:rocketbootstrapSpringboardCenterName];
    rocketbootstrap_distributedmessagingcenter_apply(c);
    [c sendMessageName:openMessagesCommand userInfo:NULL];

    // send message after 5 seconds
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(SEND_DELAY * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CPDistributedMessagingCenter *c = [%c(CPDistributedMessagingCenter) centerNamed:rocketbootstrapSmsCenterName];
        rocketbootstrap_distributedmessagingcenter_apply(c);
        [c sendMessageName:sendMessageCommand userInfo:NULL];
    });

    // send message after 10 seconds
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(SECOND_SEND_DELAY * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CPDistributedMessagingCenter *c = [%c(CPDistributedMessagingCenter) centerNamed:rocketbootstrapSmsCenterName];
        rocketbootstrap_distributedmessagingcenter_apply(c);
        [c sendMessageName:sendMessageCommand userInfo:NULL];
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


%end

%hook PBCannedResponseManager

- (id)cannedResponsesForAppIdentifier:(id)fp8
{
    id r = %orig;
    if ([(NSString *)fp8 isEqualToString:@"com.apple.MobileSMS"])
	{
        [presets removeAllObjects];
        [presets addObjectsFromArray:(NSArray *)r];
    }
    return r; 
}
- (void)setCannedResponses:(id)fp8 forAppIdentifier:(id)fp12
{
    if ([(NSString *)fp12 isEqualToString:@"com.apple.MobileSMS"])
	{
        [presets removeAllObjects];
        [presets addObjectsFromArray:(NSArray *)fp8];
    }
    %orig; 
}

%end

%hook PBSendSMSActionHandler

- (void)handleActionWithActionIdentifier:(unsigned char)fp8 attributes:(id)fp12
{
	NSLog(@"handleActionWithActionIdentifier %@ %@", @( fp8 ), fp12);
    if (fp8 == 2)
	{
        // NSLog(@"HANDLING");
        NSData *d = [(PBTimelineItemAttributeBlob *)[(NSArray *)fp12 objectAtIndex:0] content];
        NSString *reply = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
        PBContact *contact = [[self addressBookQuerySession] selectedContact];
        PBPhoneNumber *pbPhoneNumber = (PBPhoneNumber *)[(PBLabeledValue *)[[self addressBookQuerySession] selectedLabeledValue] value];
        NSString *phone = [pbPhoneNumber getStringRepresentationForTextSender];
        // NSLog(@"Wants to send reply with content '%@' to '%@' at number '%@'", reply, contact, phone);
        PBTimelineAttributeContentLocalizedString *localString = [[%c(PBTimelineAttributeContentLocalizedString) alloc] initWithLocalizationKey:@"Sending..."];
        PBTimelineAttribute *attr = [%c(PBTimelineAttribute) attributeWithType:@"subtitle" content:localString];
        [localString release];
        [(PBANCSActionHandler *)[self delegate] notificationHandler:self didSendResponse:15 withAttributes:@[attr] actions:NULL];
        [%c(PBSMSSessionManager) sendSMS:[contact recordId] number:phone withText:reply];
        [reply release];
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
	NSLog(@"handleAction %@ %@ %@", @( arg1 ), arg2, arg3);
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
            [localString release];
        }
        else
		{
            NSString *message = [NSString stringWithFormat:@"Sending failed to %@", phone];
            PBTimelineAttribute *attr = [%c(PBTimelineAttribute) attributeWithType:@"subtitle" content:message];
            [(PBTimelineActionsWatchService *)[self delegate] sendTextAppActionHandler:self didSendResponse:0 withAttributes:@[attr] forItemIdentifier:arg2];
        }


        [response release];
        [phone release];
        [pbPhone release];
    }
    else
	{
        %orig; 
    }
}

%end

// THIS PART IS FOR ACTIONABLE NOTIFICATIONS

%hook PBSMSReplyManager
-(NSSet *)smsApps
{
	NSSet *r = %orig;
	NSMutableSet *set = [NSMutableSet setWithCapacity:3];
	[set setSet:r];
	[set addObjectsFromArray:appsArray];
	return set;
}
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
	NSArray *enabledApps = [NSArray arrayWithObjects:@"com.apple.MobileSMS", @"com.apple.mobilephone", @"com.pebble.sendText", nil];
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

-(void)handleInvokeANCSActionMessage:(id)arg1
{
	PBTimelineInvokeANCSActionMessage *m = (PBTimelineInvokeANCSActionMessage *)arg1;
	NSLog(@"%@ %@ %@", m, @( [m actionID] ), [m appIdentifier]);
	if ([m actionID] == HAS_ACTIONS_IDENTIFIER)
	{
		loadNotificationActions();

	    NSMutableDictionary *dict = [notificationActionsDictionary objectForKey:[m appIdentifier]];

	    NSMutableArray *actions = [NSMutableArray array];
		
		PBTimelineAttribute *a1 = [[[%c(PBTimelineAttribute) alloc] initWithType:@"title" content:@"Dismiss" specificType:0] autorelease];
		PBTimelineAttribute *a2 = [[[%c(PBTimelineAttribute) alloc] initWithType:@"subtitle" content:@"" specificType:0] autorelease];

		[actions addObject:[[[%c(PBTimelineAction) alloc] initWithIdentifier:@(DISMISS_IDENTIFIER) type:@"ANCSResponse" attributes:@[ a1, a2 ]] autorelease]];

	    if (dict)
	   	{
		   	NSArray *arr = [dict allKeys];
		   	if ([arr count] > 0)
		   	{
		   		NSString *bulletinID = [arr objectAtIndex:0];
		   		NSDictionary *bulletinDict = [dict objectForKey:bulletinID];

		   		if (bulletinDict)
		   		{
		   			NSDictionary *actionsDict = [bulletinDict objectForKey:@"actions"];

		   			if (actionsDict)
		   			{
		   				NSArray *actionsArr = [actionsDict allKeys];
			   			if (actionsArr)
			   			{
			   				for (NSString *actionName in actionsArr)
			   				{
			   					NSDictionary *actionInfo = actionsDict[actionName];
			   					NSString *actionIdentifier = actionInfo[@"actionIdentifier"];
			   					BOOL isQuickReply = [(NSNumber *)actionInfo[@"isQuickReply"] boolValue];

								PBTimelineAttribute *attr1 = [[[%c(PBTimelineAttribute) alloc] initWithType:@"title" content:actionName specificType:0] autorelease];
								PBTimelineAttribute *attr2 = [[[%c(PBTimelineAttribute) alloc] initWithType:@"subtitle" content:@"" specificType:0] autorelease];

								[actions addObject:[[[%c(PBTimelineAction) alloc] initWithIdentifier:@(currentNumber) type:@"ANCSResponse" attributes:@[ attr1, attr2 ]] autorelease]];

								NSDictionary *actionToPerform = @{ @"actionIdentifier" : actionIdentifier, 
																   @"bulletinIdentifier" : bulletinID, 
																   @"isComposeAction" : @( isQuickReply ),
																   @"isReplyAction" : @( NO ), 
																   @"replyText" : @"" };
								[actionsToPerformDictionary setObject:actionToPerform forKey:@(currentNumber)];

								currentNumber = currentNumber + 1;
			   				}
						}
					}
		   		}
		   	}
		}

	   	// TODO send response 21 for quick reply

		PBTimelineAttribute *attr1 = [[[%c(PBTimelineAttribute) alloc] initWithType:@"title" content:@"Action" specificType:0] autorelease];
		PBTimelineAttribute *attr2 = [[[%c(PBTimelineAttribute) alloc] initWithType:@"subtitle" content:@"Action" specificType:0] autorelease];
		[self sendResponse:16 withAttributes:@[ attr1, attr2 ] actions:actions forItemIdentifier:[m ANCSIdentifier]];
		return;
	}
	else if ([m actionID] == DISMISS_IDENTIFIER)
	{
		PBTimelineAttribute *attr = [[[%c(PBTimelineAttribute) alloc] initWithType:@"subtitle" content:@"Dismissed" specificType:0] autorelease];
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
		BOOL isReplyAction = [(NSNumber *)actionToPerformDict[@"isReplyAction"] boolValue];

		if (actionID && bulletinID)
		{
			if (isComposeAction)
			{
				PBTimelineAttribute *attr = [[[%c(PBTimelineAttribute) alloc] initWithType:@"subtitle" content:@"Reply" specificType:0] autorelease];
				[self sendResponse:21 withAttributes:@[ attr ] actions:NULL forItemIdentifier:[m ANCSIdentifier]];
				return;
			}
			else if (isReplyAction)
			{
				[%c(PBANCSActionHandler) performAction:actionID forBulletinID:bulletinID];

				PBTimelineAttribute *attr = [[[%c(PBTimelineAttribute) alloc] initWithType:@"subtitle" content:@"Reply sent" specificType:0] autorelease];
				[self sendResponse:15 withAttributes:@[ attr ] actions:NULL forItemIdentifier:[m ANCSIdentifier]];
				return;
			}
			else
			{
				[%c(PBANCSActionHandler) performAction:actionID forBulletinID:bulletinID];

				PBTimelineAttribute *attr = [[[%c(PBTimelineAttribute) alloc] initWithType:@"subtitle" content:@"Action done" specificType:0] autorelease];
				[self sendResponse:15 withAttributes:@[ attr ] actions:NULL forItemIdentifier:[m ANCSIdentifier]];
				return;
			}
		}
		else
		{
			PBTimelineAttribute *attr = [[[%c(PBTimelineAttribute) alloc] initWithType:@"subtitle" content:@"Action failed!" specificType:0] autorelease];
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


%end

%hook PBNotificationSource

+(id)notificationSourceWithAppIdentifier:(id)arg1 flags:(unsigned)arg2 version:(unsigned short)arg3 attributes:(id)arg4 actions:(id)arg5
{
	NSArray *enabledApps = [NSArray arrayWithObjects:@"com.apple.MobileSMS", @"com.apple.mobilephone", @"com.pebble.sendText", nil];
	if ([enabledApps containsObject:(NSString *)arg1])
	{
		return %orig;
	}

	NSString *appID = (NSString *)arg1;
	if (![appsArray containsObject:appID])
	{
		[appsArray addObject:appID];
	}

	PBTimelineAttribute *attr1 = [[[%c(PBTimelineAttribute) alloc] initWithType:@"title" content:@"Action" specificType:0] autorelease];
	PBTimelineAction *b = [[[%c(PBTimelineAction) alloc] initWithIdentifier:@(HAS_ACTIONS_IDENTIFIER) type:@"ANCSResponse" attributes:@[ attr1 ]] autorelease];
	id r = %orig(arg1, arg2, arg3, arg4, @[ b ]);

	return r;
}

%end

%end

%ctor
{
    if ([%c(PBAppDelegate) class])
	{
        %init(PebbleMain);
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