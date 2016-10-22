//
//  MeshNoteSession.h
//  Peer
//
//  Created by Anson Liu on 9/28/16.
//  Copyright © 2016 Anson Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@import MultipeerConnectivity;

@class WCharacter;
@class MeshNoteOnlineInfo;

@interface MeshNoteSession : NSObject

@property (nonatomic) MCSession *session;
@property (nonatomic) NSString *noteIdentifier;
@property (nonatomic) BOOL infoSet;
@property (nonatomic) NSString *noteTitle;

@property (nonatomic) NSString *notePreview;

@property (nonatomic) BOOL hasPassword;
@property (nonatomic) NSString *passwordDigest;
@property (nonatomic) NSString *enteredPassword;

@property (nonatomic) NSArray<WCharacter *> *wCharacterStateArray;

@property (nonatomic) BOOL autosave;
@property (nonatomic) NSString *implementationType;

- (MeshNoteOnlineInfo *)getMeshNoteOnlineInfo;
- (NSString *)generateVisibleFromStateArray;
- (void)generatePreviewForSession;
+ (NSString *)generateFilenameForMeshNoteSession:(MeshNoteSession *)meshNoteSession;
@end
