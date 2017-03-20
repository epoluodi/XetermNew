//
//  ShortcutView.h
//  Xeterm
//
//  Created by Klwy on 16/10/17.
//  Copyright © 2016年 klwy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ButtonAction) (UIButton *sender);

@interface ShortcutView : UIView

/**
 *  标题
 */
@property (weak, nonatomic) IBOutlet UILabel *title;

/**
 *  快捷指令
 */
@property (weak, nonatomic) IBOutlet UITextField *shortcutTextField;

/**
 *  保存block
 */
@property (copy, nonatomic) ButtonAction saveAction;

/**
 *  取消block
 */
@property (copy, nonatomic) ButtonAction cancelAction;


/**
 *  添加保存block
 *
 *  @param action block
 */
- (void)addSaveAction:(ButtonAction)action;

/**
 *  添加取消block
 *
 *  @param action block
 */
- (void)addCancelAction:(ButtonAction)action;

/**
 *  设置快捷指令文本输入框协议代理
 *
 *  @param delegate 代理
 */
- (void)setShortcutTextFieldDelegate:(id<UITextFieldDelegate>)delegate;


@end
