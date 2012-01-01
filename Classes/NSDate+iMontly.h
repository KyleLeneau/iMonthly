//
//  NSDate+iMontly.h
//  iMonthly
//
//  Created by Kyle LeNeau on 12/26/11.
//  Copyright (c) 2011 LeNeau Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (iMontly)

- (NSString *)formattedMonthYearString;
- (NSString *)formattedStringUsingFormat:(NSString *)dateFormat;

- (NSDate *)thisMonth;
- (NSDate *)previousMonth;
- (NSDate *)nextMonth;
- (NSDate *)monthFromMonthOffset:(int)monthOffset;
- (NSDate *)dateWithDayNumber:(int)dayNumber;
- (NSDate *)dateWithDayOffset:(int)dayOffset;

- (NSInteger)firstWeekdayOfMonth;
- (NSInteger)lastDayOfMonth;
- (NSInteger)visibleWeeksInMonth;

- (BOOL)isSameDate:(NSDate *)day;
- (BOOL)monthContainsDay:(NSDate *)day;
- (NSInteger)dayNumber;

@end
