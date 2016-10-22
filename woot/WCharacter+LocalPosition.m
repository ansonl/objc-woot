//
//  WCharacter+LocalPosition.m
//  Peer
//
//  Created by Anson Liu on 9/22/16.
//  Copyright © 2016 Anson Liu. All rights reserved.
//

#import "WCharacter+LocalPosition.h"
#import <objc/runtime.h>

@implementation WCharacter (LocalPosition)
@dynamic localPosition;

- (void)setLocalPosition:(NSInteger)localPosition {
    objc_setAssociatedObject(self, @selector(localPosition), @(localPosition), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)localPosition {
    return [objc_getAssociatedObject(self, @selector(localPosition)) integerValue];
}

@end
