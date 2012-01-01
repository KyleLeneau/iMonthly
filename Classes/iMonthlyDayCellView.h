//
//  iMonthlyDayCellView.h
//  iMonthly
//
//  Created by Kyle LeNeau on 12/30/11.
//  Copyright (c) 2011 LeNeau Software. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kDayCellStateUnKnown,
    kDayCellStateOutOfMonth,
	kDayCellStateInMonth,
	kDayCellStateSelected,
    kDayCellStateToday
} kDayCellState;


@interface iMonthlyDayCellView : UIView

@property (nonatomic, strong) NSDate * date;

- (void)setDayCellState:(kDayCellState)state;

@end
