//
//  MainViewController.m
//  Peer
//
//  Created by Anson Liu on 9/24/16.
//  Copyright © 2016 Anson Liu. All rights reserved.
//

#import "MainViewController.h"
#import "WOOTTextViewDelegate.h"
#import "WString.h"

@interface MainViewController ()

@property (nonatomic) WOOTTextViewDelegate *delegateOne;
@property (nonatomic) WOOTTextViewDelegate *delegateTwo;

@property (nonatomic) WString *wStringInstanceOne;
@property (nonatomic) WString *wStringInstanceTwo;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _wStringInstanceOne = [[WString alloc] init];
    _wStringInstanceTwo = [[WString alloc] init];
    
    _delegateOne = [[WOOTTextViewDelegate alloc] init];
    _delegateOne.wStringInstance = _wStringInstanceOne;
    _textViewOne.delegate = _delegateOne;
    _delegateOne.affectedTextView = _textViewOne;
    
    _delegateTwo = [[WOOTTextViewDelegate alloc] init];
    _delegateTwo.wStringInstance = _wStringInstanceTwo;
    _textViewTwo.delegate = _delegateTwo;
    _delegateTwo.affectedTextView = _textViewTwo;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
