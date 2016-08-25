

@interface PBSMSPebbleAction : NSObject

@property (nonatomic, copy) NSNumber *pebbleActionId;
@property (nonatomic, copy) NSString *actionIdentifier;
@property (nonatomic, copy) NSString *bulletinIdentifier;
@property (nonatomic, copy) NSString *ANCSIdentifier;
@property (nonatomic, readwrite) BOOL isBeginQuickReplyAction;
@property (nonatomic, readwrite) BOOL isReplyAction;
@property (nonatomic, copy) NSString *replyText;
@property (nonatomic, copy) NSDate *performActionRequestDate;

+ (PBSMSPebbleAction *)deserializePebbleActionFromObject:(id)object;

- (instancetype)initWithPebbleActionId:(NSNumber *)pebbleActionId
	actionIdentifier:(NSString *)actionIdentifier
	bulletinIdentifier:(NSString *)bulletinIdentifier
	ANCSIdentifier:(NSString *)ANCSIdentifier
	isBeginQuickReplyAction:(BOOL)isBeginQuickReplyAction
	isReplyAction:(BOOL)isReplyAction
	replyText:(NSString *)replyText;
	
- (NSDictionary *)serializeToDictionary;

- (BOOL)isExpired;

@end