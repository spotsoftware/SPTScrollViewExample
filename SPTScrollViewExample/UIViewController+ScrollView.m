//
//  UIViewController+ScrollView.m
//  SPTScrollViewExample
//
//  Created by Alessandro Molari on 28/01/14.
//  Copyright (c) 2014 SPOT Software. All rights reserved.
//

#import "UIViewController+ScrollView.h"


@implementation UIViewController (ScrollView)

#pragma mark - UIScrollView management

#pragma mark ContainerView

- (void)ensureScrollView:(UIScrollView *)scrollView
{
    if ([self getContainerViewForScrollView:scrollView] == nil) {
        [self addContainerViewToScrollView:scrollView];
    }
}

- (void)addContainerViewToScrollView:(UIScrollView *)scrollView
{
    CGFloat initialContainerWidth = scrollView.frame.size.width;
    CGFloat initialContainerHeight = scrollView.frame.size.height;
    CGRect initialContainerFrame = CGRectMake(0, 0, initialContainerWidth, initialContainerHeight);
    
    UIView *containerView = [[UIView alloc] initWithFrame:initialContainerFrame];
    
    [scrollView addSubview:containerView];
    
    // Set the content size of the scroll view to match the size of the content view:
    [scrollView setContentSize:CGSizeMake(initialContainerWidth, initialContainerHeight)];
}

- (void)adjustSizeForScrollView:(UIScrollView *)scrollView
                withHorizOrient:(BOOL)isHorizontal
{
    UIView *containerView = [self getContainerViewForScrollView:scrollView];
    
    NSUInteger subviewsCount = containerView.subviews.count;
    
    CGSize size;
    if (isHorizontal) {
        size = CGSizeMake(scrollView.frame.size.width * subviewsCount, scrollView.frame.size.height);
    } else {
        size = CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.height * subviewsCount);
    }
    
    CGRect frame = CGRectMake(containerView.frame.origin.x, containerView.frame.origin.y, size.width, size.height);
    containerView.frame = frame;
    
    [scrollView setContentSize:size];
}

- (UIView *)getContainerViewForScrollView:(UIScrollView *)scrollView
{
    for (UIView *subView in scrollView.subviews) {
        if (![subView isKindOfClass:[UIImageView class]]) {
            return subView;
        }
    }
    return nil;
}

#pragma mark SubViews

- (void)addSubviews:(NSArray *)viewControllerStoryboardIds
     fromStoryboard:(NSString *)storyboardName
       toScrollView:(UIScrollView *)scrollView
    withHorizOrient:(BOOL)isHorizontal
      updatingPager:(UIPageControl *)pager
{
    for (NSString *viewControllerStoryboardId in viewControllerStoryboardIds) {
        [self addSubview:viewControllerStoryboardId
          fromStoryboard:storyboardName
            toScrollView:scrollView
         withHorizOrient:isHorizontal
           updatingPager:pager];
    }
}

- (void)addSubview:(NSString *)viewControllerStoryboardId
    fromStoryboard:(NSString *)storyboardName
      toScrollView:(UIScrollView *)scrollView
   withHorizOrient:(BOOL)isHorizontal
     updatingPager:(UIPageControl *)pager
{
    [self ensureScrollView:scrollView];
    
    UIView *containerView = [self getContainerViewForScrollView:scrollView];
    
    // { Get a reference for the view to be added
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:viewControllerStoryboardId];
    UIView *view = viewController.view;
    // }
    
    // Add the `view` as a `scrollView` subview
    [containerView addSubview:view];
    
    if (containerView.subviews.count == 1) {
        [self setupConstraintsForSubview:[containerView.subviews lastObject]
                       withPrecedingView:nil
                            inScrollView:scrollView
                    withHorizontalOffset:0
                      withVerticalOffset:0
                         withHorizOrient:isHorizontal];
    } else {
        [self setupConstraintsForSubview:[containerView.subviews lastObject]
                       withPrecedingView:[containerView.subviews objectAtIndex:(containerView.subviews.count - 2)]
                            inScrollView:scrollView
                    withHorizontalOffset:0
                      withVerticalOffset:0
                         withHorizOrient:isHorizontal];
    }
    [self adjustSizeForScrollView:scrollView withHorizOrient:isHorizontal];
    
    // If the `pager` is not nil (i.e. it has been provided), we should update it
    if (pager) {
        // The first time we add a subView we initialize the current page for the pager
        if (containerView.subviews.count == 1) {
            pager.currentPage = 0;
        }
        
        pager.numberOfPages = containerView.subviews.count;
    }
}

- (void)setupConstraintsForSubview:(UIView *)view
                 withPrecedingView:(UIView *)precedingView
                      inScrollView:(UIScrollView *)scrollView
              withHorizontalOffset:(NSUInteger)horizontalOffset
                withVerticalOffset:(NSUInteger)verticalOffset
                   withHorizOrient:(BOOL)isHorizontal
{
    UIView *containerView = [self getContainerViewForScrollView:scrollView];
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    // { Set Left (if isHorizontal) or Top (if !isHorizontal) constraint for the provided `view`
    if (precedingView == nil) {
        NSLayoutAttribute subjectAttribute = isHorizontal ? NSLayoutAttributeLeft : NSLayoutAttributeTop;
        NSLayoutAttribute relatedToAttribute = subjectAttribute;
        
        [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                               attribute:subjectAttribute
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:containerView
                                                               attribute:relatedToAttribute
                                                              multiplier:1.f
                                                                constant:horizontalOffset]];
    } else {
        NSLayoutAttribute subjectAttribute = isHorizontal ? NSLayoutAttributeLeft : NSLayoutAttributeTop;
        NSLayoutAttribute relatedToAttribute = isHorizontal ? NSLayoutAttributeRight : NSLayoutAttributeBottom;
        
        [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                               attribute:subjectAttribute
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:precedingView
                                                               attribute:relatedToAttribute
                                                              multiplier:1.f
                                                                constant:horizontalOffset]];
    }
    // }
    
    NSLayoutAttribute topOrLeftAttribute = isHorizontal ? NSLayoutAttributeTop : NSLayoutAttributeLeft;
    [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                           attribute:topOrLeftAttribute
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:containerView
                                                           attribute:topOrLeftAttribute
                                                          multiplier:1.f
                                                            constant:verticalOffset]];
    
    NSLayoutAttribute bottomOrRightAttribute = isHorizontal ? NSLayoutAttributeBottom : NSLayoutAttributeRight;
    [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                           attribute:bottomOrRightAttribute
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:containerView
                                                           attribute:bottomOrRightAttribute
                                                          multiplier:1.f
                                                            constant:verticalOffset]];
    
    NSLayoutAttribute widthOrHeightAttribute = isHorizontal ? NSLayoutAttributeWidth : NSLayoutAttributeHeight;
    [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                           attribute:widthOrHeightAttribute
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:scrollView
                                                           attribute:widthOrHeightAttribute
                                                          multiplier:1.f
                                                            constant:horizontalOffset]];
}

#pragma mark - UIPageControl management

- (void)updatePager:(UIPageControl *)pager
     fromScrollView:(UIScrollView *)scrollView
    withHorizOrient:(BOOL)isHorizontal
{
    CGFloat offset;
    CGFloat size;
    if (isHorizontal) {
        offset = scrollView.contentOffset.x;
        size = scrollView.frame.size.width;
    } else {
        offset = scrollView.contentOffset.y;
        size = scrollView.frame.size.height;
    }
    CGFloat page = offset / size;
    NSInteger pageRounded = roundf(page * 100) / 100.0;
    pager.currentPage = pageRounded;
}

@end
