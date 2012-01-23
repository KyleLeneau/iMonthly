//
//  iMonthlyCommon.h
//  iMonthly
//
//  Created by Kyle LeNeau on 1/1/12.
//  Copyright (c) 2012 LeNeau Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDate+iMontly.h"
#import "UIView+iMonthly.h"

@interface iMonthlyCommon : NSObject

@property (nonatomic, readonly) UIImage * leftArrowImage;
@property (nonatomic, readonly) UIImage * rightArrowImage;
@property (nonatomic, readonly) UIImage * darkTextPatternImage;
@property (nonatomic, readonly) UIImage * lightTextPatternImage;

+ (iMonthlyCommon *)sharedInstance;

@end

CGRect rectByChangingSize(CGRect rect, CGFloat deltaWidth, CGFloat deltaHeight);
CGRect rectFor1PxStroke(CGRect rect);
void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor);
void drawGlossAndGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor);