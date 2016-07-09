

@interface PBSMSPerformedActionsHelper : NSObject

@property (nonatomic, copy) NSArray *performedActions;

+ (PBSMSPerformedActionsHelper *)sharedHelper;

@end