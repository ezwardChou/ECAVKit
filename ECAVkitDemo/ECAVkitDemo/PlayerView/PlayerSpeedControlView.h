//
//  PlayerSpeedControlView.h
//  PlayerViewDemo
//
//  Created by Chou Edward  on 2019/10/8.
//  Copyright © 2019 Chou Edward . All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlayerSpeedControlView : UIView

@property (nonatomic,copy) void (^openMenuBlock)(BOOL isAppear);


@end

NS_ASSUME_NONNULL_END
