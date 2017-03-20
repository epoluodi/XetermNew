//
//  SidebarView.m
//  Xeterm
//
//  Created by Klwy on 16/10/17.
//  Copyright © 2016年 klwy. All rights reserved.
//

#import "SidebarView.h"

@implementation SidebarView

- (void)awakeFromNib {
    
    NSString *path = [APPDELEGATE readPlistPathWithName:ShortcutListPlistName];
    _shortcutArray = [NSMutableArray arrayWithArray:[APPDELEGATE readPlistArrayWithPlistPath:path]];
    
    path = [APPDELEGATE readPlistPathWithName:HistoryListPlistName];
    _historyArray = [NSMutableArray arrayWithArray:[APPDELEGATE readPlistArrayWithPlistPath:path]];
    
    _dataArray = [NSMutableArray arrayWithArray:_historyArray];
    _listType = NO; // 默认历史指令
    
    self.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
    
    // 设置FooterView，隐藏多余单元行
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
    
    
    _menuButtonArray = @[self.infoButton, self.historyButton, self.shortcutButton];
    _menuTitleArray = @[@"【意见反馈】", @"【清空历史指令】", @"【添加快捷指令】"];
    
    [self topMenuButtonAction:self.infoButton];
}

// 添加侧滑block
- (void)addSideAction:(ButtonAction)action {
    
    self.sideAction = nil;
    self.sideAction = action;
}

// 添加菜单block
- (void)addMenuAction:(ButtonAction)action {
    
    self.menuAction = nil;
    self.menuAction = action;
}

// 添加清屏block
- (void)addClearAction:(ButtonAction)action {
    
    self.clearAction = nil;
    self.clearAction = action;
}

// 添加注销block
- (void)addLogoutAction:(ButtonAction)action {
    
    self.logoutAction = nil;
    self.logoutAction = action;
}

// 添加快捷指令block
- (void)addShortcutAction:(ShortcutAction)action {
    self.shortAction = nil;
    self.shortAction = action;
}


- (void)deleteAllHistoryKey {
    
    if(_dataArray.count != 0) {
        
        NSString *path = [APPDELEGATE readPlistPathWithName:HistoryListPlistName];
        [APPDELEGATE savePlistArray:@[] plistPath:path];
//        _dataArray = [APPDELEGATE readPlistArrayWithPlistPath:path];
        [_dataArray removeAllObjects];
        [_historyArray removeAllObjects];
        
        [self reloadTableData];
    }
}

// 刷新指令列表数据
- (void)reloadTableData {
    [_dataArray removeAllObjects];
    // 快捷指令
    if(_listType) {
        
        [_shortcutArray removeAllObjects];
        
        NSString *shortcutPath = [APPDELEGATE readPlistPathWithName:ShortcutListPlistName];
        _shortcutArray = [NSMutableArray arrayWithArray:[APPDELEGATE readPlistArrayWithPlistPath:shortcutPath]];
        
        [_dataArray addObjectsFromArray:_shortcutArray];
    } else {
        
        [_dataArray addObjectsFromArray:_historyArray];
    }
    
    [self.tableView reloadData];
}


- (void)saveHistoryKey:(NSString *)key {
    
    NSString *path = [APPDELEGATE readPlistPathWithName:HistoryListPlistName];
    
    if(![_historyArray containsObject:key]) {
        [_historyArray addObject:key];
        [APPDELEGATE savePlistArray:_historyArray plistPath:path];
    }
    
    if(!_listType) {
        [self reloadTableData];
    }
    
    return ;
}

// 更新侧滑按键状态
- (void)updateSidebarButtonState:(BOOL)state {
    
    self.sideButton.selected = state;
}


#pragma mark - ButtonAction

// 侧滑事件
- (IBAction)sideButtonAction:(UIButton *)sender {
    
    if(self.sideAction) {
        self.sideAction(sender);
    }
    
}

// 菜单事件
- (IBAction)menuButtonAction:(UIButton *)sender {
    
    if(self.menuAction) {
        self.menuAction(sender);
    }
}

// 清屏事件
- (IBAction)clearButtonAction:(UIButton *)sender {
    
    if(self.clearAction) {
        self.clearAction(sender);
    }
}


// 注销事件
- (IBAction)logoutButtonAction:(UIButton *)sender {
    
    if(self.logoutAction) {
        self.logoutAction(sender);
    }
}


// 菜单选择
- (IBAction)topMenuButtonAction:(UIButton *)sender {
    
    NSInteger index = sender.tag - 10;
    
    UIButton *button = nil;
    for(int i = 0; i < _menuButtonArray.count; i++) {
        
        button = (UIButton *)_menuButtonArray[i];
        
        if(i == index) {
            button.selected = YES;
            button.backgroundColor = [UIColor colorWithHexString:@"2473dc"];
        } else {
            button.selected = NO;
            button.backgroundColor = [UIColor colorWithHexString:@"547aed"];
        }
    }
    
    button = nil;
    
    self.menuButton.tag = sender.tag + 10;
    [self.menuButton setTitle:_menuTitleArray[index] forState:UIControlStateNormal];
    
    
    self.tableView.hidden = index != 0 ? NO : YES;
    
    if(index == 1) {
        _listType = NO;
        [self reloadTableData];
    } else if(index == 2) {
        _listType = YES;
        [self reloadTableData];
    }
}




#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", _dataArray[indexPath.row]];
    
    return cell;
}


#pragma mark - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.shortAction(_dataArray[indexPath.row]);
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [_dataArray removeObjectAtIndex:indexPath.row];
    
    if(_listType) {
        [_shortcutArray removeObjectAtIndex:indexPath.row];
        
        NSString *path = [APPDELEGATE readPlistPathWithName:ShortcutListPlistName];
        [APPDELEGATE savePlistArray:_shortcutArray plistPath:path];
        
    } else {
        [_historyArray removeObjectAtIndex:indexPath.row];
        
        NSString *path = [APPDELEGATE readPlistPathWithName:HistoryListPlistName];
        [APPDELEGATE savePlistArray:_historyArray plistPath:path];
    }
    
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
