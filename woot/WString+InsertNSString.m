//
//  WString+InsertNSString.m
//  Peer
//
//  Created by Anson Liu on 10/5/16.
//  Copyright © 2016 Anson Liu. All rights reserved.
//

#import "WString+InsertNSString.h"

#import "InsertOp.h"

@implementation WString (InsertNSString)

- (void)insertString:(NSString *)string atPosition:(NSInteger)pos {
    for (NSInteger i = 0; i < string.length; i++) {
        [self generateInsAtPosition:i forAlpha:[string characterAtIndex:i]];
    }
}


@end
