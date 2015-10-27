//
//  NSDate+Formatter.h
//  Garfield-Common
//
//  Created by Jack Zhou on 7/8/14.
//
//

#import <Foundation/Foundation.h>

@interface NSDate (Formatter)
/**
 *  格式化时间 规则：
 *  <1分钟: @"刚刚"
 *  >1分钟 & <60分: @"xx秒前"
 *  >60分钟 & <24小时: @"xx小时前"
 *  >24小时 & <7天: @"xx天前"
 *  >7小时 & <30天: @"xx周前"
 *  >30天 @"yyyy年MM月dd日 HH:mm"
 *  @return 时间的string
 */
- (NSString *)formatterModel1;


/**
 *  格式化时间 规则：
 *  <1分钟: @"刚刚"
 *  >1分钟 & <60分: @"xx秒前"
 *  >60分钟 & <24小时: @"xx小时前"
 *  >24小时 & <7天: @"xx天前"
 *  >7小时 & <30天: @"xx周前"
 *  >30天 & <24个月: @"xx月前"
 *  >24个月:  @"xx年前"
 *  @return 时间的string
 */
- (NSString *)formatterModel2;

-(NSString *)formatterModel3;
-(NSString *)formatterModel4;
/**
 *最近三天显示今天，昨天，之前的如果是今年的则显示日期，如果是去年的则显示年份
 */
-(NSString *)formatterModel5;
-(NSString *)formatterModel6;

//互动中心专用
+ (NSString *)formatterModel7:(long long int)time;
@end
