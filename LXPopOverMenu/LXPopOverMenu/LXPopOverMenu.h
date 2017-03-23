//
//  LXPopOverMenu.h
//  LXPopOverMenu
//
//  Created by NiceForMe on 16/11/28.
//  Copyright © 2016年 BHEC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^LXPopOverMenuDoneBlock)(NSInteger selectIndex);
typedef void (^LXPopOverMenuDismiss)();

typedef NS_ENUM(NSUInteger,LXPopOverMenuDirection){
    PopOverMenuDownDirection,//菜单向下显示
    PopOverMenuUpDirection//菜单向上显示
};
/**
 *  -----------------------LXPopOverMenu-----------------------
 */
@interface LXPopOverMenu : NSObject
@property (nonatomic,assign) LXPopOverMenuDoneBlock doneBlock;
@property (nonatomic,assign) LXPopOverMenuDismiss dismissBlock;
@property (nonatomic,assign) LXPopOverMenuDirection direction;
/**
 *  show menu with view with nameArray and imageArray
 *
 *  @param view 要添加下拉（上拉）菜单的视图
 *  @param nameArray   菜单的文字数组
 *  @param imageNameArray 菜单的图片数组
 *  @param doneBlock doneBlock
 *  @param dismissBlock dismissBlock
 */
+ (void)showPopOverMenu:(UIView *)view withMenuCellNameArray:(NSArray<NSString *>*)nameArray imageNameArray:(NSArray<NSString *>*)imageNameArray menuDirection:(LXPopOverMenuDirection)direction doneBlock:(LXPopOverMenuDoneBlock)doneBlock dismissBlock:(LXPopOverMenuDismiss)dismissBlock;

@end

/**
 *  -----------------------LXPopOverMenuTableViewCell-----------------------
 */
typedef NS_ENUM(NSUInteger,CellModel){
    LXPopOverMenuTableViewCommenCell,//只有文字
    LXPopOverMenuTableViewIconCell//图文都有
};
@interface LXPopOverMenuTableViewCell : UITableViewCell
@property (nonatomic,strong) UILabel *nameLable;
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,assign) CellModel cellModel;
/**
 *  init tableViewCell
 *
 *  @param cellModel cellModel
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView cellModel:(CellModel)cellModel;
@end

/**
 *  -----------------------LXPopOverMenuTableView-----------------------
 */
@interface LXPopOverMenuTableView : UIControl
@property (nonatomic,strong) UITableView *menuTableView;
@property (nonatomic,strong) NSMutableArray *nameArray;
@property (nonatomic,strong) NSMutableArray *imageArray;
@property (nonatomic,copy) LXPopOverMenuDoneBlock doneBlock;
@property (nonatomic,copy) LXPopOverMenuDismiss dismissBlock;
/**
 *  show menu with view with nameArray and imageArray
 *
 *  @param superView 要添加下拉（上拉）菜单的视图
 *  @param nameArray   菜单的文字数组
 *  @param imageNameArray 菜单的图片数组
 *  @param doneBlock doneBlock
 *  @param dismissBlock dismissBlock
 */
- (void)showTableViewWithSuperView:(UIView *)superView menuCellNameArray:(NSArray<NSString *> *)nameArray imageNameArray:(NSArray<NSString *>*)imageNameArray menuDirection:(LXPopOverMenuDirection)direction doneBlock:(LXPopOverMenuDoneBlock)doneBlock dismissBlock:(LXPopOverMenuDismiss)dismissBlock;
@end

