//
//  AdviceView.h
//  Xeterm
//
//  Created by Klwy on 16/10/17.
//  Copyright © 2016年 klwy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPlaceHolderTextView.h"           // 带占位符

typedef void(^ButtonAction) (UIButton *sender);

@interface AdviceView : UIView

/**
 *  带占位符的输入文本
 */
@property (strong, nonatomic) UIPlaceHolderTextView *placeholderTV;

/**
 *  标题
 */
@property (weak, nonatomic) IBOutlet UILabel *title;

/**
 *  QQ号码
 */
@property (weak, nonatomic) IBOutlet UITextField *qqTextField;

/**
 *  输入文本外部视图
 */
@property (weak, nonatomic) IBOutlet UIView *outAdviceView;

/**
 *  发送block
 */
@property (copy, nonatomic) ButtonAction sendAction;

/**
 *  关闭block
 */
@property (copy, nonatomic) ButtonAction closeAction;


/**
 *  添加发送block
 *
 *  @param action block
 */
- (void)addSendAction:(ButtonAction)action;

/**
 *  添加关闭block
 *
 *  @param action block
 */
- (void)addCloseAction:(ButtonAction)action;

/**
 *  设置文本输入协议代理
 *
 *  @param delegate 代理
 */
- (void)setTextDelegate:(id<UITextFieldDelegate, UITextViewDelegate>)delegate;

@end
