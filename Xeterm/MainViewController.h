//
//  MainViewController.h
//  Xeterm
//
//  Created by Klwy on 16/10/14.
//  Copyright © 2016年 klwy. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface MainViewController : BaseViewController

// 文本视图
@property (weak, nonatomic) IBOutlet UITextView *textView;
// 提示文本
@property (weak, nonatomic) IBOutlet UILabel *topMiddleLabel;

@property (weak, nonatomic) IBOutlet UIView *topView;
- (void)showTitleText:(NSDictionary *)dic;


@end
