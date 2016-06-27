@interface ANAccountNotifier : NSObject //<ANClientCallbackProtocol>
- (id)_createDaemonConnection;
- (id)_daemonConnection;
- (void)_daemonConnectionWasInterrupted;
- (void)_daemonConnectionWasInvalidated;
- (void)_disconnectFromDaemon;
- (void)_startNotificationCallbackListenerWithMachServiceName:(id)arg1;
- (void)_stopNotificationCallbackListener;
- (void)addNotification:(id)arg1;
- (void)dealloc;
- (id)delegate;
- (id)init;
- (id)initWithCallbackMachService:(id)arg1;
- (BOOL)listener:(id)arg1 shouldAcceptNewConnection:(id)arg2;
- (void)notificationWasActivated:(id)arg1;
- (void)notificationWasCleared:(id)arg1;
- (void)notificationWasDismissed:(id)arg1;
- (void)removeNotificationWithIdentifier:(id)arg1;
- (void)removeNotificationsWithEventIdentifier:(id)arg1;
- (void)setDelegate:(id)arg1;
@end

@interface ANAccountNotification : NSObject
+ (BOOL)supportsSecureCoding;
- (id)accountTypeID;
- (id)activateAction;
- (id)activateButtonTitle;
- (id)callbackMachService;
- (id)clearAction;
- (id)date;
- (id)description;
- (id)dismissAction;
- (id)dismissButtonTitle;
- (void)encodeWithCoder:(id)arg1;
- (id)eventIdentifier;
- (id)identifier;
- (id)initForAccountWithType:(id)arg1;
- (id)initWithCoder:(id)arg1;
- (id)initWithManagedObject:(id)arg1;
- (id)message;
- (void)setActivateAction:(id)arg1;
- (void)setActivateButtonTitle:(id)arg1;
- (void)setCallbackMachService:(id)arg1;
- (void)setClearAction:(id)arg1;
- (void)setDate:(id)arg1;
- (void)setDismissAction:(id)arg1;
- (void)setDismissButtonTitle:(id)arg1;
- (void)setEventIdentifier:(id)arg1;
- (void)setMessage:(id)arg1;
- (void)setTitle:(id)arg1;
- (void)setUserInfo:(id)arg1;
- (id)title;
- (id)userInfo;
@end

@interface ANClientCallbackInterface : NSObject
+ (id)XPCInterface;
+ (id)_buildXPCInterface;
@end

@interface ANDaemonInterface : NSObject
+ (id)XPCInterface;
+ (id)_buildXPCInterface;
@end

@interface ANManagedAccountNotification : NSObject
@property (nonatomic, retain) NSString *accountTypeID;
@property (nonatomic, retain) ANManagedNotificationAction *activateAction;
@property (nonatomic, retain) NSString *activateButtonTitle;
@property (nonatomic, retain) NSString *callbackMachServiceName;
@property (nonatomic, retain) ANManagedNotificationAction *clearAction;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) ANManagedNotificationAction *dismissAction;
@property (nonatomic, retain) NSString *dismissButtonTitle;
@property (nonatomic, retain) NSString *eventID;
@property (nonatomic, retain) NSString *identifier;
@property (nonatomic, retain) NSString *message;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) id userInfo;
- (void)takeValuesFromAccountNotification:(id)arg1;
@end

@interface ANManagedNotificationAction : NSObject
@property (nonatomic, retain) NSNumber *isInternal;
@property (nonatomic, retain) ANManagedAccountNotification *notificationToActivate;
@property (nonatomic, retain) ANManagedAccountNotification *notificationToClear;
@property (nonatomic, retain) ANManagedAccountNotification *notificationToDismiss;
@property (nonatomic, retain) id options;
@property (nonatomic, retain) NSString *url;
- (void)takeValuesFromNotificationAction:(id)arg1;
@end

@interface ANNotificationAction : NSObject
+ (id)actionForLaunchingApp:(id)arg1;
+ (id)actionForLaunchingApp:(id)arg1 withOptions:(id)arg2;
+ (id)actionForOpeningWebURL:(id)arg1;
+ (BOOL)supportsSecureCoding;
- (void)encodeWithCoder:(id)arg1;
- (id)initWithCoder:(id)arg1;
- (id)initWithManagedObject:(id)arg1;
- (BOOL)isInternalURL;
- (id)options;
- (void)perform;
- (void)setIsInternalURL:(BOOL)arg1;
- (void)setOptions:(id)arg1;
- (void)setUrl:(id)arg1;
- (id)url;
@end