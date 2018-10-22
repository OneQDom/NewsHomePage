//
//  WQPageControl.m
//  iYuBaHomePageDemo
//
//  Created by WQ on 2018/10/19.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import "WQPageControl.h"
#import "UIView+Layout.h"

@implementation WQPageControl{
    NSUInteger _lastSelDotIndex;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        _lastSelDotIndex = 0;
        
        self.pageIndicatorTintColor = UIColorFromRGB(0xB6B6B8);
        self.currentPageIndicatorTintColor = UIColorFromRGB(0x007AED);

#warning 想用图的时候打开注释 填上自己的图片名 将不用再实现setNumberOfPages
//        [self setValue:[UIImage imageNamed:@"pagecontrol_dot_current"] forKeyPath:@"_currentPageImage"];
//        [self setValue:[UIImage imageNamed:@"pagecontrol_dot"] forKeyPath:@"_pageImage"];

        self.defersCurrentPageDisplay = YES;//是否接受点击
        self.hidesForSinglePage = YES;//一张的时候是否隐藏pageControl
    }
    return self;
}


- (void)setNumberOfPages:(NSInteger)numberOfPages{
    [super setNumberOfPages:numberOfPages];
    
    //在告诉pageControl几个点的时候，把所有的点设置成自己想要的大小和形状
    
    for (UIView *view in self.subviews) {
        view.width = 6.;
        view.height = 6.;
        view.layer.cornerRadius = 3.;
    }    
}

//复写 设置当前点的set方法
- (void)setCurrentPage:(NSInteger)currentPage{
    [super setCurrentPage:currentPage];
    
    NSArray <UIView *>*subViews = [self.subviews mutableCopy];
    if (subViews.count > currentPage && subViews) {
        
        //还原上次选择的点
        subViews[_lastSelDotIndex].width = 6.;
        subViews[_lastSelDotIndex].height = 6.;
        subViews[_lastSelDotIndex].layer.cornerRadius = 3.;
        
        //设置当前点
        subViews[currentPage].width = 9.5;
        subViews[currentPage].height = 6;
        
        //记录页码
        _lastSelDotIndex = currentPage;
    }
}

@end
