//
//  UIViewController+ScrollView.h
//
//  Notes:
//    Please note that the provided `scrollView` should be empty
//    (without any subviews except the image views for the scroller).
//    You should just instantiate a UIScrollView and it should work fine.
//
//  Created by Alessandro Molari on 28/01/14.
//  Copyright (c) 2014 SPOT Software. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIViewController (ScrollView)

#pragma mark - UIScrollView management

#pragma mark ContainerView

/**
 *  Adjust the `scrollView` size.
 *
 *  Notes:
 *
 *    This should be (and normally is) called at least on orientation change.
 *
 *  Usage examples:
 *
 *    - (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
 *    {
 *        [self adjustSizeForScrollView:self.scrollView];
 *    }
 */
- (void)adjustSizeForScrollView:(UIScrollView *)scrollView
                withHorizOrient:(BOOL)isHorizontal;

#pragma mark SubViews

/**
 *  Get the view controllers from the `viewControllerStoryboardIds` and append their main views to the `scrollView`.
 */
- (void)addSubviews:(NSArray *)viewControllerStoryboardIds
     fromStoryboard:(NSString *)storyboardName
       toScrollView:(UIScrollView *)scrollView
    withHorizOrient:(BOOL)isHorizontal
      updatingPager:(UIPageControl *)pager;

/**
 *  Get the view controller from the `viewControllerStoryboardId` and append its main view to the `scrollView`.
 */
- (void)addSubview:(NSString *)viewControllerStoryboardId
    fromStoryboard:(NSString *)storyboardName
      toScrollView:(UIScrollView *)scrollView
   withHorizOrient:(BOOL)isHorizontal
     updatingPager:(UIPageControl *)pager;

#pragma mark - UIPageControl management

/**
 *  Adjust the pager to match the `scrollView` state.
 *
 *  Notes:
 *
 *    This should be (and normally is) called at least when the `scrollView` ends scrolling.
 *
 *  Usage examples:
 *
 *    // Please remember to add the delegate: UIScrollViewDelegate
 *    -(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
 *    {
 *        [self updatePager:self.pager fromScrollView:scrollView];
 *    }
 */
- (void)updatePager:(UIPageControl *)pager
     fromScrollView:(UIScrollView *)scrollView
    withHorizOrient:(BOOL)isHorizontal;

@end
