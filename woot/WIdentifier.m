//
//  WId.m
//  Peer
//
//  Created by Anson Liu on 9/22/16.
//  Copyright © 2016 Anson Liu. All rights reserved.
//

#import "WIdentifier.h"

@implementation WIdentifier

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _site = [[decoder decodeObjectForKey:@"site"] integerValue];
    _clock = [[decoder decodeObjectForKey:@"clock"] integerValue];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:[NSNumber numberWithInteger:_site] forKey:@"site"];
    [encoder encodeObject:[NSNumber numberWithInteger:_clock] forKey:@"clock"];
}

- (BOOL)isEqualToWIdentifier:(WIdentifier *)identifier {
    if (!identifier)
        return NO;
    
    BOOL siteEqual = _site == identifier.site;
    BOOL clockEqual = _clock == identifier.clock;
    
    //NSLog(@"site %ld %ld clock %ld %ld", (long)_site, (long)identifier.site, (long)_clock, (long)identifier.clock);
    
    return siteEqual && clockEqual;
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    
    if (![object isKindOfClass:[WIdentifier class]]) {
        return NO;
    }
    
    return [self isEqualToWIdentifier:(WIdentifier *)object];
}

- (NSComparisonResult)compare:(WIdentifier *)identifier {
    if (self.site < identifier.site) {
        return NSOrderedAscending; //-1
    } else if (self.site > identifier.site) {
        return NSOrderedDescending;
    } else {
        if (self.clock < identifier.clock)
            return NSOrderedAscending;
        else
            return NSOrderedDescending;
    }
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = (NSUInteger)(_site + (_clock << 8));
    return hash;
}

- (NSString *)hashString {
    NSString *hash = [NSString stringWithFormat:@"site:%ldclock:%ld", (long)_site, (long)_clock];
    return hash;
}

@end
