//
//  ViewController.m
//  DemoAttachView
//
//  Created by 徐臻 on 15/2/10.
//  Copyright (c) 2015年 xuzhen. All rights reserved.
//

#import "ViewController.h"

#import "AttachedCell.h"
#import "MainCell.h"    

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;

    NSMutableArray *grouparr0;
}

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"DemoAttachView";

    [self initTableView];
    
    [self initDataSource];
}

-(void)initDataSource
{
   
    NSMutableDictionary *nameAndStateDic1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"MainCell",@"cell",@"肖利",@"name",@"NO",@"state",nil];
    NSMutableDictionary *nameAndStateDic2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"MainCell",@"cell",@"段婷婷",@"name",@"NO",@"state",nil];
    NSMutableDictionary *nameAndStateDic3 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"MainCell",@"cell",@"毛凡",@"name",@"NO",@"state",nil];
     NSMutableDictionary *nameAndStateDic4 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"MainCell",@"cell",@"毛凡",@"name",@"NO",@"state",nil];
    grouparr0 = [[NSMutableArray alloc] initWithObjects:nameAndStateDic1,nameAndStateDic2,nameAndStateDic3, nameAndStateDic4,nil];
    

}

-(void)initTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight- 200)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

#pragma mark - DataSource & Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return grouparr0.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([grouparr0[indexPath.row][@"cell"] isEqualToString:@"MainCell"]) {

        static NSString *CellIdentifier = @"MainCell";
        
        MainCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MainCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            
            cell.Headerphoto.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png",arc4random()%11]];
            cell.nameLabel.text = grouparr0[indexPath.row][@"name"];
            cell.IntroductionLabel.text = @"他开着你的花，在每一个晚霞，靠着你的肩膀绣着枝桠";
            cell.networkLabel.text = @"2G";
        }
        
        return cell;
    }
    else if([grouparr0[indexPath.row][@"cell"] isEqualToString:@"AttachedCell"]){
        
        static NSString *CellIdentifier = @"AttachedCell";
        
        AttachedCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[AttachedCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.imageLine.image = [UIImage imageNamed:@"line.png"];
        }
        
        return cell;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //点击cell后 改变cell的颜色 渐变
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSIndexPath *path = nil;
    if ([grouparr0[indexPath.row][@"cell"] isEqualToString:@"MainCell"])
    {
        if ([grouparr0[indexPath.row][@"cell"] isEqualToString:@"MainCell"]) {
            path = [NSIndexPath indexPathForItem:(indexPath.row+1) inSection:indexPath.section];
        }
        else if ([grouparr0[indexPath.row][@"cell"] isEqualToString:@"AttachedCell"])
        {
            path = indexPath;
        }
    
        NSLog(@"现在是第%ld行",indexPath.row);
    
        if ([grouparr0[indexPath.row][@"state"] boolValue] ) {
            // 关闭附加cell
            NSMutableDictionary *dd = grouparr0[indexPath.row];
            NSString *name = dd[@"name"];
            NSMutableDictionary *nameAndStateDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"MainCell",@"cell",name,@"name",@"NO",@"state",nil];
            grouparr0[(path.row-1)] = nameAndStateDic;
            [grouparr0 removeObjectAtIndex:path.row];
            NSLog(@"MainCell's grouparr0:%@",grouparr0);
            [_tableView beginUpdates];
            [_tableView deleteRowsAtIndexPaths:@[path]  withRowAnimation:UITableViewRowAnimationMiddle];
            [_tableView endUpdates];
        }
        else
        {
            // 打开附加cell
            NSMutableDictionary *dd = grouparr0[indexPath.row];
            NSString *name = dd[@"name"];
        
            NSMutableDictionary *nameAndStateDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"MainCell",@"cell",name,@"name",@"YES",@"state",nil];

            grouparr0[(path.row-1)] = nameAndStateDic;
        
            NSMutableDictionary *nameAndStateDic1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"AttachedCell",@"cell",@"YES",@"state",nil];
        
            [grouparr0 insertObject:nameAndStateDic1 atIndex:path.row];
            NSLog(@"AttachedCell's grouparr0:%@",grouparr0);
            [_tableView beginUpdates];
            [_tableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationMiddle];
            [_tableView endUpdates];
        }
    }
}



@end
