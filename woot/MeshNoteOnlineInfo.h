//
//  MeshNoteOnlineInfo.h
//  Peer
//
//  Created by Anson Liu on 10/4/16.
//  Copyright © 2016 Anson Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GenericOperation;
@class MeshNoteSession;
@class BatchOperation;

@interface MeshNoteOnlineInfo : NSObject

@property (nonatomic) NSString *noteIdentifier;
@property (nonatomic) NSString *noteTitle;

@property (nonatomic) BOOL hasPassword;
@property (nonatomic) NSString *passwordDigest;
@property (nonatomic) NSString *enteredPassword;

@property (nonatomic) BatchOperation *batchOperation;

@property (nonatomic) NSString *implementationType;

- (MeshNoteSession *)getMeshNoteSession;
- (void)updateMeshNoteSessionStateWithOps:(MeshNoteSession *)meshNoteSession;
+ (NSString *)generateFilenameForMeshNoteOnlineInfo:(MeshNoteOnlineInfo *)meshNoteOnlineInfo;

@end
