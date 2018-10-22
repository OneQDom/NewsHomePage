//
//  UIImage+Tools.h
//  iYuBaHomePageDemo
//
//  Created by WQ on 2018/10/19.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Tools)
/// 根据颜色获取一张图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
@end
