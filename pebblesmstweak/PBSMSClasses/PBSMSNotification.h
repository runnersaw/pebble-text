

@interface PBSMSNotification : NSObject

@property (nonatomic, copy) NSString *appIdentifier;
@property (nonatomic, copy) NSString *bulletinId;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSDate *timestamp;
@property (nonatomic, copy) NSArray *actions;

+ (PBSMSNotification *)deserializeFromObject:(id)object;

- (instancetype)initWithAppIdentifier:(NSString *)appIdentifier
	bulletinId:(NSString *)bulletinId
	message:(NSString *)message
	timestamp:(NSDate *)timestamp
	actions:(NSArray *)actions;
	
- (NSDictionary *)serializeToDictionary;

@end