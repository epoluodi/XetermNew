//
//  AppDelegate.h
//  Xeterm
//
//  Created by Klwy on 16/10/14.
//  Copyright © 2016年 klwy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/**
 *  保存用户数据
 *
 *  @param obj Value
 *  @param key Key
 */
- (void)saveUserObj:(id)obj forKey:(NSString *)key;

/**
 *  读取用户数据
 *
 *  @param key Key
 *
 *  @return Value
 */
- (id)readUserObjForKey:(NSString *)key;

/**
 *  获取文件路径
 *
 *  @param plistName 文件名称
 *
 *  @return 文件路径
 */
- (NSString *)readPlistPathWithName:(NSString *)plistName;

/**
 *  读取文件数据
 *
 *  @param plistPath 文件路径
 *
 *  @return 文件数据
 */
- (NSArray *)readPlistArrayWithPlistPath:(NSString *)plistPath;

/**
 *  保存文件数据
 *
 *  @param array     文件数据
 *  @param plistPath 文件路径
 */
- (void)savePlistArray:(NSArray *)array plistPath:(NSString *)plistPath;

/**
 *  判断是否为字符串
 *
 *  @param text 判断对象
 *
 *  @return 字符串
 */
- (NSString *)judgeStringContent:(id)content;

/**
 *  显示提示信息，不自动隐藏
 *
 *  @param message 提示内容
 */
- (void)showAlertMessage:(NSString *)message;

- (void)showAlertTitle:(NSString *)title message:(NSString *)message;


@end

