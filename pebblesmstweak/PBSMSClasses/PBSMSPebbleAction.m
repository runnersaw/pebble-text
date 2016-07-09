#import "PBSMSPebbleAction.h"

#import "PBSMSHelper.h"

static NSTimeInterval actionToPerformExpiration = 20.;

@implementation PBSMSPebbleAction : NSObject

+ (PBSMSPebbleAction *)deserializeFromObject:(id)object
{
    if (![object isKindOfClass:[NSDictionary class]])
    {
        return nil;
    }

    NSDictionary *dict = (NSDictionary *)object;

    NSNumber *pebbleActionId = [dict safeObjectForKey:@"pebbleActionId" ofType:[NSNumber class]];   
    NSString *actionIdentifier = [dict safeObjectForKey:@"actionIdentifier" ofType:[NSString class]];
    NSString *bulletinIdentifier = [dict safeObjectForKey:@"bulletinIdentifier" ofType:[NSString class]];
    NSString *ANCSIdentifier = [dict safeObjectForKey:@"ANCSIdentifier" ofType:[NSString class]];
    NSNumber *isBeginQuickReplyAction = [dict safeObjectForKey:@"isBeginQuickReplyAction" ofType:[NSNumber class]];
    NSNumber *isReplyAction = [dict safeObjectForKey:@"isReplyAction" ofType:[NSNumber class]];
    NSString *replyText = [dict safeObjectForKey:@"replyText" ofType:[NSString class]];

    if (!pebbleActionId ||
        !actionIdentifier ||
        !bulletinIdentifier ||
        !ANCSIdentifier ||
        !isBeginQuickReplyAction ||
        !isReplyAction ||
        !replyText)
    {
        return nil;
    }

    PBSMSPebbleAction *pebbleAction = [[PBSMSPebbleAction alloc] initWithPebbleActionId:pebbleActionId
		actionIdentifier:actionIdentifier
		bulletinIdentifier:bulletinIdentifier
		ANCSIdentifier:ANCSIdentifier
		isBeginQuickReplyAction:[isBeginQuickReplyAction boolValue]
		isReplyAction:[isReplyAction boolValue]
		replyText:replyText];
    return pebbleAction;
}

- (instancetype)initWithPebbleActionId:(NSNumber *)pebbleActionId
	actionIdentifier:(NSString *)actionIdentifier
	bulletinIdentifier:(NSString *)bulletinIdentifier
	ANCSIdentifier:(NSString *)ANCSIdentifier
	isBeginQuickReplyAction:(BOOL)isBeginQuickReplyAction
	isReplyAction:(BOOL)isReplyAction
	replyText:(NSString *)replyText
{
	self = [super init];
	if (self)
	{
		_pebbleActionId = pebbleActionId;
		_actionIdentifier = actionIdentifier;
		_bulletinIdentifier = bulletinIdentifier;
		_ANCSIdentifier = ANCSIdentifier;
		_isBeginQuickReplyAction = isBeginQuickReplyAction;
		_isReplyAction = isReplyAction;
		_replyText = replyText;
	}
	return self;
}
	
- (NSDictionary *)serializeToDictionary
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];

	[dict setObject:self.pebbleActionId forKey:@"pebbleActionId"];
	[dict setObject:self.actionIdentifier forKey:@"actionIdentifier"];
	[dict setObject:self.bulletinIdentifier forKey:@"bulletinIdentifier"];
	[dict setObject:self.ANCSIdentifier forKey:@"ANCSIdentifier"];
	[dict setObject:@( self.isBeginQuickReplyAction ) forKey:@"isBeginQuickReplyAction"];
	[dict setObject:@( self.isReplyAction ) forKey:@"isReplyAction"];
	[dict setObject:self.replyText forKey:@"replyText"];

	return [dict copy];
}

- (BOOL)isExpired
{
	NSDate *earliestValidDate = [NSDate dateWithTimeIntervalSinceNow:-actionToPerformExpiration];
	NSDate *requestDate = self.performActionRequestDate;
    return ([earliestValidDate compare:requestDate] == NSOrderedDescending);
}

@end