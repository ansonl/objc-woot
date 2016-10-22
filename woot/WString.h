//
//  WString.h
//  Peer
//
//  Created by Anson Liu on 9/22/16.
//  Copyright © 2016 Anson Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WCharacter;
@class GenericOperation;
@class InsertOp;
@class DelOp;

@interface WString : NSObject

- (NSInteger)sizeOfSequence;
- (WCharacter *)elementAtPosition:(NSInteger)position;
- (NSInteger)posElement:(WCharacter *)element;
- (void)insertElement:(WCharacter *)element atPosition:(NSInteger)position;
- (NSArray<WCharacter *> *)subseqBetweenElement:(WCharacter *)element andElement:(WCharacter *)element;
- (BOOL)containsElement:(WCharacter *)element;

- (NSString *)visibleValue;
- (WCharacter *)ithVisible:(NSInteger)i;
- (NSInteger)posVisibleElement:(WCharacter *)element;

- (BOOL)isExecutable:(GenericOperation *)op;

- (InsertOp *)generateInsAtPosition:(NSInteger)position forAlpha:(unichar)alpha;
- (void)integrateInsOp:(InsertOp *)op;
- (void)integrateInsForWCharacter:(WCharacter *)character withPreviousWCharacter:(WCharacter *)previous withNextWCharacter:(WCharacter *)next;

- (DelOp *)generateDelAtPosition:(NSInteger)position;
- (void)integrateDelOp:(DelOp *)op;
- (void)integrateDelForWCharacter:(WCharacter *)character;

- (void)restoreStateWithElementStateArray:(NSArray<WCharacter *> *)array;
- (NSArray<WCharacter *> *)allElementsStateArray;
- (NSArray<GenericOperation *> *)allElementsOpArray;

@end
