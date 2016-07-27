#import "PBSMSNotification.h"

#import "PBSMSHelper.h"
#import "PBSMSNotificationAction.h"

static NSTimeInterval notificationActionsExpiration = 60.*60.*24.;

@implementation PBSMSNotification

+ (PBSMSNotification *)deserializeFromObject:(id)object
{
    if (![object isKindOfClass:[NSDictionary class]])
    {
        return nil;
    }

    NSDictionary *dict = (NSDictionary *)object;

    NSString *appIdentifier = [dict safeObjectForKey:@"appIdentifier" ofType:[NSString class]];   
    NSString *bulletinId = [dict safeObjectForKey:@"bulletinId" ofType:[NSString class]];
    NSString *title = [dict safeObjectForKey:@"title" ofType:[NSString class]];
    NSString *subtitle = [dict safeObjectForKey:@"subtitle" ofType:[NSString class]];
    NSString *message = [dict safeObjectForKey:@"message" ofType:[NSString class]];
    NSDate *timestamp = [dict safeObjectForKey:@"timestamp" ofType:[NSDate class]];
    NSArray *actions = [dict safeObjectForKey:@"actions" ofType:[NSArray class]];

    // title and subtitle are optional
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
    	log(@"deserializing action %@", a);
    	PBSMSNotificationAction *action = [PBSMSNotificationAction deserializeFromObject:a];
    	if (action)
    	{
    		[finalActions addObject:action];
    	}
    }

    PBSMSNotification *notification = [[PBSMSNotification alloc] initWithAppIdentifier:appIdentifier
		bulletinId:bulletinId
		title:title
		subtitle:subtitle
		message:message
		timestamp:timestamp
		actions:[finalActions copy]];
    return notification;
}

- (instancetype)initWithAppIdentifier:(NSString *)appIdentifier
	bulletinId:(NSString *)bulletinId
	title:(NSString *)title
	subtitle:(NSString *)subtitle
	message:(NSString *)message
	timestamp:(NSDate *)timestamp
	actions:(NSArray *)actions
{
	self = [super init];
	if (self)
	{
		_appIdentifier = appIdentifier;
		_bulletinId = bulletinId;
		_title = (title ? title : @"");
		_subtitle = (subtitle ? subtitle : @"");
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
	[dict setObject:self.title forKey:@"title"];
	[dict setObject:self.subtitle forKey:@"subtitle"];
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

- (BOOL)isExpired
{
	NSDate *earliestValidDate = [NSDate dateWithTimeIntervalSinceNow:-notificationActionsExpiration];
	NSDate *notificationDate = self.timestamp;
    return ([earliestValidDate compare:notificationDate] == NSOrderedDescending);
}

@end