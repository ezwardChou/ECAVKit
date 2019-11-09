//
//  PlayerPresentView.m
//  PlayerViewDemo
//
//  Created by Chou Edward  on 2019/10/8.
//  Copyright © 2019 Chou Edward . All rights reserved.
//

#import "PlayerPresentView.h"

//私有类以及方法全用_开头
@interface _PlayerTouchRequestInfo : NSObject
@property (nonatomic) SEL selector;
@property (nonatomic, strong, nullable) id object;
@end

@implementation _PlayerTouchRequestInfo

@end

@interface PlayerPresentView ()<UIGestureRecognizerDelegate>

@property (nonatomic,strong) UIPanGestureRecognizer *panGesture;

@property (nonatomic,assign) PanGestureMovingDirection movingDirection;
@property (nonatomic,assign) PanGestureTriggeredPosition triggeredPosition;

@property (nonatomic,strong) _PlayerTouchRequestInfo *touchRequestInfo;


@end

@implementation PlayerPresentView

#pragma mark - init Object

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _createUI];
    }
    return self;
}

-(void)_createUI{
    self.backgroundColor = UIColor.clearColor;
    
    {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_handlePan:)];
        _panGesture.minimumNumberOfTouches = 1;
        _panGesture.maximumNumberOfTouches = 1;
        _panGesture.delegate = self;
        [self addGestureRecognizer:_panGesture];
    }

    

}


#pragma mark - Action
-(void)_handlePan:(UIPanGestureRecognizer *)pan{
    CGPoint translate = [pan translationInView:pan.view];
    switch (pan.state) {
        case UIGestureRecognizerStateBegan: {
            if ( _panBlock ) _panBlock(_triggeredPosition, _movingDirection, UIGestureRecognizerStateBegan, translate);
        }
            break;
        case UIGestureRecognizerStateChanged: {
            if ( _panBlock ) _panBlock(_triggeredPosition, _movingDirection, UIGestureRecognizerStateChanged, translate);
        }
            break;
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            if ( _panBlock ) _panBlock(_triggeredPosition, _movingDirection, UIGestureRecognizerStateEnded, translate);
        }
            break;
        default: break;
    }
    [pan setTranslation:CGPointZero inView:pan.view];
}




#pragma mark - GestureRecognizer Delegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    CGPoint location = [_panGesture locationInView:self];
    
    CGRect rect = self.bounds;
    if (location.y > rect.size.height - 50) {//影响滑动条
        return NO;
    }

    //左边是亮度 右边是音量
    if ( location.x > self.bounds.size.width * 0.5 ) {
        _triggeredPosition = PanGestureTriggeredPositionRight;
    }
    else {
        _triggeredPosition = PanGestureTriggeredPositionLeft;
    }
    
    
    CGPoint velocity = [_panGesture velocityInView:_panGesture.view];
    CGFloat x = fabs(velocity.x);
    CGFloat y = fabs(velocity.y);
    
    if (x > y) {
        _movingDirection = PanGestureMovingDirectionHorizontal;
    }
    else {
        _movingDirection = PanGestureMovingDirectionVertical;
    }
    
    return YES;
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
        
    if ( event.allTouches.count != 1 ) {
        if ( _touchRequestInfo != nil ) {
            [NSObject cancelPreviousPerformRequestsWithTarget:self
                                                     selector:_touchRequestInfo.selector
                                                       object:_touchRequestInfo.object];
            _touchRequestInfo = nil;
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    CGPoint point = [touches.anyObject locationInView:self];
    
    NSLog(@"touchesEnded %@",NSStringFromCGPoint(point));
    
    if ( event.allTouches.count == 1 ) {
        if ( _touchRequestInfo != nil ) {
            [NSObject cancelPreviousPerformRequestsWithTarget:self
                                                     selector:_touchRequestInfo.selector
                                                       object:_touchRequestInfo.object];
            _touchRequestInfo = nil;
        }
        
        UITouch *touch = touches.anyObject;
        
        if ( touch.tapCount == 0 )
            return;
        
        if ( touch.tapCount == 2 ) {
            [self _recognize:touch];
        }
        else {
            _touchRequestInfo = [_PlayerTouchRequestInfo new];
            _touchRequestInfo.selector = @selector(_recognize:);
            _touchRequestInfo.object = touch;
            [self performSelector:_touchRequestInfo.selector
                       withObject:_touchRequestInfo.object
                       afterDelay:0.180 inModes:@[NSRunLoopCommonModes]];
        }
    }
}

- (void)_recognize:(UITouch *)touch {
    if ( _touchRequestInfo != nil ) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self
                                                 selector:_touchRequestInfo.selector
                                                   object:_touchRequestInfo.object];
        _touchRequestInfo = nil;
    }

    if ( touch.tapCount % 2 == 0 )
        [self handleDoubleTap:touch];
    else
        [self handleSingleTap:touch];
}


- (void)handleSingleTap:(UITouch *)tap {

    CGPoint location = [tap locationInView:self];

    if (_singleTapBlock) {
        _singleTapBlock(location);
    }
}

- (void)handleDoubleTap:(UITouch *)tap {
    
    CGPoint location = [tap locationInView:self];

    if (_doubleTapBlock) {
        _doubleTapBlock(location);
    }
    
}

@end
