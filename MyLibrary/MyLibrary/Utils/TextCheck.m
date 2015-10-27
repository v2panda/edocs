//
//  TextCheck.m
//  RHRedHorse
//
//  Created by panda on 15/1/16.
//  Copyright (c) 2015年 forex. All rights reserved.
//   输入文本校验

#import "TextCheck.h"
#import "RHMBShowTool.h"

@implementation TextCheck
/**限制输入空格*/
+ (BOOL)isEmpty:(NSString *)str
{
    if (!str) {
        return YES;
    } else {
        //A character set containing only the whitespace characters space (U+0020) and tab (U+0009) and the newline and nextline characters (U+000A–U+000D, U+0085).
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        
        //Returns a new string made by removing from both ends of the receiver characters contained in a given character set.
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] == 0) {
            return YES;
        } else {
            [RHMBShowTool showError:@"禁止输入空格"];
            return NO;
        }
    }
}
/**限制输入数字*/
+ (BOOL)validateNumber:(NSString*)number
{
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            [RHMBShowTool showError:@"请您输入整数数字"];
            break;
        }
        i++;
    }
    return res;
}

//检测是否是手机号码
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        [RHMBShowTool showError:@"请您输入正确的手机号码"];
        return NO;
    }
}

//取款金额限制 取款金额必须为大于1的整数或小数，小数点后不超过2位
+ (BOOL)drawAmount:(NSString *)amount
{
    NSString *  Am = @"^([1-9][\\d]{0,}|0)(\\.[\\d]{1,2})?$";
    NSPredicate *regextestAmount = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",Am];
    if ([regextestAmount evaluateWithObject:amount] == YES) {
        return YES;
    }else{
        return NO;
    }
}
//登录用户名称校验
+ (BOOL)userNameLogin:(NSString *)userName
{
    NSString *  na = @"^[a-z0-9]+([._\\-]*[a-z0-9])*@([a-z0-9]+[-a-z0-9]*[a-z0-9]+.){1,63}[a-z0-9]+$";
    NSString * ph = @"^[1]\\d{10}";
    NSPredicate *regextestNa = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",na];
    NSPredicate *regextestPh = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",ph];
    if ([regextestNa evaluateWithObject:userName] == YES||[regextestPh evaluateWithObject:userName] == YES) {
        return YES;
    }else{
        return NO;
    }
}

//nickname: [/^[\@A-Za-z0-9\u0391-\uFFE5\!\#\$\%\^\&\*\.\~]{2,10}$/, "昵称由2-10位数字、字符、字母、汉字组成"]
+ (BOOL)nickNameCheck:(NSString *)nickName
{
    NSString *na = @"^[\\@A-Za-z0-9\u0391-\uFFE5\\!\\#\\$\%\\^\\&\\*\\.\\~]{2,10}$";

    NSPredicate *regextestNa = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",na];

    if ([regextestNa evaluateWithObject:nickName] == YES) {
        return YES;
    }else{
        return NO;
    }
}

// ,realname: [/^[\@A-Za-z\u0391-\uFFE5]{2,10}$/, "真实姓名由2-10位字母、汉字组成"]
+ (BOOL)realNameCheck:(NSString *)realName
{
    NSString *na = @"^[\\@A-Za-z\u0391-\uFFE5]{2,10}$";
    
    NSPredicate *regextestNa = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",na];
    
    if ([regextestNa evaluateWithObject:realName] == YES) {
        return YES;
    }else{
        return NO;
    }
}

//password: [/^[\@A-Za-z0-9\!\#\$\%\^\&\*\.\~]{6,20}$/, "密码由6-20位数字、字母等组成"]
+ (BOOL)passwordCheck:(NSString *)password
{
    NSString *na = @"^[\\@A-Za-z0-9\\!\\#\\$\\%\\^\\&\\*\\.\\~]{6,20}$";
    
    NSPredicate *regextestNa = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",na];
    
    if ([regextestNa evaluateWithObject:password] == YES) {
        return YES;
    }else{
        return NO;
    }
}

//

@end
