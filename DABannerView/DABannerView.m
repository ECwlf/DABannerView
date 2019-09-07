//
//  DABannerView.m
//  DABannerView
//
//  Created by linfeng wang on 2019/7/22.
//  Copyright © 2019 linfeng wang. All rights reserved.
//

#import "DABannerView.h"
#import "DABannerCollectionViewCell.h"
#import "DABannerFlowLayout.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]
#define randomColor random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

@interface DABannerView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation DABannerView {
    NSArray <UIColor *>*_colorArr;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _autoScroll = YES;
        _showPageControl = YES;
        _durationTime = 2.0f;
        [self addSubview:self.collectionView];
        [self addSubview:self.pageControl];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackGround) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForeGround) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}

- (void)enterBackGround {
    if (self.timer) {
        self.timer.fireDate = [NSDate distantFuture];
    }
}

- (void)enterForeGround {
    if (self.timer) {
        self.timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:self.durationTime];
    }
}

#pragma mark -- action
- (void)timerAction:(NSTimer *)timer {
    NSIndexPath *indexPath = [self.collectionView indexPathsForVisibleItems].lastObject;
    NSIndexPath *nextPath = [NSIndexPath indexPathForItem:(indexPath.item + 1)%(self.urlStringForImageArr.count+2) inSection:indexPath.section];
    [self.collectionView scrollToItemAtIndexPath:nextPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

#pragma mark -- collectionView delegate and datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.urlStringForImageArr.count + 2;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DABannerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DABannerCollectionViewCell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:self.urlStringForImageArr.lastObject]];
    }else if (indexPath.row ==_urlStringForImageArr.count + 1) {
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:self.urlStringForImageArr.firstObject]];
    }else {
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:self.urlStringForImageArr[indexPath.row - 1]]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index;
    if (indexPath.row == 0) {
        index = self.urlStringForImageArr.count - 1;
    } else if (indexPath.row == self.urlStringForImageArr.count + 1) {
        index = 0;
    } else {
        index = indexPath.row - 1;
    }
    if (self.selectItmeBlock) {
        self.selectItmeBlock(index);
    }
}

#pragma mark -- scrollview delegate
- (void)scrollViewWillBeginDragging:(UIScrollView*)scrollView {
    if (self.timer) {
        self.timer.fireDate = [NSDate distantFuture];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView*)scrollView willDecelerate:(BOOL)decelerate {
    if (self.timer) {
        self.timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:self.durationTime];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger page = offsetX / self.bounds.size.width;
    
    NSInteger itemsCount = [self.collectionView numberOfItemsInSection:0];
    if (page == 0) { // 第一页
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.urlStringForImageArr.count inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    } else if (page == itemsCount - 1) { // 最后一页
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView*)scrollView{
    // 手动调用减速完成的方法
    [self scrollViewDidEndDecelerating:self.collectionView];
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat page = offsetX / self.bounds.size.width;
    NSInteger itemsCount = [self.collectionView numberOfItemsInSection:0];
    if (page == 0) { // 第一页
        self.pageControl.currentPage = self.urlStringForImageArr.count - 1;
    } else if (page == itemsCount - 1) { // 最后一页
        self.pageControl.currentPage = 0;
    }else {
        self.pageControl.currentPage = page - 1;
    }
}

#pragma mark -- setter and getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        DABannerFlowLayout *layout = [[DABannerFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.bounces = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"DABannerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"DABannerCollectionViewCell"];
    }
    return _collectionView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        CGFloat width = 120;
        CGFloat height = 20;
        CGFloat pointX = ([UIScreen mainScreen].bounds.size.width - width) / 2;
        CGFloat pointY = self.bounds.size.height - height;
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(pointX, pointY, width, height)];
        _pageControl.numberOfPages = self.urlStringForImageArr.count;
        _pageControl.userInteractionEnabled = NO;
        _pageControl.pageIndicatorTintColor = [UIColor lightTextColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    }
    return _pageControl;
}

- (void)setUrlStringForImageArr:(NSArray *)urlStringForImageArr {
    _urlStringForImageArr = urlStringForImageArr;
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = urlStringForImageArr.count;
    [self.collectionView reloadData];
    //滚动到中间位置
    NSIndexPath* indexPath = [NSIndexPath indexPathForItem:1 inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    if (self.autoScroll) {
        [self initTimer];
    }
}

- (void)setDurationTime:(CGFloat)durationTime {
    _durationTime = durationTime;
    if (self.autoScroll) {
        [self initTimer];
    }
}

- (void)initTimer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer timerWithTimeInterval:self.durationTime target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    _timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:self.durationTime];
}

- (void)setAutoScroll:(BOOL)autoScroll {
    _autoScroll = autoScroll;
    if (autoScroll == NO) {
        if (_timer) {
            [_timer invalidate];
            _timer = nil;
        }
    }
}

@end
