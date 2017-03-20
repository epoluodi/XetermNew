//
//  UIPlaceHolderTextView.h
//  Tests
//
//  Created by lfq on 14-7-8.
//  Copyright (c) 2014年 lfq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPlaceHolderTextView : UITextView

@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end
