//
//  MyMJTableView.m
//  MJRefreshDemo
//
//  Created by 叶敬光 on 2018/1/18.
//  Copyright © 2018年 Bill. All rights reserved.
//

#import "MyMJTableView.h"
#import "MJRefresh.h"
#import "Header.h"

@interface MyMJTableView ()

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) CGFloat offsetYAtBegin;

@property (nonatomic, assign) CGFloat footerHeight;

@end

@implementation MyMJTableView

- (void)initDataWithDelegate:(id<MyMJTableViewDelegate>)myMJDelegate {
    
    self.myMJ_delegate = myMJDelegate;
    self.currentPage = 1;
    self.totalPage = self.currentPage;
    
    
    [self initTableView];
    [self initHeaderAndFooter];
    
}

- (void)initTableView {
    // 去除多余的分割线
    self.tableFooterView = [[UIView alloc]init];
    //    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 375.0, 44)];
    //    self.tableView.tableFooterView.backgroundColor = [UIColor redColor];
}



- (void)initHeaderAndFooter {
    // Set the callback（一Once you enter the refresh status，then call the action of target，that is call [self loadNewData]）
    MJRefreshNormalHeader *header =  [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    self.mj_header = header;
    //--------------------------------------------------------
    
    [self initFooter];
    
}


- (void)fetchCommentsNextPage:(BOOL)nextPage{
    NSInteger requestPage = 0;
    if (nextPage) {//上拉加载
        if (self.currentPage + 1 <= self.totalPage) { // 有数据可以上拉
            self.currentPage++;
            requestPage = self.currentPage;
            
            if ([self.myMJ_delegate respondsToSelector:@selector(addModelToDataArrayWhenFooterRefreshWithCurrentPage:)]) {
                [self.myMJ_delegate addModelToDataArrayWhenFooterRefreshWithCurrentPage:self.currentPage];
            }
            
            
            [self reloadData];
            if (self.currentPage == self.totalPage) {
                [self initNoMoreData];
                CGFloat h = self.contentSize.height - kScreenHeight + 64 + self.footerHeight;
                //    NSLog(@"jjjj = %f",h);
                [self layoutIfNeeded];  //加上这段代码,
                [self setContentOffset:CGPointMake(0, self.offsetYAtBegin + h) animated:YES];
                //                NSLog(@"aaaa = %f",self.tableView.contentOffset.y);
                //                CGFloat h =  self.tableView.contentOffset.y + 44;
                //                NSLog(@"gggg = %f",h);
                //                self.tableView.contentOffset = CGPointMake(0,44);
                //                [self.tableView setContentOffset:CGPointMake(0, 100) animated:YES];
            }else{
                [self.mj_footer endRefreshing];
            }
        }else{// 没数据可以上拉
            [self initNoMoreData];
        }
        
    }else{// 下拉刷新
        self.currentPage = 1;
        requestPage = 1;
        [self headerRefresh];
    }
    //    [self.tableView reloadData];
    //    [self.tableView.mj_header endRefreshing];
}

- (void)initNoMoreData {
    [self.mj_footer endRefreshingWithNoMoreData];
    self.tableFooterView = self.mj_footer;
    self.footerHeight = self.tableFooterView.frame.size.height + 10;
    //    NSLog(@"mmmm = %f",self.footerHeight);
}

- (void)headerRefresh {
    
    
    if ([self.myMJ_delegate respondsToSelector:@selector(setupDataArrayWhenHeaderRefresh)]) {
        [self.myMJ_delegate setupDataArrayWhenHeaderRefresh];
    }
    
    [self reloadData];
    [self.mj_header endRefreshing];
    
    self.offsetYAtBegin = self.contentOffset.y;
    // 下面处理底部
    if (self.currentPage == self.totalPage) {
        //所有数据太少，第一页就够显示完，底部“已经显示完毕”就应该加载紧跟出来
        [self initNoMoreData];
    }else{
        self.tableFooterView = [[UIView alloc]init];
        [self initFooter];
    }
}

- (void)initFooter {
    @weakify(self);
    self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self fetchCommentsNextPage:YES];
    }];
}

- (void)loadNewData {
    [self fetchCommentsNextPage:NO];
}

- (void)beginRefreshing {
    // 马上进入刷新状态
    [self.mj_header beginRefreshing];
}

@end
