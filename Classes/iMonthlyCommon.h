//
//  iMonthlyCommon.h
//  iMonthly
//
//  Created by Kyle LeNeau on 1/1/12.
//  Copyright (c) 2012 LeNeau Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDate+iMontly.h"

@interface iMonthlyCommon : NSObject

@end

CGRect rectFor1PxStroke(CGRect rect);
void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor);
void drawGlossAndGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor);