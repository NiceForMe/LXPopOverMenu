# LXPopOverMenu
LXPopOverMenu是一款非常容易调用的上拉(下拉)菜单，支持设置上拉显示或者下拉显示，可以再任何view中显示，支持修改menu的任何属性。
![img](https://github.com/NiceForMe/LXPopOverMenu/blob/master/LXPopOverMenu/menu.gif)
# 使用方法
- 将LXPopOverMenu文件夹拖入工程中去
- 添加头文件*#import "LXPopOverMenu.h"*
- 调用下面的方法
- **目前暂不支持Cocoapods**               
```objective-c
 [LXPopOverMenu showPopOverMenu:self.downBtn withMenuCellNameArray:self.nameArray imageNameArray:self.imgArray menuDirection:PopOverMenuDownDirection doneBlock:^(NSInteger selectIndex) {
        NSLog(@"%ld",(long)selectIndex);
    } dismissBlock:^{
        
  }];
```
### 依赖库:Masonry
# 联系我
如果有任何建议、想法以及对源码的意见加我QQ或者微信:771717844
欢迎iOSers提出宝贵的意见，也欢迎各位大牛批评指正，喜欢的朋友点个star
# Discussing
- email:771717844@qq.com
- [submit issues](https://github.com/NiceForMe/LXPopOverMenu/issues)
