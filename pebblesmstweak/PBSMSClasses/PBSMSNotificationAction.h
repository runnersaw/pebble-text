

@interface PBSMSNotificationAction : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *actionIdentifier;
@property (nonatomic, readwrite) BOOL isQuickReply;

+ (PBSMSNotificationAction *)deserializeFromObject:(id)object;

- (instancetype)initWithTitle:(NSString *)title
	actionIdentifier:(NSString *)actionIdentifier
	isQuickReply:(BOOL)isQuickReply;
	
- (NSDictionary *)serializeToDictionary;

@end