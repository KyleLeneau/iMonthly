//
//  BasicViewController.m
//  iMonthly
//
//  Created by Kyle LeNeau on 12/25/11.
//  Copyright (c) 2011 LeNeau Software. All rights reserved.
//

#import "BasicViewController.h"

@implementation BasicViewController

- (id)init
{
    if ((self = [super init])) {
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)loadView
{
    self.view = [[UIView alloc] init];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
