//
//  DEMOSecondViewController.m
//  REFrostedViewControllerStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "MainSecondViewController.h"

@interface MainSecondViewController ()

@end

@implementation MainSecondViewController

- (IBAction)showMenu
{
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	[self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                     forBarMetrics:UIBarMetricsDefault];
self.navigationController.navigationBar.shadowImage = [UIImage new];
self.navigationController.navigationBar.translucent = YES;
self.navigationController.view.backgroundColor = [UIColor clearColor];

}

@end
