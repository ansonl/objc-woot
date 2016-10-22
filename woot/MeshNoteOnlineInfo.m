//
//  MeshNoteOnlineInfo.m
//  Peer
//
//  Created by Anson Liu on 10/4/16.
//  Copyright © 2016 Anson Liu. All rights reserved.
//

#import "MeshNoteOnlineInfo.h"

#import "Constants.h"
#import "MeshNoteSession.h"
#import "WString.h"
#import "GenericOperation.h"
#import "InsertOp.h"
#import "DelOp.h"
#import "BatchOperation.h"

@implementation MeshNoteOnlineInfo

- (instancetype)init {
    self = [super init];
    if (!self)
        return nil;
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _noteIdentifier = [decoder decodeObjectForKey:@"noteIdentifier"];
    _noteTitle = [decoder decodeObjectForKey:@"noteTitle"];
    _hasPassword = [decoder decodeBoolForKey:@"hasPassword"];
    _passwordDigest = [decoder decodeObjectForKey:@"passwordDigest"];
    _enteredPassword = [decoder decodeObjectForKey:@"enteredPassword"];
    _batchOperation = [decoder decodeObjectForKey:@"batchOperation"];
    _implementationType = [decoder decodeObjectForKey:@"implementationType"];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:_noteIdentifier forKey:@"noteIdentifier"];
    [encoder encodeObject:_noteTitle forKey:@"noteTitle"];
    [encoder encodeBool:_hasPassword forKey:@"hasPassword"];
    [encoder encodeObject:_passwordDigest forKey:@"passwordDigest"];
    [encoder encodeObject:_enteredPassword forKey:@"enteredPassword"];
    [encoder encodeObject:_batchOperation forKey:@"batchOperation"];
    [encoder encodeObject:_implementationType forKey:@"implementationType"];
}

- (MeshNoteSession *)getMeshNoteSession {
    MeshNoteSession *meshNoteSession = [[MeshNoteSession alloc] init];
    meshNoteSession.noteIdentifier = _noteIdentifier;
    meshNoteSession.noteTitle = _noteTitle;
    meshNoteSession.hasPassword = _hasPassword;
    meshNoteSession.passwordDigest = _passwordDigest;
    meshNoteSession.enteredPassword = _enteredPassword;
    meshNoteSession.implementationType = _implementationType;
    
    return meshNoteSession;
}

//Apply operations without using an actual Pool to hold nonexecutable ops. Should move this to a category for WString.
- (void)updateMeshNoteSessionStateWithOps:(MeshNoteSession *)meshNoteSession {
    WString *tmp = [[WString alloc] init];
    //Restore element state from current meshnotesession if needed
    if (meshNoteSession.wCharacterStateArray)
        [tmp restoreStateWithElementStateArray:meshNoteSession.wCharacterStateArray];
    
    //Loop through pool until no more new operations can be executed
    NSInteger poolCountOne = _batchOperation.opArray.count;
    NSInteger poolCountTwo = _batchOperation.opArray.count + 1;
    while (poolCountOne != poolCountTwo) {
        poolCountTwo = poolCountOne;
        poolCountOne = 0;
        for (GenericOperation *op in _batchOperation.opArray) {
            if ([op isKindOfClass:[InsertOp class]] && [tmp containsElement:op.targetCharacter]) {
            } else if ([tmp isExecutable:op]) {
                if ([op isKindOfClass:[InsertOp class]]) {
                    [tmp integrateInsOp:(InsertOp *)op];
                } else if ([op isKindOfClass:[DelOp class]]) {
                    [tmp integrateDelOp:(DelOp *)op];
                }
            } else {
                poolCountOne++;
            }
        }
    }
    
    meshNoteSession.wCharacterStateArray = tmp.allElementsStateArray;
}

+ (NSString *)generateFilenameForMeshNoteOnlineInfo:(MeshNoteOnlineInfo *)meshNoteOnlineInfo {
    return [NSString stringWithFormat:@"%@-%@.%@",meshNoteOnlineInfo.noteTitle, meshNoteOnlineInfo.noteIdentifier, kMeshNoteSessionExtension];
}

@end
