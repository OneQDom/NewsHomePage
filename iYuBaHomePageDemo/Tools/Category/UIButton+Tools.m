//
//  UIButton+Tools.m
//  iYuBaHomePageDemo
//
//  Created by WQ on 2018/10/19.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import "UIButton+Tools.h"

@implementation UIButton (Tools)

+ (UIButton *)buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor bgColor:(UIColor *)bgColor highlightedColor:(UIColor *)highlightedColor{
    UIButton *button = [self buttonWithType:(UIButtonTypeCustom)];
    [button setTitle:title forState:(UIControlStateNormal)];
    
    if (bgColor) {
        [button setBackgroundColor:bgColor];
    }
    
    if (titleColor) {
        [button setTitleColor:titleColor forState:(UIControlStateNormal)];
    }
    
    if (highlightedColor) {
        [button setTitleColor:highlightedColor forState:(UIControlStateHighlighted)];
    }
    return button;
}

+ (UIButton *)buttonWithImage:(UIImage *)image selectedImage:(UIImage *)selectedImage{
    UIButton *button = [self buttonWithType:(UIButtonTypeCustom)];
    [button setImage:image forState:(UIControlStateNormal)];
    
    if (selectedImage) {
        [button setImage:selectedImage forState:(UIControlStateSelected)];
    }
    return button;
}
@end
