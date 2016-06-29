#import "PBSMSTextHelper.h"

#import "PBSMSHelper.h"
#import "PBSMSTextMessage.h"

@interface PBSMSTextHelper ()

@property (nonatomic, strong) NSArray *messages;

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

- (NSArray *)presets
{
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

- (void)loadMessages
{
	log(@"loadMessages");
    NSArray *arr = [NSArray arrayWithContentsOfFile:messagesFileLocation];

    NSMutableArray *finalMessages = [[NSMutableArray alloc] init];
    for (id object in arr)
    {
    	PBSMSTextMessage *textMessage = [PBSMSTextMessage deserializeFromObject:object];
        if (textMessage.isExpired)
		{
            removeMessageAfterSending(uuid);
            return;
        }
    	if (textMessage)
    	{
    		[finalMessages addObject:textMessage];
    	}
    }

    self.messages = [finalMessages copy];
}

- (void)saveMessages
{
	log(@"saveMessages");
	NSArray *messages = self.messages;
	NSArray *serializedMessages = [NSMutableArray array];

	for (PBSMSTextMessage *message in messages)
	{
		[serializedMessages addObject:[message serializeToDictionary]];
	}

    [serializedMessages writeToFile:messagesFileLocation];
}

- (void)saveMessageToSend:(PBSMSTextMessage *)message
{
	[self loadMessages];

	NSMutableArray *messages = [NSMutableArray arrayWithArray:self.messages];
	[messages addObject:message];

	self.messages = [messages copy]
}

- (void)messageWasSent:(PBSMSTextMessage *)sentMessage
{
	log(@"messageWasSent %@", sentMessage);
	NSArray *messages = self.messages;

	NSMutableArray *messagesToKeep = [NSMutableArray array];
	for (PBSMSTextMessage *message in messages)
	{
		if (![message.uuid isEqualToString:sentMessage.uuid])
		{
			[messagesToKeep addObject:message];
		}
	}

	self.messages = [messagesToKeep copy];

	[self saveMessages];
}

@end