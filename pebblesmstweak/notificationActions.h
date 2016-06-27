@interface PBANCSActionHandler : NSObject
+(id)actionHandlerWithDelegate:(id)arg1;
-(NSUUID *)handlingIdentifier;
-(void)sendResponse:(unsigned char)arg1 withAttributes:(id)arg2 actions:(id)arg3 forItemIdentifier:(id)arg4 ;
-(NSDictionary *)actionHandlersByAppIdentifier;
-(void)setCurrentActionHandler:(id<PBNotificationActionHandler>)arg1;
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