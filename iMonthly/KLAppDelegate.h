//
//  KLAppDelegate.h
//  iMonthly
//
//  Created by Kyle LeNeau on 12/25/11.
//  Copyright (c) 2011 LeNeau Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExampleSelectionViewController.h"

@interface KLAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navController;
@property (strong, nonatomic) ExampleSelectionViewController *selectionController;

@end
