//
//  View99Controller.m
//  MJRefreshDemo
//
//  Created by 叶敬光 on 2018/1/18.
//  Copyright © 2018年 Bill. All rights reserved.
//

#import "View99Controller.h"
#import "MJRefresh.h"
#import "Header.h"
#import "MyMJTableView.h"

@interface View99Controller ()<MyMJTableViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet MyMJTableView *tableView;
/**  */
@property (nonatomic, strong) NSMutableArray *dataArray;


@end

@implementation View99Controller


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView initDataWithDelegate:self];
    
    self.dataArray = [NSMutableArray arrayWithArray:@[@"1"]];
    
    
    
}

//- (void)initTableView {
//    // 去除多余的分割线
//    self.tableView.tableFooterView = [[UIView alloc]init];
//    //    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 375.0, 44)];
//    //    self.tableView.tableFooterView.backgroundColor = [UIColor redColor];
//}



- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 马上进入刷新状态
    [self.tableView beginRefreshing];
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

#pragma mark - MyMJTableView 的代理方法
// 这里写下拉刷新时，加载数据源的代码
- (void)setupDataArrayWhenHeaderRefresh {
    // 1.从服务器请求获得总页数
    self.tableView.totalPage = 17 - 15;
    
    // 2.从服务器请求获得数据源json，并初始化为model数组
    self.dataArray = [NSMutableArray arrayWithArray:@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15"]];
}

// 这里写上拉加载时，加载数据源的代码
- (void)addModelToDataArrayWhenFooterRefreshWithCurrentPage:(NSInteger)currentPage {
    
    int lastInt = [self.dataArray.lastObject intValue];
    NSString *string = [NSString stringWithFormat:@"%d",lastInt + 1];
    [self.dataArray addObject:string];
}

@end
