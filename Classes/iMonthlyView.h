//
//  iMonthlyView.h
//  iMonthly
//
//  Created by Kyle LeNeau on 12/26/11.
//  Copyright (c) 2011 LeNeau Software. All rights reserved.
//

#import <UIKit/UIKit.h>
@class iMonthlyView;


@protocol iMonthlyViewDelegate

@optional
- (void)imonthlyView:(iMonthlyView *)view didSelectDate:(NSDate *)selectedDate;
- (void)imonthlyView:(iMonthlyView *)view didMoveToNextMonth:(NSDate *)newMonth;
- (void)imonthlyView:(iMonthlyView *)view didMoveToPreviousMonth:(NSDate *)newMonth;

@end

@interface iMonthlyView : UIView {
    
}

@end


void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor);