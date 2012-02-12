//
//  iMonthlyCommon.m
//  iMonthly
//
//  Created by Kyle LeNeau on 1/1/12.
//  Copyright (c) 2012 LeNeau Software. All rights reserved.
//

#import "iMonthlyCommon.h"

static const CGRect kArrowRect = { 0, 0, 15, 20 };

@implementation iMonthlyCommon
{
    CGColorRef topArrowColor;
    CGColorRef bottomArrowColor;
    CGColorRef shadowColor;
    
    UIImage * _leftArrowImage;
    UIImage * _rightArrowImage;
    UIImage * _headerPatternImage;
    UIImage * _darkTextPatternImage;
    UIImage * _lightTextPatternImage;
}


static iMonthlyCommon * _sharedInstance;

- (id)init
{
    if ((self = [super init])) {
        topArrowColor = [UIColor colorWithRed:46.0/255.0 green:57.0/255.0 blue:68.0/255.0 alpha:1.0].CGColor;
        bottomArrowColor = [UIColor colorWithRed:74.0/255.0 green:91.0/255.0 blue:110.0/255.0 alpha:1.0].CGColor;
        shadowColor = [UIColor whiteColor].CGColor;
    }
    return self;
}

+ (iMonthlyCommon *)sharedInstance
{
    @synchronized(self) {
        if (!_sharedInstance) {
            _sharedInstance = [[iMonthlyCommon alloc] init];
        }
    }
    return _sharedInstance;
}

- (UIImage *)leftArrowImage
{
    if (!_leftArrowImage) {
        // Draw the arrow pointing to the left
        UIGraphicsBeginImageContextWithOptions(kArrowRect.size, NO, 0.0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        
        // Draw the path for the Right Arrow >
        // TODO: learn how to flip the arrow to re-use on the left side
        UIBezierPath * path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(kArrowRect.size.width - 1, 1)];
        [path addLineToPoint:CGPointMake(1, CGRectGetMidY(kArrowRect))];
        [path addLineToPoint:CGPointMake(kArrowRect.size.width - 1, kArrowRect.size.height - 1)];
        [path closePath];
        
        
        // Add the path to the context with the shadow and no fill
        CGContextSaveGState(context);
        CGContextAddPath(context, path.CGPath);
        CGContextSetShadowWithColor(context, CGSizeMake(0.5, 1), 1.0, shadowColor);
        CGContextFillPath(context);
        CGContextRestoreGState(context);
        
        
        // Create a gradient over the top of above by masking (clipping) to the path used
        CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
        NSArray * colors = [NSArray arrayWithObjects:(__bridge id)topArrowColor, (__bridge id)bottomArrowColor, nil];
        CGGradientRef gradient = CGGradientCreateWithColors(baseSpace, (__bridge CFArrayRef)colors, NULL);
        CGColorSpaceRelease(baseSpace), baseSpace = NULL;
        
        CGContextAddPath(context, path.CGPath);
        CGContextEOClip(context);
        
        CGPoint startPoint = CGPointMake(CGRectGetMidX(kArrowRect), CGRectGetMinY(kArrowRect));
        CGPoint endPoint = CGPointMake(CGRectGetMidX(kArrowRect), CGRectGetMaxY(kArrowRect));
        
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
        CGGradientRelease(gradient), gradient = NULL;
        
        
        _leftArrowImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    return _leftArrowImage;
}

- (UIImage *)rightArrowImage
{
    if (!_rightArrowImage) {
        // Draw the arrow pointing to the right
        UIGraphicsBeginImageContextWithOptions(kArrowRect.size, NO, 0.0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        
        // Draw the path for the Right Arrow >
        // TODO: learn how to flip the arrow to re-use on the left side
        UIBezierPath * path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(1, 1)];
        [path addLineToPoint:CGPointMake(kArrowRect.size.width - 1, CGRectGetMidY(kArrowRect))];
        [path addLineToPoint:CGPointMake(1, kArrowRect.size.height - 1)];
        [path closePath];
        

        // Add the path to the context with the shadow and no fill
        CGContextSaveGState(context);
        CGContextAddPath(context, path.CGPath);
        CGContextSetShadowWithColor(context, CGSizeMake(-0.5, 1), 1.0, shadowColor);
        CGContextFillPath(context);
        CGContextRestoreGState(context);
        
        
        // Create a gradient over the top of above by masking (clipping) to the path used
        CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
        NSArray * colors = [NSArray arrayWithObjects:(__bridge id)topArrowColor, (__bridge id)bottomArrowColor, nil];
        CGGradientRef gradient = CGGradientCreateWithColors(baseSpace, (__bridge CFArrayRef)colors, NULL);
        CGColorSpaceRelease(baseSpace), baseSpace = NULL;
        
        CGContextAddPath(context, path.CGPath);
        CGContextEOClip(context);
        
        CGPoint startPoint = CGPointMake(CGRectGetMidX(kArrowRect), CGRectGetMinY(kArrowRect));
        CGPoint endPoint = CGPointMake(CGRectGetMidX(kArrowRect), CGRectGetMaxY(kArrowRect));
        
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
        CGGradientRelease(gradient), gradient = NULL;
        
        
        _rightArrowImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    return _rightArrowImage;
}

- (UIImage *)headerPatternImage
{
    if (!_headerPatternImage) {
        // Create the Gradient Pattern for the background
        CGRect patternRect = CGRectMake(0, 0, 8, 46);
        UIGraphicsBeginImageContextWithOptions(patternRect.size, NO, 1.0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGColorRef topColor = [UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:247.0/255.0 alpha:1.0].CGColor; 
        CGColorRef bottomColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:209.0/255.0 alpha:1.0].CGColor;
        
        drawLinearGradient(context, patternRect, topColor, bottomColor);
        
        _headerPatternImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    return _headerPatternImage;
}

- (UIImage *)darkTextPatternImage
{
    if (!_darkTextPatternImage) {
        // Create the Gradient Pattern for the text
        CGRect patternRect = CGRectMake(0, 0, 8, 46);
        UIGraphicsBeginImageContextWithOptions(patternRect.size, NO, 1.0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        drawLinearGradient(context, patternRect, topArrowColor, bottomArrowColor);
        
        _darkTextPatternImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    return _darkTextPatternImage;
}

- (UIImage *)lightTextPatternImage
{
    if (!_lightTextPatternImage) {
        // Create the Gradient Pattern for the text
        CGRect patternRect = CGRectMake(0, 0, 8, 46);
        UIGraphicsBeginImageContextWithOptions(patternRect.size, NO, 1.0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGColorRef top = [UIColor colorWithRed:139.0/255.0 green:144.0/255.0 blue:150.0/255.0 alpha:1].CGColor;
        CGColorRef bottom = [UIColor colorWithRed:153.0/255.0 green:162.0/255.0 blue:172.0/255.0 alpha:1].CGColor;
        drawLinearGradient(context, patternRect, top, bottom);
        
        _lightTextPatternImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    return _lightTextPatternImage;
}

@end



CGRect rectByChangingSize(CGRect rect, CGFloat deltaWidth, CGFloat deltaHeight)
{
    return CGRectMake(rect.origin.x, rect.origin.y, rect.size.width + deltaWidth, rect.size.height + deltaHeight);
}

CGRect rectFor1PxStroke(CGRect rect) 
{
    return CGRectMake(rect.origin.x + 0.5, rect.origin.y + 0.5, rect.size.width - 1, rect.size.height - 1);
}

void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor)
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = [NSArray arrayWithObjects:(__bridge id)startColor, (__bridge id)endColor, nil];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, locations);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

void drawGlossAndGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor)
{    
    drawLinearGradient(context, rect, startColor, endColor);
    
    CGColorRef glossColor1 = [UIColor colorWithRed:1.0 green:1.0 
                                              blue:1.0 alpha:0.35].CGColor;
    CGColorRef glossColor2 = [UIColor colorWithRed:1.0 green:1.0 
                                              blue:1.0 alpha:0.1].CGColor;
    
    CGRect topHalf = CGRectMake(rect.origin.x, rect.origin.y, 
                                rect.size.width, rect.size.height/2);
    
    drawLinearGradient(context, topHalf, glossColor1, glossColor2);
}