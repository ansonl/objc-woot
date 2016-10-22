//
//  WCharacter.h
//  Peer
//
//  Created by Anson Liu on 9/22/16.
//  Copyright © 2016 Anson Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WIdentifier;

@interface WCharacter : NSObject <NSCoding>

@property (strong, nonatomic) WIdentifier *identifier;
@property (strong, nonatomic) NSData *alpha;
@property (nonatomic) BOOL visible;
@property (strong, nonatomic) WIdentifier *previousIdentifier;
@property (strong, nonatomic) WIdentifier *nextIdentifier;

@end
