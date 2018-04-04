//
//  View02Controller.m
//  MJRefreshDemo
//
//  Created by 叶敬光 on 2018/1/17.
//  Copyright © 2018年 Bill. All rights reserved.
//

#import "View02Controller.h"
#import "MJRefresh.h"
#import "Header.h"

@interface View02Controller ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**  */
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger totalPage;
/**  */
@property (nonatomic, assign) CGFloat offsetYAtBegin;
/**  */
@property (nonatomic, assign) CGFloat footerHeight;

@end

@implementation View02Controller


- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPage = 1;
    self.totalPage = 1;
    self.dataArray = [NSMutableArray arrayWithArray:@[@"1"]];
    
    [self initTableView];
    [self initHeaderAndFooter];
    
}

- (void)initTableView {
    // 去除多余的分割线
    self.tableView.tableFooterView = [[UIView alloc]init];
    //    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 375.0, 44)];
    //    self.tableView.tableFooterView.backgroundColor = [UIColor redColor];
}

- (void)initHeaderAndFooter {
    @weakify(self);
    // 用法一：
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        @strongify(self);
        [self loadNewData];
    }];
    //     用法二：（等价上面用法一）
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    //    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    //--------------------------------------------------------
    
    [self initFooter];
    
}

- (void)fetchCommentsNextPage:(BOOL)nextPage{
    NSInteger requestPage = 0;
    if (nextPage) {//上拉加载
        if (self.currentPage + 1 <= self.totalPage) { // 有数据可以上拉
            self.currentPage++;
            requestPage = self.currentPage;
            
            NSString *string = [NSString stringWithFormat:@"%ld",self.currentPage - 1 + 15];
            [self.dataArray addObject:string];
            [self.tableView reloadData];
            if (self.currentPage == self.totalPage) {
                [self initNoMoreData];
                CGFloat h = self.tableView.contentSize.height - kScreenHeight + 64 + self.footerHeight;
                //    NSLog(@"jjjj = %f",h);
                [self.tableView layoutIfNeeded];  //加上这段代码,
                [self.tableView setContentOffset:CGPointMake(0, self.offsetYAtBegin + h) animated:YES];
                //                NSLog(@"aaaa = %f",self.tableView.contentOffset.y);
                //                CGFloat h =  self.tableView.contentOffset.y + 44;
                //                NSLog(@"gggg = %f",h);
                //                self.tableView.contentOffset = CGPointMake(0,44);
                //                [self.tableView setContentOffset:CGPointMake(0, 100) animated:YES];
            }else{
                [self.tableView.mj_footer endRefreshing];
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
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
    self.tableView.tableFooterView = self.tableView.mj_footer;
    self.footerHeight = self.tableView.tableFooterView.frame.size.height + 10;
    //    NSLog(@"mmmm = %f",self.footerHeight);
}

- (void)headerRefresh {
    
    self.dataArray = [NSMutableArray arrayWithArray:@[@"1",@"2"]];
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    
    self.offsetYAtBegin = self.tableView.contentOffset.y;
    // 下面处理底部
    if (self.currentPage == self.totalPage) {
        //所有数据太少，第一页就够显示完，底部“已经显示完毕”就应该加载紧跟出来
        [self initNoMoreData];
    }else{
        self.tableView.tableFooterView = [[UIView alloc]init];
        [self initFooter];
    }
}

- (void)initFooter {
    @weakify(self);
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self fetchCommentsNextPage:YES];
    }];
}

- (void)loadNewData {
    [self fetchCommentsNextPage:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//为每个分区设置单元格
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
//为单元格配置数据
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    定义一个重用标志符号
    static NSString *reuse = @"log";
    //    从重用队列里面取标识符一样的cell（单元格）
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    //    如果重用队列里找不到就创建一个新的cell
    if (!cell) {
        //        创建单元格给定样式
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuse];
        //NSLog(@"这是新的");
    }else{
        //NSLog(@"这是重用的");
    }
    //为cell的属性赋值
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
    
}

@end
