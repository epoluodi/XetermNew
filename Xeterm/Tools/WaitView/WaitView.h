//
//  CustomWaitView.h
//  众可贷分期
//
//  Created by Klwy on 16/3/17.
//  Copyright (c) 2016年 klwy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaitView : UIView

@property (assign, nonatomic) BOOL isBgHide;
@property (strong, nonatomic, readonly) UILabel *bgLabel;
@property (strong, nonatomic) UIView *centerView;
@property (strong, nonatomic) UIActivityIndicatorView *waitView;



- (void)startAnimating;
- (void)stopAnimating;
- (BOOL)isAnimating;


@end
