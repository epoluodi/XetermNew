//
//  UIAlertView+Alert.m
//  BockTest
//
//  Created by Klwy on 14-7-18.
//  Copyright (c) 2014年 Klwy. All rights reserved.
//

#import "UIAlertView+Alert.h"

static alertBlocks _alertBlock;

@implementation UIAlertView (Alert) 

+ (void)showMsgWithString:(NSString *)msgString
                    title:(NSString *)title
    tapButtonActionBlocks:(alertBlocks)alertBlocks
{
    _alertBlock = alertBlocks;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msgString delegate:[self self] cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    dispatch_async(MAINQ, ^{
        [alertView show];
    });

    
}

+ (void)ShowMsgWithTitleString:(NSString *)title
                     msgString:(NSString *)msgString
                   cancelTitle:(NSString *)cancelTitle
                    otherTitle:(NSString *)otherTitle
         tapButtonActionBlocks:(alertBlocks)alertBlocks
{
    _alertBlock = alertBlocks;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msgString delegate:[self self] cancelButtonTitle:cancelTitle otherButtonTitles:otherTitle, nil];
    dispatch_async(MAINQ, ^{
        [alertView show];
    });
}




+ (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    _alertBlock(buttonIndex);
}



@end
