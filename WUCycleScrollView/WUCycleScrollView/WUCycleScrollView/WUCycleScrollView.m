//
//  WUCycleScrollView.m
//  WUCycleScrollView
//
//  Created by wuqh on 16/4/10.
//  Copyright © 2016年 吴启晗. All rights reserved.
//

#import "WUCycleScrollView.h"
#import "UIImageView+WebCache.h"

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight self.bounds.size.height

@interface WUCycleScrollView()<UIScrollViewDelegate>
{
    UIImageView *_centerImageView;//当前图片
    UIImageView *_leftImageView;//上一张图片
    UIImageView *_rightImageView;//下一张图片
    
    NSInteger _currentImageIndex;//当前图片索引
    NSInteger _imageCount;//图片总数
    
    NSTimer *_timer;
    
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSArray *imageArray;

@end

@implementation WUCycleScrollView

- (void)dealloc {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (instancetype)initWithImageArray:(NSArray *)imageArray frame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.imageArray = imageArray;
        _imageCount = imageArray.count;
        [self setup];
    }
    return self;
}

#pragma mark - Private
- (void)setup {
    
    [self addSubview:self.scrollView];
    [self addSubview:self.pageControl];
    [self addImageViews];
    [self setDefaultImage];
}

- (void)addImageViews {
    _leftImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    [_scrollView addSubview:_leftImageView];
    _centerImageView=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth, 0, kWidth, kHeight)];
    [_scrollView addSubview:_centerImageView];
    _rightImageView=[[UIImageView alloc]initWithFrame:CGRectMake(2*kWidth, 0, kWidth, kHeight)];
    [_scrollView addSubview:_rightImageView];
}

-(void)setDefaultImage{
    
    [_leftImageView sd_setImageWithURL:[NSURL URLWithString:self.imageArray[_imageCount-1]]];
    
    [_rightImageView sd_setImageWithURL:[NSURL URLWithString:self.imageArray[1]]];
    
    
    [_centerImageView sd_setImageWithURL:[NSURL URLWithString:self.imageArray[0]]];
    _centerImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
    [_centerImageView addGestureRecognizer:tap];
    
    _currentImageIndex=0;

    _pageControl.currentPage=_currentImageIndex;
    
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    if (_imageCount > 1) {
        _timer = [NSTimer timerWithTimeInterval:4 target:self selector:@selector(timerScrollImage) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] runMode:UITrackingRunLoopMode beforeDate:[NSDate date]];
    }
  
}

#pragma mark 重新加载图片
-(void)reloadImage{
    NSInteger leftImageIndex,rightImageIndex;
    CGPoint offset=[_scrollView contentOffset];
    if (offset.x>kWidth) { //向右滑动
        _currentImageIndex=(_currentImageIndex+1)%_imageCount;
    }else if(offset.x<kWidth){ //向左滑动
        _currentImageIndex=(_currentImageIndex+_imageCount-1)%_imageCount;
    }
 
    [_centerImageView sd_setImageWithURL:[NSURL URLWithString:self.imageArray[_currentImageIndex]]];
    
    leftImageIndex=(_currentImageIndex+_imageCount-1)%_imageCount;
    rightImageIndex=(_currentImageIndex+1)%_imageCount;
    [_leftImageView sd_setImageWithURL:[NSURL URLWithString:self.imageArray[leftImageIndex]]];
    [_rightImageView sd_setImageWithURL:[NSURL URLWithString:self.imageArray[rightImageIndex]]];

}

#pragma mark - Action
- (void)tapImage:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:didSelectedImageView:)]) {
        [self.delegate cycleScrollView:self didSelectedImageView:_currentImageIndex];
    }
}

- (void)timerScrollImage
{
    [self reloadImage];
    
    [self.scrollView setContentOffset:CGPointMake(kWidth * 2, 0) animated:YES];
}

#pragma mark - Getter
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.contentOffset = CGPointMake(kWidth, 0);
        _scrollView.contentSize = CGSizeMake(kWidth * 3, kHeight);
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, kHeight-40, kWidth, 30)];
        _pageControl.userInteractionEnabled = NO;
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        _pageControl.numberOfPages = _imageCount;
        
    }
    return _pageControl;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x >= kWidth * 2 || scrollView.contentOffset.x <= 0) {
        [self reloadImage];
        [_scrollView setContentOffset:CGPointMake(kWidth, 0) animated:NO];
        _pageControl.currentPage=_currentImageIndex;
    }
}


@end
