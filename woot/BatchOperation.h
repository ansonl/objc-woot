//
//  BatchOperation.h
//  Peer
//
//  Created by Anson Liu on 9/28/16.
//  Copyright © 2016 Anson Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GenericOperation;
@interface BatchOperation : NSObject <NSCoding>

@property (nonatomic) NSArray<GenericOperation *> *opArray;

@end
