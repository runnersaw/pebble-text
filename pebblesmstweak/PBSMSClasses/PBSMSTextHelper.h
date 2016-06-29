

@interface PBSMSTextHelper : NSObject

@property (nonatomic, copy) NSArray *presets;
@property (nonatomic, readonly) NSArray *names;
@property (nonatomic, readonly) NSArray *phones;
@property (nonatomic, readonly) NSArray *messages;

+ (PBSMSTextHelper *)sharedHelper;

@end