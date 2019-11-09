//
//  PlayerControlView.m
//  PlayerViewDemo
//
//  Created by Chou Edward  on 2019/10/8.
//  Copyright © 2019 Chou Edward . All rights reserved.
//
#import "Masonry.h"
#import "PlayerControlView.h"
#import "PlayerSpeedControlView.h"
#import "PlayerCatalogView.h"
#import "PlayerTimerController.h"
#import <AVKit/AVKit.h>


@interface PlayerControlView ()
@property (weak, nonatomic) IBOutlet UIView *viewTop;
@property (weak, nonatomic) IBOutlet UIView *viewBottom;

@property (nonatomic,strong) PlayerSpeedControlView *speedView;
@property (nonatomic,strong) PlayerCatalogView *catalogView;
@property (weak, nonatomic) IBOutlet UIButton *btnLocked;

@property (nonatomic,strong) PlayerTimerController *timerControl;

@property (nonatomic,assign) BOOL isLocked;

//contrl
@property (weak, nonatomic) IBOutlet UIButton *btnPlay;
@property (weak, nonatomic) IBOutlet UILabel *labelStart;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *labelEnd;
@property (weak, nonatomic) IBOutlet UIButton *btnFullScreen;

@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelLoading;



@property (nonatomic,strong) AVPlayer *player;
@end

@implementation PlayerControlView

#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"PlayerControlView" owner:nil options:nil];
        self = arr.firstObject;
        
        _isLocked = NO;
        [self _createUI];
        
        {
            _timerControl = PlayerTimerController.new;
            __weak typeof(self) _self = self;
            _timerControl.exeBlock = ^(PlayerTimerController * _Nonnull control) {
                __strong typeof(_self) self = _self;
                if ( !self ) return;
//                if ( self.isDisabled ) {
//                    [control clear];
//                    return;
//                }
//                if ( self.canAutomaticallyDisappear ) {
//                    if ( !self.canAutomaticallyDisappear(self) )
//                        return;
//                }
                
                [self needDisappear];
            };
        }
        
        self.isAppeared = YES;
       
    }
    return self;
}

-(void)_createUI{
    
    {
        _speedView = [PlayerSpeedControlView new];
        
        [self addSubview:_speedView];
        [_speedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@5);
            make.trailing.equalTo(@(-60));
            make.width.equalTo(@60);
            make.height.equalTo(@40);
        }];
        
         __weak typeof(self)weakSelf = self;
        _speedView.openMenuBlock = ^(BOOL isAppear) {
            [weakSelf changeSpeedViewState:isAppear];
        };
    }

    
    {
        _catalogView = [PlayerCatalogView new];
        
        [self addSubview:_catalogView];
        [_catalogView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.trailing.equalTo(@0);
            make.leading.equalTo(@0);
            make.bottom.equalTo(@0);
        }];
    }
}

#pragma mark - Public
-(void)switchAppearState{
    if ( _isAppeared )
        [self needDisappear];
    else
        [self needAppear];
}

- (void)needAppear {
    [self _start];
    self.isAppeared = YES;
}

- (void)needDisappear {
    [self _clear];
    self.isAppeared = NO;
    
}

-(void)setIsAppeared:(BOOL)isAppeared{
    _isAppeared = isAppeared;
    
    __weak typeof(self)weakSelf = self;

    PlayerConfig *config;
    
    if (_playerObject) {
        config = _playerObject.player_Config;

    }else {
        config = [PlayerConfig new];
        config.isFullScreen = NO;
        config.isLockedScreen = NO;
    }

    
    if (_isAppeared) {
        //显示
        if (config.isLockedScreen) {
            _btnLocked.hidden = 0;
            
            _viewTop.hidden = 1;
            _speedView.hidden = 1;
            _viewBottom.hidden = 1;
        } else {
            if (config.isFullScreen) {
                _viewTop.hidden = 0;
                _speedView.hidden = 0;
                _btnLocked.hidden = 0;
            }else
            {
                _viewTop.hidden = 1;
                _speedView.hidden = 1;
                _btnLocked.hidden = 1;
            }
            _viewBottom.hidden = 0;
        }
        


        [UIView animateWithDuration:0.4 animations:^{
            [UIView setAnimationCurve:7];
            weakSelf.viewTop.alpha = 1;
            weakSelf.viewBottom.alpha = 1;
            weakSelf.speedView.alpha = 1;
            weakSelf.btnLocked.alpha = 1;
        }];
        
    } else {
        //消失
        [UIView animateWithDuration:0.4 animations:^{
            [UIView setAnimationCurve:7];

            weakSelf.viewTop.alpha = 0;
            weakSelf.viewBottom.alpha = 0;
            weakSelf.speedView.alpha = 0;
            weakSelf.btnLocked.alpha = 0;

        } completion:^(BOOL finished) {
            
            weakSelf.viewTop.hidden = 1;
            weakSelf.viewBottom.hidden = 1;
            weakSelf.speedView.hidden = 1;
            weakSelf.btnLocked.hidden = 1;

        }];
    }
    
}


#pragma mark - Private
- (void)_start {

    [_timerControl start];
}

- (void)_clear {
    [_timerControl clear];
}

#pragma mark - Action

-(void)changeSpeedViewState:(BOOL)isAppear{
    NSNumber *height;
    if (isAppear) {
        height = @242;
    } else {
        height = @40;
    }
    
     __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.4 animations:^{
        [UIView setAnimationCurve:7];
        
        [weakSelf.speedView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(height);
        }];
        
        [self layoutIfNeeded];
        
    }];
    

}

- (IBAction)openCatalog:(id)sender {
    [_catalogView showMenu];
    
    [self _clear];
}


- (IBAction)locked:(id)sender {
    _isLocked = ! _isLocked;
    
    _btnLocked.selected = _isLocked;
    
    PlayerConfig *config = _playerObject.player_Config;
    config.isLockedScreen = _isLocked;
    
    [self needAppear];
}

- (IBAction)fullScreen:(id)sender {
    _fullScreenBlock();
    _btnFullScreen.selected = !_btnFullScreen.selected;
    
    [self needAppear];
    
    NSNotification *notification = [NSNotification notificationWithName:PLAYER_ROTATESCREEN object:nil userInfo:@{@"isFullScreen":@(_btnFullScreen.selected).stringValue}];
    
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (IBAction)play:(id)sender {
    
}


- (IBAction)btnBack:(id)sender {
    if (_btnFullScreen.selected) {
        [self fullScreen:_btnFullScreen];
    }
}

@end
