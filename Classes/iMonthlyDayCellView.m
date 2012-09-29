//
//  iMonthlyDayCellView.m
//  iMonthly
//
//  Created by Kyle LeNeau on 12/30/11.
//  Copyright (c) 2011 LeNeau Software. All rights reserved.
//

#import "iMonthlyDayCellView.h"
#import "iMonthlyCommon.h"

@interface iMonthlyDayCellView ()

- (void)drawTodaySelectedCellRect:(CGRect)rect;
- (void)drawTodayCellRect:(CGRect)rect;
- (void)drawSelectedCellRect:(CGRect)rect;

@end

static const CGSize kLabelSize = { 30.f, 22.f };

@implementation iMonthlyDayCellView
{
    CGRect      _originalFrame;
    UIFont      *_font;
}

@synthesize date = _date;
@synthesize cellState = _cellState;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _originalFrame = frame;
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        _font = [UIFont boldSystemFontOfSize:24.f];
        [self setCellState:kDayCellStateUnKnown];
    }
    return self;
}

- (void)setDate:(NSDate *)date
{
    _date = Nil;
    _date = date;
    
    [self setNeedsDisplay];
}

- (void)setCellState:(kDayCellState)state
{
    _cellState = state;    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor * _textColor = nil;
    UIColor * _shadowColor = nil;
    CGSize _shadowOffset = CGSizeMake(0, 1);
    CGRect largerRect = rectByChangingSize(_originalFrame, 1, 1);

    switch (_cellState) {
        case kDayCellStateOutOfMonth:
            _textColor = [UIColor colorWithPatternImage:[[iMonthlyCommon sharedInstance] lightTextPatternImage]];
            _shadowColor = [UIColor whiteColor];
            break;
        case kDayCellStateToday:
            _textColor = [UIColor whiteColor];
            _shadowColor = [UIColor colorWithPatternImage:[[iMonthlyCommon sharedInstance] darkTextPatternImage]];
            
            [self setFrame:largerRect];
            [self drawTodayCellRect:rect];
            break;
        case kDayCellStateTodaySelected:
            _textColor = [UIColor whiteColor];
            _shadowColor = [UIColor colorWithPatternImage:[[iMonthlyCommon sharedInstance] darkTextPatternImage]];
            
            [self setFrame:largerRect];
            [self drawTodaySelectedCellRect:rect];
            break;
        case kDayCellStateSelected:
            _textColor = [UIColor whiteColor];
            _shadowColor = [UIColor colorWithPatternImage:[[iMonthlyCommon sharedInstance] darkTextPatternImage]];
            _shadowOffset = CGSizeMake(0, -1);
            
            [self setFrame:largerRect];
            [self drawSelectedCellRect:rect];
            break;
        case kDayCellStateInMonth:
        default:
            _textColor = [UIColor colorWithPatternImage:[[iMonthlyCommon sharedInstance] darkTextPatternImage]];
            _shadowColor = [UIColor whiteColor];
            break;
    }

    
    CGRect _labelRect = CGRectMake((rect.size.width - kLabelSize.width) / 2, 4, kLabelSize.width, kLabelSize.height);
    CGContextSetFillColorWithColor(context, _textColor.CGColor);
    CGContextSetShadowWithColor(context, _shadowOffset, 1, _shadowColor.CGColor);
    
    NSString *label = [NSString stringWithFormat:@"%u", [_date dayNumber]];
    [label drawInRect:_labelRect withFont:_font lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentCenter];
}

- (void)drawTodaySelectedCellRect:(CGRect)rect
{
    // TODO: I would like to do an emboss effect like this:
    //   http://stackoverflow.com/questions/10417982/draw-embossed-arc-using-core-graphics
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor *strokeColor = [UIColor colorWithRed:41.0/255.0 green:54.0/255.0 blue:73.0/255.0 alpha:1.0];
    UIColor *topColor = [UIColor colorWithRed:0/255.0 green:114.0/255.0 blue:226.0/255.0 alpha:1.0];
    UIColor *bottomColor = [UIColor colorWithRed:0/255.0 green:114.0/255.0 blue:226.0/255.0 alpha:1.0];
    
    drawGlossAndGradient(context, rect, topColor.CGColor, bottomColor.CGColor);
    CGContextSetStrokeColorWithColor(context, strokeColor.CGColor);
    CGContextStrokeRect(context, rectFor1PxStroke(rect));
}

- (void)drawTodayCellRect:(CGRect)rect
{
    // TODO: I would like to do an emboss effect like this:
    //   http://stackoverflow.com/questions/10417982/draw-embossed-arc-using-core-graphics
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor *topColor = [UIColor colorWithRed:54.0/255.0 green:79.0/255.0 blue:114.0/255.0 alpha:0.8];
    UIColor *bottomColor = [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:0.4];

    [topColor setFill];
    CGContextFillRect(context, rect);

    CGRect inner = CGRectInset(rect, 1, 1);
    [bottomColor setFill];
    CGContextFillRect(context, inner);
}

- (void)drawSelectedCellRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor *strokeColor = [UIColor colorWithRed:41.0/255.0 green:54.0/255.0 blue:73.0/255.0 alpha:1.0];
    UIColor *topColor = [UIColor colorWithRed:0/255.0 green:114.0/255.0 blue:226.0/255.0 alpha:1.0];
    UIColor *bottomColor = [UIColor colorWithRed:0/255.0 green:114.0/255.0 blue:226.0/255.0 alpha:1.0];
    
    drawGlossAndGradient(context, rect, topColor.CGColor, bottomColor.CGColor);
    CGContextSetStrokeColorWithColor(context, strokeColor.CGColor);
    CGContextStrokeRect(context, rectFor1PxStroke(rect));
}

@end
