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
-(id)SMSSessionManager;
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