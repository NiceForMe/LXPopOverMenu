//
//  LXPopOverMenu.m
//  LXPopOverMenu
//
//  Created by NiceForMe on 16/11/28.
//  Copyright © 2016年 BHEC. All rights reserved.
//

#import "LXPopOverMenu.h"
#import "Masonry.h"
/*
 
 **************在这里改menu的相关配置*************
 
 */
#define MenuArrowWidth 8.0 //箭头宽度
#define MenuArrowHeight 12.0 //箭头高度

#define MenuWidth 120 //menu宽度
#define MenuSmallMargin 5 //间距
#define MenuTableViewRowHeight 40 //cell的高度
#define MenuIconSize MenuTableViewRowHeight - 2 * MenuSmallMargin //图片的size

#define MenuDefaultColor [UIColor colorWithRed:74/255.f green:74/255.f blue:74/255.f alpha:1.f]
#define MenuTableViewCellLableColor [UIColor whiteColor]
#define MenuTableViewCellSeperatLineColor [UIColor grayColor]

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

static NSString *ID = @"Identifier";

@interface LXPopOverMenu ()
@property (nonatomic,assign) BOOL menuIsExist;
@property (nonatomic,strong) LXPopOverMenuTableView *tableView;
@end

@implementation LXPopOverMenu
+ (LXPopOverMenu *)shareInstance
{
    static dispatch_once_t onceToken;
    static LXPopOverMenu *shared;
    dispatch_once(&onceToken, ^{
        shared = [[LXPopOverMenu alloc]init];
    });
    return shared;
}
- (LXPopOverMenuTableView *)tableView
{
    if (!_tableView) {
        _tableView = [[LXPopOverMenuTableView alloc]init];
    }
    return _tableView;
}
+ (void)showPopOverMenu:(UIView *)view withMenuCellNameArray:(NSArray<NSString *> *)nameArray imageNameArray:(NSArray<NSString *> *)imageNameArray menuDirection:(LXPopOverMenuDirection)direction doneBlock:(LXPopOverMenuDoneBlock)doneBlock dismissBlock:(LXPopOverMenuDismiss)dismissBlock
{
    [[LXPopOverMenu shareInstance]showTableViewWithSuperView:view menuCellNameArray:nameArray imageNameArray:imageNameArray menuDirection:direction doneBlock:doneBlock dismissBlock:dismissBlock];
}

- (void)showTableViewWithSuperView:(UIView *)superView menuCellNameArray:(NSArray<NSString *> *)nameArray imageNameArray:(NSArray<NSString *>*)imageNameArray menuDirection:(LXPopOverMenuDirection)direction doneBlock:(LXPopOverMenuDoneBlock)doneBlock dismissBlock:(LXPopOverMenuDismiss)dismissBlock
{
    [superView addSubview:self.tableView];
    [self.tableView showTableViewWithSuperView:superView menuCellNameArray:nameArray imageNameArray:imageNameArray menuDirection:direction doneBlock:doneBlock dismissBlock:dismissBlock];
}
- (void)dismiss
{
    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.tableView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.tableView removeFromSuperview];
        self.menuIsExist = NO;
    }];
}
@end

#pragma mark - LXPopOverMenuTableViewCell
@interface LXPopOverMenuTableViewCell ()

@end

@implementation LXPopOverMenuTableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView cellModel:(CellModel)cellModel
{
    LXPopOverMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[LXPopOverMenuTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID cellModel:cellModel];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellModel:(CellModel)cellModel
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.cellModel = cellModel;
        self.backgroundColor = MenuDefaultColor;
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        [self initUI];
    }
    return self;
}
- (void)initUI
{
    //nameLable
    UILabel *nameLable = [[UILabel alloc]init];
    self.nameLable = nameLable;
    nameLable.backgroundColor = MenuDefaultColor;
    nameLable.textColor = MenuTableViewCellLableColor;
    nameLable.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:nameLable];
    //imgView
    UIImageView *imgView = [[UIImageView alloc]init];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.backgroundColor = MenuDefaultColor;
    self.imgView = imgView;
    imgView.userInteractionEnabled = YES;
    [self.contentView addSubview:imgView];
    if (self.cellModel == LXPopOverMenuTableViewCommenCell) {
        [nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(MenuSmallMargin, MenuSmallMargin, MenuSmallMargin, MenuSmallMargin));
        }];
    }else if (self.cellModel == LXPopOverMenuTableViewIconCell){
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).with.offset(MenuSmallMargin);
            make.top.mas_equalTo(self.contentView).with.offset(MenuSmallMargin);
            make.height.mas_equalTo(MenuIconSize);
            make.width.mas_equalTo(MenuIconSize);
        }];
        [nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.mas_equalTo(self.contentView).with.offset(0);
            make.left.mas_equalTo(imgView.mas_right).with.offset(MenuSmallMargin);
            if (imgView) {
            }else{
                make.left.mas_equalTo(self.contentView).with.offset(MenuSmallMargin);
            }
        }];
    }
    //seperatLine
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = MenuTableViewCellSeperatLineColor;
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView).with.offset(0);
        make.left.mas_equalTo(self.contentView).with.offset(MenuSmallMargin);
        make.right.mas_equalTo(self.contentView).with.offset(-MenuSmallMargin);
        make.height.mas_equalTo(1.5);
    }];
}
@end

#pragma mark - LXPopOverMenuTableView
@interface LXPopOverMenuTableView ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,assign) BOOL menuIsExist;
@property (nonatomic,assign) BOOL isIcon;//是否有图片
@property (nonatomic,strong) UIView *backgroundView;//背景视图，给它添加了手势，作用在于点击这个视图让menu消失
@property (nonatomic,strong) UIBezierPath *path;
@property (nonatomic,strong) CALayer *menuLayer;
@property (nonatomic,assign) NSInteger cellCount;
@end

@implementation LXPopOverMenuTableView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}
#pragma mark - lazy load
- (UIView *)backgroundView
{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
        [_backgroundView addGestureRecognizer:tap];
        _backgroundView.backgroundColor = [UIColor clearColor];
    }
    return _backgroundView;
}
- (UITableView *)menuTableView
{
    if (!_menuTableView) {
        _menuTableView = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
        _menuTableView.tag = 100;
        _menuTableView.dataSource = self;
        _menuTableView.delegate = self;
        _menuTableView.showsVerticalScrollIndicator = NO;
        _menuTableView.showsHorizontalScrollIndicator = NO;
        _menuTableView.layer.cornerRadius = 4.0;
        _menuTableView.backgroundColor = MenuDefaultColor;
        _menuTableView.showsVerticalScrollIndicator = YES;
        _menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _menuTableView;
}
- (void)showTableViewWithSuperView:(UIView *)superView menuCellNameArray:(NSArray<NSString *> *)nameArray imageNameArray:(NSArray<NSString *> *)imageNameArray menuDirection:(LXPopOverMenuDirection)direction doneBlock:(LXPopOverMenuDoneBlock)doneBlock dismissBlock:(LXPopOverMenuDismiss)dismissBlock
{
    if (self.menuTableView) {
        self.menuTableView = nil;
    }
    if (imageNameArray.count == 0) {
        self.isIcon = NO;
    }else{
        self.isIcon = YES;
    }
    //下面的四个margin用来判断menu的frame是否超过父视图
    CGFloat rightMargin = CGRectGetMaxX(superView.frame) - superView.frame.size.width / 2 + MenuWidth / 2;
    CGFloat leftMargin = CGRectGetMaxX(superView.frame) - superView.frame.size.width / 2 - MenuWidth / 2;
    CGFloat bottomMargin = CGRectGetMaxY(superView.frame) + MenuSmallMargin + MenuArrowHeight + nameArray.count * MenuTableViewRowHeight;
    CGFloat topMargin = CGRectGetMinY(superView.frame) - MenuSmallMargin - MenuArrowHeight - nameArray.count * MenuTableViewRowHeight;
    self.doneBlock = doneBlock;
    NSLog(@"self.doneBlock的地址%p",self.doneBlock);
    if (self.menuIsExist == NO) {
        self.dismissBlock = dismissBlock;
        self.nameArray = [NSMutableArray arrayWithArray:nameArray];
        self.imageArray = [NSMutableArray arrayWithArray:imageNameArray];
        [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            [[[UIApplication sharedApplication]keyWindow]addSubview:self.backgroundView];
            [[[UIApplication sharedApplication]keyWindow]addSubview:self.menuTableView];
            self.menuIsExist = YES;
            CGPoint point;
            if (direction == PopOverMenuDownDirection) {//菜单向下显示
                point = CGPointMake(superView.bounds.origin.x + (superView.bounds.size.width / 2), CGRectGetMaxY(superView.bounds) + MenuSmallMargin);
                [self.menuTableView mas_makeConstraints:^(MASConstraintMaker *make) {
                    if (rightMargin >= ScreenWidth) {//如果菜单超过了右侧边距,那就让他距右边距MenuSmallMargin的距离
                        make.right.mas_equalTo(self.backgroundView.mas_right).with.offset(-MenuSmallMargin);
                    }else if (leftMargin <= 0){//小于左边距
                        make.left.mas_equalTo(self.backgroundView.mas_left).with.offset(MenuSmallMargin);
                    }else{//菜单相对于view居中显示
                        make.centerX.mas_equalTo(superView.mas_centerX);
                    }
                    if (bottomMargin > ScreenHeight) {//超过了上边距
                        self.menuTableView.scrollEnabled = YES;
                        make.bottom.mas_equalTo(self.backgroundView.mas_bottom).with.offset(-MenuSmallMargin);
                    }else{
                        self.menuTableView.scrollEnabled = NO;
                        make.height.mas_equalTo(nameArray.count * MenuTableViewRowHeight);
                    }
                    make.width.mas_equalTo(MenuWidth);
                    make.top.mas_equalTo(superView.mas_bottom).with.offset(MenuSmallMargin + MenuArrowHeight - 1);
                }];
            }else if (direction == PopOverMenuUpDirection){
                point = CGPointMake(superView.bounds.origin.x + (superView.bounds.size.width / 2), CGRectGetMinY(superView.bounds) - MenuSmallMargin);
                [self.menuTableView mas_makeConstraints:^(MASConstraintMaker *make) {
                    if (rightMargin >= ScreenWidth) {
                        make.right.mas_equalTo(self.backgroundView.mas_right).with.offset(-MenuSmallMargin);
                    }else if (leftMargin <= 0){
                        make.left.mas_equalTo(self.backgroundView.mas_left).with.offset(MenuSmallMargin);
                    }else{
                        make.centerX.mas_equalTo(superView.mas_centerX);
                    }
                    if (topMargin < 0) {
                        make.top.mas_equalTo(self.backgroundView.mas_top).with.offset(MenuSmallMargin);
                        self.menuTableView.scrollEnabled = YES;
                    }else{
                        self.menuTableView.scrollEnabled = NO;
                        make.height.mas_equalTo(nameArray.count * MenuTableViewRowHeight);
                    }
                    make.width.mas_equalTo(MenuWidth);
                    make.bottom.mas_equalTo(superView.mas_top).with.offset(-(MenuSmallMargin + MenuArrowHeight) + 1);
                }];
            }
            //通过bezierPath画三角形
            [self showMenuArrowWithPoint:point direction:direction];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.menuTableView reloadData];
            });
        } completion:^(BOOL finished) {
            if (finished) {
                
            }
        }];
        
    }else{
        [self dismiss];
    }
}
- (void)dismiss
{
    [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self.menuTableView removeFromSuperview];
        [self.backgroundView removeFromSuperview];
        [self.menuLayer removeFromSuperlayer];
    } completion:^(BOOL finished) {
        if (finished) {
            self.menuIsExist = NO;
        }
    }];
}
- (void)showMenuArrowWithPoint:(CGPoint)point direction:(LXPopOverMenuDirection)direction
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = 3.0;
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineCapRound;
    [path moveToPoint:point];
    if (direction == PopOverMenuDownDirection) {
        [path addLineToPoint:CGPointMake(point.x - MenuArrowWidth, point.y + MenuArrowHeight)];
        [path addLineToPoint:CGPointMake(point.x + MenuArrowWidth, point.y + MenuArrowHeight)];
    }else if (direction == PopOverMenuUpDirection){
        [path addLineToPoint:CGPointMake(point.x - MenuArrowWidth, point.y - MenuArrowHeight)];
        [path addLineToPoint:CGPointMake(point.x + MenuArrowWidth, point.y - MenuArrowHeight)];
    }
    [path closePath];
    [path stroke];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = MenuDefaultColor.CGColor;
    self.menuLayer = layer;
    layer.path = path.CGPath;
    [self.layer addSublayer:layer];
}
//datasource and delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.nameArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LXPopOverMenuTableViewCell *cell;
    if (self.isIcon == YES) {
        cell = [LXPopOverMenuTableViewCell cellWithTableView:tableView cellModel:LXPopOverMenuTableViewIconCell];
    }else{
        cell = [LXPopOverMenuTableViewCell cellWithTableView:tableView cellModel:LXPopOverMenuTableViewCommenCell];
    }
    if (self.nameArray.count != 0) {
        cell.nameLable.text = self.nameArray[indexPath.row];
    }
    if (self.imageArray.count != 0) {
        NSString *imgName = self.imageArray[indexPath.row];
        cell.imgView.image = [UIImage imageNamed:imgName];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MenuTableViewRowHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.doneBlock) {
        self.doneBlock(indexPath.row);
    }
    [self dismiss];
}
@end


