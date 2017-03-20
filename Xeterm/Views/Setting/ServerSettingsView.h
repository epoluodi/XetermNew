//
//  ServerSettingsView.h
//  Xeterm
//
//  Created by Klwy on 16/10/16.
//  Copyright © 2016年 klwy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ButtonAction) (UIButton *sender);

@interface ServerSettingsView : UIView

/**
 *  标题
 */
@property (weak, nonatomic) IBOutlet UILabel *title;

/**
 *  服务器地址
 */
@property (weak, nonatomic) IBOutlet UITextField *serverAddress;

/**
 *  服务器端口
 */
@property (weak, nonatomic) IBOutlet UITextField *serverPort;

/**
 *  安全传输
 */
@property (weak, nonatomic) IBOutlet UIButton *securityButton;

/**
 *  保存block
 */
@property (copy, nonatomic) ButtonAction saveAction;

/**
 *  取消block
 */
@property (copy, nonatomic) ButtonAction cancelAction;


/**
 *  添加保存block
 *
 *  @param action block
 */
- (void)addSaveAction:(ButtonAction)action;

/**
 *  添加取消block
 *
 *  @param action block
 */
- (void)addCancelAction:(ButtonAction)action;

/**
 *  设置服务器设置文本输入框协议代理
 *
 *  @param delegate 代理
 */
- (void)setServerSettingTextFieldDelegate:(id<UITextFieldDelegate>)delegate;


@end
