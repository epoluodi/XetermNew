//
//  AdviceView.m
//  Xeterm
//
//  Created by Klwy on 16/10/17.
//  Copyright © 2016年 klwy. All rights reserved.
//

#import "AdviceView.h"

@implementation AdviceView

- (void)awakeFromNib {
    
    self.hidden = YES;
    
    _placeholderTV = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(5, 5, self.outAdviceView.bounds.size.width-10, self.outAdviceView.bounds.size.height-10)];
    _placeholderTV.placeholder = @"请输入您的宝贵意见!";
    _placeholderTV.font = [UIFont systemFontOfSize:14];
    _placeholderTV.textColor = [UIColor darkGrayColor];
    _placeholderTV.returnKeyType = UIReturnKeyDone;
    [self.outAdviceView addSubview:_placeholderTV];
}

// 添加发送block
- (void)addSendAction:(ButtonAction)action {
    
    self.sendAction = nil;
    self.sendAction = action;
}

// 添加关闭block
- (void)addCloseAction:(ButtonAction)action {
    
    self.closeAction = nil;
    self.closeAction = action;
}

// 设置文本输入协议代理
- (void)setTextDelegate:(id<UITextFieldDelegate, UITextViewDelegate>)delegate {
    
    self.qqTextField.delegate = delegate;
    _placeholderTV.delegate = delegate;
}


#pragma mark - ButtonAction

// 发送意见反馈事件
- (IBAction)sendButtonAction:(UIButton *)sender {
    
    if(![self checkoutShortcutText]) {
        return ;
    }
    
    if(self.sendAction) {
        self.sendAction(sender);
    }
    
    self.qqTextField.text = @"";
    _placeholderTV.text = @"";
    
    [self closeButtonAction:nil];
}

// 校验快捷指令是否为空
- (BOOL)checkoutShortcutText {
    
    if(self.qqTextField.text.length == 0) {
        [APPDELEGATE showAlertMessage:@"请输入您的QQ号!"];
        return NO;
    }
    
    if(_placeholderTV.text.length == 0) {
        [APPDELEGATE showAlertMessage:@"请填写您的意见或建议!"];
        return NO;
    }
    
    return YES;
}

// 关闭意见反馈事件
- (IBAction)closeButtonAction:(UIButton *)sender {
    
    self.hidden = YES;
    
    if(self.closeAction) {
        self.closeAction(sender);
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
