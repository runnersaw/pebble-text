#import "PBSMSTextMessage.h"

#import "PBSMSHelper.h"

@implementation PBSMSTextMessage

+ (PBSMSTextMessage *)deserializeFromObject:(id)object
{
	if (![object isKindOfClass:[NSDictionary class]])
	{
		return nil;
    }

    NSDictionary *dict = (NSDictionary *)object;

    NSString *number = [message safeObjectForKey:@"number" ofClass:[NSString class]];   
    NSString *messageText = [message safeObjectForKey:@"message" ofClass:[NSString class]];
    NSNumber *shouldNotify = [message safeObjectForKey:@"notify" ofClass:[NSNumber class]];
    NSNumber *isNewNumber = [message safeObjectForKey:@"newNumber" ofClass:[NSNumber class]];
    NSNumber *isRecentContact = [message safeObjectForKey:@"isRecentContact" ofClass:[NSNumber class]];
    NSNumber *isReply = [message safeObjectForKey:@"isReply" ofClass:[NSNumber class]];
    NSNumber *recordId = [message safeObjectForKey:@"recordId" ofClass:[NSNumber class]];
    NSString *uuid = [message safeObjectForKey:@"uuid" ofClass:[NSString class]];
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

    PBSMSTextMessage *message = [[PBSMSTextMessage alloc] init];
    message.number = number;
    message.messageText = messageText;
    message.uuid = uuid;
    message.shouldNotify = [shouldNotify boolValue];
    message.isNewNumber = [isNewNumber boolValue];
    message.isRecentContact = [isNewNumber boolValue];
    message.isReply = [isReply boolValue];
    message.recordId = recordId;
    message.expirationDate = expirationDate;
    return message;
}

- (NSDictionary *)serializeToDictionary
{
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];

	[dictionary setObject:self.number forKey:@"number"];
	[dictionary setObject:self.number forKey:@"message"];
	[dictionary setObject:self.number forKey:@"notify"];
	[dictionary setObject:self.number forKey:@"newNumber"];
	[dictionary setObject:self.number forKey:@"isRecentContact"];
	[dictionary setObject:self.number forKey:@"isReply"];
	[dictionary setObject:self.number forKey:@"recordId"];
	[dictionary setObject:self.number forKey:@"uuid"];
	[dictionary setObject:self.number forKey:@"expirationDate"];

    return dictionary;
}

- (BOOL)isExpired
{
	return ([_expirationDate compare:[NSDate date]] == NSOrderedAscending)
}

@end