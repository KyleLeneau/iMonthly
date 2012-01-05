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
static const CGFloat kMonthLabelHeight = 24.f;
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

@synthesize currentMonth = _currentMonth;


- (void)initView
{
    self.autoresizesSubviews = YES;
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.currentMonth = [NSDate date];
    
    _headerRect = CGRectMake(0, 0, self.frame.size.width, kHeaderHeight);
    _gridRect = CGRectMake(0, kHeaderHeight, self.frame.size.width, self.frame.size.height - kHeaderHeight);
    
    _headerTextColor = [UIColor colorWithRed:84.0/255.0 green:84.0/255.0 blue:84.0/255.0 alpha:1.0];
    
    
    // Setup Header Views
    _headerTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kMonthLabelWidth, kMonthLabelHeight)];
    _headerTitleLabel.backgroundColor = [UIColor clearColor];
    _headerTitleLabel.font = [UIFont boldSystemFontOfSize:22.f];
    _headerTitleLabel.textColor = _headerTextColor;
    _headerTitleLabel.textAlignment = UITextAlignmentCenter;
    _headerTitleLabel.shadowColor = [UIColor whiteColor];
    _headerTitleLabel.shadowOffset = CGSizeMake(0, 1);
    _headerTitleLabel.text = [_currentMonth formattedMonthYearString];
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
    
    
    // Setup the Nav Buttons
    CGRect buttonFrame = CGRectMake(0, 0, kChangeMonthButtonWidth, kChangeMonthButtonHeight);
    
    _previousMonthButton = [[UIButton alloc] initWithFrame:buttonFrame];
    [_previousMonthButton setImage:[iMonthlyCommon sharedInstance].leftArrowImage forState:UIControlStateNormal];
    [_previousMonthButton.imageView setContentMode:UIViewContentModeCenter];
    _previousMonthButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _previousMonthButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_previousMonthButton addTarget:self action:@selector(showPreviousMonth) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_previousMonthButton];

    _nextMonthButton = [[UIButton alloc] initWithFrame:buttonFrame];
    [_nextMonthButton setImage:[iMonthlyCommon sharedInstance].rightArrowImage forState:UIControlStateNormal];
    [_nextMonthButton.imageView setContentMode:UIViewContentModeCenter];
    _nextMonthButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _nextMonthButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_nextMonthButton addTarget:self action:@selector(showNextMonth) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_nextMonthButton];
    
    
    // Setup the Grid Views
    _frontGridView = [[iMonthlyGridView alloc] initWithFrame:_gridRect];
    _frontGridView.currentMonth = _currentMonth;
    [_frontGridView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
    
    _backGridView = [[iMonthlyGridView alloc] initWithFrame:_gridRect];
    
    [self addSubview:_frontGridView];
    
//    NSLog(@"Visible Weeks: %d", [_currentMonth visibleWeeksInMonth]);
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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == _frontGridView && [keyPath isEqualToString:@"frame"]) {
//        NSLog(@"Recieved a frame change message");
        
        CGRect newFrame = self.frame;
        newFrame.size.height = _headerRect.size.height + _frontGridView.frame.size.height;
        self.frame = newFrame;
    }
}

- (void)setCurrentMonth:(NSDate *)currentMonth
{
    _currentMonth = Nil;
    _currentMonth = currentMonth;
    
    _headerTitleLabel.text = [_currentMonth formattedMonthYearString];
}

- (void)showPreviousMonth
{
    self.currentMonth = [_currentMonth monthFromMonthOffset:-1];
    [_frontGridView setCurrentMonth:_currentMonth];
}

- (void)showNextMonth
{
    self.currentMonth = [_currentMonth monthFromMonthOffset:1];
    [_frontGridView setCurrentMonth:_currentMonth];    
}


#pragma mark - Drawing and Layout

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
    
    _headerTitleLabel.center = CGPointMake(160, 20);

//    _daysGridRect = CGRectMake(0, 70, 320, 300);
    
    [self setNeedsDisplay];
}

@end