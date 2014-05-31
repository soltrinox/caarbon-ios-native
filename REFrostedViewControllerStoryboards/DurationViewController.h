//
//  DurationViewController.h
//  REFrostedViewControllerStoryboards
//
//  Created by Dylan Rosario on 5/24/14.
//  Copyright (c) 2014 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DurationViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) NSArray *hours;
@property (strong, nonatomic) NSArray *minutes;

@end
