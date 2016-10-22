//
//  NoteTitleCommand.m
//  Peer
//
//  Created by Anson Liu on 9/28/16.
//  Copyright © 2016 Anson Liu. All rights reserved.
//

#import "NoteInfoCommand.h"

@implementation NoteInfoCommand

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _noteIdentifier = [decoder decodeObjectForKey:@"noteIdentifier"];
    _noteTitle = [decoder decodeObjectForKey:@"noteTitle"];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:_noteIdentifier forKey:@"noteIdentifier"];
    [encoder encodeObject:_noteTitle forKey:@"noteTitle"];
}

@end
