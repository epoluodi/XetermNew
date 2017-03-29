//
//  AppDelegate.m
//  ZK
//
//  Created by ChenY on 14-5-19.
//  Copyright (c) 2014年 Klwy. All rights reserved.
//

#ifndef Klwy_Define_h
#define Klwy_Define_h

// 屏幕大小
#define SCREEN_SIZE     [[UIScreen mainScreen] bounds].size
#define SCREEN_WIDTH    [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT   [[UIScreen mainScreen] bounds].size.height





// Debug开关
#define Debug_Open NO

// 应用程序代理
#define APPDELEGATE (AppDelegate *)[[UIApplication sharedApplication] delegate]

//格式化时间戳
#define FormatTime(date) [NSString stringWithFormat:@"%.0lf",([date timeIntervalSince1970]*1000)]

//格式化时间
#define DateFromTimeInterval(timeInterval) [NSDate dateWithTimeIntervalSince1970:(timeInterval)/1000]

// 加载本地图片
#define IMAGE_WITH_NAME(_NAME) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForAuxiliaryExecutable:(_NAME)]]

// RGB颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue)\
\
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]

/************************Notification*******************************/

#define LoginWelcomeToLanguageKey @"LoginWelcomeToLanguage"
#define PopAlertInfoKey @"popAlertInfo"

/************************ValueKey*******************************/

// UUID钥匙串访问
#define UUID_KEY_SERVICE_NAME @"uuid_klwy-app_com.klwy.xeterm"
#define UUID_KEY_NAME @"uuid_klwy_com.klwy.xeterm"

// 帐号
#define UserNameKey @"userName"
// 密码
#define PasswordKey @"password"
// 记住密码
#define RememberPwdKey @"rememberPwd"

// 服务器地址
#define ServerAddressKey @"serverAddress"
// 服务器端口
#define ServerPortKey @"serverPortKey"
// 安全传输
#define SecureTransportKey @"SecureTransport"


#define REPLATED_START_FLAG @"$$"
//#define START_WORD @"▶"
#define START_WORD @"▸"
#define SECURE_PORT @"443"
#define NO_SECURE_PORT @"350"
#define DEFAULT_FONT_NAME_SIZE [UIFont fontWithName:@"Courier New" size:12]
#define DefaultGreenHexColor [UIColor colorWithHexString:@"00FF00"]


/************************Plist*****************************/

#define HistoryListPlistName @"historyList.plist"
#define ShortcutListPlistName @"shortcutList.plist"


/************************AlertText*****************************/

#define Normal_Alert_Text @"温馨提示"
#define Fail_Plist_Write @"文件写入失败"

#define GLOBALQ dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define MAINQ dispatch_get_main_queue()

#endif




