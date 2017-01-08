//
//  ViewController.m
//  Snake
//
//  Created by JzChang on 13/9/20.
//  Copyright (c) 2013年 JzChang. All rights reserved.
//

#import "ViewController.h"
#import "MKSnakeView.h"
#import "MKSnakeModel.h"

@interface ViewController () <MKSnakeViewDataSource> {
    MKSnakeModel *snakeModel;
    NSTimer *refreshTimer;
}

@property (assign, nonatomic) MKSnakeView *snakeView;
@property (assign, nonatomic) UIButton *startButton;
@property (retain, nonatomic) UISwipeGestureRecognizer *swipeUp;
@property (retain, nonatomic) UISwipeGestureRecognizer *swipeDown;
@property (retain, nonatomic) UISwipeGestureRecognizer *swipeLeft;
@property (retain, nonatomic) UISwipeGestureRecognizer *swipeRight;

@end

@implementation ViewController

- (void)dealloc
{
    [refreshTimer invalidate];
    [snakeModel release];
    [_swipeUp release];
    [_swipeDown release];
    [_swipeLeft release];
    [_swipeRight release];
    [_snakeLengthLabel release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    self.view = self.snakeView;
    self.snakeView.dataSource = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.view addSubview:self.snakeLengthLabel];
    [self.view addSubview:self.startButton];
}

#pragma mark - function

- (void)startGame
{
    if (snakeModel) {
        [snakeModel release];
    }
    snakeModel = [[MKSnakeModel alloc] initWithMoveDirection:directionLeft withAreaWidth:24 andAreaHeight:16];
    [self.view setNeedsDisplay];
    
    self.startButton.hidden = YES;
    
    // 加入手勢
    [self.view addGestureRecognizer:self.swipeUp];
    [self.view addGestureRecognizer:self.swipeDown];
    [self.view addGestureRecognizer:self.swipeLeft];
    [self.view addGestureRecognizer:self.swipeRight];
    
    refreshTimer = [NSTimer scheduledTimerWithTimeInterval:0.3
                                               target:self
                                             selector:@selector(refreshGameView:)
                                             userInfo:nil
                                              repeats:YES];
}

- (void)endGame
{
    self.startButton.hidden = NO;
    
    if (self.snakeLengthLabel) {
        [self.snakeLengthLabel release];
    }
    
    // 移除手勢
    [self.view removeGestureRecognizer:self.swipeUp];
    [self.view removeGestureRecognizer:self.swipeDown];
    [self.view removeGestureRecognizer:self.swipeLeft];
    [self.view removeGestureRecognizer:self.swipeRight];
    
    [refreshTimer invalidate];
}

#pragma mark - protocol

- (NSArray *)snakePointsInSnakeView:(UIView *)sender
{
    // 取得蛇的身體節點座標
    return snakeModel.snakePoints;
}

- (MKPoint)fruitPointInSnakeView:(MKSnakeView *)inSnakeView
{
    // 取得水果的座標
    return snakeModel.fruitPoint;
}

#pragma mark - selector

- (void)tapStartGame:(UIButton *)sender
{
    [self startGame];
}

- (void)refreshGameView:(NSTimer *)timer
{
    [snakeModel moveSnake];
    
    if ([snakeModel isHeadHitSnakeBody]) {
        [self endGame];
    }
    
    if ([snakeModel isSnakeEatFruit]) {
        [snakeModel increaseSnakeBody];
        [snakeModel putFruit];
    }
    
    self.snakeLengthLabel.text = [NSString stringWithFormat:@"%d", snakeModel.snakePoints.count];
        
    [self.view setNeedsDisplay];
}

- (void)handleSwipeUp:(UISwipeGestureRecognizer *)gesture
{
    [snakeModel changeMoveDirection:directionUp];
}

- (void)handleSwipeDown:(UISwipeGestureRecognizer *)gesture
{
    [snakeModel changeMoveDirection:directionDown];
}

- (void)handleSwipeLeft:(UISwipeGestureRecognizer *)gesture
{
    [snakeModel changeMoveDirection:directionLeft];
}

- (void)handleSwipeRight:(UISwipeGestureRecognizer *)gesture
{
    [snakeModel changeMoveDirection:directionRight];
}

#pragma mark - lazy instantiation

- (MKSnakeView *)snakeView
{
    if (!_snakeView) {
        _snakeView = [[MKSnakeView alloc] init];
        _snakeView.backgroundColor = [UIColor whiteColor];
    }
    
    return _snakeView;
}

- (UIButton *)startButton
{
    if (!_startButton) {
        _startButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _startButton.frame = CGRectMake(0, 0, 100, 50);
        _startButton.center = CGPointMake(self.view.center.y, self.view.center.x);
        [_startButton setTitle:@"開 始" forState:UIControlStateNormal];
        [_startButton addTarget:self action:@selector(tapStartGame:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _startButton;
}

- (UISwipeGestureRecognizer *)swipeUp
{
    if (!_swipeUp) {
        _swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeUp:)];
        _swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    }
    
    return _swipeUp;
}

- (UISwipeGestureRecognizer *)swipeDown
{
    if (!_swipeDown) {
        _swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDown:)];
        _swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    }
    
    return _swipeDown;
}

- (UISwipeGestureRecognizer *)swipeLeft
{
    if (!_swipeLeft) {
        _swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
        _swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    }
    
    return _swipeLeft;
}

- (UISwipeGestureRecognizer *)swipeRight
{
    if (!_swipeRight) {
        _swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
        _swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    }
    
    return _swipeRight;
}

- (UILabel *)snakeLengthLabel
{
    if (!_snakeLengthLabel) {
        _snakeLengthLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        [_snakeLengthLabel setTextAlignment:NSTextAlignmentCenter];
        [_snakeLengthLabel setBackgroundColor:[UIColor clearColor]];
    }
    
    return _snakeLengthLabel;
}

@end
