//
//  CustomWaitView.m
//  众可贷分期
//
//  Created by Klwy on 16/3/17.
//  Copyright (c) 2016年 klwy. All rights reserved.
//

#import "WaitView.h"

@implementation WaitView


- (instancetype)init
{
    if(self = [super init])
    {
        self.hidden = YES;
        self.backgroundColor = [UIColor clearColor];
        
        _isBgHide = NO;
        
        _bgLabel = [[UILabel alloc] init];
        _bgLabel.backgroundColor = [UIColor blackColor];
        _bgLabel.alpha = 0.3;
        _bgLabel.userInteractionEnabled = _isBgHide;
        [self addSubview:_bgLabel];
        
        [_bgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.mas_leading);
            make.trailing.equalTo(self.mas_trailing);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
        }];
//
        _centerView = [[UIView alloc] init];
//        _centerView.bounds = CGRectMake(0, 0, 60, 60);
//        _centerView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        _centerView.alpha = 0.7;
        _centerView.backgroundColor = [UIColor blackColor];
        _centerView.layer.cornerRadius = 10;
        _centerView.layer.masksToBounds = YES;
        [self addSubview:_centerView];
        
        [_centerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@60);
            make.height.equalTo(@60);
            make.center.equalTo(self);
        }];
        
        
        
        _waitView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//        _waitView.center = CGPointMake(CGRectGetMidX(_centerView.bounds), CGRectGetMidY(_centerView.bounds));
        [self addSubview:_waitView];
        
        [_waitView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_centerView);
        }];
        
        
        // 点击手势
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self
                                             action:@selector(processgestureReconizer:)];
        singleTap.numberOfTapsRequired = 1;
        _bgLabel.userInteractionEnabled = NO;
//        [_bgLabel addGestureRecognizer:singleTap];//loading 指示器，取消点击操作
    }
    
    return self;
}

- (void)startAnimating
{
    self.hidden = NO;
    [_waitView startAnimating];
}

- (void)stopAnimating
{
    self.hidden = YES;
    if([_waitView isAnimating]) {
        [_waitView stopAnimating];
    }
    
}

- (BOOL)isAnimating
{
    return [_waitView isAnimating];
}

- (void)setIsBgHide:(BOOL)isBgHide {
    _isBgHide = isBgHide;
    _bgLabel.userInteractionEnabled = _isBgHide;
}

#pragma mark - UIGestureRecognizer

- (void)processgestureReconizer:(UIGestureRecognizer *)gesture
{
    [self stopAnimating];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
