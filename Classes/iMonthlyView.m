//
//  iMonthlyView.m
//  iMonthly
//
//  Created by Kyle LeNeau on 12/26/11.
//  Copyright (c) 2011 LeNeau Software. All rights reserved.
//

#import "iMonthlyCommon.h"
#import "iMonthlyView.h"
#import "iMonthlyGridView.h"

static const CGFloat kHeaderHeight = 44.f;
static const CGFloat kMonthLabelWidth = 240.0f;
static const CGFloat kMonthLabelHeight = 17.f;
static const CGFloat kChangeMonthButtonWidth = 46.0f;
static const CGFloat kChangeMonthButtonHeight = 30.0f;


@implementation iMonthlyView
{
    CGRect _headerRect;
    CGRect _gridRect;
    
    UIColor * _headerTextColor;
    
    UILabel * _headerTitleLabel;
    UIButton * _nextMonthButton;
    UIButton * _previousMonthButton;
    
    iMonthlyGridView * _frontGridView;
    iMonthlyGridView * _backGridView;
}

- (void)initView
{
    self.autoresizesSubviews = YES;
    self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    
    _headerRect = CGRectMake(0, 0, self.frame.size.width, kHeaderHeight);
    _gridRect = CGRectMake(0, kHeaderHeight, self.frame.size.width, self.frame.size.height - kHeaderHeight);
    
    _headerTextColor = [UIColor colorWithRed:84.0/255.0 green:84.0/255.0 blue:84.0/255.0 alpha:1.0];
    
    // Setup Header Views
    _headerTitleLabel = [[UILabel alloc] init];
    _headerTitleLabel.backgroundColor = [UIColor clearColor];
    _headerTitleLabel.font = [UIFont boldSystemFontOfSize:22.f];
    _headerTitleLabel.textColor = _headerTextColor;
    _headerTitleLabel.textAlignment = UITextAlignmentCenter;
    _headerTitleLabel.shadowColor = [UIColor whiteColor];
    _headerTitleLabel.shadowOffset = CGSizeMake(0, 1);
    _headerTitleLabel.text = @"December 2011"; // TODO with logic
    [self addSubview:_headerTitleLabel];
    
    NSArray * weekdayNames = [[[NSDateFormatter alloc] init] shortWeekdaySymbols];
    NSUInteger firstWeekday = [[NSCalendar currentCalendar] firstWeekday];
    NSUInteger i = firstWeekday - 1;
    for (CGFloat xOffset = 0.f; xOffset < _headerRect.size.width; xOffset += 46.f, i = (i+1)%7) {
        CGRect weekdayFrame = CGRectMake(xOffset, 30.f, 46.f, kHeaderHeight - 29.f);
        UILabel * weekdayLabel = [[UILabel alloc] initWithFrame:weekdayFrame];
        weekdayLabel.backgroundColor = [UIColor clearColor];
        weekdayLabel.font = [UIFont boldSystemFontOfSize:10.f];
        weekdayLabel.textAlignment = UITextAlignmentCenter;
        weekdayLabel.textColor = _headerTextColor;
        weekdayLabel.shadowColor = [UIColor whiteColor];
        weekdayLabel.shadowOffset = CGSizeMake(0, 1);
        weekdayLabel.text = [weekdayNames objectAtIndex:i];
        [self addSubview:weekdayLabel];
    }
    
    
    // Setup the Grid Views
    _frontGridView = [[iMonthlyGridView alloc] initWithFrame:_gridRect];
    _backGridView = [[iMonthlyGridView alloc] initWithFrame:_gridRect];
    
    [self addSubview:_frontGridView];
    
    
    NSLog(@"First Weekday of Month: %d", [[[NSDate date] nextMonth] firstWeekdayOfMonth]);
    NSLog(@"Visible Weeks: %d", [[[NSDate date] monthFromMonthOffset:-3] visibleWeeksInMonth]);
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        [self initView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)drawHeaderView
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorRef topColor = [UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:247.0/255.0 alpha:1.0].CGColor; 
    CGColorRef bottomColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:209.0/255.0 alpha:1.0].CGColor;
    
    drawLinearGradient(context, _headerRect, topColor, bottomColor);    
}

- (void)drawGridView
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorRef topColor = [UIColor colorWithRed:226.0/255.0 green:226.0/255.0 blue:228.0/255.0 alpha:1.0].CGColor; 
    CGColorRef bottomColor = [UIColor colorWithRed:204.0/255.0 green:203.0/255.0 blue:208.0/255.0 alpha:1.0].CGColor;
    
    drawLinearGradient(context, _gridRect, topColor, bottomColor);
}

- (void)drawRect:(CGRect)rect
{
    [self drawHeaderView];
    [self drawGridView];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    _previousMonthButton.center = CGPointMake(20, 20);
    _nextMonthButton.center = CGPointMake(300, 20);
    
    _headerTitleLabel.frame = CGRectMake(40, 9, kMonthLabelWidth, kMonthLabelHeight);
//    _daysGridRect = CGRectMake(0, 70, 320, 300);
    
    [self setNeedsDisplay];
}

@end