#import <Foundation/Foundation.h>

@class GenericOperation;

@protocol WOOTOpBroadcastDelegateProtocol <NSObject>

- (void)broadcastOp:(GenericOperation *)op;

@end
