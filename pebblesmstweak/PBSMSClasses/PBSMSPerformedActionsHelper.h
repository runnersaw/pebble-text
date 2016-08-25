

@interface PBSMSPerformedActionsHelper : NSObject

@property (nonatomic, copy) NSMutableArray *performedActions;

+ (PBSMSPerformedActionsHelper *)sharedHelper;

@end