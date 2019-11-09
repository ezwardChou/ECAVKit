//
//  PlayerControlView.h
//  PlayerViewDemo
//
//  Created by Chou Edward  on 2019/10/8.
//  Copyright © 2019 Chou Edward . All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EC_PlayerView.h"
NS_ASSUME_NONNULL_BEGIN

@interface PlayerControlView : UIView

@property (nonatomic,assign) BOOL isAppeared;

@property (nonatomic,weak) id<PlayerObjectDelegate> playerObject;


@property (nonatomic,copy) void (^fullScreenBlock)(void);


-(void)switchAppearState;

@end

NS_ASSUME_NONNULL_END
