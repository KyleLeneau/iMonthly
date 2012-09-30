//
//  iMonthlyGridView.m
//  iMonthly
//
//  Created by Kyle LeNeau on 12/30/11.
//  Copyright (c) 2011 LeNeau Software. All rights reserved.
//

#import "iMonthlyGridView.h"
#import "iMonthlyDayCellView.h"
#import "iMonthlyCommon.h"

@interface iMonthlyGridView ()

@property (nonatomic, strong) NSDate *todaysDate;
@property (nonatomic, assign) NSInteger firstWeekdayInMonth;
@property (nonatomic, assign) NSInteger daysInMonth;
@property (nonatomic, assign) NSInteger lastDayInPreviousMonth;
@property (nonatomic, strong) iMonthlyDayCellView *selectedDayCell;

- (void)initView;

@end

static const NSInteger kVisibleWeeks = 6;
static const CGSize kDayCellSize = { 46.f, 44.f };

@implementation iMonthlyGridView

@synthesize currentMonth = _currentMonth;
@synthesize todaysDate = _todaysDate;
@synthesize firstWeekdayInMonth = _firstWeekdayInMonth;
@synthesize daysInMonth = _daysInMonth;
@synthesize lastDayInPreviousMonth = _lastDayInPreviousMonth;
@synthesize selectedDayCell = _selectedDayCell;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        [self initView];
    }
    return self;
}

- (void)initView
{
    [self setOpaque:NO];
    [self setClipsToBounds:YES];
    [self setTodaysDate:[NSDate date]];
    
    CGRect newRect = [self frame];
    newRect.size.height = kVisibleWeeks * kDayCellSize.height;
    newRect.size.width = 7 * kDayCellSize.width;
    [self setFrame:newRect];
    
    for (int i = 0; i < 6; i++) {
        for (int j = 0; j < 7; j++) {
            CGRect dayCellRect = CGRectMake(j*kDayCellSize.width, i*kDayCellSize.height, kDayCellSize.width, kDayCellSize.height);
            iMonthlyDayCellView *dayCell = [[iMonthlyDayCellView alloc] initWithFrame:dayCellRect];
            [self addSubview:dayCell];
        }
    }
}

- (void)setCurrentMonth:(NSDate *)month
{
    _currentMonth = Nil;
    _currentMonth = [month dateWithDayNumber:1];
    
    [self setFirstWeekdayInMonth:[_currentMonth firstWeekdayOfMonth]];
    [self setDaysInMonth:[_currentMonth daysInMonth]];
    [self setLastDayInPreviousMonth:[[_currentMonth previousMonth] daysInMonth]];
    
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    UIView *hitView = [self hitTest:location withEvent:event];
    
    if (!hitView)
        return;
    
    if ([hitView isKindOfClass:[iMonthlyDayCellView class]]) {
        iMonthlyDayCellView *cell = (iMonthlyDayCellView *)hitView;
        [self setSelectedDayCell:cell];
        
        // TODO: Call some delegate being passed around...
        [self setNeedsLayout];
    }
}

- (void)layoutSubviews
{
    if (_currentMonth == Nil) {
        return;
    }
    
    NSInteger totalCells = kVisibleWeeks * 7;
    for (int x = 0; x < totalCells; x++) {
        iMonthlyDayCellView *dayCell = (iMonthlyDayCellView *)[[self subviews] objectAtIndex:x];

        kDayCellState cellState = kDayCellStateOutOfMonth;
        NSInteger offset = x - (_firstWeekdayInMonth - 1);
        NSDate *thisDate = [_currentMonth dateWithDayOffset:offset];
        [dayCell setDate:thisDate];
        
        if ([_currentMonth monthContainsDay:thisDate]) {
            cellState = kDayCellStateInMonth;
        }
        
        if (_selectedDayCell != Nil && _selectedDayCell == dayCell) {
            cellState = kDayCellStateSelected;
        }
        
        if ([thisDate isSameDate:_todaysDate]) {
            // Set initial selection
            if (_selectedDayCell == Nil) [self setSelectedDayCell:dayCell];
            cellState = kDayCellStateToday;

            if (_selectedDayCell != Nil && _selectedDayCell == dayCell) {
                cellState = kDayCellStateTodaySelected;
            }
        }
        
        [dayCell setCellState:cellState];
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    UIColor *lightColor = RGBA(154, 158, 167, 0.75);
    UIColor *whiteColor = RGB(255, 255, 255);

    UIBezierPath *gridPath = [UIBezierPath bezierPath];
    [gridPath setLineWidth:1.0];
    
    // Add Horizontal ones first
    for (int i = 0; i < 7; i++) {  // TODO: replace with number of weeks
        CGFloat y = i * kDayCellSize.height + 0.5;
        [gridPath moveToPoint:CGPointMake(0, y)];
        [gridPath addLineToPoint:CGPointMake(rect.size.width + 2, y)];
    }
    
    // Add vertical lines next
    for (int j = 1; j <= 7; j++) {
        CGFloat x = j * kDayCellSize.width + 0.5;
        [gridPath moveToPoint:CGPointMake(x, 0)];
        [gridPath addLineToPoint:CGPointMake(x, rect.size.height + 2)];
    }

    // Render the Inset
    CGContextSaveGState(context); {
        CGContextTranslateCTM(context, -1, 1);
        [whiteColor setStroke];
        [gridPath stroke];
    } CGContextRestoreGState(context);
    
    // Render Stroke
    [lightColor setStroke];
    [gridPath stroke];
}

@end
