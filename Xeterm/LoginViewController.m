//
//  ViewController.m
//  Xeterm
//
//  Created by Klwy on 16/10/14.
//  Copyright © 2016年 klwy. All rights reserved.
//

#import "LoginViewController.h"

#import "MainViewController.h"              // 主视图
#import "VersionInfoView.h"                 // 版本信息
#import "ServerSettingsView.h"              // 服务器设置
#import "SFHFKeychainUtils.h"               // 访问钥匙串
#import "WebViewController.h"
#import "ToolUtil.h"


@interface LoginViewController () <UITextFieldDelegate>
{
    UIView *_shieldView;            // 遮挡视图
    
    VersionInfoView *_versionView;          // 版本信息
    ServerSettingsView *_settingView;       // 服务器设置
    
    SocketClient *_client;
    WaitView *_waitView;
    __block CoreServer *_coreServer;     //网络交互控制类
}



@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //设置网络交互控制类
    _coreServer = [[CoreServer alloc] init];
    _coreServer.delegate = self;
    
    
    [self initializeUserData];
    [self initializeUserInterface];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Initialize

- (void)initializeUserData {
    
    _client = [SocketClient shareSocketShareInstance];
    
}

- (void)initializeUserInterface {
    
    // 登录页面
    [self showLoginView];
    
    // 遮挡视图
    _shieldView = [[UIView alloc] init];
    _shieldView.backgroundColor = [UIColor blackColor];
    _shieldView.alpha = 0.3;
    _shieldView.hidden = YES;
    [self.view addSubview:_shieldView];
    
    [_shieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading);
        make.trailing.equalTo(self.view.mas_trailing);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    // 将_shieldView插入制定视图之下
    // [self.view insertSubview:_shieldView belowSubview:_versionView];
    
    // 版本信息
    _versionView = [[[NSBundle mainBundle] loadNibNamed:@"VersionInfoView" owner:nil options:nil] firstObject];
    [self.view addSubview:_versionView];
    
    // 默认大小（300，265）
    [_versionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@300);
        make.height.equalTo(@265);
        make.center.equalTo(self.view);
    }];
    
    // 关闭版本信息
    //    __block UIView *shieldView = _shieldView;
    __weak VersionInfoView *weakVersionView = _versionView;
    [weakVersionView addCloseAction:^(UIButton *sender) {
        _shieldView.hidden = YES;
    }];
    
    // 服务器设置
    _settingView = [[[NSBundle mainBundle] loadNibNamed:@"ServerSettingsView" owner:nil options:nil] firstObject];
    [self.view addSubview:_settingView];
    // 设置协议代理
    [_settingView setServerSettingTextFieldDelegate:self];
    
    // 默认大小（260， 240）
    [_settingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@260);
        make.height.equalTo(@240);
        make.center.equalTo(self.view);
    }];
    

    // 保存服务器设置
    __weak ServerSettingsView *weakSettingView= _settingView;
    [weakSettingView addSaveAction:^(UIButton *sender) {
      
    }];
    
    // 取消服务器设置
    [weakSettingView addCancelAction:^(UIButton *sender) {
        
        _shieldView.hidden = YES;
    }];
    
    _waitView = [[WaitView alloc] init];
    _waitView.isBgHide = YES;
    [self.view addSubview:_waitView];
    
    [_waitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading);
        make.trailing.equalTo(self.view.mas_trailing);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

// 显示登录页面
- (void)showLoginView {
    
    self.nameTextField.text = [APPDELEGATE judgeStringContent:[APPDELEGATE readUserObjForKey:UserNameKey]];
    
    self.rememberPwdButton.selected = [[APPDELEGATE readUserObjForKey:RememberPwdKey] boolValue];
    
    if(self.rememberPwdButton.selected) {
        
        self.pwdTextField.text = [APPDELEGATE judgeStringContent:[APPDELEGATE readUserObjForKey:PasswordKey]];
    }
}

#pragma mark - ButtonAction

// 登录
- (IBAction)loginButtonAction:(UIButton *)sender {
    
    if(![self checkoutUserLoginInfo]) {
        return ;
    }
  

    [_waitView startAnimating];
    // 建立连接
    [_client createSocketConnectionWithHost:_client.host port:_client.port success:^(BOOL state) {
        _coreServer.client = _client;
        _coreServer.serverAddress=_settingView.serverAddress.text;
        _coreServer.serverPort=_settingView.serverPort.text;
        _coreServer.userName =_nameTextField.text;
        _coreServer.userPwd = _pwdTextField.text;
        _coreServer.appVer = _versionView.appVersion;
        [_coreServer requestNDS];
     

    } failure:^(BOOL state) {
        dispatch_async(MAINQ, ^{
            [_waitView stopAnimating];
        });
    }];
}

/**
 *  校验登录信息
 *
 *  @return 校验结果
 */
- (BOOL)checkoutUserLoginInfo {
    
    // 去除无效空格符
    self.nameTextField.text = [self.nameTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if(self.nameTextField.text.length == 0) {
        [APPDELEGATE showAlertMessage:@"请填写您的帐户号码!"];
        return NO;
    }
    
    
    self.pwdTextField.text = [self.pwdTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if(self.pwdTextField.text.length == 0) {
        [APPDELEGATE showAlertMessage:@"请填写您的登录密码!"];
        return NO;
    }
    
    if(_settingView.serverAddress.text.length == 0) {
        [APPDELEGATE showAlertMessage:@"请设置服务器地址!"];
        return NO;
    }
    
    if(_settingView.serverPort.text.length == 0) {
        [APPDELEGATE showAlertMessage:@"请设置服务器端口!"];
        return NO;
    }
    
    return YES;
}


// 记住密码
- (IBAction)rememberPwdButtonAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    [APPDELEGATE saveUserObj:@(sender.selected) forKey:RememberPwdKey];
}

// 服务器设置
- (IBAction)serverSetButtonAction:(UIButton *)sender {
    
    _shieldView.hidden = NO;
    _settingView.hidden = NO;
}

// 版本信息
- (IBAction)versionInfoButtonAction:(UIButton *)sender {
    
    _shieldView.hidden = NO;
    _versionView.hidden = NO;
}

// 价格
- (IBAction)priceButtonAction:(UIButton *)sender {
    WebViewController *webVC = [[WebViewController alloc] init];
    webVC.webUrl = [self payParaString];
    webVC.webCanBack = YES;
    [self presentViewController:webVC animated:YES completion:nil];
}

- (NSString *)payParaString {
    // 0-100;
    NSInteger num = arc4random()%101;
    NSString *para = [NSString stringWithFormat:@"%@|%@", _versionView.appProductSerialNo, @(num)];
    
    return [NSString stringWithFormat:@"http://www.sixiang-soft.com/trade/?para=%@", [ToolUtil hexStringFromString:para]];
}


#pragma mark CoreServerDelegate

-(void)PayResult:(Boolean)on
{
    self.payButton.hidden =on;
}

-(void)WaitViewStop
{
    [_waitView stopAnimating];
}

-(void)openMainViewController:(NSDictionary *)loginDic
{
    MainViewController *mainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    
    [self presentViewController:mainVC animated:YES completion:^{
        
        [mainVC showTitleText:loginDic];
        
        [APPDELEGATE saveUserObj:self.nameTextField.text forKey:UserNameKey];
        [APPDELEGATE saveUserObj:self.pwdTextField.text forKey:PasswordKey];
    }];

}
#pragma mark -




#pragma mark - <UITextFieldDelegate>

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if(textField == _settingView.serverPort) {
        [UIView animateWithDuration:0.5 animations:^{
            // iPhone
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                _settingView.transform = CGAffineTransformMakeTranslation(0, -40);
            } else {
                if(UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])) {
                    _settingView.transform = CGAffineTransformMakeTranslation(0, -40);
                }
            }
        }];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if(textField == _settingView.serverPort) {
        [UIView animateWithDuration:0.5 animations:^{
            if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                _settingView.transform = CGAffineTransformMakeTranslation(0, 0);
            } else {
                if(UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])) {
                    _settingView.transform = CGAffineTransformMakeTranslation(0, 0);
                }
            }
        }];
    }
}

#pragma mark - Touches

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}





@end
