//
//  PDASquareTableViewController.m
//  Demo-0907SB
//
//  Created by Panda on 15/9/14.
//  Copyright (c) 2015年 徐臻. All rights reserved.
//

#import "PDASquareTableViewController.h"
#import "PDASquareNavbar.h"
#import "BLKDelegateSplitter.h"
#import "SquareCashStyleBehaviorDefiner.h"

@interface PDASquareTableViewController ()
@property (nonatomic) PDASquareNavbar *myCustomBar;
@property (nonatomic) BLKDelegateSplitter *delegateSplitter;
@end

@implementation PDASquareTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
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
    self.tableView.delegate = (id<UITableViewDelegate>)self.delegateSplitter;
    
    [self.view addSubview:self.myCustomBar];
    
    self.tableView.contentInset = UIEdgeInsetsMake(self.myCustomBar.maximumBarHeight, 0.0, 0.0, 0.0);
//    self.tableView.contentOffset = CGPointMake(0, 1);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SSS" forIndexPath:indexPath];
    
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
