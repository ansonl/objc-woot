//
//  TextDelegate.m
//  Peer
//
//  Created by Anson Liu on 9/24/16.
//  Copyright © 2016 Anson Liu. All rights reserved.
//

#import "WOOTTextViewDelegate.h"

#import "MeshNoteSession.h"

#import "WCharacter.h"
#import "WString.h"

#import "BatchOperation.h"

#import "GenericOperation.h"
#import "InsertOp.h"
#import "DelOp.h"

#import "Constants.h"
//#import "ReadWriteData.h"

@interface WOOTTextViewDelegate ()

@property (nonatomic) NSRange tmpRange;
@property (nonatomic) NSLock *batchOpLock;

@property (nonatomic) NSMutableArray<GenericOperation *> *opPool;
@property (nonatomic) NSLock *poolLock;

//@property (nonatomic) NSInteger deleteLastCharactersOnTextViewDidChange;

@end

@implementation WOOTTextViewDelegate

- (instancetype)init {
    self = [super init];
    if (self) {
        
        
         //For testing two local WString instances
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveBroadcast:)
                                                     name:@"Broadcast"
                                                   object:nil];
        
        
        _batchOpLock = [[NSLock alloc] init];
        _poolLock = [[NSLock alloc] init];
        
        _opPool = [[NSMutableArray alloc] init];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^(void) {
            while (1) {
                [_poolLock lock];
                /*
                NSMutableArray<GenericOperation *> *newPool = [[NSMutableArray alloc] init];
                for (GenericOperation *op in _opPool) {
                    if ([_wStringInstance isExecutable:op]) {
                        [self executeOp:op];
                    } else {
                        [newPool addObject:op];
                    }
                    sleep(0.1); //exec bad access if trying to execute too fast, locks issue?
                }
                
                if ([_opPool count] > 0)
                    NSLog(@"looped through oppool, %lu -> %lu", (unsigned long)[_opPool count], (unsigned long)[newPool count]);
                _opPool = [NSArray arrayWithArray:newPool];
                 */
                
                NSMutableArray *newPool = [[NSMutableArray alloc] init];
                for (GenericOperation *op in _opPool) {
                    if ([_wStringInstance isExecutable:op]) {
                        [self executeOp:op];
                    } else {
                        [newPool addObject:op];
                    }
                }
                if ([_opPool count] > 0)
                    NSLog(@"looped through opPool, %lu -> %lu", (unsigned long)[_opPool count], (unsigned long)[newPool count]);
                
                //Update the user interface textview if any operations were performed
                if ([_opPool count] != [newPool count])
                    [self updateTextView];
                
                _opPool = newPool;

                
                [_poolLock unlock];
                usleep(500000);
            }
        });
        
        /*
        //Auto save every 15 seconds
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^(void) {
            while (1) {
                if (_currentMeshNoteSession && _currentMeshNoteSession.autosave) {
                    _currentMeshNoteSession.wCharacterStateArray = [_wStringInstance allElementsStateArray];
                    [ReadWriteData saveFile:[NSKeyedArchiver archivedDataWithRootObject:_currentMeshNoteSession] withFilename:[MeshNoteSession generateFilenameForMeshNoteSession:_currentMeshNoteSession]];
                }
                sleep(5);
            }
        });
         */
        
    }
    return self;
}

- (NSInteger)getPoolSize {
    return _opPool.count;
}

- (void)sendBroadcastWithOperation:(GenericOperation *)op {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Broadcast" object:self userInfo:@{@"op":op}];
    NSLog(@"broadcast local integrate for string %@", _wStringInstance);

    //[_broadcastDelegate broadcastOp:op];
}

- (void)receiveBroadcast:(NSNotification *)notification {
    NSLog(@"receive local integrate for string %@", _wStringInstance);
    
    //Don't process broadcasts if the sender was self. Processing self's notification leads to the textview 'updating' before the textview actually receives the result of shouldChangeTextInRange and the last character being appended to textview text.
    if (notification.object == self)
        return;
    
    GenericOperation *op = [notification.userInfo objectForKey:@"op"];
    
    BatchOperation *batchOp = [[BatchOperation alloc] init];
    batchOp.opArray = @[op];
    [self receiveBatchOp:batchOp];
}

- (void)receiveBatchOp:(BatchOperation *)op {
    [_batchOpLock lock];
    
    _tmpRange = _affectedTextView.selectedRange;
    for (GenericOperation *subOp in op.opArray)
        [self receiveOp:(GenericOperation *)subOp];
    
    [self updateTextView];
    
    [_batchOpLock unlock];
}

- (void)receiveOp:(GenericOperation *)op {
    //Special case because isExecutable only return boolean value
    if ([op isKindOfClass:[InsertOp class]] && [_wStringInstance containsElement:op.targetCharacter]) {
        NSLog(@"character already exists! no action!!!");
        return;
    }
    
    
    if ([_wStringInstance isExecutable:op]) {
        [self executeOp:op];
    } else {
        NSLog(@"non executable op %@", op);
        [_poolLock lock];
        //_opPool = [_opPool arrayByAddingObject:op];
        [_opPool addObject:op];
        [_poolLock unlock];
    }
}

- (void)executeOp:(GenericOperation *)op {
    //NSRange tmpRange = _affectedTextView.selectedRange;

    NSLog(@"execute op %@", _wStringInstance);
    
    if ([op isKindOfClass:[InsertOp class]]) {
        //Only adjust textview selection if inserted position is before selection
        [_wStringInstance integrateInsOp:(InsertOp *)op];
        NSInteger posInserted = [_wStringInstance posVisibleElement:op.targetCharacter];
        if (posInserted <= _tmpRange.location)
            _tmpRange = NSMakeRange(_tmpRange.location + 1, _tmpRange.length);
    } else if ([op isKindOfClass:[DelOp class]]) {
        //Compute before integrating op for DelOp since character exists
        NSInteger posDeleted = [_wStringInstance posVisibleElement:op.targetCharacter];
        [_wStringInstance integrateDelOp:(DelOp *)op];
        if (posDeleted <= _tmpRange.location)
            _tmpRange = NSMakeRange(_tmpRange.location - 1, _tmpRange.length);
    } else {
        NSLog(@"Unrecognized op class %@", [_wStringInstance class]);
    }
    
    /*
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [_affectedTextView replaceRange:[_affectedTextView textRangeFromPosition:_affectedTextView.beginningOfDocument toPosition:_affectedTextView.endOfDocument] withText:[_wStringInstance visibleValue]];
        
        [_affectedTextView setSelectedRange:tmpRange];
    });
     */
}

- (void)updateTextView {
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [_affectedTextView replaceRange:[_affectedTextView textRangeFromPosition:_affectedTextView.beginningOfDocument toPosition:_affectedTextView.endOfDocument] withText:[_wStringInstance visibleValue]];
        NSLog(@"WString %@ visible: %@", _wStringInstance, [_wStringInstance visibleValue]);
        [_affectedTextView setSelectedRange:_tmpRange];
    });
}

- (void)reloadTextView {
    NSRange tmp = _affectedTextView.selectedRange;
    [_affectedTextView replaceRange:[_affectedTextView textRangeFromPosition:_affectedTextView.beginningOfDocument toPosition:_affectedTextView.endOfDocument] withText:[_wStringInstance visibleValue]];
    [_affectedTextView setSelectedRange:tmp];
}

#pragma mark - UITextViewDelegate methods

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    //NSLog(@"text in range %@ change replace with %@", NSStringFromRange(range), text);
    
    NSMutableArray<GenericOperation *> *opArray = [[NSMutableArray alloc] initWithCapacity:range.length];
    if (range.length == 0 && text.length == 0) {
        NSLog(@"no operation performed for zero range and zero text");
    } else if (text.length == 0) { //DELETE
        while (range.length > 0) {
            [opArray addObject:[_wStringInstance generateDelAtPosition:range.location + range.length - 1]];
            range.length -= 1;
        }
    } else if (range.length == 0) { //INSERT
        for (NSInteger i = 0; i < text.length; i++) {
            [opArray addObject:[_wStringInstance generateInsAtPosition:range.location+i forAlpha:[text characterAtIndex:i]]];
        }
    } else { //Autocorrect action occured, replace a non-zero range with non-zero text
        while (range.length > 0) {
            [opArray addObject:[_wStringInstance generateDelAtPosition:range.location + range.length - 1]];
            range.length -= 1;
        }
        for (NSInteger i = 0; i < text.length; i++) {
            [opArray addObject:[_wStringInstance generateInsAtPosition:range.location+i forAlpha:[text characterAtIndex:i]]];
        }
    }

    /*
    [textView replaceRange:[textView textRangeFromPosition:textView.beginningOfDocument toPosition:textView.endOfDocument] withText:[_wStringInstance visibleValue]];
    NSLog(@"saved last selected %@", NSStringFromRange(_lastSelectedRange));
    NSLog(@"set corrected textview range to %@", NSStringFromRange(NSMakeRange(_lastSelectedRange.location + pushIndex, 0)));
    [textView setSelectedRange:_lastSelectedRange];

    //The below is unneeded if our math is correct and we do not need to sync up the WString and textview text each time with = like above.
    //If the last operation was a DELETE, add a space for the UIKeyboard to delete.
    if (range.length != 0 && text.length == 0) {
       // textView.text = [NSString stringWithFormat:@"%@ ", textView.text];
    } else if (text.length > 0) { //If the last op was an insert, set the flag to the amount of characters to delete.
        //_deleteLastCharactersOnTextViewDidChange = text.length;
    }
     */
    
    for (GenericOperation *op in opArray)
        [self sendBroadcastWithOperation:op];
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    //NSLog(@"Actual visible: %@", textView.text);
    
    /*
    if (_deleteLastCharactersOnTextViewDidChange > 0) {
        textView.text = [textView.text substringToIndex:textView.text.length - _deleteLastCharactersOnTextViewDidChange];
        _deleteLastCharactersOnTextViewDidChange = 0;
    }
    */
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    //NSLog(@"textView selection changed to %@", textView.selectedTextRange);
    //_lastSelectedRange = textView.selectedRange;
}

@end
