//
//  CUSPagerView.m
//  PagerDemo
//
//  Created by apple on 2020/4/20.
//  Copyright © 2020 qiao. All rights reserved.
//

#import "CUSPagerView.h"
#import "CUSSegmentView.h"

@interface CUSPagerView () <UIScrollViewDelegate>
@property (nonatomic, assign) NSInteger currentPageIndex;
@property (nonatomic, assign) BOOL isSegmentScroll;
@property (nonatomic, strong) CUSSegmentView *segmentView;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation CUSPagerView

- (void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    NSAssert(self.viewControllers.count > 0, @"viewControllers参数必传");
    [self _setupSubviews];
}

- (void)setCurrentPageIndex:(NSInteger)currentPageIndex {
    _currentPageIndex = currentPageIndex;
    if (self.onPageChangedBlock) {
        self.onPageChangedBlock(currentPageIndex);
    }
}

- (void)_dealActions {
    __weak typeof(self) weak_self = self;
    _segmentView.onItemClickedBlock = ^(NSInteger index) {
        [weak_self _updateCurrentPageIndex:index];
    };
}
- (void)_updateCurrentPageIndex:(NSInteger)index {
    _isSegmentScroll = YES;
    self.currentPageIndex = index;
    [self _lazyLoadPages];
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width*index, 0) animated:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!_isSegmentScroll) {
        [_segmentView updateContentOffsetRate:scrollView.contentOffset.x/(scrollView.frame.size.width*1.0)];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _isSegmentScroll = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.currentPageIndex = round(scrollView.contentOffset.x/(scrollView.frame.size.width*1.0));
    [self _lazyLoadPages];
    if (!_isSegmentScroll) {
        [_segmentView updateItemIndex:_currentPageIndex];
    }
}

- (void)_setupSubviews {
    NSMutableArray *array = [@[] mutableCopy];
    for (UIViewController *temp in _viewControllers) {
        [array addObject:temp.title];
    }
    _segmentView = [[CUSSegmentView alloc] initWithFrame:CGRectMake(0, [self _safeTopBar], self.frame.size.width, 45)];
    _segmentView.titles = [array mutableCopy];
    [self addSubview:_segmentView];
    
    _scrollView = [UIScrollView new];
    _scrollView.frame = CGRectMake(0, _segmentView.frame.size.height+_segmentView.frame.origin.y, self.frame.size.width, self.frame.size.height-[self _safeTopBar]);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    [self addSubview:_scrollView];
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width*_viewControllers.count, _scrollView.frame.size.height);
    
    // 默认加载第一页
    UIViewController *page = self.viewControllers.firstObject;
    [_scrollView addSubview:page.view];
    page.view.frame = CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    
}

- (void)_lazyLoadPages {
    if (_currentPageIndex < _viewControllers.count) {
        UIViewController *page = self.viewControllers[_currentPageIndex];
        [_scrollView addSubview:page.view];
        page.view.frame = CGRectMake(_scrollView.frame.size.width*_currentPageIndex, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    }
}

- (CGFloat)_safeTopBar {
    if (@available(iOS 11.0, *)) {
        CGFloat top = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.top+44.0;
        return top;
    } else {
        return 64.0;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
