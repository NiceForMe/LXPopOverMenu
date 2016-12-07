//
//  ViewController.m
//  LXPopOverMenu
//
//  Created by NiceForMe on 16/11/28.
//  Copyright © 2016年 BHEC. All rights reserved.
//

#import "ViewController.h"
#import "LXPopOverMenu.h"

@interface ViewController ()
@property (nonatomic,strong) NSMutableArray *nameArray;
@property (nonatomic,strong) NSMutableArray *imgArray;
@property (nonatomic,strong) UIButton *downBtn;
@property (nonatomic,strong) UIButton *upBtn;
@property (nonatomic,strong) UIButton *navBtn;
@end

@implementation ViewController
- (NSMutableArray *)nameArray
{
    if (!_nameArray) {
        _nameArray = [NSMutableArray arrayWithArray:@[@"Wo",@"Jiao",@"Li",@"Xiao",@"Wo",@"Jiao",@"Li",@"Xiao",@"Wo",@"Jiao",@"Li",@"Xiao"]];
    }
    return _nameArray;
}
- (NSMutableArray *)imgArray
{
    if (!_imgArray) {
        _imgArray = [NSMutableArray arrayWithArray:@[@"example",@"example",@"example",@"example",@"example",@"example",@"example",@"example",@"example",@"example",@"example",@"example"]];
    }
    return _imgArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //nav btn
    UIButton *navBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.navBtn = navBtn;
    navBtn.frame = CGRectMake(0, 0, 60, 30);
    [navBtn setTitle:@"导航栏" forState:UIControlStateNormal];
    [navBtn setBackgroundColor:[UIColor redColor]];
    [navBtn addTarget:self action:@selector(showNavMenu) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:navBtn];
    self.navigationItem.rightBarButtonItem = item;
    //down menu
    UIButton *downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.downBtn = downBtn;
    downBtn.frame = CGRectMake(45, 300, 80, 30);
    [downBtn setTitle:@"下拉菜单" forState:UIControlStateNormal];
    [downBtn setBackgroundColor:[UIColor redColor]];
    [downBtn addTarget:self action:@selector(showDownMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:downBtn];
    //up menu
    UIButton *upBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.upBtn = upBtn;
    upBtn.frame = CGRectMake(200, 300, 80, 30);
    [upBtn setTitle:@"上拉菜单" forState:UIControlStateNormal];
    [upBtn setBackgroundColor:[UIColor redColor]];
    [upBtn addTarget:self action:@selector(showUpMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:upBtn];
    
}
#pragma mark - target
- (void)showDownMenu
{
    [LXPopOverMenu showPopOverMenu:self.downBtn withMenuCellNameArray:self.nameArray imageNameArray:self.imgArray menuDirection:PopOverMenuDownDirection doneBlock:^(NSInteger selectIndex) {
        NSLog(@"%ld",(long)selectIndex);
    } dismissBlock:^{
        
    }];
}
- (void)showUpMenu
{
    [LXPopOverMenu showPopOverMenu:self.upBtn withMenuCellNameArray:self.nameArray imageNameArray:self.imgArray menuDirection:PopOverMenuUpDirection doneBlock:^(NSInteger selectIndex) {
        NSLog(@"%ld",(long)selectIndex);
    } dismissBlock:^{
        
    }];
}
- (void)showNavMenu
{
    [LXPopOverMenu showPopOverMenu:self.navBtn withMenuCellNameArray:self.nameArray imageNameArray:self.imgArray menuDirection:PopOverMenuDownDirection doneBlock:^(NSInteger selectIndex) {
        NSLog(@"%ld",(long)selectIndex);
    } dismissBlock:^{
        
    }];
}
- (void)clickNavBtn
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
