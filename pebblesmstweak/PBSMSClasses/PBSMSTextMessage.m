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

    NSString *number = [dict safeObjectForKey:@"number" ofType:[NSString class]];   
    NSString *messageText = [dict safeObjectForKey:@"message" ofType:[NSString class]];
    NSString *uuid = [dict safeObjectForKey:@"uuid" ofType:[NSString class]];
    NSNumber *shouldNotify = [dict safeObjectForKey:@"notify" ofType:[NSNumber class]];
    NSNumber *isNewNumber = [dict safeObjectForKey:@"newNumber" ofType:[NSNumber class]];
    NSNumber *isRecentContact = [dict safeObjectForKey:@"isRecentContact" ofType:[NSNumber class]];
    NSNumber *isReply = [dict safeObjectForKey:@"isReply" ofType:[NSNumber class]];
    NSNumber *recordId = [dict safeObjectForKey:@"recordId" ofType:[NSNumber class]];
    NSDate *expirationDate = [dict safeObjectForKey:@"expirationDate" ofType:[NSDate class]];

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
        isRecentContact:[isRecentContact boolValue]
        isReply:[isReply boolValue]
        shouldNotify:[shouldNotify boolValue]
        isNewNumber:[isNewNumber boolValue]
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
        self.number = number;
        self.messageText = messageText;
        self.uuid = uuid;
        self.shouldNotify = shouldNotify;
        self.isNewNumber = isNewNumber;
        self.isRecentContact = isNewNumber;
        self.isReply = isReply;
        self.recordId = recordId;
        self.expirationDate = expirationDate;
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
    return ([_expirationDate compare:[NSDate date]] == NSOrderedAscending);
}

@end