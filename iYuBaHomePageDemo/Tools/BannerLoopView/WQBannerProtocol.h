//
//  WQBannerProtocol.h
//  iYuBaHomePageDemo
//
//  Created by WQ on 2018/10/19.
//  Copyright © 2018年 WQ. All rights reserved.
//

#ifndef WQBannerProtocol_h
#define WQBannerProtocol_h


@protocol WQBannerLoopViewDelegate <NSObject>

@optional

- (void)wq_bannerLoopViewClicked:(NSUInteger)idx data:(id)data;

@end

#endif /* WQBannerProtocol_h */
