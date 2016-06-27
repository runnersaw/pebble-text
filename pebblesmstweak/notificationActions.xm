@interface PBANCSActionHandler : NSObject
+(id)actionHandlerWithDelegate:(id)arg1;
-(NSUUID *)handlingIdentifier;
-(void)sendResponse:(unsigned char)arg1 withAttributes:(id)arg2 actions:(id)arg3 forItemIdentifier:(id)arg4 ;
-(NSDictionary *)actionHandlersByAppIdentifier;
-(void)setCurrentActionHandler:(id)arg1;
-(void)handleActionWithActionIdentifier:(unsigned char)arg1 attributes:(id)arg2;
-(id)backgroundColorForNotificationHandler:(id)arg1;
-(id)timelineWatchService; //PBTimelineWatchService *
-(void)notificationHandler:(id)arg1 didSendResponse:(unsigned char)arg2 withAttributes:(id)arg3 actions:(id)arg4;
-(void)notificationHandler:(id)arg1 didSendError:(id)arg2 withTitle:(id)arg3 icon:(id)arg4;
@end

@interface PBManagedTimelineItem : NSObject
-(id)findOrCreateActionWithIdentifier:(id)arg1;
@end

@interface PBManagedTimelineItemAction : NSObject
-(BOOL)updateValuesFromAction:(id)arg1;
@end

@interface PBManagedTimelineItemActionable : NSObject
-(BOOL)updateActionsWithActions:(id)arg1;
-(id)findOrCreateActionWithIdentifier:(id)arg1;
@end

@interface PBManagedTimelineItemActionableRelationships : NSObject
+(id)actions;
@end

@interface PBManagedTimelineItemActionAttributes : NSObject
+(id)actionId;
+(id)actionType;
@end

@interface PBManagedTimelineItemActionRelationships : NSObject
+(id)actionable;
@end

@interface PBManagedTimelineItemAttributes : NSObject
+(id)timelineIdentifierString;
+(id)nextActionId;
@end

@interface PBNotificationSource : NSObject
+(id)notificationSourceFromManagedEntry:(id)arg1;
+(id)notificationSourceWithBlob:(id)arg1 mapper:(id)arg2;
+(id)notificationSourceWithAppIdentifier:(id)arg1 flags:(unsigned)arg2 version:(unsigned short)arg3 attributes:(id)arg4 actions:(id)arg5;
-(id)initWithManagedNotificationSource:(id)arg1;
-(NSString *)modelIdentifier;
-(id)initWithAppIdentifier:(id)arg1 flags:(unsigned)arg2 version:(unsigned short)arg3 attributes:(id)arg4 actions:(id)arg5;
-(id)appNameAttribute;//PBTimelineAttribute *
-(NSArray *)actions;
-(NSString *)appIdentifier;
-(NSString *)appName;
@end

@interface PBNotificationSourceBlob : NSObject
-(id)initWithAppIdentifier:(id)arg1 flags:(unsigned)arg2 attributes:(id)arg3 actions:(id)arg4;
-(id)initWithAppIdentifier:(id)arg1 sequentialDataReader:(id)arg2;
-(id)init;
-(NSArray *)actions;
-(NSString *)appIdentifier;
@end

@interface PBNotificationSourceManager : NSObject
-(id)findNotificationSourceForAppIdentifier:(id)arg1;
-(id)actionByReplacingCannedResponsesForAction:(id)arg1 forAppIdentifier:(id)arg2;
-(void)setActions:(id)arg1 forAppIdentifier:(id)arg2 ;
@end

@interface PBSMSReplyManager : NSObject
-(id)notificationSourceManager;
-(id)initWithNotificationSourceManager:(id)arg1 linkedAccountsManager:(id)arg2 modalCoordinator:(id)arg3 userDefaults:(id)arg4 linkedServicesSessionManager:(id)arg5;
-(NSSet *)smsApps;
-(NSSet *)ancsReplyEnabledApps;
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

@interface PBTimelineActionsActionResponseMessage : NSObject
-(id)initWithItemIdentifier:(id)arg1 response:(unsigned char)arg2 attributes:(id)arg3;
-(id)initWithItemIdentifier:(id)arg1 response:(unsigned char)arg2 attributes:(id)arg3 actions:(id)arg4;
@end

@interface PBTimelineActionsInvokeActionMessage : NSObject
-(unsigned char)actionIdentifier;
@end

@interface PBTimelineActionsWatchService : NSObject
-(void)ANCSActionHandler:(id)arg1 didSendResponse:(unsigned char)arg2 withAttributes:(id)arg3 actions:(id)arg4 forItemIdentifier:(id)arg5;
-(void)sendTextAppActionHandler:(id)arg1 didSendResponse:(unsigned char)arg2 withAttributes:(id)arg3 forItemIdentifier:(id)arg4 ;
-(void)registerInvokeActionHandler;
-(void)registerInvokeANCSActionHandler;
-(id)invokeActionHandler;
-(id)ANCSActionHandler;
-(void)handleANCSActionForInvokeActionMessage:(id)arg1;
-(void)handleActionForItemIdentifier:(id)arg1 actionIdentifier:(unsigned char)arg2 attributes:(id)arg3;
-(id)notificationHandler;//PBANCSActionHandler *
-(id)sendTextAppActionHandler;//PBSendTextAppActionHandler *
-(void)handleActionForItem:(id)arg1 actionIdentifier:(unsigned char)arg2 attributes:(id)arg3;
-(void)sendResponseForItemIdentifier:(id)arg1 response:(unsigned char)arg2 attributes:(id)arg3 actions:(id)arg4;
-(void)processAction:(id)arg1 forItem:(id)arg2 attributes:(id)arg3;
-(void)sendResponseForItem:(id)arg1 response:(unsigned char)arg2 attributes:(id)arg3;
-(id)subtitleAttributeForLocalizedString:(id)arg1;
-(void)sendResponseForItem:(id)arg1 response:(unsigned char)arg2 subtitle:(id)arg3 icon:(id)arg4;
-(void)sendResponseForItem:(id)arg1 response:(unsigned char)arg2 subtitle:(id)arg3 icon:(id)arg4 specificType:(long long)arg5;
-(void)sendResponseForItemIdentifier:(id)arg1 response:(unsigned char)arg2 attributes:(id)arg3 actions:(id)arg4 mapperSignal:(id)arg5; 
-(void)sendResponseForItem:(id)arg1 response:(unsigned char)arg2 attributes:(id)arg3 actions:(id)arg4;
-(void)sendANCSResponseForItemIdentifier:(id)arg1 response:(unsigned char)arg2 attributes:(id)arg3 actions:(id)arg4;
-(void)sendResponseForItem:(id)arg1 response:(unsigned char)arg2;
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

@interface PBTimelineItem : NSObject
-(void)addLeadingSystemActionsWithItemBuilder:(id)arg1;
-(void)addTrailingSystemActionsWithItemBuilder:(id)arg1;
-(void)addActionWithType:(id)arg1 identifier:(unsigned char)arg2 title:(id)arg3 toItemBuilder:(id)arg4;
-(void)addDismissSystemActionWithItemBuilder:(id)arg1;
-(void)addMoreSystemActionWithItemBuilder:(id)arg1;
-(void)addMuteSystemActionWithItemBuilder:(id)arg1;
-(void)addUnmuteSystemActionWithItemBuilder:(id)arg1;
-(void)addRemoveSystemActionWithItemBuilder:(id)arg1;
-(NSNumber *)nextActionId;
-(NSUUID *)timelineIdentifier;
-(BOOL)shouldAddSystemActions;
-(id)newActionWithType:(id)arg1 attributes:(id)arg2;
-(id)dataSourceIdentifier;//PBTimelineDataSourceIdentifier *
-(NSArray *)actions;
-(id)actionForIdentifier:(unsigned char)arg1;
@end

@interface PBTimelineItemActionBlobBuilder : NSObject
+(id)builder;
-(/*^block*/id)withType;
-(/*^block*/id)addAttribute;
-(/*^block*/id)withIdentifier;
-(id)init;
-(NSNumber *)identifier;
-(void)setType:(NSString *)arg1;
-(NSString *)type;
-(void)setIdentifier:(NSNumber *)arg1;
-(/*^block*/id)build;
@end

@interface PBTimelineItemBlob : NSObject
-(NSArray *)actions;
@end

@interface PBTimelineItemBlobBuilder : NSObject
+(id)builder;
-(/*^block*/id)addAction;
-(NSMutableArray *)actions;
@end

@interface PBTimelineNotification : NSObject
+(id)standaloneNotificationWithTitle:(id)arg1 body:(id)arg2 actions:(id)arg3 icon:(id)arg4 backgroundColor:(id)arg5 ;
+(id)notificationFromWebTimelineNotification:(id)arg1 existingIdentifier:(id)arg2 parent:(id)arg3 time:(id)arg4 ;
+(id)timelineNotificationFromManagedTimelineNotificationItem:(id)arg1 ;
-(id)initWithManagedTimelineNotification:(id)arg1 ;
-(void)addLeadingSystemActionsWithItemBuilder:(id)arg1 ;
-(void)addTrailingSystemActionsWithItemBuilder:(id)arg1 ;
-(unsigned char)blobTypeForBlobRepresentation;
@end

@interface PBTimelinePin : NSObject
-(void)addLeadingSystemActionsWithItemBuilder:(id)arg1;
-(void)addTrailingSystemActionsWithItemBuilder:(id)arg1;
-(id)source;//PBTimelinePinSource *
-(NSArray *)notifications;
@end

@interface PBTimelineReminder : NSObject
-(void)addLeadingSystemActionsWithItemBuilder:(id)arg1;
-(void)addTrailingSystemActionsWithItemBuilder:(id)arg1;
@end

@interface PBTimelineWatchService : NSObject
-(void)sendStandaloneNotificationWithTitle:(id)arg1 body:(id)arg2;
-(void)sendStandaloneNotificationWithTitle:(id)arg1 body:(id)arg2 actions:(id)arg3 icon:(id)arg4 backgroundColor:(id)arg5;
@end


// %hook PBManagedTimelineItemActionableRelationships
// +(id)actions { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// %end
// %hook PBManagedTimelineItemActionAttributes
// +(id)actionId { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// +(id)actionType { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// %end
// %hook PBManagedTimelineItemActionRelationships
// +(id)actionable { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// %end
// %hook PBManagedTimelineItemAttributes
// +(id)timelineIdentifierString { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// +(id)nextActionId { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// %end
// %hook PBTimelineActionsActionResponseMessage
// -(id)initWithItemIdentifier:(id)arg1 response:(unsigned char)arg2 attributes:(id)arg3 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// -(id)initWithItemIdentifier:(id)arg1 response:(unsigned char)arg2 attributes:(id)arg3 actions:(id)arg4 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// %end
// %hook PBTimelineNotification
// +(id)standaloneNotificationWithTitle:(id)arg1 body:(id)arg2 actions:(id)arg3 icon:(id)arg4 backgroundColor:(id)arg5  { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// +(id)notificationFromWebTimelineNotification:(id)arg1 existingIdentifier:(id)arg2 parent:(id)arg3 time:(id)arg4  { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// +(id)timelineNotificationFromManagedTimelineNotificationItem:(id)arg1  { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// -(id)initWithManagedTimelineNotification:(id)arg1  { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// -(void)addLeadingSystemActionsWithItemBuilder:(id)arg1  { %log; %orig; }
// -(void)addTrailingSystemActionsWithItemBuilder:(id)arg1  { %log; %orig; }
// -(unsigned char)blobTypeForBlobRepresentation { %log; unsigned char r = %orig; NSLog(@" = %hhu", r); return r; }
// %end
// %hook PBTimelineReminder
// -(void)addLeadingSystemActionsWithItemBuilder:(id)arg1 { %log; %orig; }
// -(void)addTrailingSystemActionsWithItemBuilder:(id)arg1 { %log; %orig; }
// %end
// %hook PBANCSActionHandler
// +(id)actionHandlerWithDelegate:(id)arg1 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// -(NSUUID *)handlingIdentifier { %log; NSUUID * r = %orig; NSLog(@" = %@", r); return r; }
// -(void)sendResponse:(unsigned char)arg1 withAttributes:(id)arg2 actions:(id)arg3 forItemIdentifier:(id)arg4  { %log; %orig; }
// -(NSDictionary *)actionHandlersByAppIdentifier { %log; NSDictionary * r = %orig; 
// 	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:r];
// 	[dict setObject:%c(PBSendTextAppActionHandler) forKey:@"com.facebook.Messenger"];
// 	NSLog(@" = %@", dict); return dict; }
// -(void)setCurrentActionHandler:(id)arg1 { %log; %orig; }
// -(void)handleActionWithActionIdentifier:(unsigned char)arg1 attributes:(id)arg2 { %log; %orig; }
// -(id)backgroundColorForNotificationHandler:(id)arg1 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// -(id)timelineWatchService { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// -(void)notificationHandler:(id)arg1 didSendResponse:(unsigned char)arg2 withAttributes:(id)arg3 actions:(id)arg4 { %log; %orig; }
// -(void)notificationHandler:(id)arg1 didSendError:(id)arg2 withTitle:(id)arg3 icon:(id)arg4 { %log; %orig; }
// %end
// %hook PBManagedTimelineItem
// -(id)findOrCreateActionWithIdentifier:(id)arg1 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// %end
// %hook PBManagedTimelineItemAction
// -(BOOL)updateValuesFromAction:(id)arg1 { %log; BOOL r = %orig; NSLog(@" = %d", r); return r; }
// %end
// %hook PBManagedTimelineItemActionable
// -(BOOL)updateActionsWithActions:(id)arg1 { %log; BOOL r = %orig; NSLog(@" = %d", r); return r; }
// -(id)findOrCreateActionWithIdentifier:(id)arg1 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// %end
// %hook PBNotificationSource
// +(id)notificationSourceFromManagedEntry:(id)arg1 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// +(id)notificationSourceWithBlob:(id)arg1 mapper:(id)arg2 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// +(id)notificationSourceWithAppIdentifier:(id)arg1 flags:(unsigned)arg2 version:(unsigned short)arg3 attributes:(id)arg4 actions:(id)arg5 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// -(id)initWithManagedNotificationSource:(id)arg1 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// -(NSString *)modelIdentifier { %log; NSString * r = %orig; NSLog(@" = %@", r); return r; }
// -(id)initWithAppIdentifier:(id)arg1 flags:(unsigned)arg2 version:(unsigned short)arg3 attributes:(id)arg4 actions:(id)arg5 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// -(id)appNameAttribute { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// -(NSArray *)actions { %log; NSArray * r = %orig; NSLog(@" = %@", r); return r; }
// -(NSString *)appIdentifier { %log; NSString * r = %orig; NSLog(@" = %@", r); return r; }
// -(NSString *)appName { %log; NSString * r = %orig; NSLog(@" = %@", r); return r; }
// %end
// %hook PBNotificationSourceBlob
// -(id)initWithAppIdentifier:(id)arg1 flags:(unsigned)arg2 attributes:(id)arg3 actions:(id)arg4 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// -(id)initWithAppIdentifier:(id)arg1 sequentialDataReader:(id)arg2 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// -(id)init { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// -(NSArray *)actions { %log; NSArray * r = %orig; NSLog(@" = %@", r); return r; }
// -(NSString *)appIdentifier { %log; NSString * r = %orig; NSLog(@" = %@", r); return r; }
// %end
%hook PBNotificationSourceManager
-(id)findNotificationSourceForAppIdentifier:(id)arg1 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(id)actionByReplacingCannedResponsesForAction:(id)arg1 forAppIdentifier:(id)arg2 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(void)setActions:(id)arg1 forAppIdentifier:(id)arg2  { %log; %orig; }
%end
// %hook PBSMSReplyManager
// -(id)notificationSourceManager { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// -(id)initWithNotificationSourceManager:(id)arg1 linkedAccountsManager:(id)arg2 modalCoordinator:(id)arg3 userDefaults:(id)arg4 linkedServicesSessionManager:(id)arg5 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// -(NSSet *)ancsReplyEnabledApps { %log; NSSet * r = %orig; NSLog(@" = %@", r); return r; }
// %end
// %hook PBTimelineAction
// +(id)timelineActionFromManagedTimelineItemAction:(id)arg1 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// +(BOOL)isSystemIdentifier:(unsigned char)arg1 { %log; BOOL r = %orig; NSLog(@" = %d", r); return r; }
// +(id)systemActionWithIdentifier:(unsigned char)arg1 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// %end
// %hook PBTimelineActionsInvokeActionMessage
// -(unsigned char)actionIdentifier { %log; unsigned char r = %orig; NSLog(@" = %hhu", r); return r; }
// %end
// %hook PBTimelineActionsWatchService
// -(void)ANCSActionHandler:(id)arg1 didSendResponse:(unsigned char)arg2 withAttributes:(id)arg3 actions:(id)arg4 forItemIdentifier:(id)arg5 { %log; %orig; }
// -(void)sendTextAppActionHandler:(id)arg1 didSendResponse:(unsigned char)arg2 withAttributes:(id)arg3 forItemIdentifier:(id)arg4  { %log; %orig; }
// -(void)registerInvokeActionHandler { %log; %orig; }
// -(void)registerInvokeANCSActionHandler { %log; %orig; }
// -(id)invokeActionHandler { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// -(id)ANCSActionHandler { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// -(void)handleANCSActionForInvokeActionMessage:(id)arg1 { %log; %orig; }
// -(void)handleActionForItemIdentifier:(id)arg1 actionIdentifier:(unsigned char)arg2 attributes:(id)arg3 { %log; %orig; }
// -(id)notificationHandler { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// -(id)sendTextAppActionHandler { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// -(void)handleActionForItem:(id)arg1 actionIdentifier:(unsigned char)arg2 attributes:(id)arg3 { %log; %orig; }
// -(void)sendResponseForItemIdentifier:(id)arg1 response:(unsigned char)arg2 attributes:(id)arg3 actions:(id)arg4 { %log; %orig; }
// -(void)processAction:(id)arg1 forItem:(id)arg2 attributes:(id)arg3 { %log; %orig; }
// -(void)sendResponseForItem:(id)arg1 response:(unsigned char)arg2 attributes:(id)arg3 { %log; %orig; }
// -(id)subtitleAttributeForLocalizedString:(id)arg1 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// -(void)sendResponseForItem:(id)arg1 response:(unsigned char)arg2 subtitle:(id)arg3 icon:(id)arg4 { %log; %orig; }
// -(void)sendResponseForItem:(id)arg1 response:(unsigned char)arg2 subtitle:(id)arg3 icon:(id)arg4 specificType:(long long)arg5 { %log; %orig; }
// -(void)sendResponseForItemIdentifier:(id)arg1 response:(unsigned char)arg2 attributes:(id)arg3 actions:(id)arg4 mapperSignal:(id)arg5 { %log; %orig; }
// -(void)sendResponseForItem:(id)arg1 response:(unsigned char)arg2 attributes:(id)arg3 actions:(id)arg4 { %log; %orig; }
// -(void)sendANCSResponseForItemIdentifier:(id)arg1 response:(unsigned char)arg2 attributes:(id)arg3 actions:(id)arg4 { %log; %orig; }
// -(void)sendResponseForItem:(id)arg1 response:(unsigned char)arg2 { %log; %orig; }
// %end
// %hook PBTimelineInvokeANCSActionMessage
// -(NSUUID *)ANCSIdentifier { %log; NSUUID * r = %orig; NSLog(@" = %@", r); return r; }
// -(NSString *)notificationSender { %log; NSString * r = %orig; NSLog(@" = %@", r); return r; }
// -(NSString *)notificationSubtitle { %log; NSString * r = %orig; NSLog(@" = %@", r); return r; }
// -(NSString *)notificationBody { %log; NSString * r = %orig; NSLog(@" = %@", r); return r; }
// -(unsigned char)actionID { %log; unsigned char r = %orig; NSLog(@" = %hhu", r); return r; }
// -(NSString *)actionTitle { %log; NSString * r = %orig; NSLog(@" = %@", r); return r; }
// -(NSString *)appIdentifier { %log; NSString * r = %orig; NSLog(@" = %@", r); return r; }
// %end
// %hook PBTimelineItem
// -(void)addLeadingSystemActionsWithItemBuilder:(id)arg1 { %log; %orig; }
// -(void)addTrailingSystemActionsWithItemBuilder:(id)arg1 { %log; %orig; }
// -(void)addActionWithType:(id)arg1 identifier:(unsigned char)arg2 title:(id)arg3 toItemBuilder:(id)arg4 { %log; %orig; }
// -(void)addDismissSystemActionWithItemBuilder:(id)arg1 { %log; %orig; }
// -(void)addMoreSystemActionWithItemBuilder:(id)arg1 { %log; %orig; }
// -(void)addMuteSystemActionWithItemBuilder:(id)arg1 { %log; %orig; }
// -(void)addUnmuteSystemActionWithItemBuilder:(id)arg1 { %log; %orig; }
// -(void)addRemoveSystemActionWithItemBuilder:(id)arg1 { %log; %orig; }
// -(NSNumber *)nextActionId { %log; NSNumber * r = %orig; NSLog(@" = %@", r); return r; }
// -(NSUUID *)timelineIdentifier { %log; NSUUID * r = %orig; NSLog(@" = %@", r); return r; }
// -(BOOL)shouldAddSystemActions { %log; BOOL r = %orig; NSLog(@" = %d", r); return r; }
// -(id)newActionWithType:(id)arg1 attributes:(id)arg2 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// -(id)dataSourceIdentifier { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// -(NSArray *)actions { %log; NSArray * r = %orig; NSLog(@" = %@", r); return r; }
// -(id)actionForIdentifier:(unsigned char)arg1 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// %end
// %hook PBTimelineItemActionBlobBuilder
// +(id)builder { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// -(/*^block*/id)withType { %log; /*^block*/id r = %orig; return r; }
// -(/*^block*/id)addAttribute { %log; /*^block*/id r = %orig; return r; }
// -(/*^block*/id)withIdentifier { %log; /*^block*/id r = %orig; return r; }
// -(id)init { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// -(NSNumber *)identifier { %log; NSNumber * r = %orig; NSLog(@" = %@", r); return r; }
// -(void)setType:(NSString *)arg1 { %log; %orig; }
// -(NSString *)type { %log; NSString * r = %orig; NSLog(@" = %@", r); return r; }
// -(void)setIdentifier:(NSNumber *)arg1 { %log; %orig; }
// -(/*^block*/id)build { %log; /*^block*/id r = %orig; return r; }
// %end
// %hook PBTimelineItemBlob
// -(NSArray *)actions { %log; NSArray * r = %orig; NSLog(@" = %@", r); return r; }
// %end
// %hook PBTimelineItemBlobBuilder
// +(id)builder { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// -(/*^block*/id)addAction { %log; /*^block*/id r = %orig; return r; }
// -(NSMutableArray *)actions { %log; NSMutableArray * r = %orig; NSLog(@" = %@", r); return r; }
// %end
// %hook PBTimelinePin
// -(void)addLeadingSystemActionsWithItemBuilder:(id)arg1 { %log; %orig; }
// -(void)addTrailingSystemActionsWithItemBuilder:(id)arg1 { %log; %orig; }
// -(id)source { %log; id r = %orig; NSLog(@" = %@", r); return r; }
// -(NSArray *)notifications { %log; NSArray * r = %orig; NSLog(@" = %@", r); return r; }
// %end
// %hook PBTimelineWatchService
// -(void)sendStandaloneNotificationWithTitle:(id)arg1 body:(id)arg2 { %log; %orig; }
// -(void)sendStandaloneNotificationWithTitle:(id)arg1 body:(id)arg2 actions:(id)arg3 icon:(id)arg4 backgroundColor:(id)arg5 { %log; %orig; }
// %end

@interface PBTimelineAttribute : NSObject
-(id)initWithType:(id)arg1 content:(id)arg2 specificType:(long long)arg3;
-(long long)specificType;
- (id)content;
- (id)type;
@end

@interface PBTimelineAttributeContentLocalizedString : NSObject
-(NSString *)localizationKey;
@end
/* Should look like
{
	2: { "actionIdentifier" : "like", "bulletinIdentifier", bulletinID }
}
*/

@interface PBNotificationSourceWatchService :NSObject
-(void)syncWatchToPhone;
-(void)syncPhoneToWatch;
-(void)sendResponse:(id)arg1;
@end

%hook PBNotificationSourceWatchService
-(void)syncWatchToPhone { %log; %orig; }
-(void)syncPhoneToWatch { %log; %orig; }
-(void)sendResponse:(id)arg1 { %log; %orig; }
%end
