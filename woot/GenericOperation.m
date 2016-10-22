//
//  GenericOperation.m
//  Peer
//
//  Created by Anson Liu on 9/25/16.
//  Copyright © 2016 Anson Liu. All rights reserved.
//

#import "GenericOperation.h"

@implementation GenericOperation

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _targetCharacter = [decoder decodeObjectForKey:@"targetCharacter"];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:_targetCharacter forKey:@"targetCharacter"];
    
}

@end
