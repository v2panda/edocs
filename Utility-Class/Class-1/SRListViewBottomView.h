//
//  SRListViewBottomView.h
//  StackRoom
//
//  Created by jack zhou on 14-2-26.
//  Copyright (c) 2014年 JZ. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    StatusType_Loading =1,//加载中...
    StatusType_NoMore  =2,
	StatusType_NoStart =3
}StatusType;//view 状态
@interface SRListViewBottomView : UIView
@property(nonatomic,unsafe_unretained) StatusType statusType;
+ (instancetype)creatWithSize:(CGSize)size;
@end
