//
//  iMonthlyGridView.m
//  iMonthly
//
//  Created by Kyle LeNeau on 12/30/11.
//  Copyright (c) 2011 LeNeau Software. All rights reserved.
//

#import "iMonthlyGridView.h"
#import "iMonthlyDayCellView.h"

static const CGSize kDayCellSize = { 46.f, 44.f };

@implementation iMonthlyGridView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        self.opaque = NO;
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        for (int i=0; i<6; i++) {
            for (int j=0; j<7; j++) {
                CGRect r = CGRectMake(j*kDayCellSize.width, i*kDayCellSize.height, kDayCellSize.width, kDayCellSize.height);
                [self addSubview:[[iMonthlyDayCellView alloc] initWithFrame:r]];
            }
        }
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor * lightColor = [UIColor colorWithRed:154.0/255.0 green:158.0/255.0 blue:167.0/255.0 alpha:0.75];
    UIColor * whiteColor = [UIColor whiteColor];
    UIBezierPath * gridPath = [UIBezierPath bezierPath];
    gridPath.lineWidth = 1.0;
    
    // Add Horizontal ones first
    for (int i = 0; i < 6; i++) {  // TODO: replace with number of weeks
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
