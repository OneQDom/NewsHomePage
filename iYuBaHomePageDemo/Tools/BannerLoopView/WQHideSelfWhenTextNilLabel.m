//
//  WQHideSelfWhenTextNilLabel.m
//  iYuBaHomePageDemo
//
//  Created by WQ on 2018/10/19.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import "WQHideSelfWhenTextNilLabel.h"
#import "UIView+Layout.h"//每个用的地方在import，防止用masonry的时候手误

@interface WQHideSelfWhenTextNilLabel ()

@property (nonatomic, strong) UIView *maskView;

@end

@implementation WQHideSelfWhenTextNilLabel

- (instancetype)initWithFrame:(CGRect)frame
                withSuperView:(UIView *)superView
                    backColor:(UIColor *)backColor
                    textColor:(UIColor *)textColor
                         font:(UIFont *)font{
    
    if ([super initWithFrame:frame]) {

        self.backgroundColor = backColor ? backColor : [UIColor clearColor];
        [self setTextColor:textColor ? textColor : [UIColor whiteColor]];
        self.font = font ? font : [UIFont fontWithName:@"PingFangSC-Medium" size:18];//[UIFont systemFontOfSize:18];
        
        self.maskView = [[UIView alloc]initWithFrame:CGRectMake(frame.origin.x - 20, frame.origin.y, self.width +20, self.height)];
        self.maskView.backgroundColor = UIColorFromRGBWithAlpha(0x000000, 0.646);
        self.frame = CGRectMake(20, 0, self.maskView.width - 20, self.maskView.height);
        [self.maskView addSubview:self];
        [superView addSubview:self.maskView];
    }
    
    return self;
}

- (void)setText:(NSString *)text{
    [super setText:text];

    if (text.length <= 0 || !text) {
        self.hidden = YES;
        self.maskView.hidden = YES;
    }else{
        self.hidden = NO;
        self.maskView.hidden = NO;
    }
}

- (void)dealloc{
    NSLog(@"%@ 被释放了",[self class]);
}

@end
