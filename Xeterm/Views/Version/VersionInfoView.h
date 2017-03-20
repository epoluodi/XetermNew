//
//  VersionInfoView.h
//  Xeterm
//
//  Created by Klwy on 16/10/16.
//  Copyright © 2016年 klwy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ButtonAction) (UIButton *sender);

@interface VersionInfoView : UIView

@property(strong, nonatomic, readonly) NSString *appVersion;
@property(strong, nonatomic, readonly) NSString *appProductSerialNo;

/**
 *  标题
 */
@property (weak, nonatomic) IBOutlet UILabel *title;

/**
 *  版本号
 */
@property (weak, nonatomic) IBOutlet UILabel *versionNum;

/**
 *  发布时间
 */
@property (weak, nonatomic) IBOutlet UILabel *publishDate;

/**
 *  产品序列
 */
@property (weak, nonatomic) IBOutlet UILabel *productNum;

/**
 *  开发者
 */
@property (weak, nonatomic) IBOutlet UILabel *developerName;

/**
 *  服务QQ号
 */
@property (weak, nonatomic) IBOutlet UILabel *serviceQQ;

/**
 *  关闭block
 */
@property (copy, nonatomic) ButtonAction closeAction;

/**
 *  添加关闭block
 *
 *  @param action block
 */
- (void)addCloseAction:(ButtonAction)action;

@end
