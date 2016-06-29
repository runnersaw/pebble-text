#import "PBSMSTextMessage.h"

#import "PBSMSHelper.h"

@implementation PBSMSTextMessage

+ (PBSMSTextMessage *)serializeFromObject:(id)object
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
    return message;
}

- (BOOL)isExpired
{
	return ([_expirationDate compare:[NSDate date]] == NSOrderedAscending)
}

@end