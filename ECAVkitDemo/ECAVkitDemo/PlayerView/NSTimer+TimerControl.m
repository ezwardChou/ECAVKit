//
//  NSTimer+TimerControl.m
//  PlayerViewDemo
//
//  Created by Chou Edward  on 2019/10/8.
//  Copyright © 2019 Chou Edward . All rights reserved.
//

#import "NSTimer+TimerControl.h"


@implementation NSTimer (TimerControl)

+ (NSTimer *)assetAdd_timerWithTimeInterval:(NSTimeInterval)ti
                                      block:(void(^)(NSTimer *timer))block
                                    repeats:(BOOL)repeats {
    NSTimer *timer = [NSTimer timerWithTimeInterval:ti
                                             target:self
                                           selector:@selector(assetAdd_exeBlock:)
                                           userInfo:block
                                            repeats:repeats];
    return timer;
}

+ (void)assetAdd_exeBlock:(NSTimer *)timer {
    void(^block)(NSTimer *timer) = timer.userInfo;
    if ( block ) block(timer);
    else [timer invalidate];
}

- (void)assetAdd_fire {
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:self.timeInterval]];
}

@end
