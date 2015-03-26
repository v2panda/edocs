//
//  Person.h
//  DemoCoreData
//
//  Created by 徐臻 on 15/3/26.
//  Copyright (c) 2015年 xuzhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Card;

@interface Person : NSManagedObject

@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Card *card;

@end
