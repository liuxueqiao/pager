//
//  CUSPagerView.h
//  PagerDemo
//
//  Created by apple on 2020/4/20.
//  Copyright © 2020 qiao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CUSPagerView : UIView

@property (nonatomic, strong) void(^onPageChangedBlock)(NSInteger index);
@property (nonatomic, strong) NSArray *viewControllers;

@end

NS_ASSUME_NONNULL_END
