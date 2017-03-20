//
//  SidebarView.h
//  Xeterm
//
//  Created by Klwy on 16/10/17.
//  Copyright © 2016年 klwy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ShortcutAction) (NSString *key);
typedef void(^ButtonAction) (UIButton *sender);

@interface SidebarView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (assign, nonatomic, readonly) BOOL listType;
@property (strong, nonatomic, readonly) NSMutableArray *historyArray;
@property (strong, nonatomic, readonly) NSMutableArray *shortcutArray;

@property (strong, nonatomic, readonly) NSMutableArray *dataArray;

/**
 *  侧边栏内容视图
 */
@property (weak, nonatomic) IBOutlet UIView *sideContentView;

/**
 *  历史指令列表
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/**
 *  侧滑按键
 */
@property (weak, nonatomic) IBOutlet UIButton *sideButton;

/**
 *  菜单按键
 */
@property (weak, nonatomic) IBOutlet UIButton *menuButton;

/**
 *  信息
 */
@property (weak, nonatomic) IBOutlet UIButton *infoButton;

/**
 *  历史
 */
@property (weak, nonatomic) IBOutlet UIButton *historyButton;

/**
 *  快捷
 */
@property (weak, nonatomic) IBOutlet UIButton *shortcutButton;


/**
 *  菜单按键列表
 */
@property (strong, nonatomic, readonly) NSArray *menuButtonArray;

/**
 *  菜单标题列表
 */
@property (strong, nonatomic, readonly) NSArray *menuTitleArray;

/**
 *  侧滑block
 */
@property (copy, nonatomic) ButtonAction sideAction;

/**
 *  菜单block
 */
@property (copy, nonatomic) ButtonAction menuAction;


/**
 *  清屏block
 */
@property (copy, nonatomic) ButtonAction clearAction;

/**
 *  注销block
 */
@property (copy, nonatomic) ButtonAction logoutAction;

/**
 *  快捷指令block
 */
@property (copy, nonatomic) ShortcutAction shortAction;

/**
 *  添加侧滑block
 *
 *  @param action block
 */
- (void)addSideAction:(ButtonAction)action;

/**
 *  添加菜单block
 *
 *  @param action block
 */
- (void)addMenuAction:(ButtonAction)action;

/**
 *  添加清屏block
 *
 *  @param action block
 */
- (void)addClearAction:(ButtonAction)action;

/**
 *  添加注销block
 *
 *  @param action block
 */
- (void)addLogoutAction:(ButtonAction)action;

/**
 *  添加快捷指令block
 *
 *  @param action block
 */
- (void)addShortcutAction:(ShortcutAction)action;


/**
 *  删除所有历史指令
 */
- (void)deleteAllHistoryKey;

/**
 *  保存历史指令
 */
- (void)saveHistoryKey:(NSString *)key;

/**
 *  刷新历史指令列表数据
 */
- (void)reloadTableData;



/**
 *  刷新快捷指令列表数据
 */
//- (void)reloadShortcutTableData;

/**
 *  更新侧滑按键状态
 *
 *  @param state 更新状态
 */
- (void)updateSidebarButtonState:(BOOL)state;

@end
