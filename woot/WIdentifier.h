//
//  WId.h
//  Peer
//
//  Created by Anson Liu on 9/22/16.
//  Copyright © 2016 Anson Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WIdentifier : NSObject <NSCoding>

@property (nonatomic) NSInteger site;
@property (nonatomic) NSInteger clock;

- (NSComparisonResult)compare:(WIdentifier *)identifier;
- (NSString *)hashString;
@end
