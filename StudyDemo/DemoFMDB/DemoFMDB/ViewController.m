//
//  ViewController.m
//  DemoFMDB
//
//  Created by 徐臻 on 15/3/30.
//  Copyright (c) 2015年 xuzhen. All rights reserved.
//

#import "ViewController.h"
#import "FMDatabase.h"

@interface ViewController ()
@property(nonatomic,strong)FMDatabase *db;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //1.获得数据库文件的路径
       NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *fileName=[doc stringByAppendingPathComponent:@"student.sqlite"];
         //2.获得数据库
         FMDatabase *db=[FMDatabase databaseWithPath:fileName];
         //3.打开数据库
         if ([db open]) {
                 //4.创表
                BOOL result=[db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_student (id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, age integer NOT NULL);"];
               if (result) {
                        NSLog(@"创表成功");
                    }else
                        {
                                NSLog(@"创表失败");
                            }
            }
         self.db=db;
    
   // [self insert];
    NSLog(@"*******************");
    [self query];
     NSLog(@"--------------");
    [self delete];
    [self query];
}

-(void)openDb:(NSString *)dbname{
    //取得数据库保存路径，通常保存沙盒Documents目录
    NSString *directory=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSLog(@"%@",directory);
    NSString *filePath=[directory stringByAppendingPathComponent:dbname];
    //创建FMDatabase对象
    self.database=[FMDatabase databaseWithPath:filePath];
    //打开数据上
    if ([self.database open]) {
        NSLog(@"数据库打开成功!");
    }else{
        NSLog(@"数据库打开失败!");
    }
}


 //插入数据
-(void)insert
 {
     for (int i = 0; i<10; i++) {
         NSString *name = [NSString stringWithFormat:@"jack-%d", arc4random_uniform(100)];
         // executeUpdate : 不确定的参数用?来占位
         [self.db executeUpdate:@"INSERT INTO t_student (name, age) VALUES (?, ?);", name, @(arc4random_uniform(40))];
     }
}

//删除数据
-(void)delete
{
     //    [self.db executeUpdate:@"DELETE FROM t_student;"];
     [self.db executeUpdate:@"DROP TABLE IF EXISTS t_student;"];
     [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_student (id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, age integer NOT NULL);"];
 }

//查询
- (void)query
{
    // 1.执行查询语句
     FMResultSet *resultSet = [self.db executeQuery:@"SELECT * FROM t_student"];

     // 2.遍历结果
     while ([resultSet next]) {
         int ID = [resultSet intForColumn:@"id"];
         NSString *name = [resultSet stringForColumn:@"name"];
         int age = [resultSet intForColumn:@"age"];
         NSLog(@"%d %@ %d", ID, name, age);
     }
}

@end
