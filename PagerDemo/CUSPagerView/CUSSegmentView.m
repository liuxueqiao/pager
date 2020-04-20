//
//  CUSSegmentView.m
//  PagerDemo
//
//  Created by apple on 2020/4/20.
//  Copyright © 2020 qiao. All rights reserved.
//

#import "CUSSegmentView.h"

@interface CUSSegmentView () <UIScrollViewDelegate>
{
    CGFloat _itemWidth;
}
@property (nonatomic, strong) CALayer *tagView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSArray<UIButton *> *itemButtons;
@end

@implementation CUSSegmentView

- (void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    NSAssert(self.titles.count > 0, @"titles参数必传");
    self.backgroundColor = [UIColor whiteColor];
    _itemWidth = 80;
    _currentIndex = 0;
    [self _setupSubviews];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)updateContentOffsetRate:(CGFloat)offsetRate {
    // 更改线位置
    __block CGFloat itemWidth = _itemWidth;
    [UIView animateWithDuration:0.15 animations:^{
        CGRect rect = self.tagView.frame;
        rect.origin.x = itemWidth*offsetRate;
        self.tagView.frame = rect;
    }];
}

- (void)updateItemIndex:(NSInteger)index {
    [self _scrollToItem:index];
}

#pragma mark - privite

- (void)_scrollToItem:(NSInteger)index {
    [_itemButtons[_currentIndex] setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_itemButtons[index] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _currentIndex = index;
    [self _scrollToCenter];
    
    // 更改线位置
    CGRect rect = self.tagView.frame;
    rect.origin.x = _itemWidth*index;
    self.tagView.frame = rect;
}

- (void)_scrollToCenter {
    if (_currentIndex < 3) {
        [_scrollView scrollRectToVisible:CGRectMake(0, 0, _itemWidth, _scrollView.frame.size.height) animated:YES];
    } else if (_currentIndex > _itemButtons.count-4) {
        [_scrollView scrollRectToVisible:CGRectMake(_itemWidth*(_itemButtons.count-1), 0, _itemWidth, _scrollView.frame.size.height) animated:YES];
    } else {
        UIView *currItemView = _scrollView.subviews[_currentIndex];
        CGFloat currItemViewCenterX = currItemView.frame.origin.x - _scrollView.contentOffset.x;
        if (currItemViewCenterX < self.frame.size.width/2.0) {
            [_scrollView scrollRectToVisible:CGRectMake(_itemWidth*(_currentIndex-2), 0, _itemWidth, _scrollView.frame.size.height) animated:YES];
        } else {
            [_scrollView scrollRectToVisible:CGRectMake(_itemWidth*(_currentIndex+2), 0, _itemWidth, _scrollView.frame.size.height) animated:YES];
        }
        
    }
}

- (void)_onItemClicked:(UIButton *)sender {
    NSInteger index = sender.tag-100;
    [self _scrollToItem:index];
    
    if (self.onItemClickedBlock) {
        self.onItemClickedBlock(index);
    }
}

- (void)_setupSubviews {
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    [self addSubview:scrollView];
    _scrollView = scrollView;
    
    NSMutableArray *buttons = [@[] mutableCopy];
    NSArray *items = _titles;
    NSInteger i=0;
    for (NSString *item in items) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(_itemWidth*i, 0, _itemWidth, scrollView.frame.size.height-2);
        [btn setTitle:item forState:UIControlStateNormal];
        [btn setTitleColor:i==_currentIndex?[UIColor blackColor]:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(_onItemClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 100+i;
        [scrollView addSubview:btn];
        [buttons addObject:btn];
        i++;
    }
    scrollView.contentSize = CGSizeMake(_itemWidth*items.count, scrollView.frame.size.height);
    _itemButtons = buttons;
    
    CALayer *tag = [CALayer new];
    tag.frame = CGRectMake(0, _scrollView.frame.size.height-3, _itemWidth, 2);
    tag.backgroundColor = [UIColor blueColor].CGColor;
    [_scrollView.layer addSublayer:tag];
    _tagView = tag;
    
    CALayer *line = [CALayer new];
    line.frame = CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1);
    line.backgroundColor = [UIColor separatorColor].CGColor;
    [self.layer addSublayer:line];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
