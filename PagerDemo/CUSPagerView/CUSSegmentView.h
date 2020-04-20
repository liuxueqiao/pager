//
//  CUSSegmentView.h
//  PagerDemo
//
//  Created by apple on 2020/4/20.
//  Copyright © 2020 qiao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CUSSegmentView : UIView

@property (nonatomic, strong) void(^onItemClickedBlock)(NSInteger index);
@property (nonatomic, strong) NSArray *titles;

- (void)updateContentOffsetRate:(CGFloat)offsetRate;
- (void)updateItemIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
