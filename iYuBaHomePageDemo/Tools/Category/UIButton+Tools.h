//
//  UIButton+Tools.h
//  iYuBaHomePageDemo
//
//  Created by WQ on 2018/10/19.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Tools)
/**
 *  仅有文字
 *
 *  @param title            文字
 *  @param titleColor       文字颜色
 *  @param bgColor          背景颜色
 *  @param highlightedColor 高亮颜色
 *
 *  @return self
 */
+ (UIButton *)buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor bgColor:(UIColor *)bgColor highlightedColor:(UIColor *)highlightedColor;

/**
 *  仅有图片
 *
 *  @param image         默认图片
 *  @param selectedImage 选中图片
 *
 *  @return self
 */
+ (UIButton *)buttonWithImage:(UIImage *)image selectedImage:(UIImage *)selectedImage;
@end
