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

static const CGSize kDayCellSize = { 46.f, 44.f };

@implementation iMonthlyGridView
{
    NSDate * _today;
    NSInteger _visibleWeeks;
    NSInteger _firstWeekdayInMonth;
    NSInteger _daysInMonth;
    NSInteger _lastDayPreviousMonth;
    
    iMonthlyDayCellView * _selectedDayCell;
}

@synthesize currentMonth = _currentMonth;


- (void)initView
{
    self.opaque = NO;
    self.clipsToBounds = YES;
    _today = [NSDate date];
    _visibleWeeks = 6;
    
    CGRect newRect = self.frame;
    newRect.size.height = _visibleWeeks * kDayCellSize.height;
    newRect.size.width = 7 * kDayCellSize.width;
    self.frame = newRect;    
    
    NSInteger temp = 0;
    for (int i=0; i<6; i++) {
        for (int j=0; j<7; j++) {
            CGRect r = CGRectMake(j*kDayCellSize.width, i*kDayCellSize.height, kDayCellSize.width, kDayCellSize.height);
            [self insertSubview:[[iMonthlyDayCellView alloc] initWithFrame:r] atIndex:temp];
            temp++;
        }
    }    
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        [self initView];
    }
    return self;
}

- (void)setCurrentMonth:(NSDate *)month
{
    _currentMonth = Nil;
    _currentMonth = [month dateWithDayNumber:1];
    NSLog(@"GridView setting Current Month: %@", _currentMonth);
    
    _today = [NSDate date];
    _firstWeekdayInMonth = [_currentMonth firstWeekdayOfMonth];
    _daysInMonth = [_currentMonth daysInMonth];
    _lastDayPreviousMonth = [[_currentMonth previousMonth] daysInMonth];
    
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    UIView * hitView = [self hitTest:location withEvent:event];
    
    if (!hitView)
        return;
    
    if ([hitView isKindOfClass:[iMonthlyDayCellView class]]) {
        iMonthlyDayCellView * cell = (iMonthlyDayCellView *)hitView;
        _selectedDayCell = cell;
        // TODO: Call some delegate being passed around...
        [self setNeedsLayout];
    }
}

- (void)layoutSubviews
{
    if (_currentMonth == Nil) {
        return;
    }
    
    NSInteger totalCells = _visibleWeeks * 7;
    iMonthlyDayCellView * dayCell = Nil;
    
    for (int x = 0; x < totalCells; x++) {
        dayCell = (iMonthlyDayCellView *)[self.subviews objectAtIndex:x];
        
        NSInteger offset = x - (_firstWeekdayInMonth - 1);
        NSDate * thisDate = [_currentMonth dateWithDayOffset:offset];
        [dayCell setDate:thisDate];
        
        if ([_currentMonth monthContainsDay:thisDate]) {
            [dayCell setDayCellState:kDayCellStateInMonth];
        } else {
            [dayCell setDayCellState:kDayCellStateOutOfMonth];
        }
        
        if (_currentMonth && [thisDate isSameDate:_today]) {
            [dayCell setDayCellState:kDayCellStateToday];
        }
        
        if (_selectedDayCell != Nil && _selectedDayCell == dayCell) {
            [dayCell setDayCellState:kDayCellStateSelected];
        }
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor * lightColor = [UIColor colorWithRed:154.0/255.0 green:158.0/255.0 blue:167.0/255.0 alpha:0.75];
    UIColor * whiteColor = [UIColor whiteColor];
    UIBezierPath * gridPath = [UIBezierPath bezierPath];
    gridPath.lineWidth = 1.0;
    
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
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, -1, 1);
    [whiteColor setStroke];
    [gridPath stroke];
    CGContextRestoreGState(context);
    
    // Render Stroke
    [lightColor setStroke];
    [gridPath stroke];
}

@end
