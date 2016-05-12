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

@interface PBSendTextContactAddress : NSObject
+(id)sendTextContactAddressFromManagedEntry:(id)arg1 ;
-(id)initWithManagedAddress:(id)arg1 ;
-(id)initWithUUID:(id)arg1 type:(unsigned char)arg2 attributes:(id)arg3 ;
-(id)initWithUUID:(id)arg1 type:(unsigned char)arg2 address:(id)arg3 ;
-(id)address;
-(id)init;
-(BOOL)isEqual:(id)arg1 ;
-(unsigned char)type;
-(NSArray *)attributes;
-(NSUUID *)uuid;
@end

@interface PBSendTextContact : NSObject
+(id)sendTextContactFromManagedEntry:(id)arg1 ;
+(id)blobEntryModelFromBlobEntry:(id)arg1 ;
-(id)blobRepresentationWithMapper:(id)arg1 ;
-(id)address:(id)arg1 ;
-(id)contactByUpdatingPhoneNumbers:(id)arg1 ;
-(id)initWithManagedContact:(id)arg1 ;
-(NSString *)modelIdentifier;
-(NSString *)underlyingIdentifier;
-(id)initWithUUID:(id)arg1 underlyingId:(id)arg2 flags:(unsigned)arg3 attributes:(id)arg4 addresses:(id)arg5 ;
-(id)initWithUUID:(id)arg1 underlyingId:(id)arg2 displayName:(id)arg3 flags:(unsigned)arg4 addresses:(id)arg5 ;
-(id)contactByUpdatingAddresses:(id)arg1 ;
-(id)contactByUpdatingDisplayName:(id)arg1 ;
-(id)contactByAddingAddress:(id)arg1 ;
-(id)contactByRemovingAddress:(id)arg1 ;
-(id)addressWithUUID:(id)arg1 ;
-(BOOL)containsAddress:(id)arg1 ;
-(NSArray *)addresses;
-(id)init;
-(NSArray *)attributes;
-(NSString *)displayName;
-(NSUUID *)uuid;
-(unsigned)flags;
@end

@interface PBSendSMSService : NSObject
-(id)initWithSMSReplyManager:(id)arg1 ;
-(id)SMSReplyManager;
-(id)sendSMS:(id)arg1 toContact:(id)arg2 transactionID:(id)arg3 ;
-(id)init;
@end

@interface PBSendTextAppPreference : NSObject
+(id)preferenceBlobFromEntries:(id)arg1 ;
+(id)entriesFromPreferenceBlob:(id)arg1 ;
+(unsigned char)typeForEntry:(id)arg1 ;
+(void)load;
-(id)initWithAppIdentifier:(id)arg1 preferenceBlob:(id)arg2 ;
-(id)contactWithUnsortedEntries:(id)arg1 ;
-(id)appPreferenceByAddingRecentEntries:(id)arg1 forContactUUID:(id)arg2 ;
-(id)appPreferenceByUpdatingFavoriteEntries:(id)arg1 forContactUUID:(id)arg2 ;
-(id)appPreferenceByRemovingRecentEntry:(id)arg1 ;
-(id)favoriteEntries;
-(id)recentEntries;
-(id)appPreferenceByRemovingEntryWithAddressIdentifier:(id)arg1 ;
-(id)appPreferenceByMovingAddressWithAddressIdentifier:(id)arg1 toIndex:(long long)arg2 ;
-(BOOL)containsEntryWithContactIdentifier:(id)arg1 ;
-(NSArray *)entries;
-(id)initWithEntries:(id)arg1 ;
@end

@interface PBSendTextAppPreferenceEntry : NSObject
-(BOOL)isEqualToEntry:(id)arg1 ;
-(NSUUID *)contactUUID;
-(NSUUID *)addressUUID;
-(id)initWithContactUUID:(id)arg1 addressUUID:(id)arg2 ;
-(BOOL)isEqual:(id)arg1 ;
-(long long)compare:(id)arg1 ;
@end

@interface PBTimelineInvokeANCSActionMessage : NSObject
+ (void)load;
- (id)appIdentifier;
- (id)notificationSubtitle;
- (id)notificationSender;
- (id)actionTitle;
- (unsigned char)actionType;
- (id)ANCSIdentifier;
- (id)initWithData:(id)fp8;

// 3.12
-(NSString *)notificationBody;
-(unsigned)timestamp;
-(unsigned char)actionID;
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
// - (void)handleActionWithActionIdentifier:(unsigned char)fp8 attributes:(id)fp12;
- (void)startHandlingInvokeActionMessage:(id)fp8;
- (id)initWithDelegate:(id)fp8 SMSReplyManager:(id)fp12 contactPreferredPhoneManager:(id)fp16;

// 3.12
+(id)handlerWithNotificationSourceIdentifier:(id)arg1 delegate:(id)arg2;
-(NSString *)notificationSourceIdentifier;
-(id)initWithNotificationSourceIdentifier:(id)arg1 delegate:(id)arg2 SMSReplyManager:(id)arg3 contactPreferredPhoneManager:(id)arg4 sendSMSService:(id)arg5;
-(id)sendSMSService;
@end

@interface PBNotificationSource : NSObject
+ (id)notificationSourceWithAppIdentifier:(id)fp8 flags:(unsigned int)fp12 version:(unsigned short)fp16 attributes:(id)fp20 actions:(id)fp24;
+ (id)blobEntryModelFromBlobEntry:(id)fp8;
+ (id)notificationSourceFromManagedEntry:(id)fp8;
- (id)actions; // TODO find type
- (id)attributes;
- (unsigned short)version;
- (unsigned int)flags;
- (id)appIdentifier;
- (id)initWithAppIdentifier:(id)fp8 flags:(unsigned int)fp12 version:(unsigned short)fp16 attributes:(id)fp20 actions:(id)fp24;
- (id)blobRepresentationWithMapper:(id)fp8;
- (id)modelIdentifier;
- (id)initWithManagedNotificationSource:(id)fp8;

// 3.12
-(NSString *)appName;
-(NSString *)description;
-(id)muteAttribute;
-(id)appNameAttribute;
-(id)lastUpdatedAttribute;
@end

@interface PBTimelineActionsWatchService : NSObject
+ (id)watchServiceForWatch:(id)fp8 watchServicesSet:(id)fp12;
- (id)notificationHandler;
- (id)accountUserID;
- (id)ANCSActionHandler;
- (id)invokeActionHandler;
- (void)setAddressBookQuerySession:(id)fp8;
- (id)addressBookQuerySession;
- (id)contactPreferredPhoneManager;
- (id)addressBookManager;
- (id)keyedTokenGenerator;
- (id)httpActionSessionManager;
- (id)lockerAppManager;
- (id)timelineWatchService;
- (id)timelineManager;
- (id)watch;
- (void)ANCSActionHandler:(id)fp8 didSendResponse:(unsigned char)fp12 withAttributes:(id)fp16 actions:(id)fp20 forItemIdentifier:(id)fp24;
- (void)sendResponseForItemIdentifier:(id)fp8 response:(unsigned char)fp12;
- (void)sendResponseForItemIdentifier:(id)fp8 response:(unsigned char)fp12 attributes:(id)fp16;
- (void)sendANCSResponseForItemIdentifier:(id)fp8 response:(unsigned char)fp12 attributes:(id)fp16 actions:(id)fp20;
- (void)sendResponseForItemIdentifier:(id)fp8 response:(unsigned char)fp12 attributes:(id)fp16 actions:(id)fp20;
- (void)sendResponseForItemIdentifier:(id)fp8 response:(unsigned char)fp12 subtitle:(id)fp16 icon:(id)fp20 specificType:(int)fp24;
- (void)sendResponseForItemIdentifier:(id)fp8 response:(unsigned char)fp12 subtitle:(id)fp16 icon:(id)fp20;
- (id)subtitleWithMuted:(BOOL)fp8 forDataSourceUUID:(id)fp12;
- (void)processHttpActionWithAttributes:(id)fp8 timelineIdentifier:(id)fp12 dataSourceUUID:(id)fp16;
- (void)processAction:(id)fp8 forItem:(id)fp12 attributes:(id)fp16;
- (void)handleActionForItem:(id)fp8 actionIdentifier:(unsigned char)fp12 attributes:(id)fp16;
- (void)handleActionForItemIdentifier:(id)fp8 actionIdentifier:(unsigned char)fp12 attributes:(id)fp16;
- (void)handleANCSActionForInvokeActionMessage:(id)fp8;
- (void)registerInvokeActionHandler;
- (void)registerInvokeANCSActionHandler;
- (id)initWithWatch:(id)fp8 watchServicesSet:(id)fp12 timelineManager:(id)fp16 currentUserLockerAppManager:(id)fp20;
- (id)init;

// 3.12
-(void)sendTextAppActionHandler:(id)arg1 didSendResponse:(unsigned char)arg2 withAttributes:(id)arg3 forItemIdentifier:(id)arg4;
@end

@interface PBTimelineActionsInvokeActionMessage : NSObject
+ (void)load;
- (id)attributes;
- (unsigned char)actionIdentifier;
- (id)itemIdentifier;
- (id)initWithData:(id)fp8;
@end

@interface PBTimelineActionsActionResponseMessage : NSObject
- (id)initWithItemIdentifier:(id)fp8 response:(unsigned char)fp12 attributes:(id)fp16 actions:(id)fp20;
- (id)initWithItemIdentifier:(id)fp8 response:(unsigned char)fp12 attributes:(id)fp16;
@end

@interface PBTimelineAction : NSObject
+ (id)systemActionWithIdentifier:(unsigned char)fp8;
+ (BOOL)isSystemIdentifier:(unsigned char)fp8;
+ (id)timelineActionFromManagedTimelineItemAction:(id)fp8;
- (id)attributes;
- (id)type;
- (id)identifier;
- (id)initWithIdentifier:(id)fp8 type:(id)fp12 attributes:(id)fp16;
- (id)init;
- (id)blobRepresentationWithMapper:(id)fp8;
@end

@interface PBSMSNotificationActionHandler : NSObject
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

@interface PBANCSActionHandler : NSObject
+ (id)actionHandlerWithDelegate:(id)fp8;
- (void)setCurrentActionHandler:(id)fp8;
- (id)currentActionHandler;
- (void)setHandlingIdentifier:(id)fp8;
- (id)handlingIdentifier;
- (id)timelineWatchService;
- (id)actionHandlersByAppIdentifier;
- (id)delegate;
- (void)notificationHandler:(id)fp8 didSendError:(id)fp12 withTitle:(id)fp16 icon:(id)fp20;
- (void)notificationHandler:(id)fp8 didSendResponse:(unsigned char)fp12 withAttributes:(id)fp16 actions:(id)fp20;
- (void)handleActionWithActionIdentifier:(unsigned char)fp8 attributes:(id)fp12;
- (void)handleInvokeANCSActionMessage:(id)fp8;
- (BOOL)isHandlingNotificationWithIdentifier:(id)fp8;
- (id)initWithDelegate:(id)fp8;

// 3.12
-(void)sendResponse:(unsigned char)arg1 withAttributes:(id)arg2 actions:(id)arg3 forItemIdentifier:(id)arg4;
-(id)backgroundColorForNotificationHandler:(id)arg1;
@end

@interface PBNotificationSourceManager : NSObject
- (id)cannedResponseManager;
- (id)notificationSourceDataStore;
- (id)servicesQueue;
- (id)watchServices;
- (void)setNotificationSourceDatabaseAvailable:(unsigned int)fp8;
- (unsigned int)notificationSourceDatabaseAvailable;
- (void)updateCannedResponsesForAppIdentifier:(id)fp8;
- (void)setActions:(id)fp8 forAppIdentifier:(id)fp12; // HERE!!!!! TODO TO DO
- (id)actionByReplacingAction:(id)fp8 withCannedResponses:(id)fp12;
- (void)notificationSourceDatabaseIsAvailable:(BOOL)fp8;
- (void)synchronizeAllWatchServices;
- (void)rejectNotificationSourceChange:(id)fp8 forWatch:(id)fp12 retryLater:(BOOL)fp16;
- (void)acknowledgeNotificationSourceChange:(id)fp8 forWatch:(id)fp12;
- (void)synchronizationFinishedForWatch:(id)fp8;
- (void)removeNotificationSourceStatusesForWatch:(id)fp8;
- (id)notificationSourceChangesForWatch:(id)fp8;
- (void)removeNotificationSourceWatchService:(id)fp8;
- (void)addNotificationSourceWatchService:(id)fp8;
- (id)allNotificationSources;
- (id)findNotificationSourceForAppIdentifier:(id)fp8;
- (void)removeNotificationSourceWithAppIdentifier:(id)fp8;
- (void)addNotificationSource:(id)fp8;
- (void)handleCannedResponseDidChangeNotification:(id)fp8;
- (void)dealloc;
- (id)initWithCannedResponseManager:(id)fp8;

// 3.12
-(void)entryModelWasAdded:(id)arg1;
-(void)deleteAllLocalNotificationSources;
@end

@interface PBSMSSendRequest : NSObject
+ (id)requestWithMessage:(id)arg1 account:(id)arg2;
- (id)message;
- (id)account;
@end

@interface PBContact : NSObject
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

@interface PBSMSReplyManager : NSObject
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

@interface PBSMSApiClient : NSObject
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
-(id)message;
-(id)transactionID;
-(id)sendRequest;

@end

@interface PBLinkedAccountsRequest : NSObject
+ (id)credentialsJSONTransformer;
+ (id)JSONKeyPathsByPropertyKey;
+ (id)requestWithCredentials:(id)fp8;
- (id)credentials;
@end

@interface PBLinkedAccountsSessionManager : NSObject
- (id)revokeLinkedAccount:(id)fp8;
- (id)refreshLinkedAccount:(id)fp8;
- (id)authorizationURLRequestForProvider:(unsigned char)fp8;
- (id)initWithBaseURL:(id)fp8 sessionConfiguration:(id)fp12;
@end

@interface PBLinkedAccount : NSObject
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

@interface PBLinkedAccountCredentials : NSObject
+ (id)expirationJSONTransformer;
+ (id)JSONKeyPathsByPropertyKey;
- (id)expiration;
- (id)apiData;
@end

@interface PBLinkedAccountsManager : NSObject
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
%hook PBSendTextAppActionHandler
+(id)handlerWithDelegate:(id)arg1 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
+(void)load { %log; %orig; }
-(void)dealloc { %log; %orig; }
-(id)timelineWatchService { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(id)initWithSMSReplyManager:(id)arg1 delegate:(id)arg2 sendSMSService:(id)arg3 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(id)SMSReplyManager { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(id)sendSMSService { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(id)phoneNumberFromAttributes:(id)arg1 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(id)responseFromAttributes:(id)arg1 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(void)notifyUserWithError:(id)arg1 { %log; %orig; }
-(BOOL)handlesAction:(unsigned char)arg1 forItem:(id)arg2 { %log; BOOL r = %orig; NSLog(@" = %d", r); return r; }
// -(void)handleAction:(unsigned char)arg1 forItemIdentifier:(id)arg2 attributes:(id)arg3 { %log; %orig; }
-(id)currentTimelineItem { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(void)setCurrentTimelineItem:(id)arg1 { %log; %orig; }
-(id)init { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(id)delegate { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(NSIndexSet *)actions { %log; NSIndexSet * r = %orig; NSLog(@" = %@", r); return r; }
%end
%hook PBSendTextContactAddress
+(id)sendTextContactAddressFromManagedEntry:(id)arg1  { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(id)initWithManagedAddress:(id)arg1  { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(id)initWithUUID:(id)arg1 type:(unsigned char)arg2 attributes:(id)arg3  { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(id)initWithUUID:(id)arg1 type:(unsigned char)arg2 address:(id)arg3  { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(id)address { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(id)init { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(BOOL)isEqual:(id)arg1  { %log; BOOL r = %orig; NSLog(@" = %d", r); return r; }
-(unsigned char)type { %log; unsigned char r = %orig; NSLog(@" = %hhu", r); return r; }
-(NSArray *)attributes { %log; NSArray * r = %orig; NSLog(@" = %@", r); return r; }
-(NSUUID *)uuid { %log; NSUUID * r = %orig; NSLog(@" = %@", r); return r; }
%end
%hook PBSendTextContact
+(id)sendTextContactFromManagedEntry:(id)arg1  { %log; id r = %orig; NSLog(@" = %@", r); return r; }
+(id)blobEntryModelFromBlobEntry:(id)arg1  { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(id)blobRepresentationWithMapper:(id)arg1  { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(id)address:(id)arg1  { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(id)contactByUpdatingPhoneNumbers:(id)arg1  { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(id)initWithManagedContact:(id)arg1  { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(NSString *)modelIdentifier { %log; NSString * r = %orig; NSLog(@" = %@", r); return r; }
-(NSString *)underlyingIdentifier { %log; NSString * r = %orig; NSLog(@" = %@", r); return r; }
-(id)initWithUUID:(id)arg1 underlyingId:(id)arg2 flags:(unsigned)arg3 attributes:(id)arg4 addresses:(id)arg5  { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(id)initWithUUID:(id)arg1 underlyingId:(id)arg2 displayName:(id)arg3 flags:(unsigned)arg4 addresses:(id)arg5  { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(id)contactByUpdatingAddresses:(id)arg1  { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(id)contactByUpdatingDisplayName:(id)arg1  { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(id)contactByAddingAddress:(id)arg1  { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(id)contactByRemovingAddress:(id)arg1  { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(id)addressWithUUID:(id)arg1  { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(BOOL)containsAddress:(id)arg1  { %log; BOOL r = %orig; NSLog(@" = %d", r); return r; }
-(NSArray *)addresses { %log; NSArray * r = %orig; NSLog(@" = %@", r); return r; }
-(id)init { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(NSArray *)attributes { %log; NSArray * r = %orig; NSLog(@" = %@", r); return r; }
-(NSString *)displayName { %log; NSString * r = %orig; NSLog(@" = %@", r); return r; }
-(NSUUID *)uuid { %log; NSUUID * r = %orig; NSLog(@" = %@", r); return r; }
-(unsigned)flags { %log; unsigned r = %orig; NSLog(@" = %u", r); return r; }
%end
%hook PBSendSMSService
-(id)initWithSMSReplyManager:(id)arg1  { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(id)SMSReplyManager { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(id)sendSMS:(id)arg1 toContact:(id)arg2 transactionID:(id)arg3  { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(id)init { %log; id r = %orig; NSLog(@" = %@", r); return r; }
%end
%hook PBSendTextAppPreference
+(id)preferenceBlobFromEntries:(id)arg1  { %log; id r = %orig; NSLog(@" = %@", r); return r; }
+(id)entriesFromPreferenceBlob:(id)arg1  { %log; id r = %orig; NSLog(@" = %@", r); return r; }
+(unsigned char)typeForEntry:(id)arg1  { %log; unsigned char r = %orig; NSLog(@" = %hhu", r); return r; }
+(void)load { %log; %orig; }
-(id)initWithAppIdentifier:(id)arg1 preferenceBlob:(id)arg2  { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(id)contactWithUnsortedEntries:(id)arg1  { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(id)appPreferenceByAddingRecentEntries:(id)arg1 forContactUUID:(id)arg2  { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(id)appPreferenceByUpdatingFavoriteEntries:(id)arg1 forContactUUID:(id)arg2  { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(id)appPreferenceByRemovingRecentEntry:(id)arg1  { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(id)favoriteEntries { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(id)recentEntries { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(id)appPreferenceByRemovingEntryWithAddressIdentifier:(id)arg1  { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(id)appPreferenceByMovingAddressWithAddressIdentifier:(id)arg1 toIndex:(long long)arg2  { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(BOOL)containsEntryWithContactIdentifier:(id)arg1  { %log; BOOL r = %orig; NSLog(@" = %d", r); return r; }
-(NSArray *)entries { %log; NSArray * r = %orig; NSLog(@" = %@", r); return r; }
-(id)initWithEntries:(id)arg1  { %log; id r = %orig; NSLog(@" = %@", r); return r; }
%end
%hook PBSendTextAppPreferenceEntry
-(BOOL)isEqualToEntry:(id)arg1  { %log; BOOL r = %orig; NSLog(@" = %d", r); return r; }
-(NSUUID *)contactUUID { %log; NSUUID * r = %orig; NSLog(@" = %@", r); return r; }
-(NSUUID *)addressUUID { %log; NSUUID * r = %orig; NSLog(@" = %@", r); return r; }
-(id)initWithContactUUID:(id)arg1 addressUUID:(id)arg2  { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(BOOL)isEqual:(id)arg1  { %log; BOOL r = %orig; NSLog(@" = %d", r); return r; }
-(long long)compare:(id)arg1  { %log; long long r = %orig; NSLog(@" = %lld", r); return r; }
%end
%hook PBTimelineInvokeANCSActionMessage
+ (void)load { %log; %orig; }
- (id)appIdentifier { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)notificationSubtitle { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)notificationSender { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)actionTitle { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (unsigned char)actionType { %log; unsigned char r = %orig; NSLog(@" = %hhu", r); return r; }
- (id)ANCSIdentifier { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)initWithData:(id)fp8 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(NSString *)notificationBody { %log; NSString * r = %orig; NSLog(@" = %@", r); return r; }
-(unsigned)timestamp { %log; unsigned r = %orig; NSLog(@" = %u", r); return r; }
-(unsigned char)actionID { %log; unsigned char r = %orig; NSLog(@" = %hhu", r); return r; }
%end
%hook PBSendSMSActionHandler
+ (id)handlerWithDelegate:(id)fp8 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (void)setAddressBookQuerySession:(id)fp8 { %log; %orig; }
- (id)addressBookQuerySession { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)SMSAPIClient { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)SMSReplyManager { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)preferredPhoneManager { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)delegate { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (void)addressBookQuerySession:(id)fp8 foundMultipleContactMatches:(id)fp12 { %log; %orig; }
- (void)addressBookQuerySessionFailedWithNoContactAccess:(id)fp8 { %log; %orig; }
- (void)addressBookQuerySessionFailedToFindContactMatch:(id)fp8 { %log; %orig; }
- (void)addressBookQuerySession:(id)fp8 foundMultipleAddresses:(id)fp12 { %log; %orig; }
- (void)addressBookQuerySession:(id)fp8 finishedWithContact:(id)fp12 labeledValue:(id)fp16 { %log; %orig; }
- (void)startHandlingInvokeActionMessage:(id)fp8 { %log; %orig; }
- (id)initWithDelegate:(id)fp8 SMSReplyManager:(id)fp12 contactPreferredPhoneManager:(id)fp16 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
+(id)handlerWithNotificationSourceIdentifier:(id)arg1 delegate:(id)arg2 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(NSString *)notificationSourceIdentifier { %log; NSString * r = %orig; NSLog(@" = %@", r); return r; }
-(id)initWithNotificationSourceIdentifier:(id)arg1 delegate:(id)arg2 SMSReplyManager:(id)arg3 contactPreferredPhoneManager:(id)arg4 sendSMSService:(id)arg5 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(id)sendSMSService { %log; id r = %orig; NSLog(@" = %@", r); return r; }
%end
%hook PBNotificationSource
// + (id)notificationSourceWithAppIdentifier:(id)fp8 flags:(unsigned int)fp12 version:(unsigned short)fp16 attributes:(id)fp20 actions:(id)fp24 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// + (id)blobEntryModelFromBlobEntry:(id)fp8 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// + (id)notificationSourceFromManagedEntry:(id)fp8 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// - (id)actions { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// - (id)attributes { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// - (unsigned short)version { %log; unsigned short r = %orig; NSLog(@" = %hu", r); return r; }
// - (unsigned int)flags { %log; unsigned int r = %orig; NSLog(@" = %u", r); return r; }
// - (id)appIdentifier { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// - (id)initWithAppIdentifier:(id)fp8 flags:(unsigned int)fp12 version:(unsigned short)fp16 attributes:(id)fp20 actions:(id)fp24 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// - (id)blobRepresentationWithMapper:(id)fp8 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// - (id)modelIdentifier { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// - (id)initWithManagedNotificationSource:(id)fp8 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// -(NSString *)appName { %log; NSString * r = %orig; NSLog(@" = %@", r); return r; }
// -(NSString *)description { %log; NSString * r = %orig; NSLog(@" = %@", r); return r; }
// -(id)muteAttribute { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// -(id)appNameAttribute { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// -(id)lastUpdatedAttribute { %log; id r = %orig; NSLog(@" = %@", r); return r; }
%end
%hook PBTimelineActionsWatchService
+ (id)watchServiceForWatch:(id)fp8 watchServicesSet:(id)fp12 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)notificationHandler { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)accountUserID { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)ANCSActionHandler { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)invokeActionHandler { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (void)setAddressBookQuerySession:(id)fp8 { %log; %orig; }
- (id)addressBookQuerySession { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)contactPreferredPhoneManager { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)addressBookManager { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)keyedTokenGenerator { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)httpActionSessionManager { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)lockerAppManager { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)timelineWatchService { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)timelineManager { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)watch { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (void)ANCSActionHandler:(id)fp8 didSendResponse:(unsigned char)fp12 withAttributes:(id)fp16 actions:(id)fp20 forItemIdentifier:(id)fp24 { %log; %orig; }
- (void)sendResponseForItemIdentifier:(id)fp8 response:(unsigned char)fp12 { %log; %orig; }
- (void)sendResponseForItemIdentifier:(id)fp8 response:(unsigned char)fp12 attributes:(id)fp16 { %log; %orig; }
- (void)sendANCSResponseForItemIdentifier:(id)fp8 response:(unsigned char)fp12 attributes:(id)fp16 actions:(id)fp20 { %log; %orig; }
- (void)sendResponseForItemIdentifier:(id)fp8 response:(unsigned char)fp12 attributes:(id)fp16 actions:(id)fp20 { %log; %orig; }
- (void)sendResponseForItemIdentifier:(id)fp8 response:(unsigned char)fp12 subtitle:(id)fp16 icon:(id)fp20 specificType:(int)fp24 { %log; %orig; }
- (void)sendResponseForItemIdentifier:(id)fp8 response:(unsigned char)fp12 subtitle:(id)fp16 icon:(id)fp20 { %log; %orig; }
- (id)subtitleWithMuted:(BOOL)fp8 forDataSourceUUID:(id)fp12 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (void)processHttpActionWithAttributes:(id)fp8 timelineIdentifier:(id)fp12 dataSourceUUID:(id)fp16 { %log; %orig; }
- (void)processAction:(id)fp8 forItem:(id)fp12 attributes:(id)fp16 { %log; %orig; }
- (void)handleActionForItem:(id)fp8 actionIdentifier:(unsigned char)fp12 attributes:(id)fp16 { %log; %orig; }
- (void)handleActionForItemIdentifier:(id)fp8 actionIdentifier:(unsigned char)fp12 attributes:(id)fp16 { %log; %orig; }
- (void)handleANCSActionForInvokeActionMessage:(id)fp8 { %log; %orig; }
- (void)registerInvokeActionHandler { %log; %orig; }
- (void)registerInvokeANCSActionHandler { %log; %orig; }
- (id)initWithWatch:(id)fp8 watchServicesSet:(id)fp12 timelineManager:(id)fp16 currentUserLockerAppManager:(id)fp20 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)init { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(void)sendTextAppActionHandler:(id)arg1 didSendResponse:(unsigned char)arg2 withAttributes:(id)arg3 forItemIdentifier:(id)arg4 { %log; %orig; }
%end
%hook PBTimelineActionsInvokeActionMessage
+ (void)load { %log; %orig; }
- (id)attributes { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (unsigned char)actionIdentifier { %log; unsigned char r = %orig; NSLog(@" = %hhu", r); return r; }
- (id)itemIdentifier { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)initWithData:(id)fp8 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
%end
%hook PBTimelineActionsActionResponseMessage
- (id)initWithItemIdentifier:(id)fp8 response:(unsigned char)fp12 attributes:(id)fp16 actions:(id)fp20 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)initWithItemIdentifier:(id)fp8 response:(unsigned char)fp12 attributes:(id)fp16 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
%end
%hook PBTimelineAction
+ (id)systemActionWithIdentifier:(unsigned char)fp8 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
+ (BOOL)isSystemIdentifier:(unsigned char)fp8 { %log; BOOL r = %orig; NSLog(@" = %d", r); return r; }
+ (id)timelineActionFromManagedTimelineItemAction:(id)fp8 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)attributes { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)type { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)identifier { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)initWithIdentifier:(id)fp8 type:(id)fp12 attributes:(id)fp16 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)init { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)blobRepresentationWithMapper:(id)fp8 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
%end
%hook PBSMSNotificationActionHandler
+ (id)handlerWithDelegate:(id)fp8 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (void)setAddressBookQuerySession:(id)fp8 { %log; %orig; }
- (id)addressBookQuerySession { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)SMSAPIClient { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)SMSReplyManager { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)preferredPhoneManager { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)delegate { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (void)addressBookQuerySession:(id)fp8 foundMultipleContactMatches:(id)fp12 { %log; %orig; }
- (void)addressBookQuerySessionFailedWithNoContactAccess:(id)fp8 { %log; %orig; }
- (void)addressBookQuerySessionFailedToFindContactMatch:(id)fp8 { %log; %orig; }
- (void)addressBookQuerySession:(id)fp8 foundMultipleAddresses:(id)fp12 { %log; %orig; }
- (void)addressBookQuerySession:(id)fp8 finishedWithContact:(id)fp12 labeledValue:(id)fp16 { %log; %orig; }
- (void)handleActionWithActionIdentifier:(unsigned char)fp8 attributes:(id)fp12 { %log; %orig; }
- (void)startHandlingInvokeActionMessage:(id)fp8 { %log; %orig; }
- (id)initWithDelegate:(id)fp8 SMSReplyManager:(id)fp12 contactPreferredPhoneManager:(id)fp16 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
%end
%hook PBANCSActionHandler
+ (id)actionHandlerWithDelegate:(id)fp8 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (void)setCurrentActionHandler:(id)fp8 { %log; %orig; }
- (id)currentActionHandler { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (void)setHandlingIdentifier:(id)fp8 { %log; %orig; }
- (id)handlingIdentifier { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)timelineWatchService { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)actionHandlersByAppIdentifier { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)delegate { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (void)notificationHandler:(id)fp8 didSendError:(id)fp12 withTitle:(id)fp16 icon:(id)fp20 { %log; %orig; }
- (void)notificationHandler:(id)fp8 didSendResponse:(unsigned char)fp12 withAttributes:(id)fp16 actions:(id)fp20 { %log; %orig; }
- (void)handleActionWithActionIdentifier:(unsigned char)fp8 attributes:(id)fp12 { %log; %orig; }
- (void)handleInvokeANCSActionMessage:(id)fp8 { %log; %orig; }
- (BOOL)isHandlingNotificationWithIdentifier:(id)fp8 { %log; BOOL r = %orig; NSLog(@" = %d", r); return r; }
- (id)initWithDelegate:(id)fp8 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(void)sendResponse:(unsigned char)arg1 withAttributes:(id)arg2 actions:(id)arg3 forItemIdentifier:(id)arg4 { %log; %orig; }
-(id)backgroundColorForNotificationHandler:(id)arg1 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
%end
%hook PBNotificationSourceManager
- (id)cannedResponseManager { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)notificationSourceDataStore { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)servicesQueue { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)watchServices { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (void)setNotificationSourceDatabaseAvailable:(unsigned int)fp8 { %log; %orig; }
- (unsigned int)notificationSourceDatabaseAvailable { %log; unsigned int r = %orig; NSLog(@" = %u", r); return r; }
- (void)updateCannedResponsesForAppIdentifier:(id)fp8 { %log; %orig; }
- (void)setActions:(id)fp8 forAppIdentifier:(id)fp12 { %log; %orig; }
- (id)actionByReplacingAction:(id)fp8 withCannedResponses:(id)fp12 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (void)notificationSourceDatabaseIsAvailable:(BOOL)fp8 { %log; %orig; }
- (void)synchronizeAllWatchServices { %log; %orig; }
- (void)rejectNotificationSourceChange:(id)fp8 forWatch:(id)fp12 retryLater:(BOOL)fp16 { %log; %orig; }
- (void)acknowledgeNotificationSourceChange:(id)fp8 forWatch:(id)fp12 { %log; %orig; }
- (void)synchronizationFinishedForWatch:(id)fp8 { %log; %orig; }
- (void)removeNotificationSourceStatusesForWatch:(id)fp8 { %log; %orig; }
- (id)notificationSourceChangesForWatch:(id)fp8 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (void)removeNotificationSourceWatchService:(id)fp8 { %log; %orig; }
- (void)addNotificationSourceWatchService:(id)fp8 { %log; %orig; }
- (id)allNotificationSources { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)findNotificationSourceForAppIdentifier:(id)fp8 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (void)removeNotificationSourceWithAppIdentifier:(id)fp8 { %log; %orig; }
- (void)addNotificationSource:(id)fp8 { %log; %orig; }
- (void)handleCannedResponseDidChangeNotification:(id)fp8 { %log; %orig; }
- (void)dealloc { %log; %orig; }
- (id)initWithCannedResponseManager:(id)fp8 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(void)entryModelWasAdded:(id)arg1 { %log; %orig; }
-(void)deleteAllLocalNotificationSources { %log; %orig; }
%end
%hook PBSMSSendRequest
+ (id)requestWithMessage:(id)arg1 account:(id)arg2 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)message { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)account { %log; id r = %orig; NSLog(@" = %@", r); return r; }
%end
%hook PBContact
// + (id)contactWithRecordRef:(void *)fp8 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (void *)recordRef { %log; void * r = %orig; NSLog(@" = %p", r); return r; }
- (id)phoneNumbers { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)nickname { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)companyName { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)nameSuffix { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)lastName { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)middleName { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)firstName { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)namePrefix { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (int)identifier { %log; int r = %orig; NSLog(@" = %d", r); return r; }
- (id)fullName { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// - (id)initWithRecordRef:(void *)fp8 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)init { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)actionSubtitle { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)actionTitle { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (void)performActionOnAddressBookQuerySession:(id)fp8 { %log; %orig; }
+ (NSString *)phoneWithPrefix:(NSString *)number { %log; NSString * r = %orig; NSLog(@" = %@", r); return r; }
- (NSNumber *)recordId { %log; NSNumber * r = %orig; NSLog(@" = %@", r); return r; }
+(id)fallbackName { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(id)computeOrderableName { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(id)orderableName { %log; id r = %orig; NSLog(@" = %@", r); return r; }
%end
%hook PBSMSReplyManager
- (id)SMSProviders { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)linkedAccountsManager { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)notificationSourceManager { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (void)setHasLinkedSMSAccount:(BOOL)fp8 { %log; %orig; }
- (BOOL)hasLinkedSMSAccount { %log; BOOL r = %orig; NSLog(@" = %d", r); return r; }
- (void)removeDisabledProvidersIfNecessary { %log; %orig; }
- (unsigned char)linkedSMSProvider { %log; unsigned char r = %orig; NSLog(@" = %hhu", r); return r; }
- (void)handleCarrierOverrideDidChangeNotification:(id)fp8 { %log; %orig; }
- (void)disableSMSActions { %log; %orig; }
- (void)enableSMSActions { %log; %orig; }
- (BOOL)isCarrierProviderEnabled { %log; BOOL r = %orig; NSLog(@" = %d", r); return r; }
- (void)setSMSActionsEnabled:(BOOL)fp8 { %log; %orig; }
- (unsigned char)providerFromCarrier { %log; unsigned char r = %orig; NSLog(@" = %hhu", r); return r; }
- (id)linkedSMSAccount { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (void)removeSMSAccount { %log; %orig; }
- (void)setSMSAccount:(id)fp8 { %log; %orig; }
- (void)dealloc { %log; %orig; }
- (id)initWithNotificationSourceManager:(id)fp8 linkedAccountsManager:(id)fp12 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(id)linkedServicesSessionManager { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(id)initWithNotificationSourceManager:(id)arg1 linkedAccountsManager:(id)arg2 modalCoordinator:(id)arg3 userDefaults:(id)arg4 linkedServicesSessionManager:(id)arg5 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(id)smsApp { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(void)prepareSMSSetup { %log; %orig; }
-(id)currentCarrier { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(void)setLastKnownCarrier:(id)arg1  { %log; %orig; }
-(NSUserDefaults *)smsUserDefaults { %log; NSUserDefaults * r = %orig; NSLog(@" = %@", r); return r; }
-(BOOL)checkIfProviderIsSupported:(unsigned char)arg1 forCarrier:(id)arg2 linkedAccount:(id)arg3 { %log; BOOL r = %orig; NSLog(@" = %d", r); return r; }
-(BOOL)needToShowSMSSetup { %log; BOOL r = %orig; NSLog(@" = %d", r); return r; }
-(id)lastKnownCarrier { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(NSSet *)smsApps { %log; NSSet * r = %orig; NSLog(@" = %@", r); return r; }
-(NSSet *)ancsReplyEnabledApps { %log; NSSet * r = %orig; NSLog(@" = %@", r); return r; }
-(id)networkInfo { %log; id r = %orig; NSLog(@" = %@", r); return r; }
%end
%hook PBSMSApiClient
+ (id)client { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)smsReplyManager { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)linkedAccountsManager { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)SMSSessionManager { %log; id r = %orig; NSLog(@" = %@", r); return r; }
+ (void)sendSMS:(NSNumber *)recordId number:(NSString *)number withText:(NSString *)text { %log; %orig; }
- (id)sendSMSWithRecipients:(id)fp8 text:(id)fp12 transactionID:(id)fp16 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)initWithLinkedAccountsManager:(id)fp8 smsReplyManager:(id)fp12 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
+(id)clientWithMessage:(id)arg1 transactionID:(id)arg2 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(id)initWithLinkedAccountsManager:(id)arg1 smsReplyManager:(id)arg2 message:(id)arg3 transactionID:(id)arg4 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(id)smsApp { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(id)phoneApp { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(void)revokeAccounts:(id)arg1 { %log; %orig; }
-(id)sendRequestWithRefreshedLinkedAccounts:(id)arg1 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(void)revokeAccountsFromError:(id)arg1 { %log; %orig; }
-(BOOL)needToRefreshLinkedAccountsForError:(id)arg1 { %log; BOOL r = %orig; NSLog(@" = %d", r); return r; }
-(id)message { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(id)transactionID { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(id)sendRequest { %log; id r = %orig; NSLog(@" = %@", r); return r; }
%end
%hook PBLinkedAccountsRequest
// + (id)credentialsJSONTransformer { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// + (id)JSONKeyPathsByPropertyKey { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// + (id)requestWithCredentials:(id)fp8 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// - (id)credentials { %log; id r = %orig; NSLog(@" = %@", r); return r; }
%end
%hook PBLinkedAccountsSessionManager
- (id)revokeLinkedAccount:(id)fp8 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)refreshLinkedAccount:(id)fp8 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)authorizationURLRequestForProvider:(unsigned char)fp8 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)initWithBaseURL:(id)fp8 sessionConfiguration:(id)fp12 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
%end
%hook PBLinkedAccount
// + (id)credentialsJSONTransformer { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// + (id)settingsJSONTransformer { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// + (id)providerJSONTransformer { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// + (id)uuidJSONTransformer { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// + (id)encodingBehaviorsByPropertyKey { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// + (id)JSONKeyPathsByPropertyKey { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// - (void)setCredentials:(id)fp8 { %log; %orig; }
// - (id)credentials { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// - (void)setSettings:(id)fp8 { %log; %orig; }
// - (id)settings { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// - (unsigned char)provider { %log; unsigned char r = %orig; NSLog(@" = %hhu", r); return r; }
// - (id)uuid { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// - (id)queryParameters:(id)fp8 key:(id)fp12 toResultClass:(id)fp16 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// - (BOOL)isAccountExpired { %log; BOOL r = %orig; NSLog(@" = %d", r); return r; }
// - (id)initWithProvider:(unsigned char)fp8 queryParameters:(id)fp12 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// -(BOOL)isExpired { %log; BOOL r = %orig; NSLog(@" = %d", r); return r; }
%end
%hook PBLinkedAccountCredentials
// + (id)expirationJSONTransformer { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// + (id)JSONKeyPathsByPropertyKey { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// - (id)expiration { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// - (id)apiData { %log; id r = %orig; NSLog(@" = %@", r); return r; }
%end
%hook PBLinkedAccountsManager
+(id) providerToString:(unsigned char)arg1 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
+(unsigned char) stringToProvider:(id)arg { %log; unsigned char r = %orig; NSLog(@" = %hhu", r); return r; }
-(BOOL) addLinkedAccount:(id)arg { %log; BOOL r = %orig; NSLog(@" = %d", r); return r; }
-(BOOL) hasLinkedAccountForProvider:(unsigned char)arg { %log; BOOL r = %orig; NSLog(@" = %d", r); return r; }
-(BOOL) removeLinkedAccountForProvider:(unsigned char)arg { %log; BOOL r = %orig; NSLog(@" = %d", r); return r; }
-(id) linkedAccountForProvider:(unsigned char)arg { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(BOOL) isProviderEnabled:(unsigned char)arg { %log; BOOL r = %orig; NSLog(@" = %d", r); return r; }
-(id) APIClient { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(NSSet *)enabledProviders { %log; NSSet * r = %orig; NSLog(@" = %@", r); return r; }
-(void) refreshLinkedAccountForProvider:(unsigned char)arg1 withForceRefresh:(BOOL)arg2 completion:(id)arg3 { %log; %orig; }
-(id) linkedAccountsValet { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(id) init { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(id)refreshLinkedAccountsAssociatedWithApp:(id)arg1 withForceRefresh:(BOOL)arg2 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(id)linkedAccountsForApp:(id)arg1 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(id)linkedAccountRefreshSignal:(id)arg1 forApp:(id)arg2 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(BOOL)hasLinkedAccountForApp:(id)arg1 { %log; BOOL r = %orig; NSLog(@" = %d", r); return r; }
-(BOOL)addLinkedAccount:(id)arg1 toApp:(id)arg2 { %log; BOOL r = %orig; NSLog(@" = %d", r); return r; }
-(BOOL)removeLinkedAccount:(id)arg1 forApp:(id)arg2 { %log; BOOL r = %orig; NSLog(@" = %d", r); return r; }
-(id)linkedAccountsSessionManager { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(void)migrateLinkedAccountsFrom3Dot6To3Dot7 { %log; %orig; }
-(void)migrateSMSAccountFrom3Dot6To3Dot7ForProvider:(unsigned char)arg1 { %log; %orig; }
%end
@interface PBTimelineAttributeContentLocalizedString : NSObject
+(BOOL)supportsSecureCoding;
-(id)initWithLocalizationKey:(id)arg1;
-(id)initWithLocalizationKey:(id)arg1 placeholderKeyPaths:(id)arg2;
-(NSArray *)placeholderKeyPaths;
-(id)localizedStringWithLocalizedBundle:(id)arg1 binding:(id)arg2;
-(id)initWithCoder:(id)arg1;
-(id)init;
-(NSString *)localizationKey;
@end
%hook PBTimelineAttributeContentLocalizedString
+(BOOL)supportsSecureCoding { %log; BOOL r = %orig; NSLog(@" = %d", r); return r; }
-(id)initWithLocalizationKey:(id)arg1 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(id)initWithLocalizationKey:(id)arg1 placeholderKeyPaths:(id)arg2 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(NSArray *)placeholderKeyPaths { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(id)localizedStringWithLocalizedBundle:(id)arg1 binding:(id)arg2 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(id)initWithCoder:(id)arg1 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(id)init { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(NSString *)localizationKey { %log; id r = %orig; NSLog(@" = %@", r); return r; }
%end

@interface PBSMSMessage : NSObject
+(id)messageWithRecipients:(id)arg1 text:(id)arg2;
+(id)recipientsJSONTransformer;
+(id)JSONKeyPathsByPropertyKey;
-(NSArray *)recipients;
-(NSString *)text;
@end

%hook PBSMSMessage
+(id)messageWithRecipients:(id)arg1 text:(id)arg2 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
+(id)recipientsJSONTransformer { %log; id r = %orig; NSLog(@" = %@", r); return r; }
+(id)JSONKeyPathsByPropertyKey { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(NSArray *)recipients { %log; id r = %orig; NSLog(@" = %@", r); NSLog(@" = %@", [[r objectAtIndex:0] class]); return r; }
-(NSString *)text { %log; id r = %orig; NSLog(@" = %@", r); return r; }
%end

@interface PBPhoneNumber : NSObject
+(id)phoneNumberWithStringValue:(id)arg1 ;
-(NSString *)rawStringValue;
-(id)sanitizePhoneNumberForWatch:(id)arg1 ;
-(BOOL)isPhoneNumberStringValid:(id)arg1 ;
-(id)phoneUtil;
-(id)sanitizePhoneNumberForWeb:(id)arg1 ;
-(id)sanitizePhoneNumber:(id)arg1 withCharacterWhitelist:(id)arg2 separator:(id)arg3 ;
-(NSNumber *)countryCallingCode;
-(NSString *)stringRepresentationForWatch;
-(NSString *)stringRepresentationForWeb;
-(id)initWithStringValue:(id)arg1 ;
-(id)init;
-(BOOL)isEqual:(id)arg1 ;
-(id)description;
-(BOOL)isValid;
-(id)phoneNumber;
-(NSString *)isoCountryCode;
@end

// %hook PBPhoneNumber
// +(id)phoneNumberWithStringValue:(id)arg1 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// -(NSString *)rawStringValue { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// -(id)sanitizePhoneNumberForWatch:(id)arg1  { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// -(BOOL)isPhoneNumberStringValid:(id)arg1 { return %orig; }
// -(id)phoneUtil { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// -(id)sanitizePhoneNumberForWeb:(id)arg1  { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// -(id)sanitizePhoneNumber:(id)arg1 withCharacterWhitelist:(id)arg2 separator:(id)arg3  { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// -(NSNumber *)countryCallingCode { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// -(NSString *)stringRepresentationForWatch { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// -(NSString *)stringRepresentationForWeb { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// -(id)initWithStringValue:(id)arg1  { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// -(id)init { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// -(BOOL)isEqual:(id)arg1 {return %orig;}
// -(id)description { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// -(BOOL)isValid { %log; BOOL r = %orig; NSLog(@" = %d", r); return r; }
// -(id)phoneNumber { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// -(NSString *)isoCountryCode { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// %end