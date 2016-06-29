#import "PBSMSTextMessage.h"

#import "PBSMSHelper.h"

@implementation PBSMSTextMessage

+ (PBSMSTextMessage *)deserializeFromObject:(id)object
{
	if (![object isKindOfClass:[NSDictionary class]])
	{
		return nil;
    }

    NSDictionary *message = (NSDictionary *)object;

    NSString *number = [message safeObjectForKey:@"number" ofClass:[NSString class]];   
    NSString *messageText = [message safeObjectForKey:@"message" ofClass:[NSString class]];
    NSString *uuid = [message safeObjectForKey:@"uuid" ofClass:[NSString class]];
    NSNumber *shouldNotify = [message safeObjectForKey:@"notify" ofClass:[NSNumber class]];
    NSNumber *isNewNumber = [message safeObjectForKey:@"newNumber" ofClass:[NSNumber class]];
    NSNumber *isRecentContact = [message safeObjectForKey:@"isRecentContact" ofClass:[NSNumber class]];
    NSNumber *isReply = [message safeObjectForKey:@"isReply" ofClass:[NSNumber class]];
    NSNumber *recordId = [message safeObjectForKey:@"recordId" ofClass:[NSNumber class]];
    NSDate *expirationDate = [message safeObjectForKey:@"expirationDate" ofClass:[NSDate class]];

    if (!number ||
    	!messageText ||
    	!shouldNotify ||
    	!isNewNumber ||
    	!isRecentContact ||
    	!isReply ||
    	!recordId ||
    	!uuid ||
    	!expirationDate)
    {
    	return nil;
    }

    PBSMSTextMessage *message = [[PBSMSTextMessage alloc] initWithNumber:number
		messageText:messageText
		uuid:uuid
		recordId:recordId
		isRecentContact:@( isRecentContact )
		isReply:@( isReply )
		shouldNotify:@( shouldNotify )
		isNewNumber:@( isNewNumber )
		expirationDate:expirationDate];
    return message;
}

- (instancetype)initWithNumber:(NSString *)number
	messageText:(NSString *)messageText
	uuid:(NSString *)uuid
	recordId:(NSNumber *)recordId
	isRecentContact:(BOOL)isRecentContact
	isReply:(BOOL)isReply
	shouldNotify:(BOOL)shouldNotify
	isNewNumber:(BOOL)isNewNumber
	expirationDate:(NSDate *)expirationDate
{
	self = [super init];
	if (self)
	{
	    message.number = number;
	    message.messageText = messageText;
	    message.uuid = uuid;
	    message.shouldNotify = shouldNotify;
	    message.isNewNumber = isNewNumber;
	    message.isRecentContact = isNewNumber;
	    message.isReply = isReply;
	    message.recordId = recordId;
	    message.expirationDate = expirationDate;
	}
	return self;
}

- (NSDictionary *)serializeToDictionary
{
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];

	[dictionary setObject:self.number forKey:@"number"];
	[dictionary setObject:self.messageText forKey:@"message"];
	[dictionary setObject:@( self.shouldNotify ) forKey:@"notify"];
	[dictionary setObject:@( self.isNewNumber ) forKey:@"newNumber"];
	[dictionary setObject:@( self.isRecentContact ) forKey:@"isRecentContact"];
	[dictionary setObject:@( self.isReply ) forKey:@"isReply"];
	[dictionary setObject:self.recordId forKey:@"recordId"];
	[dictionary setObject:self.uuid forKey:@"uuid"];
	[dictionary setObject:self.expirationDate forKey:@"expirationDate"];

    return dictionary;
}

- (BOOL)isExpired
{
	return ([_expirationDate compare:[NSDate date]] == NSOrderedAscending)
}

@end