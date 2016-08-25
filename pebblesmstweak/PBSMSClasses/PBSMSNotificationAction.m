#import "PBSMSNotificationAction.h"

#import "PBSMSHelper.h"

@implementation PBSMSNotificationAction

+ (PBSMSNotificationAction *)deserializeNotificationActionFromObject:(id)object
{
    if (![object isKindOfClass:[NSDictionary class]])
    {
        return nil;
    }

    NSDictionary *dict = (NSDictionary *)object;

    NSString *title = [dict safeObjectForKey:@"actionTitle" ofType:[NSString class]];   
    NSString *actionIdentifier = [dict safeObjectForKey:@"actionIdentifier" ofType:[NSString class]];
    NSNumber *isQuickReply = [dict safeObjectForKey:@"isQuickReply" ofType:[NSNumber class]];

    if (!title ||
        !actionIdentifier)
    {
        return nil;
    }

    PBSMSNotificationAction *action = [[PBSMSNotificationAction alloc] initWithTitle:title
        actionIdentifier:actionIdentifier
        isQuickReply:[isQuickReply boolValue]];
    return action;
}

- (instancetype)initWithTitle:(NSString *)title
	actionIdentifier:(NSString *)actionIdentifier
	isQuickReply:(BOOL)isQuickReply
{
	self = [super init];
	if (self)
	{
		_title = title;
		_actionIdentifier = actionIdentifier;
		_isQuickReply = isQuickReply;
	}
	return self;
}
	
- (NSDictionary *)serializeToDictionary
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];

	[dict setObject:self.title forKey:@"actionTitle"];
	[dict setObject:self.actionIdentifier forKey:@"actionIdentifier"];
	[dict setObject:@( self.isQuickReply ) forKey:@"isQuickReply"];

	return [dict copy];
}

@end