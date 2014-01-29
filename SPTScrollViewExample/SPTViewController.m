//
//  SPTViewController.m
//  SPTScrollViewExample
//
//  Created by Alessandro Molari on 28/01/14.
//  Copyright (c) 2014 SPOT Software. All rights reserved.
//

#import "SPTViewController.h"
#import "UIViewController+ScrollView.h"


@implementation SPTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scrollView.delegate = self;
    
    [self addSubviews:@[@"firstViewController", @"secondViewController", @"thirdViewController"]
       fromStoryboard:@"Main"
         toScrollView:self.scrollView
      withHorizOrient:YES
        updatingPager:self.pager];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

#pragma mark Orientation

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self adjustSizeForScrollView:self.scrollView withHorizOrient:YES];
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updatePager:self.pager fromScrollView:scrollView withHorizOrient:YES];
}

@end
