//
//  PlayerPresentView.h
//  PlayerViewDemo
//
//  Created by Chou Edward  on 2019/10/8.
//  Copyright © 2019 Chou Edward . All rights reserved.
//

/*
 这个类专门用于点击事件的分发
 
 */

#import "Masonry.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PanGestureTriggeredPositionLeft,
    PanGestureTriggeredPositionRight
} PanGestureTriggeredPosition;

typedef enum : NSUInteger {
    PanGestureMovingDirectionHorizontal,
    PanGestureMovingDirectionVertical
} PanGestureMovingDirection;

NS_ASSUME_NONNULL_BEGIN

@interface PlayerPresentView : UIView

@property (nonatomic,copy) void(^singleTapBlock)(CGPoint location);
@property (nonatomic,copy) void(^doubleTapBlock)(CGPoint location);

@property (nonatomic,copy) void(^panBlock)(PanGestureTriggeredPosition triggeredPosition, PanGestureMovingDirection movingDirection, UIGestureRecognizerState state, CGPoint location);


@end

NS_ASSUME_NONNULL_END
