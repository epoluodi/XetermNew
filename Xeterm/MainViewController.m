//
//  MainViewController.m
//  Xeterm
//
//  Created by Klwy on 16/10/14.
//  Copyright © 2016年 klwy. All rights reserved.
//

#import "MainViewController.h"

#import "ShortcutView.h"            // 快捷指令
#import "AdviceView.h"              // 意见反馈
#import "SidebarView.h"             // 侧边栏
#import "SocketClient.h"
#import "MoreColorText.h"

@interface MainViewController () <UITextFieldDelegate, UITextViewDelegate> // UITableViewDataSource, UITableViewDelegate,
{
    SocketClient *_client;
    ShortcutView *_shortView;                   // 快捷指令
    AdviceView *_adviceView;                    // 意见反馈
    SidebarView *_sideView;                     // 侧边栏
    
    UIView *_shieldView;            // 遮挡视图
    WaitView *_waitView;
    
    
    UIColor *_defaultColor;
    NSMutableAttributedString *_mainMutAttStr;
    
    
    // 指令显示区域
    NSString *_startWord;
    NSMutableAttributedString *_topMiddleAttrStr;
    NSAttributedString *_waitRequestStr;
    
    CGFloat _textOffset;
    CGFloat _keyboardHeight;
    
    NSRange _range;
    NSRange _temRange;
    UIFont *_textFont;
    
}

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initializeUserData];
    [self initializeUserInterface];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 页面加载完成隐藏侧边栏
    [self showSidebarViewWithState:NO];
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - Initialize

- (void)initializeUserData {
    _textFont = DEFAULT_FONT_NAME_SIZE;
    _temRange = NSMakeRange(0, 0);
    _range = NSMakeRange(0, 0);
    _keyboardHeight = 0;
    _textOffset = 0;
    _client = [SocketClient shareSocketShareInstance];
//    _defaultColor = [UIColor colorWithHexString:@"00FF00"];
    _defaultColor = DefaultGreenHexColor;
    
    _mainMutAttStr = [[NSMutableAttributedString alloc] init];
    _waitRequestStr = [[NSAttributedString alloc] init];
    
    // 指令内容区域
    _startWord = START_WORD;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginWelcomeToLanguage:) name:LoginWelcomeToLanguageKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popAlertInfo:) name:PopAlertInfoKey object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)initializeUserInterface {
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 背景颜色
    self.view.backgroundColor = [UIColor blackColor];
    
    self.textView.delegate = self;
    self.textView.autocorrectionType = UITextAutocorrectionTypeNo;
//    self.textView.font = [UIFont fontWithName:@"Courier New" size:12];
    self.textView.font = _textFont;
    _textView.layoutManager.allowsNonContiguousLayout=NO;
    
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
    // [self.view insertSubview:_shieldView belowSubview:self.adviceView];
    
    // 快捷指令视图
    _shortView = [[[NSBundle mainBundle] loadNibNamed:@"ShortcutView" owner:nil options:nil] firstObject];
    [self.view addSubview:_shortView];
    
    [_shortView setShortcutTextFieldDelegate:self];
    
    // 默认大小（260， 150）
    [_shortView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@260);
        make.height.equalTo(@150);
        make.center.equalTo(self.view);
    }];
    
    // 保存快捷指令设置
    __weak ShortcutView *weakShortView = _shortView;
    // __block UIView *shieldView = _shieldView;
    [weakShortView addSaveAction:^(UIButton *sender) {
        
        [_sideView reloadTableData];
    }];
    
    // 取消快捷指令设置
    [weakShortView addCancelAction:^(UIButton *sender) {
        _sideView.sideContentView.userInteractionEnabled = YES;
        _shieldView.hidden = YES;
        [self.view endEditing:YES];
    }];
    
    // 意见反馈视图
    _adviceView = [[[NSBundle mainBundle] loadNibNamed:@"AdviceView" owner:nil options:nil] firstObject];
    [self.view addSubview:_adviceView];
    
    [_adviceView setTextDelegate:self];
    
    // 默认大小（260， 280）
    [_adviceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@260);
        make.height.equalTo(@280);
        make.center.equalTo(self.view);
    }];
    
    // 发送意见
    __weak AdviceView *weakAdviceView = _adviceView;
    [weakAdviceView addSendAction:^(UIButton *sender) {
        [self requestAdvice];
    }];
    
    // 关闭意见
    [weakAdviceView addCloseAction:^(UIButton *sender) {
        _sideView.sideContentView.userInteractionEnabled = YES;
        _shieldView.hidden = YES;
        [self.view endEditing:YES];
    }];
    
    _waitView = [[WaitView alloc] init];
    [self.view addSubview:_waitView];
    
    [_waitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading);
        make.trailing.equalTo(self.view.mas_trailing);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    // 侧边栏
    _sideView = [[[NSBundle mainBundle] loadNibNamed:@"SidebarView" owner:nil options:nil] firstObject];
    [self.view addSubview:_sideView];
    //    [_sideView setTableDelegate:self];
    
    [_sideView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            make.width.equalTo(@220);
            make.top.equalTo(self.view);
        } else {
            make.width.equalTo(@250);
            make.top.equalTo(self.view.mas_top);//.offset(20);
        }
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    // 侧滑
    __weak SidebarView *weakSideView = _sideView;
    [weakSideView addSideAction:^(UIButton *sender) {
        [self.view endEditing:YES];
        [self showSidebarViewWithState:!sender.selected];
    }];
    // 菜单
    [weakSideView addMenuAction:^(UIButton *sender) {
        
        NSInteger index = sender.tag - 20;
        
        if(index == 0) {
            _shieldView.hidden = NO;
            _adviceView.hidden = NO;
            _sideView.sideContentView.userInteractionEnabled = NO;
        } else if(index == 1) {
            
            [UIAlertView ShowMsgWithTitleString:@"删除确认对话框" msgString:@"确定删除全部历史记录吗？" cancelTitle:@"确认" otherTitle:@"取消" tapButtonActionBlocks:^(NSInteger buttonIndex) {
                if(buttonIndex == 0) {
                    [_sideView deleteAllHistoryKey];
                }
            }];
            
        } else {
            _shieldView.hidden = NO;
            _shortView.hidden = NO;
            _sideView.sideContentView.userInteractionEnabled = NO;
        }
    }];
    // 清屏
    [weakSideView addClearAction:^(UIButton *sender) {
        _textView.text = @"";
        _mainMutAttStr = [[NSMutableAttributedString alloc] init];
        [self showDefaultColorText:_startWord];
    }];
    // 注销
    [weakSideView addLogoutAction:^(UIButton *sender) {
        
        [UIAlertView ShowMsgWithTitleString:@"注销" msgString:@"确定是否注销应用程序？" cancelTitle:@"确认" otherTitle:@"取消" tapButtonActionBlocks:^(NSInteger buttonIndex) {
            if(buttonIndex == 0) {
                _sideView.sideContentView.userInteractionEnabled = YES;
                [_client closeSocketConnection];
                [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }];
    
    // 快捷键
    [weakSideView addShortcutAction:^(NSString *key) {
        // 隐藏侧边栏
        [self showSidebarViewWithState:NO];
        
        [self showDefaultColorText:key];
//        [self requestCmdStr:key];
    }];

    
}

// 显示或隐藏侧边栏
- (void)showSidebarViewWithState:(BOOL)state {

    [_sideView updateSidebarButtonState:state];
    
    CGFloat width = _sideView.bounds.size.width-40;
    width = state ? 0 : width;

    [_sideView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            make.width.equalTo(@220);
            make.top.equalTo(self.view);
        } else {
            make.width.equalTo(@250);
            make.top.equalTo(self.view.mas_top).offset(20);
        }
        make.right.equalTo(self.view.mas_right).offset(width);
        make.bottom.equalTo(self.view);
    }];
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}


- (void)showContentText:(NSString *)str {
    
    if(self.textView.text.length != 0) {
//        [self showDefaultColorText:@"\n"];
        
        [_mainMutAttStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n" attributes:@{NSForegroundColorAttributeName: _defaultColor, NSFontAttributeName: _textFont}]];
    }
    if(str.length != 0) {
        _range.location = _textView.text.length + 1;
    }
    
    
    MoreColorText *moreColor = [MoreColorText shareMoreColorInstance];
    [_mainMutAttStr appendAttributedString:[moreColor colorTextWithString:str]];
    self.textView.attributedText = _mainMutAttStr;
    
    
    [_textView scrollRangeToVisible:NSMakeRange(_mainMutAttStr.string.length, 0)];
    _textView.selectedRange =NSMakeRange(_textView.text.length, 0);
    [_textView becomeFirstResponder];
}

- (void)showDefaultColorText:(NSString *)text {
    
    NSString *tempStr = [self lastCmdStr];
    
    _range = _temRange;
    
    
    if(_mainMutAttStr.string.length < _textView.text.length || ![tempStr hasSuffix:text]) {
    
        if(_textView.selectedRange.location >= _textView.text.length) {
            [_mainMutAttStr appendAttributedString:[[NSAttributedString alloc] initWithString:text attributes:@{NSForegroundColorAttributeName: _defaultColor, NSFontAttributeName: _textFont}]];
            self.textView.attributedText = _mainMutAttStr;
        } else {
            if(_mainMutAttStr.string.length < _textView.text.length) {
                
                _range.location -= text.length;
                _textView.selectedRange = _range;
                
            }
            
             [_mainMutAttStr insertAttributedString:[[NSAttributedString alloc] initWithString:text attributes:@{NSForegroundColorAttributeName: _defaultColor, NSFontAttributeName: _textFont}] atIndex:_textView.selectedRange.location];
            
            self.textView.attributedText = _mainMutAttStr;
            _range.location += text.length;
            _textView.selectedRange = _range;
        }
    }

    [self.textView scrollRangeToVisible:_textView.selectedRange];
}

- (void)showTitleText:(NSDictionary *)dic {
    // 顶部提示信息
    _topMiddleAttrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"【键盘可用】%@", dic[@"ep"]]];
    NSString *color = [NSString stringWithFormat:@"%@", dic[@"cl"]];
    [_topMiddleAttrStr addAttributes:@{NSForegroundColorAttributeName:[UIColor yellowColor]} range:NSMakeRange(0, 6)];
    [_topMiddleAttrStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:color]} range:NSMakeRange(6, _topMiddleAttrStr.length-6)];
    self.topMiddleLabel.attributedText = _topMiddleAttrStr;
    
    
    
    NSString *waitText = [NSString stringWithFormat:@"【接收等待】%@", dic[@"ep"]];
    _waitRequestStr = [[NSAttributedString alloc] initWithString:waitText attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"FF0000"]}];
}



#pragma mark - Notification
- (void)loginWelcomeToLanguage:(NSNotification *)notification {
    
    [self showContentText:[notification userInfo][@"message"]];
}

- (void)popAlertInfo:(NSNotification *)notification {
    
    [UIAlertView showMsgWithString:[notification userInfo][@"message"] title:Normal_Alert_Text tapButtonActionBlocks:^(NSInteger buttonIndex) {
        if(buttonIndex == 0) {
            [_client closeSocketConnection];
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (void)keyboardWillChangeFrame:(NSNotification *)noti
{
    CGSize size = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    _keyboardHeight = size.height;
    

    [_textView mas_remakeConstraints:^(MASConstraintMaker *make) {
      
//        make.top.equalTo(self.view.mas_top).offset(40);
        make.top.equalTo(self.topView.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom).offset(-_keyboardHeight);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    
 
    
    [self.view layoutIfNeeded];
//    [_textView scrollRangeToVisible:_textView.selectedRange];
}




#pragma mark - Request
- (void)requestAdvice {
    
    NSString *content = _adviceView.placeholderTV.text;
    [content stringByReplacingOccurrencesOfString:@"<" withString:@"("];
    [content stringByReplacingOccurrencesOfString:@">" withString:@")"];
    [content stringByReplacingOccurrencesOfString:@"/" withString:@"|"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"advice" forKey:@"cmd"];
    [dic setObject:_adviceView.qqTextField.text forKey:@"qq"];
    [dic setObject:content forKey:@"data"];
    
    
    [self waitViewStartAnimation];
    
    [_client sendMessage:dic sendState:^(BOOL state) {
        [self waitViewStopAnimation];
        
        if(state) {
            [APPDELEGATE showAlertTitle:@"衷心感谢" message:@"谢谢您关注我们的产品，我们将尽快给你答复！"];
        }
    }];
}

- (void)requestCmdStr:(NSString *)cmdStr {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"raw" forKey:@"cmd"];
    [dic setObject:cmdStr forKey:@"data"];
    
    [self waitViewStartAnimation];
    self.topMiddleLabel.attributedText = _waitRequestStr;

    
    [_client sendMessage:dic result:^(ServerResult *result) {
        self.topMiddleLabel.attributedText = _topMiddleAttrStr;
        [self waitViewStopAnimation];
        if([result.cmdStr isEqualToString:@"raw"]) {
            [self showContentText:result.messageStr];
        }
    }];
}


- (NSString *)lastCmdStr {
    
    NSString *text = [self.textView.text substringToIndex:self.textView.selectedRange.location];
    NSRange range = [text rangeOfString:_startWord options:NSBackwardsSearch]; // NSBackwardsSearch 表示最后的一个 // 去掉options表示从第一个开始
    if (range.location != NSNotFound)
    {
        return [text substringFromIndex:range.location+range.length];
    }

    
//    NSRange range = [self.textView.text rangeOfString:_startWord options:NSBackwardsSearch]; // NSBackwardsSearch 表示最后的一个 // 去掉options表示从第一个开始
//    if (range.location != NSNotFound)
//    {
//        return [self.textView.text substringFromIndex:range.location+range.length];
//    }
    
    return @"";
}


- (void)waitViewStartAnimation {
    [_waitView startAnimating];
    _sideView.sideContentView.userInteractionEnabled = NO;
    _sideView.tableView.userInteractionEnabled = NO;
}

- (void)waitViewStopAnimation {
    [_waitView stopAnimating];
    _sideView.sideContentView.userInteractionEnabled = YES;
    _sideView.tableView.userInteractionEnabled = YES;
}

#pragma mark - ButtonAction

// 向右箭头
- (IBAction)rightNextButtonAction:(UIButton *)sender {
    [self showDefaultColorText:_startWord];
}

// 回车
- (IBAction)enterButtonAction:(id)sender {
    [self showDefaultColorText:@"\n"];
}

// 发送
- (IBAction)sendCmdButtonAction:(id)sender {
//    [self.view endEditing:YES];
    [self showSidebarViewWithState:NO];
    
    NSString *key = [self lastCmdStr];
    [_sideView saveHistoryKey:key];
    [self showDefaultColorText:key];
    [self requestCmdStr:key];
}

#pragma mark - <UITextFieldDelegate>

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if(textField == _shortView.shortcutTextField) {
        [UIView animateWithDuration:0.5 animations:^{
            // iPhone
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                _shortView.transform = CGAffineTransformMakeTranslation(0, -80);
            } else {
                if(UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation])) {
                    _shortView.transform = CGAffineTransformMakeTranslation(0, -30);
                } else {
                    _shortView.transform = CGAffineTransformMakeTranslation(0, -150);
                }
            }
        }];
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if(textField == _shortView.shortcutTextField) {
        [UIView animateWithDuration:0.5 animations:^{
            _shortView.transform = CGAffineTransformMakeTranslation(0, 0);
        }];
    }
}


#pragma mark - <UITextViewDelegate>

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if(textView == _adviceView.placeholderTV) {
        [UIView animateWithDuration:0.5 animations:^{
            // iPhone
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                _adviceView.transform = CGAffineTransformMakeTranslation(0, -80);
            } else {
                
                if(UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation])) {
                    _adviceView.transform = CGAffineTransformMakeTranslation(0, -80);
                } else {
                    _adviceView.transform = CGAffineTransformMakeTranslation(0, -210);
                }
            }
        }];
    } else if(textView == self.textView) {
    
        _range = _textView.selectedRange;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if(textView == _textView) {
        [_textView scrollRangeToVisible:_textView.selectedRange];
        [_textView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.view.mas_top).offset(40);
            make.top.equalTo(self.topView.mas_bottom);
            make.bottom.equalTo(self.view.mas_bottom);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
        }];
        
        [self.view layoutIfNeeded];
     
        
        return ;
    }
    
    
    [UIView animateWithDuration:0.5 animations:^{
        _adviceView.transform = CGAffineTransformMakeTranslation(0, 0);
    }];
}


- (void)textViewDidChangeSelection:(UITextView *)textView {
    
    _temRange = _textView.selectedRange;
}


#pragma mark - Touches

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
