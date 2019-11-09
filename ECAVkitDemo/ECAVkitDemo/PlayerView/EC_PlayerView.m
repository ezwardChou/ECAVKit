//
//  PlayerView.m
//  PlayerViewDemo
//
//  Created by Chou Edward  on 2019/10/8.
//  Copyright © 2019 Chou Edward . All rights reserved.
//

#import "EC_PlayerView.h"
#import "PlayerControlView.h"
#import "PlayerPresentView.h"
#import "PlayerWaterMarkView.h"


@implementation PlayerConfig
@end

#pragma mark - PlayerView Class
@interface EC_PlayerView ()<PlayerObjectDelegate>
@property (nonatomic,strong) PlayerPresentView *presentView;

@property (nonatomic,strong) PlayerControlView *controlView;

@property (nonatomic,strong) PlayerWaterMarkView *waterMarkView;

@end

@implementation EC_PlayerView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _createUI];
        [self _config];
    }
    return self;
}

#pragma mark - XIB
-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self _createUI];
    [self _config];

}

#pragma mark - Init
-(void)_createUI{
    self.backgroundColor = UIColor.blackColor;
    
    _waterMarkView = [PlayerWaterMarkView new];
    [self addSubview:_waterMarkView];
    [_waterMarkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.bottom.equalTo(@0);
        
    }];
    
    _presentView = [PlayerPresentView new];
    [self addSubview:_presentView];
    [_presentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.bottom.equalTo(@0);
        
    }];
    
     __weak typeof(self)weakSelf = self;
    //block
    {
        _presentView.singleTapBlock = ^(CGPoint location) {
            [weakSelf _singleTapAction];
        };
    
        _presentView.doubleTapBlock = ^(CGPoint location) {
            [weakSelf _doubleTapAction];
        };
        
        _presentView.panBlock = ^(PanGestureTriggeredPosition triggeredPosition, PanGestureMovingDirection movingDirection, UIGestureRecognizerState state, CGPoint location) {
            
        };
    }
    
    
    _controlView = [PlayerControlView new];
    [_presentView addSubview:_controlView];

    [_controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.bottom.equalTo(@0);
        
    }];
    [_presentView bringSubviewToFront:_controlView];
    
    {

        _controlView.playerObject = self;
        
        _controlView.fullScreenBlock = ^{
            [weakSelf _changeScreen];
        };
    }
}

-(void)_config{
    _config = [PlayerConfig new];
    _config.isLockedScreen = NO;
    _config.isFullScreen = NO;
}


#pragma mark - Action
-(void)_singleTapAction{
    
    [_controlView switchAppearState];
    
}

-(void)_doubleTapAction{
    if (_config.isLockedScreen) {
        return;
    }
    
    NSLog(@"双击");
    [_waterMarkView stop];
}

-(void)_changeScreen{
    if (_config.isFullScreen) {
        [self removeFromSuperview];
        
        [_oldSuperView addSubview:self];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.bottom.equalTo(@0);
            make.leading.equalTo(@0);
            make.trailing.equalTo(@0);
            
        }];
    } else {
        [self removeFromSuperview];
        
        UIWindow *wind = [UIApplication sharedApplication].windows.firstObject;
        [wind addSubview:self];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.bottom.equalTo(@0);
            make.leading.equalTo(@0);
            make.trailing.equalTo(@0);
            
        }];
    }
        
    BOOL oldValue = _config.isFullScreen;
    NSLog(@"%d",oldValue);
    _config.isFullScreen = !oldValue;

}


#pragma mark - PlayerObjectDelegate
-(PlayerConfig *)player_Config{
    return _config;
}
@end
