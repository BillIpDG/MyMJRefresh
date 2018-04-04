//
//  MyMJTableView.h
//  MJRefreshDemo
//
//  Created by 叶敬光 on 2018/1/18.
//  Copyright © 2018年 Bill. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyMJTableViewDelegate <NSObject>

- (void)setupDataArrayWhenHeaderRefresh;
- (void)addModelToDataArrayWhenFooterRefreshWithCurrentPage:(NSInteger)currentPage;

@end

@interface MyMJTableView : UITableView


@property (nonatomic, assign) NSInteger totalPage;

@property (nonatomic, weak) id<MyMJTableViewDelegate> myMJ_delegate;
/** refresh When ViewDidAppear */
- (void)beginRefreshing;

- (void)initDataWithDelegate:(id<MyMJTableViewDelegate>)myMJDelegate;

@end
