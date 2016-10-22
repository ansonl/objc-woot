//
//  WString.m
//  Peer
//
//  Created by Anson Liu on 9/22/16.
//  Copyright © 2016 Anson Liu. All rights reserved.
//

#import "WString.h"

#import "WIdentifier.h"

#import "WCharacter.h"
#import "WCharacter+LocalPosition.h"
#import "WCharacter+Special.h"

#import "InsertOp.h"
#import "DelOp.h"

@interface WString ()


//@property (nonatomic) NSMutableArray<WCharacter *> *orderedVisibleSeq;


@property (nonatomic) NSMutableArray<WCharacter *> *orderedSeq;
@property (nonatomic) NSRecursiveLock *orderedSeqLock; //Recursive lock used because restoreStateFromCharArray calls insertElementatPosition and both methods acquire locks

@property (nonatomic) NSMutableDictionary *charByIdDict;
@property (nonatomic) NSRecursiveLock *charByIdDictLock;
    
@property (nonatomic) NSInteger site;
@property (nonatomic) NSInteger clock;

@property (nonatomic) WCharacter *beginning;
@property (nonatomic) WCharacter *ending;

@end

@implementation WString

BOOL optimization = NO;

- (instancetype)init {
    self = [super init];
    if (self) {
        _orderedSeqLock = [[NSRecursiveLock alloc] init];
        _orderedSeq = [[NSMutableArray alloc] init];
        
        //_orderedVisibleSeq = [[NSMutableArray alloc] init];
        
        
        WIdentifier *beginningId = [[WIdentifier alloc] init];
        beginningId.clock = -1;
        WIdentifier *endingId = [[WIdentifier alloc] init];
        endingId.clock = -2;
        
        _beginning = [[WCharacter alloc] init];
        _beginning.special = YES;
        _beginning.identifier = beginningId;
        
        _ending = [[WCharacter alloc] init];
        _ending.special = YES;
        _ending.identifier = endingId;
        
        //Load beginning and ending characters
        [_orderedSeqLock lock];
        [_orderedSeq addObject:_beginning];
        [_orderedSeq addObject:_ending];
        [_orderedSeqLock unlock];
        
        if (optimization) {
            _charByIdDictLock = [[NSRecursiveLock alloc] init];
            _charByIdDict = [[NSMutableDictionary alloc] init];
            
            //Load beginning and ending characters
            [_charByIdDictLock lock];
            [_charByIdDict setObject:_beginning forKey:_beginning.identifier.hashString];
            [_charByIdDict setObject:_ending forKey:_ending.identifier.hashString];
            [_charByIdDictLock unlock];
        }
        
        _site = arc4random_uniform(INT32_MAX);
        _clock = 0;
    }
    return self;
}

- (NSInteger)sizeOfSequence {
    [_orderedSeqLock lock];
    NSInteger seqCount = [_orderedSeq count];
    [_orderedSeqLock unlock];
    return seqCount;
}

- (WCharacter *)elementAtPosition:(NSInteger)position {
    [_orderedSeqLock lock];
    WCharacter *element = _orderedSeq[position];
    [_orderedSeqLock unlock];
    return element;
}

- (NSInteger)posElement:(WCharacter *)element {
    [_orderedSeqLock lock];
    NSArray *tmp = [NSArray arrayWithArray:_orderedSeq];
    [_orderedSeqLock unlock];
    return [tmp indexOfObject:element];
}

- (void)insertElement:(WCharacter *)element atPosition:(NSInteger)position {
    [_orderedSeqLock lock];
    if (position < [_orderedSeq count]) {
        [_orderedSeq insertObject:element atIndex:position];
    } else {
        NSAssert(NO, @"orderedSequence array not big enough.");
        /*
        do {
            [_orderedSeq addObject:[[WCharacter alloc] init]];
        } while (!(position < [_orderedSeq count]));
         */
    }
    [_orderedSeqLock unlock];
    /*
    if (element.visible && element.localPosition < [_orderedVisibleSeq count]) {
        [_orderedVisibleSeq insertObject:element atIndex:element.localPosition];
    } else if (element.localPosition == [_orderedVisibleSeq count]) { //just at the end of array so add new object
        [_orderedVisibleSeq addObject:element];
    } else {
        NSAssert(NO, @"orderedVisibleSequence array not big enough.");
    }
     */
    
    //[_charById setObject:element forKey:[NSNumber numberWithInteger:[element.identifier hash]]];
    
    if (optimization) {
        [_charByIdDictLock lock];
        [_charByIdDict setObject:element forKey:element.identifier.hashString];
        [_charByIdDictLock unlock];
    }
}

- (NSArray<WCharacter *> *)subseqBetweenElement:(WCharacter *)elementStart andElement:(WCharacter *)elementEnd {
    NSInteger startElementPos = [self posElement:elementStart];
    NSInteger endElementPos = [self posElement:elementEnd];
    
    //NSLog(@"mark %ld %ld", (long)startElementPos, (long)endElementPos);
    
    [_orderedSeqLock lock];
    NSArray *tmp = [NSArray arrayWithArray:_orderedSeq];
    [_orderedSeqLock unlock];
    return [tmp subarrayWithRange:NSMakeRange(startElementPos+1, endElementPos-startElementPos-1)];
}

- (BOOL)containsElement:(WCharacter *)element {
    if (optimization) {
        [_charByIdDictLock lock];
        BOOL elementExists = [_charByIdDict valueForKey:element.identifier.hashString] != nil;
        [_charByIdDictLock unlock];
        return elementExists;
    }
    
    [_orderedSeqLock lock];
    NSArray *tmp = [NSArray arrayWithArray:_orderedSeq];
    [_orderedSeqLock unlock];
    return [tmp containsObject:element];
    //return [[_charById allKeys] containsObject:[NSNumber numberWithInteger:[element.identifier hash]]];
}

# pragma mark - User string link methods

- (NSString *)visibleValue {
    NSMutableString *output = [NSMutableString string];
    [_orderedSeqLock lock];
    for (NSInteger i = 0; i < [_orderedSeq count]; i++) {
        if (!_orderedSeq[i].visible)
            continue;
        unichar *saved = (unichar*)_orderedSeq[i].alpha.bytes;
        NSString *tmp = [NSString stringWithFormat:@"%C", *saved];
        [output appendString:tmp];
    }
    [_orderedSeqLock unlock];
    return output;
}
    
- (WCharacter *)ithVisible:(NSInteger)i {
    [_orderedSeqLock lock];
    NSArray<WCharacter *> *tmp = [NSArray arrayWithArray:_orderedSeq];
    [_orderedSeqLock unlock];
    
    i += 1;
    NSInteger searchPos = 0;
    while (searchPos < [tmp count]) {
        if (tmp[searchPos].visible) {
            i -= 1;
        }
        
        if (i == 0) {
            return tmp[searchPos];
        }
        
        searchPos++;
    }
    
    NSLog(@"looked for ith visible that is out of range");
    return nil;
    /*
    return _orderedVisibleSeq[i];
     */
}

//If element is no visible, the position (index) of the previous visible element or highest visible index, if not found, is returned.
- (NSInteger)posVisibleElement:(WCharacter *)element {
    [_orderedSeqLock lock];
    
    NSInteger visibleCount = -1;
    for (NSInteger i = 0; i < [_orderedSeq count]; i++) {
        if ([_orderedSeq[i] isEqual:element] && _orderedSeq[i].visible) {
            visibleCount++;
            break;
        }
        if ([_orderedSeq[i] isEqual:element]) {
            break;
        }
        if (_orderedSeq[i].visible) {
            visibleCount++;
        }
    }
    
    [_orderedSeqLock unlock];
    return visibleCount;
}

- (NSInteger)visibleCharacterCount {
    [_orderedSeqLock lock];
    
    NSInteger count = 0;
    for (NSInteger i = 0; i < [_orderedSeq count]; i++) {
        if (!_orderedSeq[i].visible)
            continue;
        count++;
    }
    
    [_orderedSeqLock unlock];
    return count;
}

- (WCharacter *)characterForId:(WIdentifier *)identifier {
    if (optimization) {
        [_charByIdDictLock lock];
        WCharacter *element = [_charByIdDict valueForKey:identifier.hashString];
        [_charByIdDictLock unlock];
        if (!element)
            NSLog(@"Optimized - character for id not found");
        
        return element;
    }
    
    [_orderedSeqLock lock];
    for (WCharacter *element in _orderedSeq) {
        if ([element.identifier isEqual:identifier]) {
            [_orderedSeqLock unlock];
            return element;
        }
    }
    [_orderedSeqLock unlock];
    NSLog(@"character for id not found");
    return nil;
}

# pragma mark - Operation methods

- (BOOL)isExecutable:(GenericOperation *)op {
    if ([op isKindOfClass:[InsertOp class]]) {
        if ([self containsElement:op.targetCharacter]) {
            NSLog(@"Insert op, character already exists!");
            return NO;
        } /*else if ([self containsElement:_charById[[NSNumber numberWithInteger:[op.targetCharacter.previousIdentifier hash]]]] && [self containsElement:_charById[[NSNumber numberWithInteger:[op.targetCharacter.nextIdentifier hash]]]]){ //Check for existence of previous and next characters
            return YES;
        } */
         else if ([self characterForId:op.targetCharacter.previousIdentifier] && [self characterForId:op.targetCharacter.nextIdentifier]){ //Check for existence of previous and next characters
            return YES;
        } else {
            return NO;
        }
    } else if ([op isKindOfClass:[DelOp class]]) {
        if ([self containsElement:op.targetCharacter])
            return YES;
        else
            return NO;
    } else {
        NSLog(@"Unrecognized op class %@", op);
        return NO;
    }
}

- (InsertOp *)generateInsAtPosition:(NSInteger)position forAlpha:(unichar)alpha {
    _clock++;
    
    InsertOp *op = [[InsertOp alloc] init];
    if (position == 0) {
        op.previousCharacter = _beginning;
    } else {
        op.previousCharacter = [self ithVisible:position - 1];
    }
    
    //if (position == [_orderedVisibleSeq count])
    if (position == [self visibleCharacterCount])
        op.nextCharacter = _ending;
    else
        op.nextCharacter = [self ithVisible:position];
    
    WIdentifier *insertId = [[WIdentifier alloc] init];
    insertId.site = _site;
    insertId.clock = _clock;
    
    /*
    unichar tmp;
    if ([alpha length] > 0) {
        tmp = [alpha characterAtIndex:0];
    } else {
        NSLog(@"invalid gen ins for alpha %@", alpha);
        return nil; //don't continue or else we will just insert a null character
    }
     */
    
    WCharacter *insertChar = [[WCharacter alloc] init];
    insertChar.identifier = insertId;
    insertChar.alpha = [NSData dataWithBytes:&alpha length:sizeof(unichar)];
    insertChar.visible = YES;
    insertChar.previousIdentifier = op.previousCharacter.identifier;
    insertChar.nextIdentifier = op.nextCharacter.identifier;
    
    insertChar.localPosition = position;
    
    op.targetCharacter = insertChar;
    
    [self integrateInsOp:op];
    
    return op;
}

- (void)integrateInsOp:(InsertOp *)op {
    /*
    WCharacter *previousCharacter = _charById[[NSNumber numberWithInteger:[op.targetCharacter.previousIdentifier hash]]];
    WCharacter *nextCharacter = _charById[[NSNumber numberWithInteger:[op.targetCharacter.nextIdentifier hash]]];
     */
    WCharacter *previousCharacter = [self characterForId:op.targetCharacter.previousIdentifier];
    WCharacter *nextCharacter = [self characterForId:op.targetCharacter.nextIdentifier];
    
    [self integrateInsForWCharacter:op.targetCharacter withPreviousWCharacter:previousCharacter withNextWCharacter:nextCharacter];
}

- (void)integrateInsForWCharacter:(WCharacter *)character withPreviousWCharacter:(WCharacter *)previous withNextWCharacter:(WCharacter *)next {
    NSArray<WCharacter *> *subseqChar = [self subseqBetweenElement:previous andElement:next];
    
    if ([subseqChar count] == 0) {
        [self insertElement:character atPosition:[self posElement:next]];
        //[_charById setObject:character forKey:[NSNumber numberWithInteger:[character.identifier hash]]];
    } else {
        NSMutableArray<WCharacter *> *list = [[NSMutableArray alloc] init];
        [list addObject:previous];
        for (NSInteger i = 0; i < [subseqChar count]; i++) {
            //NSNumber *key = [NSNumber numberWithInteger:[subseqChar[i].previousIdentifier hash]];
            //WCharacter *thingPrevious = _charById[[NSNumber numberWithInteger:[subseqChar[i].previousIdentifier hash]]];
            
            /*
            BOOL listPrev = [self posElement:_charById[[NSNumber numberWithInteger:[subseqChar[i].previousIdentifier hash]]]] <= [self posElement:previous];
            BOOL listNext = [self posElement:next] <= [self posElement:_charById[[NSNumber numberWithInteger:[subseqChar[i].nextIdentifier hash]]]];
             */
            
            BOOL listPrev = [self posElement:[self characterForId:subseqChar[i].previousIdentifier]] <= [self posElement:previous];
            BOOL listNext = [self posElement:next] <= [self posElement:[self characterForId:subseqChar[i].nextIdentifier]];
            
            if (listPrev && listNext)
                [list addObject:subseqChar[i]];
        }
        [list addObject:next];
        
        NSInteger i = 1;
        while (i < [list count] - 1 && [list[i].identifier compare:character.identifier] == NSOrderedAscending) {
            i++;
        }
        [self integrateInsForWCharacter:character withPreviousWCharacter:list[i - 1] withNextWCharacter:list[i]];
    }
}

- (DelOp *)generateDelAtPosition:(NSInteger)position {
    WCharacter *target = [self ithVisible:position];
    
    DelOp *op = [[DelOp alloc] init];
    op.targetCharacter = target;
    
    [self integrateDelOp:op];
    
    return op;
}

- (void)integrateDelOp:(DelOp *)op {
    [self integrateDelForWCharacter:op.targetCharacter];
}

- (void)integrateDelForWCharacter:(WCharacter *)character {
    NSInteger pos = [self posElement:character];
    
    if (pos == NSNotFound) {
        NSLog(@"could not find");
    }
    
    [self elementAtPosition:pos].visible = NO;
    
    /*
    NSInteger positionInVisibleSequence = [_orderedVisibleSeq indexOfObject:character];
    if (positionInVisibleSequence != NSNotFound) {
        [_orderedVisibleSeq removeObjectAtIndex:positionInVisibleSequence];
        for (NSInteger i = positionInVisibleSequence; i < [_orderedVisibleSeq count]; i++) {
            [_orderedVisibleSeq objectAtIndex:i].localPosition--;
        }
    }
     */
}

# pragma mark - State management methods

- (void)restoreStateWithElementStateArray:(NSArray<WCharacter *> *)array {
    [_orderedSeqLock lock];
    [_charByIdDictLock lock];
    _orderedSeq = [[NSMutableArray alloc] init];
    _charByIdDict = [[NSMutableDictionary alloc] init];
    //Add blank object to the array so that insertElement method does not fail
    [_orderedSeq addObject:(WCharacter *)[[NSObject alloc] init]];
    
    for (NSInteger i = 0; i < array.count; i++)
        [self insertElement:array[i] atPosition:i];
    
    //remove the blank object we previously added now that the array is restored
    [_orderedSeq removeLastObject];
    
    //Alternative method without dictionary optimization
    //_orderedSeq = [NSMutableArray arrayWithArray:array];
    [_charByIdDictLock unlock];
    [_orderedSeqLock unlock];
}

- (NSArray<WCharacter *> *)allElementsStateArray {
    [_orderedSeqLock lock];
    NSArray<WCharacter *> *tmp = [NSArray arrayWithArray:_orderedSeq];
    [_orderedSeqLock unlock];
    return [NSArray arrayWithArray:tmp];
}

- (NSArray<GenericOperation *> *)allElementsOpArray {
    //CHANGE TO ONLY VISIBLE ELEMENT SINCE NEW ELEMENTS ONLY DEPEND ON VISIBLE ELEMENTS IN FUTURE
    //^problem with that is offline clients may make a change that depends on deleted (online) character and then a new peer will not have information on the now deleted character when the delayed insert that depends on deleted character arrives
    [_orderedSeqLock lock];
    NSArray<WCharacter *> *tmp = [NSArray arrayWithArray:_orderedSeq];
    [_orderedSeqLock unlock];
    
    NSMutableArray<GenericOperation *> *opArray = [[NSMutableArray alloc] initWithCapacity:[tmp count]];
    for (WCharacter * element in [self subseqBetweenElement:_beginning andElement:_ending]) {
        WCharacter *previousCharacter = [self characterForId:element.previousIdentifier];
        WCharacter *nextCharacter = [self characterForId:element.nextIdentifier];
        
        InsertOp *op = [[InsertOp alloc] init];
        op.targetCharacter = element;
        op.previousCharacter = previousCharacter;
        op.nextCharacter = nextCharacter;
        [opArray addObject:op];
        
        //Generate delete if the element is invisible, we must have deleted it in the past
        if (!element.visible) {
            DelOp *op2 = [[DelOp alloc] init];
            op2.targetCharacter = element;
            [opArray addObject:op2];
        }
        
        
    }
    return opArray;
}

@end
