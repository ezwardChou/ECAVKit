//
//  PlayerWaterMarkView.m
//  PlayerViewDemo
//
//  Created by Chou Edward  on 2019/10/9.
//  Copyright © 2019 Chou Edward . All rights reserved.
//

#import "PlayerWaterMarkView.h"

@interface PlayerWaterMarkView ()<CAAnimationDelegate>
@property (nonatomic,strong) UIImageView *imgWaterMark;

@property (nonatomic,strong) CABasicAnimation *animation;

@property (nonatomic,strong) NSDate *startTime;
@end

@implementation PlayerWaterMarkView

#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNoti:) name:@"PLAYER_ROTATESCREEN" object:nil];
        
        /*
         水印图片保证长宽其中一边最大不超过300
         */
        _imgWaterMark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1"]];
        _imgWaterMark.frame = CGRectMake(0, 0, 300, 300);
        
        [self addSubview:_imgWaterMark];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self _startLineAnim];
        });

    }
    return self;
}


#pragma mark - Notification
-(void)receiveNoti:(NSNotification *)notification
{
    NSDictionary *dict = notification.userInfo;
    
    NSNumber *num = dict[@"isFullScreen"];

    //调整水印位置
    
}


#pragma mark - Public
-(void)start{
//    _imgWaterMark.image = [UIImage imageWithData:[VideoManager shareManager].wmModel.data];
//
//    _imgWaterMark.alpha = [VideoManager shareManager].wmModel.alpha / 255.0;
//
//    if ([VideoManager shareManager].wmModel.waterMarkType == WaterMarkMarquee) {
//
//        [self startLineAnim];
//
//    }
//    else {
//        if ([VideoManager shareManager].wmModel.waterMarkType == WaterMarkFixed || [VideoManager shareManager].wmModel.interal == 0.0) {
//            return;
//        }
//
//
//
//
//        NSLog(@"启动timer");
//
//        if (_timer) {
//            [_timer invalidate];
//            _timer = nil;
//        }
//
//        _timer = [NSTimer scheduledTimerWithTimeInterval:[VideoManager shareManager].wmModel.interal target:self selector:@selector(moveWaterMark) userInfo:nil repeats:1];
//
//    }
}

-(void)stop{
    
    [_imgWaterMark.layer removeAllAnimations];
}
#pragma mark - Animation
-(void)_startLineAnim{

    CGRect frame = self.frame;
    _imgWaterMark.layer.position = CGPointMake(-150, 150);

    _animation = [CABasicAnimation animation];
    _animation.keyPath = @"position";
    _animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(-150, 150)];
    _animation.toValue = [NSValue valueWithCGPoint:CGPointMake(frame.size.width + 150, 150)];
    _animation.duration = frame.size.width / 50.0;
    _animation.delegate = self;
   
//    _animation.fillMode = kCAFillModeBoth;
    
    [_imgWaterMark.layer addAnimation:_animation forKey:@"position"];
    
    [_imgWaterMark startAnimating];
    
}


//继续动画

#pragma mark - Delegate
-(void)animationDidStart:(CAAnimation *)anim{

}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{

    if (flag) {
        [self _startLineAnim];
    } else {
        
    }
    
}
@end
