

@interface PBSMSTextMessage : NSObject

@property (nonatomic, copy) NSString *number;
@property (nonatomic, copy) NSString *messageText;
@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSNumber *recordId;
@property (nonatomic, readwrite) BOOL isRecentContact;
@property (nonatomic, readwrite) BOOL isReply;
@property (nonatomic, readwrite) BOOL shouldNotify;
@property (nonatomic, readwrite) BOOL isNewNumber;
@property (nonatomic, copy) NSDate *expirationDate;
@property (nonatomic, readonly) BOOL isExpired;

+ (PBSMSTextMessage *)deserializeTextMessageFromObject:(id)object;

- (instancetype)initWithNumber:(NSString *)number
	messageText:(NSString *)messageText
	uuid:(NSString *)uuid
	recordId:(NSNumber *)recordId
	isRecentContact:(BOOL)isRecentContact
	isReply:(BOOL)isReply
	shouldNotify:(BOOL)shouldNotify
	isNewNumber:(BOOL)isNewNumber
	expirationDate:(NSDate *)expirationDate;
	
- (NSDictionary *)serializeToDictionary;

@end