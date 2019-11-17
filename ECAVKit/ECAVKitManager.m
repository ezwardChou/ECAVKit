//
//  ECAVKitManager.m
//  AVKit
//
//  Created by Chou Edward  on 2019/10/30.
//  Copyright © 2019 Chou Edward . All rights reserved.
//
#import <AVKit/AVKit.h>
#import "ECAVKitManager.h"

#pragma mark - 辅助输出函数
NSString * _Nonnull ECStringFromPlayerState(ECAVPlayerState state) {
    switch (state) {
        case ECAVPlayerStatusUnknown:
            return @"ECAVPlayerStatusUnknown";
            break;
            case ECAVPlayerStatusStalling:
                return @"ECAVPlayerStatusStalling";
                break;
            case ECAVPlayerStatusPlaying:
                return @"ECAVPlayerStatusPlaying";
                break;
            case ECAVPlayerStatusPaused:
                return @"ECAVPlayerStatusPaused";
                break;
            case ECAVPlayerStatusStopped:
                return @"ECAVPlayerStatusStopped";
                break;
            case ECAVPlayerStatusFailed:
                return @"ECAVPlayerStatusFailed";
                break;
        default:
            break;
    }
}

@implementation AVPlayer (Helper)

NSString *_getTimeStringValue(CMTime time) {
    NSInteger second = CMTimeGetSeconds(time);
    
    NSInteger s = second % 60;//秒
    NSInteger minutes = (second - s) / 60;//分
    NSInteger m = minutes % 60;
    
    NSInteger h = (minutes - m) / 60;
    
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld",h,m,s];
}

-(NSString *)durationStringValue{
    return _getTimeStringValue(self.currentItem.duration);
}

-(NSString *)playTimeStringValue{
    return _getTimeStringValue(self.currentTime);
}

-(CGFloat)possion{
    NSInteger currentTime = CMTimeGetSeconds(self.currentTime);
    NSInteger totalTime = CMTimeGetSeconds(self.currentItem.duration);

    return (double)currentTime / (double)totalTime;
}

-(NSInteger)buffingLength{

    NSArray *valueArr = self.currentItem.loadedTimeRanges;
    NSValue *firstObj = valueArr.firstObject;
    
    CMTimeRange timeRange = firstObj.CMTimeRangeValue;
    NSInteger startSecond = CMTimeGetSeconds(timeRange.start);
    NSInteger durationSecond = CMTimeGetSeconds(timeRange.duration);

    return startSecond + durationSecond;
}



-(ECAVPlayerState)state{
    return [ECAVKitManager shareManager].state;
}

@end


@interface ECAVKitManager ()

/*
 
 这里涉及到3个类
 AVPlayer、AVPlayerItem、AVAsset、AVPlayerLayer
 
 AVPlayer是用于控制音视频播放、暂停
 
 AVPlayerItem与AVAsset都是一个文件、流对应一个对象，一个文件、流的URL可以构造一个AVAsset，然后一个AVAsset可以构造一个Item，当然你也可以直接使用Item的URL参数构造方法来构造Item。
 
 AVPlayerLayer只是用于展示而已
 */

@property (nonatomic,strong) AVPlayerLayer *playerLayer;

@property (nonatomic,assign) ECAVPlayerState playerState;

@end

@implementation ECAVKitManager

#pragma mark - Init
+(instancetype)shareManager{
    static ECAVKitManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = ECAVKitManager.new;
        [sharedInstance _initSelf];
    });
    return sharedInstance;
}


-(void)_initSelf{
    _player = [AVPlayer new];
    
     __weak typeof(self)weakSelf = self;
    [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        /*
         说明，这里可以取到播放时间，CMTime属性比较特殊，因为浮点数的精度问题，苹果封装了一个C的结构体，其中成员变量value表示分子，scale表示分母，二者运算结果为时间。
         
         */
        [weakSelf _updatePlayerTime:time];
    }];
    
    [self _registerNotification];
}


-(void)_registerNotificationWithItem:(AVPlayerItem *)item{
    [item addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [item addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    
}

-(void)_registerNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_videoDidPlayEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

//- (instancetype)init {
//    return [[self class] shareManager];
//}
#pragma mark - 懒加载
-(AVPlayerLayer *)playerLayer{
    if (_playerLayer == nil) {
        /*
         这个构造方法会导致_player的引用计数器+1
         */
        
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    }
    
    return _playerLayer;
}

#pragma mark - Public
-(void)setScreenLayer:(UIView *)view{
    [view.layer addSublayer:self.playerLayer];
}

-(void)playVideoWithOnlinePath:(NSString *)path{
    [self _postPlayStateChanged:ECAVPlayerStatusStalling];

    if (path == nil || ![path isKindOfClass:NSString.class]) {

        [self _postPlayStateChanged:ECAVPlayerStatusFailed];
        
        return;
    }
    
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:path]];
    
    [self _registerNotificationWithItem:item];
    
    //存疑
    [_player replaceCurrentItemWithPlayerItem:item];
    
    [_player play];
}


-(void)playVideoWithLocalPath:(NSString *)path{
    [self _postPlayStateChanged:ECAVPlayerStatusStalling];

    if (path == nil || ![path isKindOfClass:NSString.class]) {

        [self _postPlayStateChanged:ECAVPlayerStatusFailed];
        
        return;
    }
    
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:path]];
    
    [self _registerNotificationWithItem:item];
    
    [_player replaceCurrentItemWithPlayerItem:item];
    
    [_player play];
}

-(void)pause{
    [_player pause];
    _state = ECAVPlayerStatusPaused;
    [self _postPlayStateChanged:_state];
}

-(void)play{
    [_player play];
    _state = ECAVPlayerStatusPlaying;
    [self _postPlayStateChanged:_state];
}

-(void)stop{
    [_player seekToTime:kCMTimeZero];
    [_player pause];
    _state = ECAVPlayerStatusStopped;
    [self _postPlayStateChanged:_state];
    
    /*
     尝试过在这里将currentItem 替换为nil，结果会导致播放下个文件时，item的播放状态不能够被正确监听到。
    */
}

-(void)seekToPossion:(CGFloat)possion{
    
     NSInteger totalTime = CMTimeGetSeconds(_player.currentItem.duration);
    
    CGFloat specialTime = totalTime * possion;
    NSInteger specialValue = lround(specialTime);
    
    [_player seekToTime:CMTimeMake(specialValue, 1.0)];
}

-(void)setPlayingRate:(CGFloat)rate{
    
    if (_state == ECAVPlayerStatusStopped) {
        return;
    }
    
    _player.rate = rate;
    
    if (_state == ECAVPlayerStatusPaused) {
        [_player pause];
    }
}

-(void)updateScreenFrame:(CGRect)frame{
    _playerLayer.frame = frame;
}

-(void)jumpForward:(NSInteger)second{
    NSInteger currentTime = CMTimeGetSeconds(_player.currentTime);
    
    [_player seekToTime:CMTimeMake(currentTime + second, 1.0)];
}

-(void)jumpBackward:(NSInteger)second{
    NSInteger currentTime = CMTimeGetSeconds(_player.currentTime);
    
    [_player seekToTime:CMTimeMake(currentTime - second, 1.0)];
}
#pragma mark - TOOL METHOD
-(void)_updatePlayerTime:(CMTime)time{
    
    if ([_playerDelegate respondsToSelector:@selector(ecAVPlayerTimeChanged)]) {
        [_playerDelegate ecAVPlayerTimeChanged];
    }
    
}

-(void)_videoDidPlayEnd{
    [self _postPlayStateChanged:ECAVPlayerStatusStopped];
}

-(void)_postPlayStateChanged:(ECAVPlayerState)state{
    if ([_playerDelegate respondsToSelector:@selector(ecAVPlayerPlayStateChanged:)]) {
               [_playerDelegate ecAVPlayerPlayStateChanged:state];
    }
}

#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"state"]) {
        AVPlayerItemStatus oldStatus = (AVPlayerItemStatus)[change[NSKeyValueChangeOldKey] integerValue];
               AVPlayerItemStatus newStatus = (AVPlayerItemStatus)[change[NSKeyValueChangeNewKey] integerValue];
               if (oldStatus == newStatus) {
                   return;
               }
               switch (newStatus) {
                   case AVPlayerItemStatusReadyToPlay:
                       [self _postPlayStateChanged:ECAVPlayerStatusPlaying];
                       break;
                   case AVPlayerItemStatusFailed:
                       [self _postPlayStateChanged:ECAVPlayerStatusFailed];
                   case AVPlayerItemStatusUnknown:
                       [self _postPlayStateChanged:ECAVPlayerStatusUnknown];
                       break;
               }
        
    }
    else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
      
        if (_player.state == ECAVPlayerStatusPaused) {
            // 这里这么写是因为：状态变化是异步的，有可能在播放器暂停时观察到状态变化，这时候不应该变动原来的状态
            return;
        }
        BOOL oldValue = [change[NSKeyValueChangeOldKey] boolValue];
        BOOL newValue = [change[NSKeyValueChangeNewKey] boolValue];
        if (oldValue == NO && newValue == YES) {
            //这里这么写是因为观察到会有old new都是0的情况
            _state = ECAVPlayerStatusStalling;
            [self _postPlayStateChanged:ECAVPlayerStatusStalling];
        }
        
        
    }
    else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
        if (_state == ECAVPlayerStatusPaused) {
           // 这里这么写是因为：状态变化是异步的，有可能在播放器暂停时观察到状态变化，这时候不应该变动原来的状态
               return;
        }
       BOOL oldValue = [change[NSKeyValueChangeOldKey] boolValue];
       BOOL newValue = [change[NSKeyValueChangeNewKey] boolValue];
       if (oldValue == NO && newValue == YES) { //这里这么写是因为观察到会有old new都是0的情况
           _state = ECAVPlayerStatusPlaying;
           [self _postPlayStateChanged:ECAVPlayerStatusPlaying];
       }

    }

    
}
@end
