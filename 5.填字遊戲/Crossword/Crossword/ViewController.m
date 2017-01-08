//
//  ViewController.m
//  Crossword
//
//  Created by Mac on 13/9/30.
//  Copyright (c) 2013年 KKBOX. All rights reserved.
//

#import "ViewController.h"
#import "MKCrosswordView.h"

@interface ViewController () <MKCrosswordViewDelegate, UITextFieldDelegate> {
    MKPoint editPoint;
    CGFloat moveOffset;
    CGFloat keyboardTop;
}

@property (strong, nonatomic) MKCrosswordView *mkCrosswordView;
@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;
@property (strong, nonatomic) UITextField *gridTextField;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.mkCrosswordView];
    [self.view addSubview:self.gridTextField];
    [self.mkCrosswordView addGestureRecognizer:self.tapGestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    keyboardTop = keyboardRect.origin.y;
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [self _moveDown];
}

- (void)_moveUp
{
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGRect aFrame = self.view.frame;
                         aFrame.origin.y -= moveOffset;
                         self.view.frame = aFrame;
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                         }
                     }];
}

- (void)_moveDown
{
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGRect aFrame = self.view.frame;
                         aFrame.origin.y += moveOffset;
                         self.view.frame = aFrame;
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             moveOffset = 0.0;
                         }
                     }];
}

#pragma mark - MKCrosswordViewDelegate

- (void)MKCrosswordView:(MKCrosswordView *)MKCrosswordView tapInGridPoint:(MKPoint)gridPoint andWord:(NSString *)word
{
    self.gridTextField.hidden = NO;
    self.gridTextField.text = word;
    [self.gridTextField becomeFirstResponder];
    editPoint = gridPoint;
    
    self.gridTextField.frame = CGRectMake(gridPoint.x * girdWidth + 20, gridPoint.y * gridHeight + 20, girdWidth, gridHeight);
    
    // 畫面移動
    CGFloat editGridBottom = self.gridTextField.frame.origin.y + gridHeight;
            
    if (editGridBottom > keyboardTop && self.view.frame.origin.y == 0) {
        moveOffset = editGridBottom - keyboardTop;
        [self _moveUp];
    }
    else if (editGridBottom < keyboardTop && self.view.frame.origin.y < 0 ){
        [self _moveDown];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    self.gridTextField.hidden = YES;
    
    [self.mkCrosswordView changWord:textField.text InGridPoint:editPoint];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    self.gridTextField.text = @"";
    
    return YES;
}

#pragma mark - lazy instantiation

- (MKCrosswordView *)mkCrosswordView
{
    if (!_mkCrosswordView) {
        _mkCrosswordView = [[MKCrosswordView alloc] initWithFrame:self.view.frame];
        _mkCrosswordView.backgroundColor = [UIColor whiteColor];
        _mkCrosswordView.delegate = self;
    }
    
    return _mkCrosswordView;
}

- (UITapGestureRecognizer *)tapGestureRecognizer
{
    if (!_tapGestureRecognizer) {
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.mkCrosswordView action:@selector(handleTap:)];
    }
    
    return _tapGestureRecognizer;
}

- (UITextField *)gridTextField
{
    if (!_gridTextField) {
        _gridTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 20, girdWidth, gridHeight)];
        [_gridTextField setBackgroundColor:[UIColor blackColor]];
        [_gridTextField setTextColor:[UIColor whiteColor]];
        [_gridTextField setFont:[UIFont boldSystemFontOfSize:20]];
        [_gridTextField setReturnKeyType:UIReturnKeyDone]; 
        _gridTextField.delegate = self;
        _gridTextField.hidden = YES;
    }
    
    return _gridTextField;
}

@end
