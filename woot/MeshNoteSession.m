//
//  MeshNoteSession.m
//  Peer
//
//  Created by Anson Liu on 9/28/16.
//  Copyright © 2016 Anson Liu. All rights reserved.
//

#import "MeshNoteSession.h"

#import "Constants.h"
#import "WString.h"
#import "MeshNoteOnlineInfo.h"

@implementation MeshNoteSession

- (instancetype)init {
    self = [super init];
    if (!self)
        return nil;
    
    _noteIdentifier = [NSString stringWithFormat:@"%u%ld%u", arc4random_uniform(INT_MAX), (long)round([[NSDate date] timeIntervalSince1970]), arc4random_uniform(INT_MAX)];
    
    _autosave = YES;
    _implementationType = @"WOOT";
    
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _noteIdentifier = [decoder decodeObjectForKey:@"noteIdentifier"];
    _infoSet = [decoder decodeBoolForKey:@"infoSet"];
    _noteTitle = [decoder decodeObjectForKey:@"noteTitle"];
    _hasPassword = [decoder decodeBoolForKey:@"hasPassword"];
    _passwordDigest = [decoder decodeObjectForKey:@"passwordDigest"];
    _enteredPassword = [decoder decodeObjectForKey:@"enteredPassword"];
    _wCharacterStateArray = [decoder decodeObjectForKey:@"wCharacterStateArray"];
    _implementationType = [decoder decodeObjectForKey:@"implementationType"];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:_noteIdentifier forKey:@"noteIdentifier"];
    [encoder encodeBool:_infoSet forKey:@"infoSet"];
    [encoder encodeObject:_noteTitle forKey:@"noteTitle"];
    [encoder encodeBool:_hasPassword forKey:@"hasPassword"];
    [encoder encodeObject:_passwordDigest forKey:@"passwordDigest"];
    [encoder encodeObject:_enteredPassword forKey:@"enteredPassword"];
    [encoder encodeObject:_wCharacterStateArray forKey:@"wCharacterStateArray"];
    [encoder encodeObject:_implementationType forKey:@"implementationType"];
}


- (BOOL)isEqualToWIdentifier:(MeshNoteSession *)meshNoteSession {
    if (!meshNoteSession)
        return NO;
    
    return [self.noteIdentifier isEqual:meshNoteSession.noteIdentifier];
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[MeshNoteSession class]]) {
        return NO;
    }
    
    return [self isEqualToWIdentifier:(MeshNoteSession *)object];
}

- (MeshNoteOnlineInfo *)getMeshNoteOnlineInfo {
    MeshNoteOnlineInfo *onlineInfo = [[MeshNoteOnlineInfo alloc] init];
    onlineInfo.noteIdentifier = _noteIdentifier;
    onlineInfo.noteTitle = _noteTitle;
    onlineInfo.hasPassword = _hasPassword;
    onlineInfo.passwordDigest = _passwordDigest;
    onlineInfo.enteredPassword = _enteredPassword;
    onlineInfo.implementationType = _implementationType;
    
    //Supply operation array later
    return onlineInfo;
}

- (NSString *)generateVisibleFromStateArray {
    WString *tmp = [[WString alloc] init];
    //Restore element state from current meshnotesession if needed
    if (_wCharacterStateArray) {
        [tmp restoreStateWithElementStateArray:_wCharacterStateArray];
    }
    return tmp.visibleValue;
}

- (void)generatePreviewForSession {
    WString *tmp = [[WString alloc] init];
    //Restore element state from current meshnotesession if needed
    if (_wCharacterStateArray) {
        [tmp restoreStateWithElementStateArray:_wCharacterStateArray];
    }
    NSInteger previewLength = 100;
    _notePreview = [NSString stringWithFormat:@"%@%@", tmp.visibleValue.length > previewLength ? [tmp.visibleValue substringWithRange:NSMakeRange(0, previewLength-1)] : tmp.visibleValue, tmp.visibleValue.length > previewLength ? @"..." : @""];
}

+ (NSString *)generateFilenameForMeshNoteSession:(MeshNoteSession *)meshNoteSession {
    return [NSString stringWithFormat:@"%@-%@.%@",meshNoteSession.noteTitle, meshNoteSession.noteIdentifier, kMeshNoteSessionExtension];
}

@end
