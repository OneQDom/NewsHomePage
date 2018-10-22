//
//  WQHideSelfWhenTextNilLabel.h
//  iYuBaHomePageDemo
//
//  Created by WQ on 2018/10/19.
//  Copyright © 2018年 WQ. All rights reserved.



/*
  主要是为了label内容为空的时候，隐藏掉这个label
*/

#import <UIKit/UIKit.h>

@interface WQHideSelfWhenTextNilLabel : UILabel

/**
 *  创建用于0.9 发现首页 banner 文字标题的label 会自动add到这个superView
 *
 * @param frame      label的位置
 * @param superView  承载本label的父view
 * @param backColor  标签背景色
 * @param textColor  文本内容颜色
 * @param font        文本字体
 */

- (instancetype)initWithFrame:(CGRect)frame withSuperView:(UIView *)superView backColor:(UIColor *)backColor textColor:(UIColor *)textColor font:(UIFont *)font;

@end
