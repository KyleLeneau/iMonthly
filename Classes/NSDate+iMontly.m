//
//  NSDate+iMontly.m
//  iMonthly
//
//  Created by Kyle LeNeau on 12/26/11.
//  Copyright (c) 2011 LeNeau Software. All rights reserved.
//

#import "NSDate+iMontly.h"
#define DATE_COMPONENTS NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit

@implementation NSDate (iMontly)

- (NSString *)formattedMonthYearString
{
    return [self formattedStringUsingFormat:@"MMMM yyyy"];
}

- (NSString *)formattedStringUsingFormat:(NSString *)dateFormat
{   
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormat];
    [formatter setLocale: [[NSLocale alloc] initWithLocaleIdentifier:@"en"]];
    
    return [formatter stringFromDate:self];
}

- (NSDate *)thisMonth
{
    return [self monthFromMonthOffset:0];
}

- (NSDate *)previousMonth
{
    return [self monthFromMonthOffset:-1];
}

- (NSDate *)nextMonth
{
    return [self monthFromMonthOffset:+1];
}

- (NSDate *)nextDay
{
    return [self dateWithDayOffset:+1];
}

- (NSDate *)dateWithDayOffset:(int)dayOffset
{    
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDateComponents * components = [calendar components:DATE_COMPONENTS fromDate:self];
    
    [components setDay: [components day] + dayOffset];    
    return [calendar dateFromComponents:components];    
}

- (NSDate *)monthFromMonthOffset:(int)monthOffset
{    
    NSCalendar * calendar = [NSCalendar currentCalendar];   
    NSDateComponents * components = [calendar components:DATE_COMPONENTS fromDate:self];
    
    if (monthOffset == 0) {
        [components setDay: ([components day] - ([components day] - 1))]; 
    } else {
        [components setMonth: ([components month] + monthOffset)];
    }
    
    return [calendar dateFromComponents:components];
}

- (BOOL)isSameDate:(NSDate *)day
{
    if (day == nil) {
        return NO;
    }
    
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDateComponents * selfComponents = [calendar components:DATE_COMPONENTS fromDate:self];
    NSDateComponents * dayComponents = [calendar components:DATE_COMPONENTS fromDate:day];
    
    return (selfComponents.day == dayComponents.day) && (selfComponents.month == dayComponents.month) && (selfComponents.year == dayComponents.year);
}

- (BOOL)monthContainsDay:(NSDate *)day
{
    if (day == nil) {
        return NO;
    }
    
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDateComponents * selfComponents = [calendar components:DATE_COMPONENTS fromDate:self];    
    NSDateComponents * dayComponents = [calendar components:DATE_COMPONENTS fromDate:day];
    
    return (selfComponents.month == dayComponents.month) && (selfComponents.year == dayComponents.year);
}

- (NSDate *)dateWithDayNumber:(int)dayNumber
{    
    NSCalendar * calendar = [NSCalendar currentCalendar];    
    NSDateComponents * components = [calendar components:DATE_COMPONENTS fromDate:self];
    [components setDay: dayNumber];
    
    return [calendar dateFromComponents:components];
}

- (NSInteger)dayNumber
{
    NSCalendar * calendar = [NSCalendar currentCalendar];    
    NSDateComponents * components = [calendar components:DATE_COMPONENTS fromDate:self];
    return components.day;
}

- (NSInteger)firstWeekdayOfMonth
{
    NSCalendar * calendar = [NSCalendar currentCalendar];    
	return [[calendar components: NSWeekdayCalendarUnit fromDate:self] weekday];
}

- (NSInteger)lastDayOfMonth
{
    NSCalendar * calendar = [NSCalendar currentCalendar];    
    NSRange daysRange = [calendar rangeOfUnit:NSDayCalendarUnit 
                                       inUnit:NSMonthCalendarUnit 
                                      forDate:self];    
    return daysRange.length;
}

- (NSInteger)visibleWeeksInMonth
{
    NSInteger firstDay = [self firstWeekdayOfMonth] - 1;
    double count = firstDay + [self lastDayOfMonth];
    return ceilf(count / 7);
}

@end
