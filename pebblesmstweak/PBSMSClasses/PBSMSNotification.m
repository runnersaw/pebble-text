#import "PBSMSNotification.h"

#import "PBSMSNotificationAction.h"

@implementation PBSMSNotification

@property (nonatomic, copy) NSString *appIdentifier;
@property (nonatomic, copy) NSString *bulletinId;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSDate *timestamp;
@property (nonatomic, copy) NSArray *actions;

+ (PBSMSNotification *)deserializeFromObject:(id)object
{
    if (![object isKindOfClass:[NSDictionary class]])
    {
        return nil;
    }

    NSDictionary *dict = (NSDictionary *)object;

    NSString *appIdentifier = [dict safeObjectForKey:@"appIdentifier" ofType:[NSString class]];   
    NSString *bulletinId = [dict safeObjectForKey:@"bulletinId" ofType:[NSString class]];
    NSString *message = [dict safeObjectForKey:@"message" ofType:[NSString class]];
    NSDate *timestamp = [dict safeObjectForKey:@"timestamp" ofType:[NSDate class]];
    NSArray *actions = [dict safeObjectForKey:@"actions" ofType:[NSArray class]];

    if (!appIdentifier ||
        !bulletinId ||
        !message ||
        !timestamp ||
        !actions)
    {
        return nil;
    }

    NSMutableArray *finalActions = [NSMutableArray array];
    for (id a in actions)
    {
    	PBSMSNotificationAction *action = [PBSMSNotificationAction deserializeFromObject:a];
    	if (action)
    	{
    		[finalActions addObject:action];
    	}
    }

    PBSMSNotification *notification = [[PBSMSNotificationAction alloc] initWithAppIdentifier:appIdentifier
		bulletinId:bulletinId
		message:message
		timestamp:timestamp
		actions:[finalActions copy];
    return notification;
}

- (instancetype)initWithAppIdentifier:(NSString *)appIdentifier
	bulletinId:(NSString *)bulletinId
	message:(NSString *)message
	timestamp:(NSDate *)timestamp
	actions:(NSArray *)actions
{
	self = [super init];
	if (self)
	{
		_appIdentifier = appIdentifier;
		_bulletinId = bulletinId;
		_message = message;
		_timestamp = timestamp;
		_actions = actions;
	}
	return self;
}
	
- (NSDictionary *)serializeToDictionary
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];

	[dict setObject:self.appIdentifier forKey:@"appIdentifier"];
	[dict setObject:self.bulletinId forKey:@"bulletinId"];
	[dict setObject:self.message forKey:@"message"];
	[dict setObject:self.timestamp forKey:@"timestamp"];

	NSMutableArray *serializedActions = [NSMutableArray array];
	for (PBSMSNotificationAction *action in self.actions)
	{
		[serializedActions addObject:[action serializeToDictionary]];
	}
	[dict setObject:[serializedActions copy] forKey:@"actions"];

	return [dict copy];
}

@end