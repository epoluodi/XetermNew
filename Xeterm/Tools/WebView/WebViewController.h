//
//  WebViewController.h
//  众可贷
//
//  Created by Klwy on 15/4/8.
//  Copyright (c) 2015年 klwy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : BaseViewController <UIWebViewDelegate>



@property (nonatomic, copy) NSString *webUrl;
@property (nonatomic, copy) NSString *webTitle;
@property (nonatomic, assign) BOOL webCanBack;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
