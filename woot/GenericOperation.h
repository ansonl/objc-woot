//
//  GenericOperation.h
//  Peer
//
//  Created by Anson Liu on 9/25/16.
//  Copyright © 2016 Anson Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WCharacter;

@interface GenericOperation : NSObject <NSCoding>

@property (nonatomic) WCharacter *targetCharacter;

@end
