//
//  HomePageSegmentView.m
//  iYuBaHomePageDemo
//
//  Created by WQ on 2018/10/19.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import "HomePageSegmentView.h"

@interface HomePageSegmentView ()
@property (weak, nonatomic) IBOutlet UIButton *sixMinutesBtn;
@end

@implementation HomePageSegmentView{
    UIButton *_lastTouchedBtn;
}

- (instancetype)initWithXib{
    self = [[NSBundle mainBundle] loadNibNamed:@"HomePageSegmentView" owner:nil options:nil][0];
    if (self) {
        _lastTouchedBtn = self.sixMinutesBtn;
    }
    return self;
}

- (IBAction)BBCSixMinutes_action:(id)sender {
    if ([self setBtnStatusWith:sender]) {
        !_BBCSixMinutesblock ?: _BBCSixMinutesblock();
    }
}

- (IBAction)BBCEnglish_action:(id)sender {
    if ([self setBtnStatusWith:sender]) {
        !_BBCEnglishblock ?: _BBCEnglishblock();
    }
}

- (IBAction)BBCNews_action:(id)sender {
    if ([self setBtnStatusWith:sender]) {
        !_BBCNewsblock ?: _BBCNewsblock();
    }
}

- (IBAction)newsWords_action:(id)sender {
    if ([self setBtnStatusWith:sender]) {
        !_newsWordsblock ?: _newsWordsblock();
    }
}

- (BOOL)setBtnStatusWith:(UIButton *)btn{
    if (_lastTouchedBtn != btn) {
        _lastTouchedBtn.selected = NO;
        btn.selected = YES;
        _lastTouchedBtn = btn;
        return YES;
    }
    
    
    return NO;
}
@end
