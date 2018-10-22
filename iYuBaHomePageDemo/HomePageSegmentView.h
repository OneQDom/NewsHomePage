//
//  HomePageSegmentView.h
//  iYuBaHomePageDemo
//
//  Created by WQ on 2018/10/19.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomePageSegmentView : UIView

//对应按钮的点击回调

@property (nonatomic, copy) dispatch_block_t BBCSixMinutesblock;
@property (nonatomic, copy) dispatch_block_t BBCEnglishblock;
@property (nonatomic, copy) dispatch_block_t BBCNewsblock;
@property (nonatomic, copy) dispatch_block_t newsWordsblock;



- (instancetype)initWithXib;

@end
