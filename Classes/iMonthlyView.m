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

typedef enum {
    kRollUp,
    kRollDown
} MonthAnimation;

@interface iMonthlyView ()

- (void)initView;

@end

@implementation iMonthlyView
{
    CGRect _headerRect;
    CGRect _gridRect;

    UIColor * _headerTextColor;
    
    UIView * _headerView;
    UILabel * _headerTitleLabel;
    UIButton * _nextMonthButton;
    UIButton * _previousMonthButton;
    
    iMonthlyGridView * _frontGridView;
    iMonthlyGridView * _backGridView;
    
    BOOL _transitioning;
}

@synthesize currentMonth = _currentMonth;


- (void)initView
{
    self.clipsToBounds = YES;
    self.autoresizesSubviews = YES;
    self.currentMonth = [NSDate date];
    self.backgroundColor = [UIColor redColor];
    
    _transitioning = NO;
    _headerRect = CGRectMake(0, 0, self.frame.size.width, kHeaderHeight);
    _gridRect = CGRectMake(0, kHeaderHeight, self.frame.size.width, self.frame.size.height - kHeaderHeight);
    
    _headerTextColor = RGB(84, 84, 84);
    
    
    // Setup Header Views
    _headerView = [[UIView alloc] initWithFrame:_headerRect];
    _headerView.backgroundColor = [UIColor colorWithPatternImage:[[iMonthlyCommon sharedInstance] headerPatternImage]];

    _headerTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kMonthLabelWidth, kMonthLabelHeight)];
    _headerTitleLabel.backgroundColor = [UIColor clearColor];
    _headerTitleLabel.font = [UIFont boldSystemFontOfSize:22.f];
    _headerTitleLabel.textColor = _headerTextColor;
    _headerTitleLabel.textAlignment = UITextAlignmentCenter;
    _headerTitleLabel.shadowColor = [UIColor whiteColor];
    _headerTitleLabel.shadowOffset = CGSizeMake(0, 1);
    _headerTitleLabel.text = [_currentMonth formattedMonthYearString];
    [_headerView addSubview:_headerTitleLabel];
    
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
        [_headerView addSubview:weekdayLabel];
    }
    
    
    // Setup the Nav Buttons
    CGRect buttonFrame = CGRectMake(0, 0, kChangeMonthButtonWidth, kChangeMonthButtonHeight);
    
    _previousMonthButton = [[UIButton alloc] initWithFrame:buttonFrame];
    [_previousMonthButton setImage:[iMonthlyCommon sharedInstance].leftArrowImage forState:UIControlStateNormal];
    [_previousMonthButton.imageView setContentMode:UIViewContentModeCenter];
    _previousMonthButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _previousMonthButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_previousMonthButton addTarget:self action:@selector(showPreviousMonth) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_previousMonthButton];

    _nextMonthButton = [[UIButton alloc] initWithFrame:buttonFrame];
    [_nextMonthButton setImage:[iMonthlyCommon sharedInstance].rightArrowImage forState:UIControlStateNormal];
    [_nextMonthButton.imageView setContentMode:UIViewContentModeCenter];
    _nextMonthButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _nextMonthButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_nextMonthButton addTarget:self action:@selector(showNextMonth) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_nextMonthButton];
    
    
    // Setup the Grid Views
    _backGridView = [[iMonthlyGridView alloc] initWithFrame:_gridRect];
    _backGridView.hidden = YES;
    _frontGridView = [[iMonthlyGridView alloc] initWithFrame:_gridRect];
    _frontGridView.currentMonth = _currentMonth;
    
    [self addSubview:_frontGridView];
    [self addSubview:_backGridView];
    [self addSubview:_headerView];
    
    
    // Setup this view frame size
    CGRect newFrame = self.frame;
    newFrame.size.height = kHeaderHeight + _frontGridView.frame.size.height;
    newFrame.size.width = _frontGridView.frame.size.width;
    self.frame = newFrame;
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

- (void)setCurrentMonth:(NSDate *)currentMonth
{
    _currentMonth = Nil;
    _currentMonth = currentMonth;
    
    _headerTitleLabel.text = [_currentMonth formattedMonthYearString];
}

- (void)swapGridViews
{
    iMonthlyGridView *tmp = _backGridView;
    _backGridView = _frontGridView;
    _frontGridView = tmp;
    [self exchangeSubviewAtIndex:[self.subviews indexOfObject:_frontGridView] 
              withSubviewAtIndex:[self.subviews indexOfObject:_backGridView]];    
}

- (void)transitionMonthView:(MonthAnimation)animType
{
    // Slide grid view up
    _backGridView.hidden = NO;
    _transitioning = YES;
    
    // Setup the back grid top to be the bottom of the front
    switch (animType) {
        case kRollUp:
            _backGridView.top = _frontGridView.bottom;
            break;
        case kRollDown:
            _backGridView.bottom = _frontGridView.top;
            break;
    }
    
    // Begin the animation
    [UIView animateWithDuration:0.7
                          delay:0 
                        options:UIViewAnimationCurveLinear
                     animations:^{
                         switch (animType) {
                             case kRollUp:
                                 _frontGridView.top = -_backGridView.height + kHeaderHeight;
                                 break;
                             case kRollDown:
                                 _frontGridView.top = _backGridView.height + kHeaderHeight;
                                 break;
                         }
                         
                         _backGridView.top = 0.0f + kHeaderHeight;
                         [self swapGridViews];
                     }
                     completion:^(BOOL finished){
                         _transitioning = NO;
                         _backGridView.hidden = YES;
                     }];
}

- (void)showPreviousMonth
{
    if (_transitioning) {
        return;
    }
    
    self.currentMonth = [_currentMonth monthFromMonthOffset:-1];
    [_backGridView setCurrentMonth:_currentMonth];
    [self transitionMonthView:kRollDown];
}

- (void)showNextMonth
{
    if (_transitioning) {
        return;
    }
    
    self.currentMonth = [_currentMonth monthFromMonthOffset:1];
    [_backGridView setCurrentMonth:_currentMonth];
    [self transitionMonthView:kRollUp];
}


#pragma mark - Drawing and Layout

- (void)layoutSubviews
{
    _previousMonthButton.center =   CGPointMake(20, 20);
    _nextMonthButton.center = CGPointMake(CGRectGetMaxX(_headerRect) - 20, 20);
    _headerTitleLabel.center = CGPointMake(CGRectGetMidX(_headerRect), 20);
    _gridRect = _frontGridView.frame;
    
    [self setNeedsDisplay];
}

- (void)drawGridView
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor *topColor = RGB(226, 226, 228);
    UIColor *bottomColor = RGB(204, 203, 208);
    drawLinearGradient(context, _gridRect, topColor.CGColor, bottomColor.CGColor);
}

//- (void)drawBottomShadowView
//{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//
//    UIColor *topColor = RGBA(246, 246, 247, 1);
//    UIColor *bottomColor = RGBA(204, 204, 209, 0);
//    drawLinearGradient(context, _shadowRect, topColor.CGColor, bottomColor.CGColor);
//}

- (void)drawRect:(CGRect)rect
{
    [self drawGridView];
//    [self drawBottomShadowView];
}

@end