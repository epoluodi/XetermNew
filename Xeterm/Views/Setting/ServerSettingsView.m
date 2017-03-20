//
//  ServerSettingsView.m
//  Xeterm
//
//  Created by Klwy on 16/10/16.
//  Copyright © 2016年 klwy. All rights reserved.
//

#import "ServerSettingsView.h"

@implementation ServerSettingsView

- (void)awakeFromNib {
    
    self.hidden = YES;
    
    [self showServerInfo];
}

- (void)showServerInfo {
    
    self.serverAddress.text = [APPDELEGATE judgeStringContent:[APPDELEGATE readUserObjForKey:ServerAddressKey]];
    
    self.serverPort.text = [APPDELEGATE judgeStringContent:[APPDELEGATE readUserObjForKey:ServerPortKey]];
    
    self.securityButton.selected = [[APPDELEGATE readUserObjForKey:SecureTransportKey] boolValue];
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

// 设置服务器设置文本输入框协议代理
- (void)setServerSettingTextFieldDelegate:(id<UITextFieldDelegate>)delegate {
    
    self.serverAddress.delegate = delegate;
    self.serverPort.delegate = delegate;
}

#pragma mark - ButtonAction
// 安全传输
- (IBAction)securityButtonAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    self.serverPort.text = sender.selected ? SECURE_PORT : NO_SECURE_PORT;
}

// 保存服务器设置事件
- (IBAction)saveButtonAction:(UIButton *)sender {
    
    
    if(![self checkoutServerSettingInfo]) {
        return ;
    }
    
    [APPDELEGATE saveUserObj:self.serverAddress.text forKey:ServerAddressKey];
    [APPDELEGATE saveUserObj:self.serverPort.text forKey:ServerPortKey];
    [APPDELEGATE saveUserObj:@(self.securityButton.selected) forKey:SecureTransportKey];
    
    if(self.saveAction) {
        self.saveAction(sender);
    }
    
    [self cancelButtonAction:nil];
}

// 校验是否服务器设置
- (BOOL)checkoutServerSettingInfo {
    
    if(self.serverAddress.text.length == 0) {
        [APPDELEGATE showAlertMessage:@"请输入服务器地址!"];
        return NO;
    }
    
    if(self.serverPort.text.length == 0) {
        [APPDELEGATE showAlertMessage:@"请输入服务器端口!"];
        return NO;
    }
    
    return YES;
}

// 取消服务器设置事件
- (IBAction)cancelButtonAction:(UIButton *)sender {
    
    self.hidden = YES;
    
    [self showServerInfo];
    
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
