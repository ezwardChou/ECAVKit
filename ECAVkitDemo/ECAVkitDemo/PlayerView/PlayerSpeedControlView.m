//
//  PlayerSpeedControlView.m
//  PlayerViewDemo
//
//  Created by Chou Edward  on 2019/10/8.
//  Copyright © 2019 Chou Edward . All rights reserved.
//
#import "Masonry.h"
#import "PlayerSpeedControlView.h"

@interface PlayerSpeedControlView ()

@property (weak, nonatomic) IBOutlet UIButton *btnSpeed;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnArray;

@property (nonatomic,assign) BOOL isAppear;


@end

@implementation PlayerSpeedControlView

#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"PlayerSpeedControlView" owner:nil options:nil];
        self = arr.firstObject;
        
        _isAppear = NO;
        
        self.layer.cornerRadius = 6;
        
    }
    return self;
}


#pragma mark - Action

- (IBAction)openSpeedMenu:(id)sender {
    
    _isAppear = !_isAppear;
    _openMenuBlock(_isAppear);
}

- (IBAction)changeSpeed:(UIButton *)sender {
    NSInteger tag = sender.tag;
    
    for (UIButton *btn in _btnArray) {
        btn.selected = 0;
    }
    
    sender.selected = 1;
    
    NSArray *arr = @[@0.5, @1.0, @1.25, @1.5, @1.75];
    
    NSNumber *rate = arr[sender.tag - 1];
    
//    [PlayerManager sharedInstance].player.rate = rate.floatValue;
    [_btnSpeed setTitle:sender.titleLabel.text forState:UIControlStateNormal];
}

@end
