@class PBSMSTextMessage;

@interface PBSMSTextHelper : NSObject

@property (nonatomic, copy) NSArray *presets;
@property (nonatomic, readonly) NSArray *messages;

+ (PBSMSTextHelper *)sharedHelper;

- (void)loadMessages;
- (void)saveMessages;
- (void)saveMessageToSend:(PBSMSTextMessage *)message;
- (void)removeMessage:(PBSMSTextMessage *)removedMessage;

@end