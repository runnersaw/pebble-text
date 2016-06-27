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
// - (void)_fillOutCopy:(id)arg1 withZone:(struct _NSZone { }*)arg2;
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
// - (struct CGSize { float x1; float x2; })composedAttachmentImageSize;
// - (struct CGSize { float x1; float x2; })composedAttachmentImageSizeForKey:(id)arg1;
// - (struct CGSize { float x1; float x2; })composedAttachmentImageSizeForKey:(id)arg1 withObserver:(id)arg2;
// - (struct CGSize { float x1; float x2; })composedAttachmentImageSizeWithObserver:(id)arg1;
- (id)composedAttachmentImageWithObserver:(id)arg1;
- (id)content;
- (id)context;
// - (id)copyWithZone:(struct _NSZone { }*)arg1;
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
// - (id)copyWithZone:(struct _NSZone { }*)arg1;
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

@interface BBContent : NSObject

+ (id)contentWithTitle:(id)arg1 subtitle:(id)arg2 message:(id)arg3;
+ (BOOL)supportsSecureCoding;

// - (id)copyWithZone:(struct _NSZone { }*)arg1;
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

@interface BBAppearance : NSObject
- (id)title;
@end

static NSString *notificationsFileLocation = @"/var/mobile/Library/Preferences/com.sawyervaughan.pebblesms.notifications.plist";

static NSMutableDictionary *bulletinDict = [NSMutableDictionary dictionary];
/* Should look like:

{ 
"com.facebook.Messenger" : 
    { 
    bulletinId :
        {
            "bulletinID" : bulletinId,
            "title": title,
            "subtitle": subtitle,
            "message": message,
            "timestamp" : NSDate,
            "actions" : {
                "Like": "AD83-29492...",
                ...
            }
            "type": "reply" or "actionableNotification"
        }
    }, ...
}

NOTE bulletin.title and bulletin.message are equal to PBTimelineInvokeANCSActionMessage.sender and PBTimelineInvokeANCSActionMessage.body

*/

static void addBulletinToDictionary(BBBulletin *bulletin) {
    NSString *appIdentifier = [bulletin sectionID];
    NSString *bulletinID = [bulletin bulletinID];

    if (appIdentifier == NULL) {
        return;
    }

    NSMutableDictionary *appDict = [bulletinDict objectForKey:appIdentifier];
    if (!appDict) {
        appDict = [NSMutableDictionary dictionary];
    }

    if ([appDict objectForKey:bulletinID] != NULL) {
        return;
    }

    BBContent *content = [bulletin content];
    NSString *title = [content title];
    NSString *subtitle = [content subtitle];
    NSString *message = [content message];
    NSDate *timestamp = [NSDate date];

    NSLog(@"HEREHERELOOK %@ %@ %@", title, subtitle, message);
    NSLog(@"%@", [bulletin title]);

    if (bulletinID == NULL) {
        return;
    }

    BOOL hasActions = NO;
    NSMutableDictionary *actionsDict = [NSMutableDictionary dictionary];
    for (BBAction *action in [bulletin supplementaryActionsForLayout:1]) {
        NSString *actionIdentifier = [action identifier];
        NSString *actionTitle = [(BBAppearance *)[action appearance] title];
        if (![action isAuthenticationRequired] && actionIdentifier && actionTitle) {
            [actionsDict setObject:actionIdentifier forKey:actionTitle];
            hasActions = YES;
        }
    }

    if (!hasActions) {
        return;
    }

    // subtitle needs to go last in case it's null
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:timestamp, @"timestamp", actionsDict, @"actions", message, @"message", NULL];
    if (title != NULL) {
        [dict setObject:title forKey:@"title"];
    }
    if (subtitle != NULL) {
        [dict setObject:subtitle forKey:@"subtitle"];
    }
    // NSMutableDictionary *finalDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:dict, bulletinID, NULL];

    NSMutableDictionary *d = [NSMutableDictionary dictionaryWithObjectsAndKeys:dict, bulletinID, NULL];
    [bulletinDict setObject:d forKey:appIdentifier];

    [bulletinDict writeToFile:notificationsFileLocation atomically:NO];
}

%hook BBBulletin
+ (id)addBulletinToCache:(id)arg1 { 
    // %log; 
    id r = %orig; 
    if (![r isMemberOfClass:%c(BBBulletinRequest)]) {
        addBulletinToDictionary((BBBulletin *)r);
    }
    return r; 
}

- (id)_responseForAction:(id)arg1 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)responseForAcknowledgeAction { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)responseForAction:(id)arg1 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)responseForButtonActionAtIndex:(unsigned int)arg1 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)responseForDefaultAction { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)responseForExpireAction { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)responseForRaiseAction { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)supplementaryActions { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)supplementaryActionsByLayout { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)supplementaryActionsForLayout:(int)arg1 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
%end

%hook BBAction
- (id)_nameForActionType:(int)arg1 { %log; id r = %orig; NSLog(@"= %@", r); return r; }
- (BOOL)hasInteractiveAction { %log; BOOL r = %orig; NSLog(@"= %d", r); return r; }
- (BOOL)hasLaunchAction { %log; BOOL r = %orig; NSLog(@"= %d", r); return r; }
- (BOOL)hasPluginAction { %log; BOOL r = %orig; NSLog(@"= %d", r); return r; }
- (BOOL)hasRemoteViewAction { %log; BOOL r = %orig; NSLog(@"= %d", r); return r; }
- (id)initWithIdentifier:(id)arg1 { %log; id r = %orig; NSLog(@"= %@", r); return r; }
- (BOOL)deliverResponse:(id)arg1 { %log; BOOL r = %orig; NSLog(@"= %d", r); return r; }
%end

@interface BBServer : NSObject
- (void)deliverResponse:(id)arg1;
- (void)observer:(id)arg1 handleResponse:(id)arg2;
@end

@interface BBResponse : NSObject
- (id)actionID;
- (id)replyText;
- (void)send;
- (id /* block */)sendBlock;
@end

@interface BBObserver : NSObject
- (void)noteServerReceivedResponseForBulletin:(id)arg1;
- (void)sendResponse:(id)arg1;
@end

%hook BBServer
- (void)deliverResponse:(id)arg1 { %log; return %orig; }
- (void)observer:(id)arg1 handleResponse:(id)arg2 { %log; return %orig; }
%end

%hook BBResponse
- (id)actionID { %log; id r = %orig; NSLog(@"= %@", r); return r; }
- (id)replyText { %log; id r = %orig; NSLog(@"= %@", r); NSLog(@"OVERRIDEN HELLO"); return @"HELLO"; }
- (void)send { %log; return %orig; }
- (id /* block */)sendBlock { %log; id r = %orig; NSLog(@"= %@", r); return r; }
%end

%hook BBObserver
- (void)noteServerReceivedResponseForBulletin:(id)arg1 { %log; return %orig; }
- (void)sendResponse:(id)arg1 { %log; return %orig; }
%end