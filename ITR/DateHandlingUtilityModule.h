//
//  DateHandlingUtilityModule.h
//  ITR
//
//  Created by if65 on 02/10/2016.
//  Copyright © 2016 if65. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateHandlingUtilityModule : NSObject

-(NSString*)dateToStringWithDate:(NSDate*)date;
-(NSString*)dateToStringWithDate:(NSDate*)date andTimeZone:(NSString*)timeZoneName;

-(NSDate*)sameDayOfTheLastYearWithDate:(NSDate*)date;
-(NSDate*)sameDayOfTheLastYearWithDate:(NSDate*)date andTimeZone:(NSString*)timeZoneName;

-(NSDate*)equivalentDayOfTheLastYearWithDate:(NSDate*)date;
-(NSDate*)equivalentDayOfTheLastYearWithDate:(NSDate*)date andTimeZone:(NSString*)timeZoneName;

-(NSDate*)addToDate:(NSDate*)date andNumberOfDays:(int)number;
-(NSDate*)addToDate:(NSDate*)date andNumberOfDays:(int)number andTimeZone:(NSString*)timeZoneName;

-(NSDate*)firstDayOfTheWeekWithDate:(NSDate*)date;
-(NSDate*)firstDayOfTheWeekWithDate:(NSDate*)date andTimeZone:(NSString*)timeZoneName;

-(NSDate*)lastDayOfTheWeekWithDate:(NSDate*)date;
-(NSDate*)lastDayOfTheWeekWithDate:(NSDate*)date andTimeZone:(NSString*)timeZoneName;

-(NSDate*)firstDayOfTheMonthWithDate:(NSDate*)date;
-(NSDate*)firstDayOfTheMonthWithDate:(NSDate*)date andTimeZone:(NSString*)timeZoneName;

-(NSDate*)lastDayOfTheMonthWithDate:(NSDate*)date;
-(NSDate*)lastDayOfTheMonthWithDate:(NSDate*)date andTimeZone:(NSString*)timeZoneName;

-(NSDate*)firstDayOfTheYearWithDate:(NSDate*)date;
-(NSDate*)firstDayOfTheYearWithDate:(NSDate*)date andTimeZone:(NSString*)timeZoneName;

-(NSDate*)lastDayOfTheYearWithDate:(NSDate*)date;
-(NSDate*)lastDayOfTheYearWithDate:(NSDate*)date andTimeZone:(NSString*)timeZoneName;

-(NSDate*)firstDayOfTheMobileYearWithDate:(NSDate*)date;
-(NSDate*)firstDayOfTheMobileYearWithDate:(NSDate*)date andTimeZone:(NSString*)timeZoneName;

@end
