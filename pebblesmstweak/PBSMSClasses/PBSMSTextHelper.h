@class PBSMSTextMessage;

@interface PBSMSTextHelper : NSObject

@property (nonatomic, copy) NSArray *presets;
@property (nonatomic, strong) NSMutableArray *messagesSent;

+ (PBSMSTextHelper *)sharedHelper;

@end