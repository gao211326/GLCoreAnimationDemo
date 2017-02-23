//
//  ViewController.m
//  GLCoreAnimationDemo
//
//  Created by 高磊 on 2017/2/20.
//  Copyright © 2017年 高磊. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic,strong)NSMutableArray *datas;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.datas = [NSMutableArray arrayWithObjects:@"CATransitionViewController",@"CAAnimationGroupViewController",@"CABasicAnimationViewController",@"CAKeyframeAnimationViewController",@"CASpringAnimationViewController", nil];
    
    //去除多余不显示cell的线
    self.tableView.tableFooterView = [[UIView alloc] init];
}



#pragma mark == UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"animationCell" forIndexPath:indexPath];

    cell.textLabel.text = self.datas[indexPath.row];
    
    return cell;
}

#pragma mark == UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    Class class = NSClassFromString(self.datas[indexPath.row]);
    
    UIViewController *vc = [[class alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark == 懒加载
- (NSMutableArray *)datas
{
    if (nil == _datas)
    {
        _datas = [[NSMutableArray alloc] init];
    }
    return _datas;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
