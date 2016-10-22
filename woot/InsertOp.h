//
//  InsertOp.h
//  Peer
//
//  Created by Anson Liu on 9/24/16.
//  Copyright © 2016 Anson Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GenericOperation.h"

@class WCharacter;

@interface InsertOp : GenericOperation <NSCoding>

@property (nonatomic) WCharacter *previousCharacter;
@property (nonatomic) WCharacter *nextCharacter;

@end
