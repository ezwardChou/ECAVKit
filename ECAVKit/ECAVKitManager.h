//
//  ECAVKitManager.h
//  AVKit
//
//  Created by Chou Edward  on 2019/10/30.
//  Copyright © 2019 Chou Edward . All rights reserved.
//

/*
 功能设计
 
目标：设计一个播放器，专门用于m3u8链接的播放。
 
 功能分布：
 播放暂停 原生提供
 
 播放状态提醒 对原生通知提醒的二次封装
 
 播放进度的显示：已播放进度、总时长、进度条 原生的时间通知
 
 倍速 原生提供
 
 
 进阶要求：
    参考VLCKit来构造部分接口
 */
#import <AVKit/AVKit.h>
#import <Foundation/Foundation.h>



typedef enum : NSUInteger {
    ECAVPlayerStatusUnknown = 0,
    ECAVPlayerStatusStalling,
    ECAVPlayerStatusPlaying,
    ECAVPlayerStatusPaused,
    ECAVPlayerStatusStopped,
    ECAVPlayerStatusFailed
    
} ECAVPlayerState;

NSString * _Nonnull ECStringFromPlayerState(ECAVPlayerState state);

@interface AVPlayer (Helper)
-(ECAVPlayerState)state;
-(NSString *_Nullable)durationStringValue;
-(NSString *_Nullable)playTimeStringValue;
-(CGFloat)possion;
-(NSInteger)buffingLength;

@end


#pragma mark - ECAVPlayerDelegate

@protocol ECAVPlayerDelegate <NSObject>

@optional

-(void)ecAVPlayerTimeChanged;

-(void)ecAVPlayerPlayStateChanged:(ECAVPlayerState)state;
@end


NS_ASSUME_NONNULL_BEGIN

@interface ECAVKitManager : NSObject

/// init
+(instancetype)shareManager;

@property (nonatomic,strong) AVPlayer *player;

@property (nonatomic,weak) id<ECAVPlayerDelegate> playerDelegate;

@property (nonatomic,assign, readonly) ECAVPlayerState state;

/// 设置播放视图
/// @param view 设置用于展示播放画面的视图
-(void)setScreenLayer:(UIView *)view;


/// 更新屏幕位置信息，如果不设置更新的话，那么在视图变换后，画面的尺寸不会正确变化，它是layer，不是view
/// @param frame 设置你变换后的尺寸
-(void)updateScreenFrame:(CGRect)frame;

/// 播放视频 在线
/// @param path 路径，在线路径
-(void)playVideoWithOnlinePath:(NSString *)path;

/// 播放视频 本地
/// @param path 路径，在线路径
-(void)playVideoWithLocalPath:(NSString *)path;


-(void)play;

-(void)pause;

-(void)stop;


/// 跳到你需要的进度
/// @param possion 进度百分比 0为开始，1为末尾
-(void)seekToPossion:(CGFloat)possion;


/// 设置播放速度
/// @param rate 速度值 需要注意一个点，根据官方的注释说明，如果设置rate的值为0，那么播放会停止。若设置非零值，则会开始播放，详情可见官方注释。
-(void)setPlayingRate:(CGFloat)rate;


/// 向前快进若干秒， 目前属于废弃状态，因为实现的方式不够完美
/// @param second 需要快进的秒数
-(void)jumpForward:(NSInteger)second __attribute__ ((deprecated));


/// 向后快退若干秒， 目前属于废弃状态，因为实现的方式不够完美
/// @param second 需要快进的秒数
-(void)jumpBackward:(NSInteger)second __attribute__ ((deprecated));
@end



NS_ASSUME_NONNULL_END
