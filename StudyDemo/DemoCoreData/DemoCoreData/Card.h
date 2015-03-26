//
//  Card.h
//  DemoCoreData
//
//  Created by 徐臻 on 15/3/26.
//  Copyright (c) 2015年 xuzhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Card : NSManagedObject

@property (nonatomic, retain) NSString * no;
@property (nonatomic, retain) NSManagedObject *person;

@end
