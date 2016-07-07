#import "PBSMSTextHelper.h"

#import "PBSMSHelper.h"
#import "PBSMSTextMessage.h"

@interface PBSMSTextHelper ()

@property (nonatomic, strong) NSMutableArray *mutableMessages;

@end

@implementation PBSMSTextHelper

+ (id)sharedHelper {
    static PBSMSTextHelper *sharedTextHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedTextHelper = [[self alloc] init];
    });
    return sharedTextHelper;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _mutableMessages = [NSMutableArray array];
    }
    return self;
}

- (NSArray *)presets
{
    log(@"presets %@", _presets);
    if (_presets.count == 0)
    {
        _presets = @[ @"OK", 
            @"Yes", 
            @"No", 
            @"Call me", 
            @"Call you later", 
            @"Thank you", 
            @"See you soon", 
            @"Running late", 
            @"On my way", 
            @"Busy right now - give me a second?" ];
    }

    return _presets;
}

- (NSArray *)messages
{
    return [self.mutableMessages copy];
}

- (void)loadMessages
{
    log(@"loadMessages");
    NSArray *arr = [NSArray arrayWithContentsOfFile:messagesFileLocation];

    if (!arr)
    {
        return;
    }

    [self.mutableMessages removeAllObjects];
    for (id object in arr)
    {
        PBSMSTextMessage *textMessage = [PBSMSTextMessage deserializeFromObject:object];
        if (textMessage && !textMessage.isExpired)
        {
            [self.mutableMessages addObject:textMessage];
        }
    }
}

- (void)saveMessages
{
    log(@"saveMessages");
    NSMutableArray *serializedMessages = [NSMutableArray array];

    for (PBSMSTextMessage *message in self.mutableMessages)
    {
        [serializedMessages addObject:[message serializeToDictionary]];
    }

    [serializedMessages writeToFile:messagesFileLocation atomically:YES];
}

- (void)saveMessageToSend:(PBSMSTextMessage *)message
{
    [self loadMessages];

    [self.mutableMessages addObject:message];

    [self saveMessages];
}

- (void)removeMessage:(PBSMSTextMessage *)removedMessage
{
    log(@"removeMessage %@", removedMessage);

    for (PBSMSTextMessage *message in self.mutableMessages)
    {
        if (![message.uuid isEqualToString:removedMessage.uuid])
        {
            [self.mutableMessages removeObject:message];
        }
    }

    [self saveMessages];
}

@end