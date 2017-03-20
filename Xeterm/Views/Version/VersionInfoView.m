//
//  VersionInfoView.m
//  Xeterm
//
//  Created by Klwy on 16/10/16.
//  Copyright © 2016年 klwy. All rights reserved.
//

#import "VersionInfoView.h"
#import "SFHFKeychainUtils.h"
#import "ToolUtil.h"

@implementation VersionInfoView

- (void)awakeFromNib {
    
    self.hidden = YES;
    
    [self showVersionInfo];
}

- (void)showVersionInfo {
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // APP名称
    // APP 版本号
    _appVersion = [NSString stringWithFormat:@"%@", [infoDictionary objectForKey:@"CFBundleShortVersionString"]];
    self.versionNum.text = [NSString stringWithFormat:@"软件版本：%@", _appVersion];
    _appProductSerialNo = [self getProductSerialNo];
    self.productNum.text = [NSString stringWithFormat:@"产品序列：%@", _appProductSerialNo];
}

/**
 *  添加关闭block
 *
 *  @param action block
 */
- (void)addCloseAction:(ButtonAction)action {
    
    self.closeAction = nil;
    self.closeAction = action;
}

/**
 *  关闭事件
 *
 *  @param sender 关闭按键
 */
- (IBAction)closeButtonAction:(UIButton *)sender {
    
    self.hidden = YES;
    
    if(self.closeAction) {
        self.closeAction(sender);
    }
}


- (NSString *)getProductSerialNo {
    
    NSString *uuid =  [SFHFKeychainUtils getPasswordForUsername:UUID_KEY_NAME
                                                 andServiceName:UUID_KEY_SERVICE_NAME
                                                          error:nil];
    if(!uuid)
    {
        uuid = [[UIDevice currentDevice].identifierForVendor UUIDString];
        [SFHFKeychainUtils storeUsername:UUID_KEY_NAME
                             andPassword:uuid
                          forServiceName:UUID_KEY_SERVICE_NAME
                          updateExisting:1
                                   error:nil];
    }
    
    NSString *doubleMD5 = [ToolUtil MD5String:[ToolUtil MD5String:uuid]];
    
    NSMutableString *serialNo = [NSMutableString string];
    [serialNo appendString:[doubleMD5 substringWithRange:NSMakeRange(13, 1)]];
    [serialNo appendString:[doubleMD5 substringWithRange:NSMakeRange(21, 1)]];
    [serialNo appendString:[doubleMD5 substringWithRange:NSMakeRange(6, 1)]];
    [serialNo appendString:[doubleMD5 substringWithRange:NSMakeRange(30, 1)]];
    [serialNo appendString:@"-"];
    [serialNo appendString:[doubleMD5 substringWithRange:NSMakeRange(5, 1)]];
    [serialNo appendString:[doubleMD5 substringWithRange:NSMakeRange(29, 1)]];
    [serialNo appendString:[doubleMD5 substringWithRange:NSMakeRange(17, 1)]];
    [serialNo appendString:[doubleMD5 substringWithRange:NSMakeRange(11, 1)]];
    [serialNo appendString:@"-"];
    [serialNo appendString:[doubleMD5 substringWithRange:NSMakeRange(15, 1)]];
    [serialNo appendString:[doubleMD5 substringWithRange:NSMakeRange(20, 1)]];
    [serialNo appendString:[doubleMD5 substringWithRange:NSMakeRange(7, 1)]];
    [serialNo appendString:[doubleMD5 substringWithRange:NSMakeRange(24, 1)]];
    [serialNo appendString:@"-"];
    [serialNo appendString:[doubleMD5 substringWithRange:NSMakeRange(19, 1)]];
    [serialNo appendString:[doubleMD5 substringWithRange:NSMakeRange(23, 1)]];
    [serialNo appendString:[doubleMD5 substringWithRange:NSMakeRange(3, 1)]];
    [serialNo appendString:[doubleMD5 substringWithRange:NSMakeRange(4, 1)]];
    
    return serialNo;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */



@end
