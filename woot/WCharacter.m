//
//  WCharacter.m
//  Peer
//
//  Created by Anson Liu on 9/22/16.
//  Copyright © 2016 Anson Liu. All rights reserved.
//

#import "WCharacter.h"

#import "WIdentifier.h"

@implementation WCharacter

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _identifier = [decoder decodeObjectForKey:@"identifier"];
    _alpha = [decoder decodeDataObject];
    _visible = [decoder decodeBoolForKey:@"visible"];
    _previousIdentifier = [decoder decodeObjectForKey:@"previousIdentifier"];
    _nextIdentifier = [decoder decodeObjectForKey:@"nextIdentifier"];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:_identifier forKey:@"identifier"];
    [encoder encodeDataObject:_alpha];
    [encoder encodeBool:_visible forKey:@"visible"];
    [encoder encodeObject:_previousIdentifier forKey:@"previousIdentifier"];
    [encoder encodeObject:_nextIdentifier forKey:@"nextIdentifier"];
}

- (BOOL)isEqualToWCharacter:(WCharacter *)character {
    if (!character)
        return NO;
    
    BOOL identifierEqual = [_identifier isEqual:character.identifier];
    
    return identifierEqual;
}

- (BOOL)isEqual:(id)object {
    //NSLog(@"isequal from %@", self);
    
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[WCharacter class]]) {
        return NO;
    }
    
    return [self isEqualToWCharacter:(WCharacter *)object];
}

- (NSUInteger)hash {
    //NSLog(@"hash from %@", self);
    
    NSUInteger hash = 0;
    hash = [_identifier hash];
    return hash;
}

@end
