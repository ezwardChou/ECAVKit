//
//  PlayerCatalogView.m
//  PlayerViewDemo
//
//  Created by Chou Edward  on 2019/10/8.
//  Copyright © 2019 Chou Edward . All rights reserved.
//



#import "PlayerCatalogView.h"

@interface PlayerCatalogView ()
@property (weak, nonatomic) IBOutlet UIView *viewBG;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailing;

@end

@implementation PlayerCatalogView

#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"PlayerCatalogView" owner:nil options:nil];
        
        self = arr.firstObject;
        
        self.hidden = 1;
    
    }
    return self;
}


#pragma mark - touch
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    //hidden all

     __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        [UIView setAnimationCurve:7];
        
        weakSelf.trailing.constant = -330;
        
        [weakSelf layoutIfNeeded];
    } completion:^(BOOL finished) {
        weakSelf.hidden = 1;
    }];
}

#pragma mark - Public
-(void)showMenu{
    self.hidden = 0;
    
     __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        [UIView setAnimationCurve:7];
        
        weakSelf.trailing.constant = 0.0;
        [weakSelf layoutIfNeeded];

    }];
}


@end
