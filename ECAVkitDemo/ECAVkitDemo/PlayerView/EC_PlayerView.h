//
//  PlayerView.h
//  PlayerViewDemo
//
//  Created by Chou Edward  on 2019/10/8.
//  Copyright © 2019 Chou Edward . All rights reserved.
//
#define PLAY_URL @"http://test360drm.oss-cn-shanghai.aliyuncs.com/record/live1/1_558_1271/1_558_1271.m3u8?OSSAccessKeyId=LTAIOPhqgY7Bwmtw&Expires=1571474963&Signature=CCGrb0lxEeagEzSUwbWE5BxSYDE%3D"
#import <UIKit/UIKit.h>

#import "Masonry.h"

#define PLAYER_ROTATESCREEN @"PLAYER_ROTATESCREEN"
/*
 播放器的配置文件
 */
@interface PlayerConfig : NSObject
@property (nonatomic,assign) BOOL isFullScreen;
@property (nonatomic,assign) BOOL isLockedScreen;
@property (nonatomic,assign) BOOL isAppear;

@end

@interface EC_PlayerView : UIView
@property (nonatomic,strong) PlayerConfig *config;

@property (nonatomic,weak) UIView *oldSuperView;

@end

@protocol PlayerObjectDelegate <NSObject>

-(PlayerConfig *)player_Config;

@end

