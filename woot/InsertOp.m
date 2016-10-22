//
//  InsertOp.m
//  Peer
//
//  Created by Anson Liu on 9/24/16.
//  Copyright © 2016 Anson Liu. All rights reserved.
//

#import "InsertOp.h"

@implementation InsertOp

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (!self) {
        return nil;
    }
    
    _previousCharacter = [decoder decodeObjectForKey:@"previousCharacter"];
    _nextCharacter = [decoder decodeObjectForKey:@"nextCharacter"];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder{
    [super encodeWithCoder:encoder];
    [encoder encodeObject:_previousCharacter forKey:@"previousCharacter"];
    [encoder encodeObject:_nextCharacter forKey:@"nextCharacter"];
}

@end
