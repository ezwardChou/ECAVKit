//
//  PlayerTimerController.h
//  PlayerViewDemo
//
//  Created by Chou Edward  on 2019/10/8.
//  Copyright © 2019 Chou Edward . All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlayerTimerController : NSObject

@property (nonatomic) NSTimeInterval interval;

@property (nonatomic, copy, nullable) void(^exeBlock)(PlayerTimerController *control);

- (void)start;

- (void)clear;

- (void)reset;
@end

NS_ASSUME_NONNULL_END
