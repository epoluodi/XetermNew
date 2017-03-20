//
//  ShortcutView.m
//  Xeterm
//
//  Created by Klwy on 16/10/17.
//  Copyright © 2016年 klwy. All rights reserved.
//

#import "ShortcutView.h"

@implementation ShortcutView

- (void)awakeFromNib {
    
    self.hidden = YES;
}

// 添加保存block
- (void)addSaveAction:(ButtonAction)action {
    
    self.saveAction = nil;
    self.saveAction = action;
}

// 添加取消block
- (void)addCancelAction:(ButtonAction)action {
    
    self.cancelAction = nil;
    self.cancelAction = action;
}

// 设置快捷指令文本输入框协议代理
- (void)setShortcutTextFieldDelegate:(id<UITextFieldDelegate>)delegate {
    
    self.shortcutTextField.delegate = delegate;
}


#pragma mark - ButtonAction

// 保存服务器设置事件
- (IBAction)saveButtonAction:(UIButton *)sender {
    
    
    if(![self checkoutShortcutText]) {
        return ;
    }
    
    if(self.saveAction) {
        self.saveAction(sender);
    }
    
    self.shortcutTextField.text = @"";
    
    [self cancelButtonAction:nil];
}

// 校验快捷指令是否为空
- (BOOL)checkoutShortcutText {
    
    [self.shortcutTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if(self.shortcutTextField.text.length == 0) {
        [APPDELEGATE showAlertMessage:@"请输入快捷指令!"];
        return NO;
    }
    
    if(![self saveShortcutKey:self.shortcutTextField.text]) {
        return NO;
    }
    
    
    return YES;
}


- (BOOL)saveShortcutKey:(NSString *)key {
    
    NSString *path = [APPDELEGATE readPlistPathWithName:ShortcutListPlistName];
    NSMutableArray *muArray = [NSMutableArray arrayWithArray:[APPDELEGATE readPlistArrayWithPlistPath:path]];
    
    if([muArray containsObject:key]) {
        [APPDELEGATE showAlertMessage:@"快捷指令已存在！"];
        return NO;
    }
    
    [muArray addObject:key];
    [APPDELEGATE savePlistArray:muArray plistPath:path];
    
    return YES;
}

// 取消服务器设置事件
- (IBAction)cancelButtonAction:(UIButton *)sender {
    
    self.hidden = YES;
    
    if(self.cancelAction) {
        self.cancelAction(sender);
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
