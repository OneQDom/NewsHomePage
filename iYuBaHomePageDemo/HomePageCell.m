//
//  HomePageCell.m
//  iYuBaHomePageDemo
//
//  Created by WQ on 2018/10/19.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import "HomePageCell.h"
#import "HomePageModel.h"

@interface HomePageCell()

@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *dateL;

@end

@implementation HomePageCell

- (void)setModel:(HomePageModel *)model{
    _model = model;
    
    // 完全可以对 SD_ 进行二次封装   只需传URL的string
    [self.imgV sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:nil];
    self.titleL.text = model.title;
    
    // 按理说这个时间应该进行一次格式化
    // 正常来说给时间戳比较好
    self.dateL.text = [NSString stringWithFormat:@"%@ | 阅读:%@",[model.creatTime substringToIndex:[model.creatTime rangeOfString:@" "].location],model.readCount];
}

@end
