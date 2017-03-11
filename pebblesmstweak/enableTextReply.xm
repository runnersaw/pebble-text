#import "PBSMSClasses/PBSMSHelper.h"

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

// 4.3
-(void)removeSMSAccountWithReason:(id)arg1;
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

@interface PBLinkedAccountExtendedCredentials : PBLinkedAccountCredentials

+ (id)encodingBehaviorsByPropertyKey;
+ (id)JSONKeyPathsByPropertyKey;
- (id)accountData;

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

@interface PBLinkedAccountsSessionManager
-(id)authorizationURLRequestForProvider:(unsigned char)arg1 ;
-(id)revokeLinkedAccount:(id)arg1 withReason:(id)arg2 ;
-(id)refreshLinkedAccount:(id)arg1 ;
-(id)createReauthSession:(id)arg1 ;
-(id)sendVerifyPinRequest:(id)arg1 linkedAccount:(id)arg2 sessionID:(id)arg3 ;
-(id)handleForCredentialError:(id)arg1 ;
-(id)initWithBaseURL:(id)arg1 sessionConfiguration:(id)arg2 ;
@end

%group PebbleTextReply

%hook PBSMSReplyManager

- (BOOL)hasLinkedSMSAccount {
	return YES;
}

- (BOOL)isCarrierProviderEnabled {
	return YES;
}

- (void)setSMSActionsEnabled:(BOOL)fp8 {
	%orig(YES);
}

- (void)disableSMSActions {
	%log;
	%orig;
}

- (void)enableSMSActions {
	%log;
	%orig;
}

-(void)removeSMSAccountWithReason:(id)arg1 {
	%log;
	%orig;
}

%end

%hook PBLinkedAccountsManager

-(BOOL)hasLinkedAccountForApp:(id)arg1 {
	%log;
	if ([arg1 isKindOfClass:[%c(PBMobilePhoneApp) class]])
	{
		return YES;
	}
	if ([arg1 isKindOfClass:[%c(PBMobileSMSApp) class]])
	{
		return YES;
	}

	return %orig;
}
-(id)linkedAccountsForApp:(id)arg1 {
	id r = %orig;
	%log;
	log(@"%@", r);
	return r;
}

%end

%hook PBLinkedAccountsSessionManager

-(id)revokeLinkedAccount:(id)arg1 withReason:(id)arg2 {
	%log;
	%orig;
}

%end

%hook PBTimelineAttribute

- (id)content
{
    if ([[self type] isEqual:@"emojiSupported"])
	{
        return [NSNumber numberWithBool:YES];
    }
    else
	{
        return %orig;
    }
}

%end

%end

%ctor
{
    if ([%c(PBAppDelegate) class])
	{
        %init(PebbleTextReply);
    }
}

