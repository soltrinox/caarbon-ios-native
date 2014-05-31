//
//  BaseDashBoardViewController.h
//  REFrostedViewControllerStoryboards
//
//  Created by Dylan Rosario on 5/23/14.
//  Copyright (c) 2014 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MainAppDelegate.h"

@interface BaseDashBoardViewController : UIViewController <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>{
    
    MainAppDelegate *appDelegate;
    
    IBOutlet UIScrollView	*_scrollView;
    IBOutlet UITableView   *tableView;
    IBOutlet UIScrollView	*_cardView;
     IBOutlet UIScrollView	*_eventView;
	 IBOutlet UIButton *requestButton;
    NSArray  *eventList;
    NSArray *tableData;

	NSMutableArray *mastereventArray;
    NSDictionary *masterDict;
}

@property(nonatomic,assign)   id <UIScrollViewDelegate>   delegate;

- (IBAction)unwindToFirstViewController:(UIStoryboardSegue *)segue;
- (IBAction) backButtonTapped;
- (IBAction) openRequest:(id)sender;
- (void)viewCart;
- (IBAction)paySend:(id)sender;
-(IBAction)useevent:(id)sender;
-(IBAction)removeevent:(id)sender;

@property (nonatomic, retain) NSArray *mastereventList;


@end
