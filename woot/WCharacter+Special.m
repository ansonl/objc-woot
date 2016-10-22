//
//  WCharacter+Special.m
//  Peer
//
//  Created by Anson Liu on 9/24/16.
//  Copyright © 2016 Anson Liu. All rights reserved.
//

#import "WCharacter+Special.h"
#import <objc/runtime.h>

@implementation WCharacter (Special)

- (void)setSpecial:(BOOL)special {
    objc_setAssociatedObject(self, @selector(special), @(special), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)special {
    return [objc_getAssociatedObject(self, @selector(special)) integerValue];
}

@end
