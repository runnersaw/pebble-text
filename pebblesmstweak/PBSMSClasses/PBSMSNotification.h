

@interface PBSMSNotification : NSObject

@property (nonatomic, copy) NSString *appIdentifier;
@property (nonatomic, copy) NSString *bulletinId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSDate *timestamp;
@property (nonatomic, copy) NSArray *actions;

+ (PBSMSNotification *)deserializeNotificationFromObject:(id)object;

- (instancetype)initWithAppIdentifier:(NSString *)appIdentifier
	bulletinId:(NSString *)bulletinId
	title:(NSString *)title
	subtitle:(NSString *)subtitle
	message:(NSString *)message
	timestamp:(NSDate *)timestamp
	actions:(NSArray *)actions;
	
- (NSDictionary *)serializeToDictionary;

- (BOOL)isExpired;

@end