//
//  WString+InsertNSString.h
//  Peer
//
//  Created by Anson Liu on 10/5/16.
//  Copyright © 2016 Anson Liu. All rights reserved.
//

#import "WString.h"

@interface WString (InsertNSString)

- (void)insertString:(NSString *)string atPosition:(NSInteger)pos;

@end
