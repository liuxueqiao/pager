//
//  ViewController.m
//  PagerDemo
//
//  Created by apple on 2020/4/20.
//  Copyright © 2020 qiao. All rights reserved.
//

#import "ViewController.h"
#import "ItemViewController.h"
#import "CUSPagerView.h"

@interface ViewController ()
@property (nonatomic, strong) NSArray *viewControllers;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Pager Demo";
    
    NSArray *colors = @[[UIColor redColor], [UIColor blueColor], [UIColor greenColor], [UIColor cyanColor],
    [UIColor lightGrayColor], [UIColor grayColor], [UIColor brownColor], [UIColor purpleColor], [UIColor redColor], [UIColor blueColor]];
    
    NSMutableArray *array = [@[] mutableCopy];
    for (int i=0; i<10; i++) {
        ItemViewController *vc1 = [ItemViewController new];
        vc1.view.backgroundColor = colors[i];
        vc1.title = [NSString stringWithFormat:@"页面%d",i];
        [self addChildViewController:vc1]; // 注意，要加入childViewController
        [array addObject:vc1];
    }
    _viewControllers = [array mutableCopy];
    
    CUSPagerView *view = [[CUSPagerView alloc] initWithFrame:self.view.bounds];
    view.viewControllers = [array mutableCopy];
    [self.view addSubview:view];
    
    __weak typeof(self) weak_self = self;
    view.onPageChangedBlock = ^(NSInteger index) {
        [weak_self onPageChanged:index];
    };
    
}

- (void)onPageChanged:(NSInteger)index {
    ItemViewController *vc = _viewControllers[index];
    [vc loadData]; //子视图都要求在loadData方法里请求数据等操作
}


@end
