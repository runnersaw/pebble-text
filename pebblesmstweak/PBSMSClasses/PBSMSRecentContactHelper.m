#import "PBSMSRecentContactHelper.h"

#import "PBSMSHelper.h"

@implementation PBSMSContact

+ (PBSMSContact *)deserializeFromObject:(id)object
{
    if (![object isKindOfClass:[NSDictionary class]])
    {
        return nil;
    }

    NSDictionary *dict = (NSDictionary *)object;

    NSString *name = [dict safeObjectForKey:@"name" ofType:[NSString class]];   
    NSString *phone = [dict safeObjectForKey:@"phone" ofType:[NSString class]];

    if (!name ||
        !phone)
    {
        return nil;
    }

    PBSMSContact *contact = [[PBSMSContact alloc] initWithName:name
    	phone:phone];
    return contact;
}

- (instancetype)initWithName:(NSString *)name phone:(NSString *)phone
{
	self = [super init];
	if (self)
	{
		_name = name;
		_phone = phone;
	}
	return self;
}

- (NSDictionary *)serializeToDictionary
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];

	[dict setObject:self.name forKey:@"name"];
	[dict setObject:self.phone forKey:@"phone"];

	return dict;
}

@end

@interface PBSMSRecentContactHelper

@property (nonatomic, strong) NSMutableArray *mutableContacts;

@end

@implementation PBSMSRecentContactHelper

+ (id)sharedHelper {
    static PBSMSRecentContactHelper *sharedContactHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedContactHelper = [[self alloc] init];
    });
    return sharedContactHelper;
}

- (void)addContact:(PBSMSContact *)contact
{
	[self loadContacts];

	// If it already contains contact, do nothing
	for (PBSMSContact *c in self.mutableContacts)
	{
		if ([c.name isEqualToString:contact.name] && [c.phone isEqualToString:contact.phone])
		{
			return;
		}
	}

	[self.mutableContacts insertObject:contact atIndex:0];
	while (self.mutableContacts.count > MAX_CONTACTS)
	{
		[self.mutableContacts removeLastObject];
	}

	[self saveContacts];
}

- (NSArray *)contacts
{
	return [mutableContacts copy];
}

- (NSArray *)names
{
	NSMutableArray *names = [NSMutableArray array];
	for (PBSMSContact *contact in self.mutableContacts)
	{
		[names addObject:contact.name];
	}
	return [names copy];
}

- (NSArray *)phones
{
	NSMutableArray *phones = [NSMutableArray array];
	for (PBSMSContact *contact in self.mutableContacts)
	{
		[phones addObject:contact.phone];
	}
	return [phones copy];
}

- (void)loadContacts
{
    NSArray *arr = [NSArray arrayWithContentsOfFile:recentFileLocation];

    [self.mutableContacts removeAllObjects];
    for (id object in arr)
	{
        PBSMSContact *contact = [PBSMSContact deserializeFromObject:object];
        if (contact)
        {
        	[self.mutableContacts addObject:contact];
        }
    }
}

- (void)saveContacts
{
	NSMutableArray *finalArray = [NSMutableArray array];

	for (PBSMSContact *contact in self.mutableContacts)
	{
		[finalArray addObject:[contact serializeToDictionary]];
	}

    [[finalArray copy] writeToFile:recentFileLocation atomically:YES];
}

@end