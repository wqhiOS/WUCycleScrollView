//
//  WUCycleScrollView.h
//  WUCycleScrollView
//
//  Created by wuqh on 16/4/10.
//  Copyright © 2016年 吴启晗. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WUCycleScrollView;

@protocol WUCycleScrollViewDelegate <NSObject>

- (void)cycleScrollView:(WUCycleScrollView*)cycleScrollView didSelectedImageView:(NSInteger)index;

@end

@interface WUCycleScrollView : UIView

@property (nonatomic, weak) id<WUCycleScrollViewDelegate> delegate;

- (instancetype)initWithImageArray:(NSArray *)imageArray frame:(CGRect)frame;

@end
