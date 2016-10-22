//
//  NoteTitleCommand.h
//  Peer
//
//  Created by Anson Liu on 9/28/16.
//  Copyright © 2016 Anson Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoteInfoCommand : NSObject <NSCoding>

@property (nonatomic) NSString *noteIdentifier;
@property (nonatomic) NSString *noteTitle;

@end
