//
//  TextCheck.h
//  RHRedHorse
//
//  Created by panda on 15/1/16.
//  Copyright (c) 2015年 forex. All rights reserved.
//  输入文本校验

#import <Foundation/Foundation.h>

@interface TextCheck : NSObject
/**限制输入空格*/
+ (BOOL)isEmpty:(NSString *)str;
/**限制输入数字*/
+ (BOOL)validateNumber:(NSString*)number;
/**检测是否是手机号码*/
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
/**取款金额限制 取款金额必须为大于1的整数或小数，小数点后不超过2位*/
+ (BOOL)drawAmount:(NSString *)amount;
/**登录用户名称校验  限制只能使用邮箱和手机号*/
+ (BOOL)userNameLogin:(NSString *)userName;
/**昵称校验*/
+ (BOOL)nickNameCheck:(NSString *)nickName;
/**真实姓名校验*/
+ (BOOL)realNameCheck:(NSString *)realName;
/**密码校验*/
+ (BOOL)passwordCheck:(NSString *)password;
@end
