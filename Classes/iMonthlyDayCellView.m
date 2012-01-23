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
    
    CGRect _originalFrame;
    UIFont * _font;
    UIColor * _textColor;
    UIColor * _shadowColor;
    CGSize _shadowOffset;
}

@synthesize date = _date;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _originalFrame = frame;
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        _font = [UIFont boldSystemFontOfSize:24.f];
        [self setDayCellState:kDayCellStateUnKnown];
    }
    return self;
}

- (void)setDate:(NSDate *)date
{
    _date = Nil;
    _date = date;
    
    [self setNeedsDisplay];
}

- (void)setDayCellState:(kDayCellState)state
{
    _cellState = state;
    
    switch (_cellState) {
        case kDayCellStateOutOfMonth:
            _textColor = [UIColor colorWithPatternImage:[iMonthlyCommon sharedInstance].lightTextPatternImage];
            _shadowColor = [UIColor whiteColor];
            _shadowOffset = CGSizeMake(0, 1);
            break;
        case kDayCellStateToday:
            _textColor = [UIColor whiteColor];
            _shadowColor = [UIColor colorWithPatternImage:[iMonthlyCommon sharedInstance].darkTextPatternImage];
            _shadowOffset = CGSizeMake(0, 1);
            
            CGRect todayRect = rectByChangingSize(_originalFrame, 1, 1);
            self.frame = todayRect;
            break;
        case kDayCellStateSelected:
            _textColor = [UIColor whiteColor];
            _shadowColor = [UIColor colorWithPatternImage:[iMonthlyCommon sharedInstance].darkTextPatternImage];
            _shadowOffset = CGSizeMake(0, -1);
            
            CGRect selectedRect = rectByChangingSize(_originalFrame, 1, 1);
            self.frame = selectedRect;
            break;
        case kDayCellStateInMonth:
        default:
            _textColor = [UIColor colorWithPatternImage:[iMonthlyCommon sharedInstance].darkTextPatternImage];
            _shadowColor = [UIColor whiteColor];
            _shadowOffset = CGSizeMake(0, 1);
            break;
    }
    
    [self setNeedsDisplay];
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
    
    CGRect _labelRect = CGRectMake((rect.size.width - kLabelSize.width) / 2, 4, kLabelSize.width, kLabelSize.height);
    CGContextSetFillColorWithColor(context, _textColor.CGColor);
    CGContextSetShadowWithColor(context, _shadowOffset, 1, _shadowColor.CGColor);
    [[NSString stringWithFormat:@"%u", [_date dayNumber]] 
     drawInRect:_labelRect 
     withFont:_font 
     lineBreakMode:UILineBreakModeClip 
     alignment:UITextAlignmentCenter];
}

@end
