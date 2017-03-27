//
//  ViewController.h
//  Xeterm
//
//  Created by Klwy on 16/10/14.
//  Copyright © 2016年 klwy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreServer.h"
@interface LoginViewController : BaseViewController<CoreServerDelegate>

// 帐号
@property (weak, nonatomic) IBOutlet __block UITextField *nameTextField;
// 密码
@property (weak, nonatomic) IBOutlet __block UITextField *pwdTextField;
// 记住密码按键
@property (weak, nonatomic) IBOutlet UIButton *rememberPwdButton;
// 登录按键
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (weak, nonatomic) IBOutlet UIButton *payButton;

@end

