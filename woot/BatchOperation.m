//
//  BatchOperation.m
//  Peer
//
//  Created by Anson Liu on 9/28/16.
//  Copyright © 2016 Anson Liu. All rights reserved.
//

#import "BatchOperation.h"

@implementation BatchOperation

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _opArray = [decoder decodeObjectForKey:@"opArray"];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:_opArray forKey:@"opArray"];
}

@end
