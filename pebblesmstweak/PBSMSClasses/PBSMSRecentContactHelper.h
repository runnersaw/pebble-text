

@interface PBSMSContact

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *phone;

+ (PBSMSContact *)deserializeFromObject:(id)object;

- (instancetype)initWithName:(NSString *)name phone:(NSString *)phone;

- (NSDictionary *)serializeToDictionary;

@end

@interface PBSMSRecentContactHelper

@property (nonatomic, readonly) NSArray *contacts;
@property (nonatomic, readonly) NSArray *names;
@property (nonatomic, readonly) NSArray *phones;

+ (PBSMSRecentContactHelper *)sharedHelper;

- (void)addContact:(PBSMSContact *)contact;
- (void)loadContacts;
- (void)saveContacts;

@end