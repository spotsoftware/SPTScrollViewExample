//
//  SPTFirstViewController.m
//  SPTScrollViewExample
//
//  Created by Alessandro Molari on 28/01/14.
//  Copyright (c) 2014 SPOT Software. All rights reserved.
//

#import "SPTFirstViewController.h"

@interface SPTFirstViewController ()

@end

@implementation SPTFirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"Loaded the first view controller");
}

@end
