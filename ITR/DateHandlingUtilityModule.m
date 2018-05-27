//
//  DateHandlingUtilityModule.m
//  ITR
//
//  Created by if65 on 02/10/2016.
//  Copyright © 2016 if65. All rights reserved.
//

#import "DateHandlingUtilityModule.h"

@implementation DateHandlingUtilityModule

-(NSString*)dateToStringWithDate:(NSDate*)date{
    return [self dateToStringWithDate:date andTimeZone:@""];
}

-(NSString*)dateToStringWithDate:(NSDate*)date andTimeZone:(NSString*)timeZoneName{
    
    NSString *defaultTimeZoneName = [timeZoneName isEqualToString:@""] ? @"CET" : timeZoneName;
    
    NSTimeZone *defaultTimeZone = [[NSTimeZone alloc] initWithName:defaultTimeZoneName];
    
    NSLocale *locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US_POsiX"];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setLocale:locale];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [formatter setTimeZone:defaultTimeZone];
    
    return [formatter stringFromDate:date];
}

#pragma mark -
#pragma mark day

-(NSDate*)sameDayOfTheLastYearWithDate:(NSDate*)date{
    return [self sameDayOfTheLastYearWithDate:date andTimeZone:@""];
}

-(NSDate*)sameDayOfTheLastYearWithDate:(NSDate*)date andTimeZone:(NSString*)timeZoneName{
    
    NSString *defaultTimeZoneName = [timeZoneName isEqualToString:@""] ? @"CET" : timeZoneName;
    
    NSTimeZone *defaultTimeZone = [[NSTimeZone alloc] initWithName:defaultTimeZoneName];
    
    /*NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:defaultTimeZone];
    [calendar setFirstWeekday:2];
    [calendar setMinimumDaysInFirstWeek:4];
    
    NSDateComponents *dateComponents = [calendar componentsInTimeZone:defaultTimeZone fromDate:date]; //estrae tutti i componenti...
    
    NSDateComponents *toSearchComponents = [[NSDateComponents alloc] init];
    [toSearchComponents setTimeZone:defaultTimeZone];
    
    [toSearchComponents setMonth:[dateComponents month]];
    [toSearchComponents setDay:[dateComponents day]];

    
    NSDate *testDate = [calendar nextDateAfterDate:date matchingComponents:toSearchComponents options:NSCalendarSearchBackwards|NSCalendarMatchPreviousTimePreservingSmallerUnits];*/
    
    NSDate *testDate = [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitDay value:-365 toDate:date options:0];
    
    return testDate;
}

-(NSDate*)equivalentDayOfTheLastYearWithDate:(NSDate*)date{
    return [self equivalentDayOfTheLastYearWithDate:date andTimeZone:@""];
}

-(NSDate*)equivalentDayOfTheLastYearWithDate:(NSDate*)date andTimeZone:(NSString*)timeZoneName{
    
    NSString *defaultTimeZoneName = [timeZoneName isEqualToString:@""] ? @"CET" : timeZoneName;
    
    NSTimeZone *defaultTimeZone = [[NSTimeZone alloc] initWithName:defaultTimeZoneName];
    
    /*NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:defaultTimeZone];
    [calendar setFirstWeekday:2];
    [calendar setMinimumDaysInFirstWeek:3];
    
    NSDateComponents *dateComponents = [calendar componentsInTimeZone:defaultTimeZone fromDate:date]; //estrae tutti i componenti...

    NSDateComponents *toSearchComponents = [[NSDateComponents alloc] init];
    [toSearchComponents setTimeZone:defaultTimeZone];
    [toSearchComponents setWeekOfYear:[dateComponents weekOfYear]];
    [toSearchComponents setWeekday:[dateComponents weekday]];
    
    return [calendar nextDateAfterDate:date matchingComponents:toSearchComponents options:NSCalendarSearchBackwards|NSCalendarMatchNextTimePreservingSmallerUnits];*/
    
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setTimeZone:defaultTimeZone];
    [gregorian setFirstWeekday:2];
    [gregorian setMinimumDaysInFirstWeek:4];
    
    NSDateComponents *currentDateComponents = [gregorian componentsInTimeZone:defaultTimeZone fromDate:date];
    
    NSDateComponents *newDateComponents = [[NSDateComponents alloc]init];
    [newDateComponents setTimeZone:defaultTimeZone];
    [newDateComponents setYear:[currentDateComponents year] - 1 ];
    [newDateComponents setWeekOfYear:[currentDateComponents weekOfYear]];
    [newDateComponents setWeekday:[currentDateComponents weekday]];
    
    NSDate *newDate = [gregorian dateFromComponents:newDateComponents];
    
    return newDate;
}

-(NSDate*)addToDate:(NSDate*)date andNumberOfDays:(int)number{
    return [self addToDate:date andNumberOfDays:number andTimeZone:@""];
}

-(NSDate*)addToDate:(NSDate*)date andNumberOfDays:(int)number andTimeZone:(NSString*)timeZoneName{
    NSString *defaultTimeZoneName = [timeZoneName isEqualToString:@""] ? @"CET" : timeZoneName;
    
    NSTimeZone *defaultTimeZone = [[NSTimeZone alloc] initWithName:defaultTimeZoneName];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];

    NSDateComponents *interval = [[NSDateComponents alloc]init];
    [interval setDay:number];
    [interval setTimeZone:defaultTimeZone];
    
    return [calendar dateByAddingComponents:interval toDate:date options:0];
}

#pragma mark -
#pragma mark week

-(NSDate*)firstDayOfTheWeekWithDate:(NSDate*)date {
    return [self firstDayOfTheWeekWithDate:date andTimeZone:@""];
}

-(NSDate*)firstDayOfTheWeekWithDate:(NSDate*)date andTimeZone:(NSString*)timeZoneName{
    
    NSString *defaultTimeZoneName = [timeZoneName isEqualToString:@""] ? @"CET" : timeZoneName;
    
    NSTimeZone *defaultTimeZone = [[NSTimeZone alloc] initWithName:defaultTimeZoneName];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:defaultTimeZone];
    [calendar setFirstWeekday:2];
    [calendar setMinimumDaysInFirstWeek:3];
    
    NSDateComponents *dateComponents = [calendar componentsInTimeZone:defaultTimeZone fromDate:date]; //estrae tutti i componenti...
    
    if ([dateComponents weekday] != 2) {
        NSDateComponents *toSearchComponents = [[NSDateComponents alloc] init];
        [toSearchComponents setTimeZone:defaultTimeZone];
        [toSearchComponents setWeekOfYear:[dateComponents weekOfYear]];
        [toSearchComponents setWeekday:2];
        
        return [calendar nextDateAfterDate:date matchingComponents:toSearchComponents options:NSCalendarSearchBackwards|NSCalendarMatchNextTimePreservingSmallerUnits];
    } else {
        return date;
    }
}

-(NSDate*)lastDayOfTheWeekWithDate:(NSDate*)date {
    return [self lastDayOfTheWeekWithDate:date andTimeZone:@""];
}

-(NSDate*)lastDayOfTheWeekWithDate:(NSDate*)date andTimeZone:(NSString*)timeZoneName{
    
    NSString *defaultTimeZoneName = [timeZoneName isEqualToString:@""] ? @"CET" : timeZoneName;
    
    NSTimeZone *defaultTimeZone = [[NSTimeZone alloc] initWithName:defaultTimeZoneName];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:defaultTimeZone];
    [calendar setFirstWeekday:2];
    [calendar setMinimumDaysInFirstWeek:3];
    
    NSDateComponents *dateComponents = [calendar componentsInTimeZone:defaultTimeZone fromDate:date]; //estrae tutti i componenti...
    
    if ([dateComponents weekday] != 1) {
        NSDateComponents *toSearchComponents = [[NSDateComponents alloc] init];
        [toSearchComponents setTimeZone:defaultTimeZone];
        [toSearchComponents setWeekOfYear:[dateComponents weekOfYear]];
        [toSearchComponents setWeekday:1];
        
        return [calendar nextDateAfterDate:date matchingComponents:toSearchComponents options:NSCalendarMatchNextTimePreservingSmallerUnits];
    } else {
        return date;
    }
}

#pragma mark -
#pragma mark month

-(NSDate*)firstDayOfTheMonthWithDate:(NSDate*)date{
    return [self firstDayOfTheMonthWithDate:date andTimeZone:@""];
}

-(NSDate*)firstDayOfTheMonthWithDate:(NSDate*)date andTimeZone:(NSString*)timeZoneName{
    
    NSString *defaultTimeZoneName = [timeZoneName isEqualToString:@""] ? @"CET" : timeZoneName;
    
    NSTimeZone *defaultTimeZone = [[NSTimeZone alloc] initWithName:defaultTimeZoneName];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    /*la data è sempre riferita a GMT perciò non ho bisogno di alcuna conversione
     devo estrarre i compenenti della data impostando prima la TimeZone a CET*/
    NSDateComponents *components = [calendar componentsInTimeZone:defaultTimeZone fromDate:date]; //estrae tutti i componenti...
    
    //torno indietro di un numero di giorni pari a day -1
    NSDateComponents *toAddInterval = [NSDateComponents new];
    [toAddInterval setDay:1-[components day]];
    
    //ora restituisco la data richiesta;
    return [calendar dateByAddingComponents:toAddInterval toDate:date options:0];
}

-(NSDate*)lastDayOfTheMonthWithDate:(NSDate*)date{
    return [self lastDayOfTheMonthWithDate:date andTimeZone:@""];
}

-(NSDate*)lastDayOfTheMonthWithDate:(NSDate*)date andTimeZone:(NSString*)timeZoneName{
    
    NSString *defaultTimeZoneName = [timeZoneName isEqualToString:@""] ? @"CET" : timeZoneName;
    
    NSTimeZone *defaultTimeZone = [[NSTimeZone alloc] initWithName:defaultTimeZoneName];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:31];
    [components setTimeZone:defaultTimeZone];
    
    return [calendar nextDateAfterDate:date matchingComponents:components options:NSCalendarMatchPreviousTimePreservingSmallerUnits];
}

#pragma mark -
#pragma mark year

-(NSDate*)firstDayOfTheYearWithDate:(NSDate*)date{
    return [self firstDayOfTheYearWithDate:date andTimeZone:@""];
}
            
-(NSDate*)firstDayOfTheYearWithDate:(NSDate*)date andTimeZone:(NSString*)timeZoneName{
    
    NSString *defaultTimeZoneName = [timeZoneName isEqualToString:@""] ? @"CET" : timeZoneName;
    
    NSTimeZone *defaultTimeZone = [[NSTimeZone alloc] initWithName:defaultTimeZoneName];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:defaultTimeZone];
    [calendar setFirstWeekday:2];
    [calendar setMinimumDaysInFirstWeek:3];
    
    NSDateComponents *dateComponents = [calendar componentsInTimeZone:defaultTimeZone fromDate:date]; //estrae tutti i componenti...
    
    if ([dateComponents day] != 1 && [dateComponents month] != 1) {
        NSDateComponents *toSearchComponents = [[NSDateComponents alloc] init];
        [toSearchComponents setTimeZone:defaultTimeZone];
        [toSearchComponents setMonth:1];
        [toSearchComponents setDay:1];
        
        NSDate *testDate =[calendar nextDateAfterDate:date matchingComponents:toSearchComponents options:NSCalendarSearchBackwards|NSCalendarMatchNextTimePreservingSmallerUnits];
        return testDate;
    } else {
        return date;
    }
}

-(NSDate*)lastDayOfTheYearWithDate:(NSDate*)date{
    return [self lastDayOfTheYearWithDate:date andTimeZone:@""];
}

-(NSDate*)lastDayOfTheYearWithDate:(NSDate*)date andTimeZone:(NSString*)timeZoneName{
    
    NSString *defaultTimeZoneName = [timeZoneName isEqualToString:@""] ? @"CET" : timeZoneName;
    
    NSTimeZone *defaultTimeZone = [[NSTimeZone alloc] initWithName:defaultTimeZoneName];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:31];
    [components setMonth:12];
    [components setTimeZone:defaultTimeZone];
    
    return [calendar nextDateAfterDate:date matchingComponents:components options:NSCalendarMatchPreviousTimePreservingSmallerUnits];
}

-(NSDate*)firstDayOfTheMobileYearWithDate:(NSDate*)date{
    return [self firstDayOfTheMobileYearWithDate:date andTimeZone:@""];
}

-(NSDate*)firstDayOfTheMobileYearWithDate:(NSDate*)date andTimeZone:(NSString*)timeZoneName{
    
    NSString *defaultTimeZoneName = [timeZoneName isEqualToString:@""] ? @"CET" : timeZoneName;
    
    NSTimeZone *defaultTimeZone = [[NSTimeZone alloc] initWithName:defaultTimeZoneName];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    /*la data è sempre riferita a GMT perciò non ho bisogno di alcuna conversione
     devo estrarre i compenenti della data impostando prima la TimeZone a CET*/
    NSDateComponents *components = [calendar componentsInTimeZone:defaultTimeZone fromDate:date]; //estrae tutti i componenti...
    
    //torno indietro allo stesso giorno dell'anno scorso
    NSDateComponents *newComponents = [NSDateComponents new];
    [newComponents setYear:[components year]-1];
    [newComponents setMonth:[components month]];
    [newComponents setDay:[components day]];
    [newComponents setTimeZone:defaultTimeZone];
    
    //ora restituisco la data richiesta;
    return [calendar dateFromComponents:newComponents];
}

@end
