//
//  UIAlertView+Alert.h
//  BockTest
//
//  Created by Klwy on 14-7-18.
//  Copyright (c) 2014年 Klwy. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  协议回调代码块
 *
 *  @param buttonIndex 按键索引
 */
typedef void(^alertBlocks)(NSInteger buttonIndex);

@interface UIAlertView (Alert)// <UIAlertViewDelegate>


/**
 *  自定义封装AlertView
 *
 *  @param msgString   消息内容
 *  @param title       警告标题
 *  @param alertBlocks 回调代码块
 */
+ (void)showMsgWithString:(NSString *)msgString
                    title:(NSString *)title
    tapButtonActionBlocks:(alertBlocks)alertBlocks;

/**
 *  自定义封装AlertView
 *
 *  @param title       警告标题
 *  @param msgString   消息内容
 *  @param cancelTitle 取消按键标题
 *  @param otherTitle  其他按键标题
 *  @param alertBlocks 回调代码块
 */
+ (void)ShowMsgWithTitleString:(NSString *)title
                     msgString:(NSString *)msgString
                   cancelTitle:(NSString *)cancelTitle
                    otherTitle:(NSString *)otherTitle
         tapButtonActionBlocks:(alertBlocks)alertBlocks;

@end
