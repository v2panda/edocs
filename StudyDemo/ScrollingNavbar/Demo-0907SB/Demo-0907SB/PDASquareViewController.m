//
//  PDASquareViewController.m
//  Demo-0907SB
//
//  Created by Panda on 15/9/14.
//  Copyright (c) 2015年 徐臻. All rights reserved.
//

#import "PDASquareViewController.h"
#import "PDASquareNavbar.h"
#import "SquareCashStyleBehaviorDefiner.h"
#import "BLKDelegateSplitter.h"

@interface PDASquareViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic)  UITableView *tableView;
@property (nonatomic) BLKDelegateSplitter *delegateSplitter;
@property (nonatomic) PDASquareNavbar *myCustomBar;
@end

@implementation PDASquareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Setup the bar
    self.myCustomBar = [[PDASquareNavbar alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.frame), 100.0)];
    
    SquareCashStyleBehaviorDefiner *behaviorDefiner = [[SquareCashStyleBehaviorDefiner alloc] init];
    [behaviorDefiner addSnappingPositionProgress:0.0 forProgressRangeStart:0.0 end:0.5];
    [behaviorDefiner addSnappingPositionProgress:1.0 forProgressRangeStart:0.5 end:1.0];
    behaviorDefiner.snappingEnabled = YES;
    behaviorDefiner.elasticMaximumHeightAtTop = YES;
    self.myCustomBar.behaviorDefiner = behaviorDefiner;
    

    
    // Configure a separate UITableViewDelegate and UIScrollViewDelegate (optional)
    self.delegateSplitter = [[BLKDelegateSplitter alloc] initWithFirstDelegate:behaviorDefiner secondDelegate:self];

    
    // Setup the table view
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    self.tableView.contentInset = UIEdgeInsetsMake(self.myCustomBar.maximumBarHeight, 0.0, 0.0, 0.0);
    self.tableView.dataSource =  self;
    
    self.tableView.delegate = (id<UITableViewDelegate>)self.delegateSplitter;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.myCustomBar];
    
    // Add close button - it's pinned to the top right corner, so it doesn't need to respond to bar height changes
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(self.myCustomBar.frame.size.width-40.0, 25.0, 30.0, 30.0);
    closeButton.tintColor = [UIColor whiteColor];
    [closeButton setImage:[UIImage imageNamed:@"Close.png"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeViewController:) forControlEvents:UIControlEventTouchUpInside];
    [self.myCustomBar addSubview:closeButton];
}

- (void)closeViewController:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [NSString stringWithFormat:@"第几%ld行",indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"IMG_0007"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 6) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
