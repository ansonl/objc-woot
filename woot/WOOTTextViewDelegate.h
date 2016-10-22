//
//  TextDelegate.h
//  Peer
//
//  Created by Anson Liu on 9/24/16.
//  Copyright © 2016 Anson Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WOOTOpBroadcastDelegateProtocol.h"

@class WString;
@class MeshNoteSession;
@class BatchOperation;

@interface WOOTTextViewDelegate : NSObject <UITextViewDelegate>

@property(nonatomic, weak) id <WOOTOpBroadcastDelegateProtocol> broadcastDelegate;
@property (nonatomic) WString *wStringInstance;
@property (nonatomic) UITextView *affectedTextView;

@property (nonatomic) MeshNoteSession *currentMeshNoteSession;

- (void)receiveBatchOp:(BatchOperation *)op;
//- (void)receiveOp:(GenericOperation *)op;
- (NSInteger)getPoolSize;
- (void)reloadTextView;

@end
