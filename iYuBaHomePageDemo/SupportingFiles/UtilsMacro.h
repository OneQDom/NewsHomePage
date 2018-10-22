//
//  UtilsMacro.h
//  iYuBaHomePageDemo
//
//  Created by WQ on 2018/10/19.
//  Copyright © 2018年 WQ. All rights reserved.
//

#ifndef UtilsMacro_h
#define UtilsMacro_h


#define SCREEN_WIDTH  [[UIScreen mainScreen]bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen]bounds].size.height


#define IS_IPHONE_X (SCREEN_HEIGHT >= 812) ? YES : NO
#define NAVBAR_HEIGHT  (IS_IPHONE_X ? 88.0f : 64.0f)
#define StatusBarHeight (IS_IPHONE_X ? 44.0f : 20.0f)
#define TabBarHeight (IS_IPHONE_X ? 83.0f : 49.0f)
#define ViewBottom (IS_IPHONE_X ? 34.0f : 0.0f)



#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromRGBWithAlpha(rgbValue,alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue]


#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

///关于iOS11
#define AdjustsScrollViewInsetNever(controller,view) if(@available(iOS 11.0, *)) {view.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;} else{controller.automaticallyAdjustsScrollViewInsets = NO;}


#endif /* UtilsMacro_h */
