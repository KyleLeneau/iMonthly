//
//  iMonthlyDayCellView.m
//  iMonthly
//
//  Created by Kyle LeNeau on 12/30/11.
//  Copyright (c) 2011 LeNeau Software. All rights reserved.
//

#import "iMonthlyDayCellView.h"
#import "iMonthlyCommon.h"

static const CGSize kLabelSize = { 30.f, 22.f };

@interface iMonthlyDayCellView (Private)

- (UIImage *)gradientImage;

@end


@implementation iMonthlyDayCellView
{
    kDayCellState _cellState;
    
    UIFont * _font;
    UIColor * _darkColor;
    UIColor * _whiteColor;
    UIColor * _lightColor;
    
    UILabel * _dayNumberLabel;
}

@synthesize date = _date;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        _font = [UIFont boldSystemFontOfSize:24.f];
        _darkColor = [UIColor darkTextColor];
        _whiteColor = [UIColor whiteColor];
        _lightColor = [UIColor lightTextColor];
        
        CGRect _labelRect = CGRectMake((frame.size.width - kLabelSize.width) / 2, 8, kLabelSize.width, kLabelSize.height);
        _dayNumberLabel = [[UILabel alloc] initWithFrame:_labelRect];
        _dayNumberLabel.backgroundColor = [UIColor clearColor];
        _dayNumberLabel.textAlignment = UITextAlignmentCenter;
        _dayNumberLabel.font = _font;
        _dayNumberLabel.text = @"2";
        [self setDayCellState:kDayCellStateUnKnown];
        [self addSubview:_dayNumberLabel];
    }
    return self;
}

- (void)setDayCellState:(kDayCellState)state
{
    _cellState = state;
    
    switch (_cellState) {
        case kDayCellStateOutOfMonth:
            _dayNumberLabel.textColor = _lightColor;
            _dayNumberLabel.shadowColor = _whiteColor;
            _dayNumberLabel.shadowOffset = CGSizeMake(0, 1);
            break;
        case kDayCellStateToday:
            _dayNumberLabel.textColor = _whiteColor;
            _dayNumberLabel.shadowColor = _darkColor;
            _dayNumberLabel.shadowOffset = CGSizeMake(0, 1);
            break;
        case kDayCellStateSelected:
            _dayNumberLabel.textColor = _whiteColor;
            _dayNumberLabel.shadowColor = _darkColor;
            _dayNumberLabel.shadowOffset = CGSizeMake(0, -1);
            break;
        case kDayCellStateInMonth:
        default:
            _dayNumberLabel.textColor = _darkColor;
            _dayNumberLabel.shadowColor = _whiteColor;
            _dayNumberLabel.shadowOffset = CGSizeMake(0, 1);
            break;
    }
}

//- (void)drawRect:(CGRect)rect
//{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    // Add a color for red up where the colors are
//    [[UIColor colorWithRed:154.0/255.0 green:158.0/255.0 blue:167.0/255.0 alpha:0.75] setStroke];
//    
//    CGContextSaveGState(context);
//    CGContextMoveToPoint(context, 0, 0.5);
//    CGContextAddLineToPoint(context, rect.size.width - 1 + 0.5, 0 + 0.5);
//    CGContextAddLineToPoint(context, rect.size.width - 1 + 0.5, rect.size.height + 0.5);
//    CGContextSetLineWidth(context, 1.0);
//    CGContextStrokePath(context);
//    CGContextRestoreGState(context);
//}

@end
