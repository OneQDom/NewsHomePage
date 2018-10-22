//
//  WQBannerLoopView.m
//  iYuBaHomePageDemo
//
//  Created by WQ on 2018/10/19.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import "WQBannerLoopView.h"
#import "WQHideSelfWhenTextNilLabel.h"
#import "WQPageControl.h"
#import "UIView+Layout.h"


static const NSTimeInterval WQB_default_Timer_Scroll_Interval = 5.;


@interface WQBannerLoopView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView  *mainScrollView;

@property (nonatomic, strong) UIImageView   *leftImgView;
@property (nonatomic, strong) UIImageView   *centerImgView;
@property (nonatomic, strong) UIImageView   *rightImgView;

@property (nonatomic, strong) NSTimer       *scrollTimer;

/////////////////// 底下带遮罩的文字描述 没有内容自动隐藏//////////////////////
@property (nonatomic, strong) WQHideSelfWhenTextNilLabel       * bottomLeftTitleL;
@property (nonatomic, strong) WQHideSelfWhenTextNilLabel       * bottomCenterTitleL;
@property (nonatomic, strong) WQHideSelfWhenTextNilLabel       * bottomRightTitleL;

/////////////////// pageControl ///////////////////////////
@property (nonatomic, strong) WQPageControl *pageContrl;

@end



@implementation WQBannerLoopView{
    
    /** 当前显示的图片数据源 （centerImgView的内容）  左右各有一张才对 */
    NSUInteger _currentShowIndex;
    
    /** 要轮播图片的数量 */
    NSUInteger _maxImageIndex;
    
    /** 图片资源是不是网络图 */
    BOOL _isURLImageSource;
    /** 图片资源是不是有model */
    BOOL _isModelImageSource;
}

- (void)removeFromSuperview{
    [self stopTimer];
    [super removeFromSuperview];
    
    NSLog(@"轮播图被移除");
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _currentShowIndex = 0;
        _scrollTimerInterval = WQB_default_Timer_Scroll_Interval;
        self.scrollTimerInterval = 6;
        
        [self addSubview:self.mainScrollView];
        [self insertSubview:self.pageContrl aboveSubview:self.mainScrollView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self setPageControlOriginType:_pageControlOriginType];
}

- (void)startTimer{
    if (self.scrollTimer) {
        [self.scrollTimer invalidate];
        self.scrollTimer = nil;
    }
    
    self.scrollTimer = [NSTimer timerWithTimeInterval:self.scrollTimerInterval target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.scrollTimer forMode:NSRunLoopCommonModes];
    NSLog(@"timer 被启动");
}

- (void)timerAction{
    _currentShowIndex += 1;
    [self selectSetImageWayAndRefreshImage:NO];
}

- (void)stopTimer{
    [self.scrollTimer invalidate];
    self.scrollTimer = nil;
    NSLog(@"timer 释放掉");
}


#pragma mark - refrfesh data
// 判断是否为网络图   并刷新显示的图片   
- (void)selectSetImageWayAndRefreshImage:(BOOL)isDecelerat{

    WS(ws);
    [UIView animateWithDuration:0.3 animations:^{
        ws.mainScrollView.contentOffset = CGPointMake(ws.width * 2, 0);
    } completion:^(BOOL finished) {
        [ws.mainScrollView setContentOffset:CGPointMake(self.width, 0)];
        [ws switchedRefreshType];
        
        if (isDecelerat) {
            [ws stopTimer];
            [ws startTimer];
        }
    }];
}

// 手动从左往右划
- (void)selectSetImageWayAndRefreshImageWhenLeftScrollToRight{

    WS(ws);
    [UIView animateWithDuration:0.3 animations:^{
        ws.mainScrollView.contentOffset = CGPointMake(0, 0);
    } completion:^(BOOL finished) {
        [ws.mainScrollView setContentOffset:CGPointMake(ws.width, 0)];
        [ws switchedRefreshType];
        
        [ws stopTimer];
        [ws startTimer];
    }];
}


- (void)switchedRefreshType{
    if (_isModelImageSource) {
        [self setImageAndTitleWithModel];
    }else{
        
        if (_isURLImageSource){
            [self setImageWithUrl];
        }else{
            [self setImageWithLocal];
        }
    }
}

- (void)setImageWithLocal{
    NSUInteger idx = _currentShowIndex%self.localImageArr.count;
    
    if (idx == 0) {
        self.leftImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.localImageArr[_maxImageIndex]]];
    }else{
        self.leftImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.localImageArr[idx - 1]]];
    }

    self.centerImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.localImageArr[idx]]];
    
    if (idx == _maxImageIndex) {
        self.rightImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.localImageArr[0]]];
    }else{
        self.rightImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.localImageArr[idx + 1]]];
    }
    
    [self setPageControlCurrentIdx:idx];
}

- (void)setImageWithUrl{
    NSUInteger idx = _currentShowIndex%self.urlImageArr.count;

    if (idx == 0) {
        [self.leftImgView sd_setImageWithURL:[NSURL URLWithString:self.urlImageArr[_maxImageIndex]] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    }else{
        [self.leftImgView sd_setImageWithURL:[NSURL URLWithString:self.urlImageArr[idx - 1]] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    }
    
    [self.centerImgView sd_setImageWithURL:[NSURL URLWithString:self.urlImageArr[idx]] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];

    if (idx == _maxImageIndex) {
        [self.rightImgView sd_setImageWithURL:[NSURL URLWithString:self.urlImageArr[0]] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    }else{
        [self.rightImgView sd_setImageWithURL:[NSURL URLWithString:self.urlImageArr[idx + 1]] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    }
    
    [self setPageControlCurrentIdx:idx];
}

- (void)setImageAndTitleWithModel{

    NSUInteger idx = _currentShowIndex%self.bannerModelList.count;
    WQBannerDataModel *leftModel;
    WQBannerDataModel *centerModel = self.bannerModelList[idx];
    WQBannerDataModel *rightModel;
    
    if (idx == 0) {
        leftModel = self.bannerModelList[_maxImageIndex];
    }else{
        leftModel = self.bannerModelList[idx - 1];
    }
    [self.leftImgView sd_setImageWithURL:[NSURL URLWithString:leftModel.url] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    [self.bottomLeftTitleL setText:leftModel.title];
    
    
    [self.centerImgView sd_setImageWithURL:[NSURL URLWithString:self.bannerModelList[idx].url] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    [self.bottomCenterTitleL setText:centerModel.title];
    
    
    if (idx == _maxImageIndex) {
        rightModel = self.bannerModelList[0];
    }else{
        rightModel = self.bannerModelList[idx + 1];
    }
    [self.rightImgView sd_setImageWithURL:[NSURL URLWithString:rightModel.url] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    [self.bottomRightTitleL setText:rightModel.title];

}


#pragma mark - scroll delegate *******************
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x < self.width * 0.7) {
        //从左往右滚
        if (_currentShowIndex < 1) {
            _currentShowIndex = _maxImageIndex;
        }else{
            _currentShowIndex -= 1;
        }
        [self selectSetImageWayAndRefreshImageWhenLeftScrollToRight];
    }else if (scrollView.contentOffset.x > self.width * 1.3){
        //从右往左滚
        _currentShowIndex += 1;
        [self selectSetImageWayAndRefreshImage:YES];
    }
}

#pragma mark - function = = = == =  =
- (void)tapImage_action{
    //点击了轮播图，代理回调当前显示数据源的下标回去
    if (self.delegate && [self.delegate respondsToSelector:@selector(wq_bannerLoopViewClicked:data:)]) {
        [self.delegate wq_bannerLoopViewClicked:_currentShowIndex%_maxImageIndex data:nil];
    }
    NSLog(@"点击了banner上的图片  数据源下标：%ld",_currentShowIndex%_maxImageIndex);
}

- (void)pageControlValueChange:(UIPageControl *)pageContrl{
    NSLog(@"点击了pageControl");
}

#pragma mark - setter - - - - - - - - - - -

- (void)setUrlImageArr:(NSArray *)urlImageArr{
    
    if (urlImageArr.count <= 0) {
        return;
    }
    
    self.pageContrl.numberOfPages = _urlImageArr.count;

    if (urlImageArr.count >= 3) {
        _urlImageArr = [urlImageArr mutableCopy];
    }else{
        _urlImageArr = [self handleImageArrWith:[_urlImageArr mutableCopy]];
    }
    
    _localImageArr = nil;
    _bannerModelList = nil;
    
    _isURLImageSource = YES;
    _isModelImageSource = NO;

    _currentShowIndex = 0;
    _maxImageIndex = self.urlImageArr.count - 1;
    [self.mainScrollView setContentOffset:CGPointMake(self.width, 0)];
    [self setImageWithUrl];
    [self startTimer];
}

- (void)setLocalImageArr:(NSArray *)localImageArr{
    if (localImageArr.count <= 0) {
        NSLog(@"传空的数组，滚个球啊！！！");
        return;
    }
    
    if (localImageArr.count >= 3) {
        _localImageArr = [localImageArr mutableCopy];
    }else{
        _localImageArr = [self handleImageArrWith:[_localImageArr mutableCopy]];
    }
    
    _urlImageArr = nil;
    _bannerModelList = nil;
    
    _isURLImageSource = NO;
    _isModelImageSource = NO;

    _currentShowIndex = 0;
    _maxImageIndex = self.localImageArr.count - 1;
    [self.mainScrollView setContentOffset:CGPointMake(self.width, 0)];
    [self setImageWithLocal];
    [self startTimer];
}

- (void)setBannerModelList:(NSArray<WQBannerDataModel *> *)bannerModelList{
    if (bannerModelList.count <= 0) {
        NSLog(@"传空的数组，滚个球啊！！！");
        return;
    }
    
    if (bannerModelList.count >= 3) {
        _bannerModelList = [bannerModelList mutableCopy];
    }else{
        _bannerModelList = [self handleImageArrWith:[bannerModelList mutableCopy]];
    }
    
    _localImageArr = nil;
    _urlImageArr = nil;
    
    _isURLImageSource = NO;
    _isModelImageSource = YES;
    _currentShowIndex = 0;
    _maxImageIndex = self.bannerModelList.count - 1;
    [self.mainScrollView setContentOffset:CGPointMake(self.width, 0)];
    [self setImageAndTitleWithModel];
    [self startTimer];
}


//若是传进来的数据小于三的时候
- (NSArray *)handleImageArrWith:(NSArray *)arr{
    if (!arr) {
        return @[].mutableCopy;
    }
    
    NSMutableArray *tmpArr = [[NSMutableArray alloc]initWithCapacity:0];
    if (arr.count == 1) {
        
        [tmpArr addObject:arr.firstObject];
        [tmpArr addObject:arr.firstObject];
        
    }else if (arr.count == 2){
        
        [tmpArr addObjectsFromArray:arr];
        [tmpArr addObject:arr.firstObject];
        
    }
    
    return tmpArr.mutableCopy;
}

- (void)setScrollTimerInterval:(float)scrollTimerInterval{
    _scrollTimerInterval = MAX(1., scrollTimerInterval);
    [self startTimer];
}

- (void)setPageControlOriginType:(WQBannerPageControlOriginType)pageControlOriginType{
    _pageControlOriginType = pageControlOriginType;
    
    if (pageControlOriginType == WQBannerPageControlOriginType_rightBottom) {
        
        self.pageContrl.frame = CGRectMake(self.width / 2., self.height - 33, self.width / 2. - 20, 33);
        
    }else if (pageControlOriginType == WQBannerPageControlOriginType_bottom){
        
        self.pageContrl.frame = CGRectMake(0, self.height - 33, self.width, 33);
        
    }else if (pageControlOriginType == WQBannerPageControlOriginType_top){
        
        self.pageContrl.frame = CGRectMake(0, 0, self.width, 33);
    }
    
    if (self.bannerModelList.count > 0) {
        self.pageContrl.numberOfPages = self.bannerModelList.count;
    }else if (self.localImageArr.count > 0) {
            self.pageContrl.numberOfPages = self.localImageArr.count;
    }else if (self.urlImageArr.count > 0) {
        self.pageContrl.numberOfPages = self.urlImageArr.count;
    }
    
}

- (void)setPageControlCurrentIdx:(NSUInteger)idx{
    self.pageContrl.currentPage = idx;
}

#pragma mark - lazy - - --- - - -- - - - --

- (UIScrollView *)mainScrollView{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _mainScrollView.contentSize = CGSizeMake(self.width * 3, 0);
        _mainScrollView.delegate = self;
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.bounces = NO;
        _mainScrollView.showsVerticalScrollIndicator = NO;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage_action)];
        [_mainScrollView addGestureRecognizer:tap];
    }
    return _mainScrollView;
}

- (WQPageControl *)pageContrl{
    if (!_pageContrl) {
        _pageContrl = [[WQPageControl alloc]initWithFrame:CGRectMake(self.width / 2., self.height - 33, self.width / 2. - 20, 33)];
        [_pageContrl addTarget:self action:@selector(pageControlValueChange:) forControlEvents:(UIControlEventValueChanged)];
//        _pageContrl.hidden = YES;
    }
    return _pageContrl;
}

- (UIImageView *)leftImgView{
    if (!_leftImgView) {
        _leftImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _leftImgView.contentMode = UIViewContentModeScaleAspectFill;
        _leftImgView.clipsToBounds = YES;
        _leftImgView.backgroundColor = [UIColor clearColor];
        [self.mainScrollView addSubview:_leftImgView];
    }
    return _leftImgView;
}

- (UIImageView *)centerImgView{
    if (!_centerImgView) {
        _centerImgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.leftImgView.right, 0, self.width, self.height)];
        _centerImgView.contentMode = UIViewContentModeScaleAspectFill;
        _centerImgView.clipsToBounds = YES;
        _centerImgView.backgroundColor = [UIColor clearColor];
        [self.mainScrollView addSubview:_centerImgView];
    }
    return _centerImgView;
}

- (UIImageView *)rightImgView{
    if (!_rightImgView) {
        _rightImgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.centerImgView.right, 0, self.width, self.height)];
        _rightImgView.contentMode = UIViewContentModeScaleAspectFill;
        _rightImgView.clipsToBounds = YES;
        _rightImgView.backgroundColor = [UIColor clearColor];
        [self.mainScrollView addSubview:_rightImgView];
    }
    return _rightImgView;
}


- (WQHideSelfWhenTextNilLabel *)bottomLeftTitleL{
    if (!_bottomLeftTitleL) {
        _bottomLeftTitleL = [[WQHideSelfWhenTextNilLabel alloc]initWithFrame:CGRectMake(20, self.height - 33., self.width - 20, 33)
                                                               withSuperView:self.mainScrollView
                                                                   backColor:nil
                                                                   textColor:nil
                                                                        font:nil];
    }
    return _bottomLeftTitleL;
}

- (WQHideSelfWhenTextNilLabel *)bottomCenterTitleL{
    if (!_bottomCenterTitleL) {
        _bottomCenterTitleL = [[WQHideSelfWhenTextNilLabel alloc]initWithFrame:CGRectMake(self.width + 20, self.height - 33., self.width - 20, 33)
                                                               withSuperView:self.mainScrollView
                                                                   backColor:nil
                                                                   textColor:nil
                                                                        font:nil];
    }
    return _bottomCenterTitleL;
}

- (WQHideSelfWhenTextNilLabel *)bottomRightTitleL{
    if (!_bottomRightTitleL) {
        _bottomRightTitleL = [[WQHideSelfWhenTextNilLabel alloc]initWithFrame:CGRectMake(self.width * 2. + 20, self.height - 33., self.width - 20, 33)
                                                               withSuperView:self.mainScrollView
                                                                   backColor:nil
                                                                   textColor:nil
                                                                        font:nil];
    }
    return _bottomRightTitleL;
}

@end


@implementation WQBannerDataModel

@end
