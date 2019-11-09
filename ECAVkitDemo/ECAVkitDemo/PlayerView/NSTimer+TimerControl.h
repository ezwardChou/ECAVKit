//
//  NSTimer+TimerControl.h
//  PlayerViewDemo
//
//  Created by Chou Edward  on 2019/10/8.
//  Copyright © 2019 Chou Edward . All rights reserved.
//



#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (TimerControl)

+ (NSTimer *)assetAdd_timerWithTimeInterval:(NSTimeInterval)ti
                                      block:(void(^)(NSTimer *timer))block
                                    repeats:(BOOL)repeats;

- (void)assetAdd_fire;

@end

NS_ASSUME_NONNULL_END
