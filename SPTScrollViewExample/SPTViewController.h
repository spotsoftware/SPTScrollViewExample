//
//  SPTViewController.h
//  SPTScrollViewExample
//
//  Created by Alessandro Molari on 28/01/14.
//  Copyright (c) 2014 SPOT Software. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SPTViewController : UIViewController <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pager;

@end
