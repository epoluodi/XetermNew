//
//  AppDelegate.m
//  Xeterm
//
//  Created by Klwy on 16/10/14.
//  Copyright © 2016年 klwy. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 启动页面停留0.3秒
    [NSThread sleepForTimeInterval:5];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - UserInfo
// 保存用户数据
- (void)saveUserObj:(id)obj forKey:(NSString *)key {
    
    [[NSUserDefaults standardUserDefaults] setObject:obj forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 读取用户数据
- (id)readUserObjForKey:(NSString *)key {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

// 读取文件路径
- (NSString *)readPlistPathWithName:(NSString *)plistName {
    // 文件路径
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [documentDirectory stringByAppendingPathComponent:plistName];
    
    return path;
}

// 读取文件数据
- (NSArray *)readPlistArrayWithPlistPath:(NSString *)plistPath {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL exists = [fileManager fileExistsAtPath:plistPath];
    
    if(!exists) {
        return @[];
    }
    
    return [NSArray arrayWithContentsOfFile:plistPath];
}

// 保存文件数据
- (void)savePlistArray:(NSArray *)array plistPath:(NSString *)plistPath
{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL exists = [fileManager fileExistsAtPath:plistPath];
    
    if(!exists)
    {
        BOOL success = [@[] writeToFile:plistPath atomically:YES];
        if(!success)
        {
            NSAssert(NO, Fail_Plist_Write);
        }
    }
    
    [array writeToFile:plistPath atomically:YES];
}



// 判断是否为字符串
- (NSString *)judgeStringContent:(id)content
{
    if([content isKindOfClass:[NSString class]])
    {
        return content;
    }
    
    return @"";
}

// 显示提示信息，不自动隐藏
- (void)showAlertMessage:(NSString *)message {
    [[[UIAlertView alloc] initWithTitle:@"温馨提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
}

- (void)showAlertTitle:(NSString *)title message:(NSString *)message {
    [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
}

@end
