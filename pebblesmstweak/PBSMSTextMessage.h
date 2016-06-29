

@interface PBSMSTextMessage

@property (nonatomic, copy) NSString *number;
@property (nonatomic, copy) NSString *messageText;
@property (nonatomic, copy) NSNumber *shouldNotify;
@property (nonatomic, copy) NSNumber *isNewNumber;
@property (nonatomic, copy) NSNumber *recordId;
@property (nonatomic, readwrite) BOOL isRecentContact;
@property (nonatomic, readwrite) BOOL isReply;
@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSDate *expirationDate;
@property (nonatomic, readonly) BOOL isExpired;

+ (PBSMSTextMessage *)deserializeFromObject:(id)object;
- (NSDictionary *)serializeToDictionary:(PBSMSTextMessage *)message;

@end