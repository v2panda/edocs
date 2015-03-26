//
//  ViewController.m
//  DemoCoreData
//
//  Created by 徐臻 on 15/3/26.
//  Copyright (c) 2015年 xuzhen. All rights reserved.
//

#import "ViewController.h"
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Person.h"
#import "AppDelegate.h"
#import "Card.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 自己创建的时候用
  //  [self runCoreData];
    
    
}
- (IBAction)Clicked:(UIButton *)sender
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = app.managedObjectContext;
    switch (sender.tag) {
        case 0://添加一条数据到数据库
        {
            NSLog(@"0");
            
            Person *p = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:context];
            p.name = @"李四";
            p.age = @11;
            
            Card *card = [NSEntityDescription insertNewObjectForEntityForName:@"Card" inManagedObjectContext:context];
            card.no = @"123";
            p.card = card;
            //保存设置 把内存中的数据同步到数据库文件当中
            [app saveContext];
        }
            
            break;
            
        case 1://删除
        {
           NSLog(@"1");
            NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Person"];
            NSArray *persons = [app.managedObjectContext executeFetchRequest:request error:nil];
            for (Person *p in persons) {
                
                    [app.managedObjectContext deleteObject:p];
                    
                    [app saveContext];
            }

        }
            
            break;
            
        case 2://修改
        {
            NSLog(@"2");
            NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Person"];
            NSArray *persons = [context executeFetchRequest:request error:nil];
            for (Person *p in persons) {
                if ([p.name isEqualToString:@"李四"]) {
                    p.name = @"王五";
                    [app saveContext];
                }
            }

        }
            break;
            
        case 3://查询数据库里面的数据
        {
            NSLog(@"3");
            //创建查询请求
            NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Person"];
            NSArray *persons = [app.managedObjectContext executeFetchRequest:request error:nil];
            for (Person *p in persons) {
                NSLog(@"%@ %@",p.name,p.age);
                NSLog(@" %@",p.card.no);
            }
        }
            
            break;
    }
}

- (void)runCoreData
{
    // 从应用程序包中加载模型文件
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    // 传入模型对象，初始化NSPersistentStoreCoordinator
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model] ;
    // 构建SQLite数据库文件的路径
    NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSURL *url = [NSURL fileURLWithPath:[docs stringByAppendingPathComponent:@"person.data"]];
    // 添加持久化存储库，这里使用SQLite作为存储库
    NSError *error = nil;
    NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
    if (store == nil) { // 直接抛异常
        [NSException raise:@"添加数据库错误" format:@"%@", [error localizedDescription]];
    }
    // 初始化上下文，设置persistentStoreCoordinator属性
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
    context.persistentStoreCoordinator = psc;
    // 用完之后，记得要[context release];
}

@end
