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
        _lightColor = [UIColor lightGrayColor];
        
        CGRect _labelRect = CGRectMake((frame.size.width - kLabelSize.width) / 2, 8, kLabelSize.width, kLabelSize.height);
        _dayNumberLabel = [[UILabel alloc] initWithFrame:_labelRect];
        _dayNumberLabel.backgroundColor = [UIColor clearColor];
        _dayNumberLabel.textAlignment = UITextAlignmentCenter;
        _dayNumberLabel.font = _font;
        _dayNumberLabel.text = [NSString stringWithFormat:@"%u", [_date dayNumber]];
        [self setDayCellState:kDayCellStateUnKnown];
        [self addSubview:_dayNumberLabel];
    }
    return self;
}

- (void)setDate:(NSDate *)date
{
    _date = Nil;
    _date = date;
    
    _dayNumberLabel.text = [NSString stringWithFormat:@"%u", [_date dayNumber]];
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
            
            CGRect todayRect = rectByChangingSize(self.frame, 1, 1);
            self.frame = todayRect;
            break;
        case kDayCellStateSelected:
            _dayNumberLabel.textColor = _whiteColor;
            _dayNumberLabel.shadowColor = _darkColor;
            _dayNumberLabel.shadowOffset = CGSizeMake(0, -1);
            
            CGRect selectedRect = rectByChangingSize(self.frame, 1, 1);
            self.frame = selectedRect;
            break;
        case kDayCellStateInMonth:
        default:
            _dayNumberLabel.textColor = _darkColor;
            _dayNumberLabel.shadowColor = _whiteColor;
            _dayNumberLabel.shadowOffset = CGSizeMake(0, 1);
            break;
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    if (_cellState == kDayCellStateToday) {
        [[UIColor colorWithRed:54.0/255.0 green:79.0/255.0 blue:114.0/255.0 alpha:0.8] setFill];
        CGContextFillRect(context, rect);
                
        CGRect inner = CGRectInset(rect, 1, 1);
        [[UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:0.4] setFill];
        CGContextFillRect(context, inner);        
    }
    
    if (_cellState == kDayCellStateSelected) {
        CGColorRef strokeColor = [UIColor colorWithRed:41.0/255.0 green:54.0/255.0 blue:73.0/255.0 alpha:1.0].CGColor;
        CGColorRef topColor = [UIColor colorWithRed:0/255.0 green:114.0/255.0 blue:226.0/255.0 alpha:1.0].CGColor;
        CGColorRef bottomColor = [UIColor colorWithRed:0/255.0 green:114.0/255.0 blue:226.0/255.0 alpha:1.0].CGColor;

        drawGlossAndGradient(context, rect, topColor, bottomColor);
        CGContextSetStrokeColorWithColor(context, strokeColor);
        CGContextStrokeRect(context, rectFor1PxStroke(rect));
    }
}

@end
