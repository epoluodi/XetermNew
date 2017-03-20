//
//  WebViewController.m
//  众可贷
//
//  Created by Klwy on 15/4/8.
//  Copyright (c) 2015年 klwy. All rights reserved.
//

#import "WebViewController.h"
#import "WaitView.h"

@interface WebViewController ()
{
    WaitView *_waitView;
    UIButton *_backButton;
}


@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self inializeUserInterface];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - Initialize

- (void)inializeUserInterface
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.webView setScalesPageToFit:YES];
    
    self.webView.delegate = self;

    NSString *urlStr = [_webUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *baseUrl = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:baseUrl
                                                  cachePolicy:NSURLRequestUseProtocolCachePolicy
                                              timeoutInterval:10.0];
    [self.webView loadRequest:request];
    
    _waitView = [[WaitView alloc] init];
    [self.view addSubview:_waitView];
    
    [_waitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading);
        make.trailing.equalTo(self.view.mas_trailing);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    _backButton = [[UIButton alloc] init];
    _backButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_backButton setTitle:@"返 回" forState:UIControlStateNormal];
    [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _backButton.backgroundColor = [UIColor colorWithHexString:@"00a0e9"];
    [_backButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    _backButton.layer.cornerRadius = 25;
    _backButton.layer.masksToBounds = YES;
    [self.view addSubview:_backButton];
    
    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@50);
        make.height.equalTo(@50);
        make.top.equalTo(self.view.mas_top).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
    }];
    
    // 拖拽
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureReconizer:)];
    [_backButton addGestureRecognizer:pan];
}


#pragma mark - ButtonAction

- (void)backButtonPressed:(UIButton *)sender
{
    if(self.webCanBack)
    {
        if ([self.webView canGoBack]) {
            [self.webView  goBack];
        }
        else
        {
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
    }
    else
    {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    
}

#pragma mark - UIWebViewDeletage

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [_waitView startAnimating];
//    NSLog(@"开始 rul = %@", webView.request.URL.absoluteString);

}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [_waitView stopAnimating];
//    NSLog(@"结束 rul = %@", webView.request.URL.absoluteString);
}


#pragma mark - UIGestureRecognizer

// 手势滑动事件，侧滑效果
- (void)panGestureReconizer:(UIPanGestureRecognizer *)gesture
{
    static CGPoint startCenter;
    
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        startCenter = _backButton.center;
    }
    else if (gesture.state == UIGestureRecognizerStateChanged)
    {
        // 此处必须从self.view中获取translation，因为translation和view的transform属性挂钩，若transform改变了则translation也会变
        CGPoint translation = [gesture translationInView:self.view];
        
        _backButton.center = CGPointMake(startCenter.x+translation.x, startCenter.y+translation.y);
    }
    else if (gesture.state == UIGestureRecognizerStateEnded)
    {
        startCenter = CGPointZero;
    }
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
