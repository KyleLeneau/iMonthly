//
//  EmptyViewController.m
//  iMonthly
//
//  Created by Kyle LeNeau on 9/29/12.
//  Copyright (c) 2012 LeNeau Software. All rights reserved.
//

#import "EmptyViewController.h"
#import "iMonthlyCommon.h"

@interface EmptyViewController ()

@end

@implementation EmptyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)loadView
{
    InnerGlossView *view = [[InnerGlossView alloc] init];
    [view setBackgroundColor:RGB(220, 220, 220)];
    [self setView:view];
}

@end


@implementation InnerGlossView

- (void)drawRect:(CGRect)rect
{
    CGContextRef gc = UIGraphicsGetCurrentContext();
    
    CGRect inner = CGRectMake(40, 40, 240, 240);
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:inner cornerRadius:10];
//    CGPathRef shape = CGPathCreateCopyByStrokingPath(roundedRect.CGPath, NULL, 40, kCGLineCapRound, kCGLineJoinRound, 0);
    CGPathRef shape = CGPathCreateCopy(roundedRect.CGPath);
    CGMutablePathRef shapeInverse = CGPathCreateMutableCopy(shape);
    CGPathAddRect(shapeInverse, NULL, CGRectInfinite);
    
    CGContextBeginPath(gc);
    CGContextAddPath(gc, shape);
    CGContextSetFillColorWithColor(gc, [UIColor redColor].CGColor);
    CGContextFillPath(gc);
    
    CGContextSaveGState(gc); {
        CGContextBeginPath(gc);
        CGContextAddPath(gc, shape);
        CGContextClip(gc);
        CGContextSetShadowWithColor(gc, CGSizeZero, 7, [UIColor colorWithWhite:0 alpha:.25].CGColor);
        CGContextBeginPath(gc);
        CGContextAddPath(gc, shapeInverse);
        CGContextFillPath(gc);
    } CGContextRestoreGState(gc);
    
    CGContextSetStrokeColorWithColor(gc, [UIColor colorWithWhite:.75 alpha:1].CGColor);
    CGContextSetLineWidth(gc, 1);
    CGContextSetLineJoin(gc, kCGLineCapRound);
    CGContextBeginPath(gc);
    CGContextAddPath(gc, shape);
    CGContextStrokePath(gc);
    
    CGPathRelease(shape);
    CGPathRelease(shapeInverse);
}

@end