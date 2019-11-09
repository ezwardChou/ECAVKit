//
//  PlayerTimerController.m
//  PlayerViewDemo
//
//  Created by Chou Edward  on 2019/10/8.
//  Copyright © 2019 Chou Edward . All rights reserved.
//

#import "PlayerTimerController.h"
#import "NSTimer+TimerControl.h"

@interface PlayerTimerController ()
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) short point;
@property (nonatomic, assign) BOOL resetState;

@end

@implementation PlayerTimerController
- (instancetype)init {
    self = [super init];
    if ( self ) {
        self.interval = 3;
    }
    return self;
}

- (void)setInterval:(NSTimeInterval)interval {
    _interval = interval;
    _point = interval;
}

- (void)start {
    [self clear];
    __weak typeof(self) _self = self;
    _timer = [NSTimer assetAdd_timerWithTimeInterval:1 block:^(NSTimer *timer) {
        __strong typeof(_self) self = _self;
        if ( !self ) {
            [timer invalidate];
            return ;
        }
        if ( 0 == --self.point ) {
            if ( self.exeBlock ) self.exeBlock(self);
            if ( !self.resetState ) [self clear];
            self.resetState = NO;
        }
    } repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    [_timer assetAdd_fire];
}

- (void)clear {
    [_timer invalidate];
    _timer = nil;
    _point = _interval;
}

- (void)reset {
    _point = _interval;
    _resetState = YES;
}
@end
