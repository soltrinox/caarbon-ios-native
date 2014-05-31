//
//  BaseDashBoardViewController.m
//  REFrostedViewControllerStoryboards
//
//  Created by Dylan Rosario on 5/23/14.
//  Copyright (c) 2014 Roman Efimov. All rights reserved.
//

#import "BaseDashBoardViewController.h"
#import "MainAppDelegate.h"
#import "MVSpeechSynthesizer.h"
#import "DurationViewController.h"

@interface BaseDashBoardViewController ()

@end

@implementation BaseDashBoardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) seteventList{
    
    NSLog(@"Setting Master Event List");
    
    NSDictionary *event1 = @{@"title" : @"San Francisco Ballet", @"ends" : @"12/15/2014", @"message" : @"This is some text for this event and some details about the event that will display on event card.", @"badge":@"10"};
    
    NSDictionary *event2 = @{@"title" : @"Giant vs Yankees", @"ends" : @"12/15/2014", @"message" : @"This is some text for this event and some details about the event that will display on event card.", @"badge":@"10"};
    
    NSDictionary *event3 = @{@"title" : @"Business Meeting @ Radius", @"ends" : @"12/15/2014", @"message" : @"This is some text for this event and some details about the event that will display on event card.", @"badge":@"10"};
    
    NSDictionary *event4 = @{@"title" : @"Dinner date with Mom", @"ends" : @"12/15/2014", @"message" : @"This is some text for this event and some details about the event that will display on event card.", @"badge":@"10"};
    
    
    NSDictionary *event5 = @{@"title" : @"Niko's Birthday", @"ends" : @"12/15/2014", @"message" : @"This is some text for this event and some details about the event that will display on event card.", @"badge":@"10"};
    
    NSDictionary *event6 = @{@"title" : @"A sample event", @"ends" : @"12/15/2014", @"message" : @"This is some text for this event and some details about the event that will display on event card.", @"badge":@"10"};
    
    
    
	NSArray *neweventList = @[    event1,
                            event2,
                            event3,
                            event4,
                            event5,
                            event6];
    
    _mastereventList = neweventList;
    mastereventArray = [(NSArray*)_mastereventList mutableCopy];
   
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	[self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                     forBarMetrics:UIBarMetricsDefault];
	self.navigationController.navigationBar.shadowImage = [UIImage new];
	self.navigationController.navigationBar.translucent = YES;
	self.navigationController.view.backgroundColor = [UIColor clearColor];

	
	[self seteventList];

	eventList =   _mastereventList ;
    NSLog(@"%@", eventList);

	// now set the boundary of the scroller
	// then add the view to current view controller
    CGRect scrollViewFrame = self.view.bounds;
    _scrollView = [[UIScrollView alloc] initWithFrame:scrollViewFrame];
    _scrollView.delegate = self;
    _scrollView.scrollEnabled = YES;
    [_scrollView setContentSize:CGSizeMake(280, 320)];
    [self.view addSubview:_scrollView];
    UIView *myOuterView = [[UIView alloc] initWithFrame:self.view.bounds];
    myOuterView.backgroundColor = [UIColor clearColor]; //  [[UIColor alloc]initWithRed:198.0/255.0 green:198.0/255.0 blue:198.0/255.0 alpha:0.25];
    [_scrollView addSubview:myOuterView];

    [self addeventView];

	  NSString *speech = @"Select an appointment from your calendar or choose one of our recommended events to reserve your valet.";

	[self readText:speech];

}

- (IBAction) openRequest:(id)sender{
	DurationViewController *durationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"durationview"];
	self.navigationController.viewControllers = @[durationViewController];
}

-(void)readText:(NSString *)readText {


    MVSpeechSynthesizer *mvSpeech=[MVSpeechSynthesizer sharedSyntheSize];
   
    mvSpeech.higlightColor=[UIColor yellowColor];
    mvSpeech.isTextHiglight=YES;
    mvSpeech.speechString=readText;
    NSString *speechLanguage=mvSpeech.speechLanguage;
    [mvSpeech startRead];
   
    mvSpeech.speechStartBlock=^(AVSpeechSynthesizer *synthesizer, AVSpeechUtterance *utterence){
        // you can change the accent of the digital assistant
        NSLog(@"speech language==%@",speechLanguage);
        NSArray *tempArray=[speechLanguage componentsSeparatedByString:@"-"];
        NSString *identifier = [NSLocale localeIdentifierFromComponents: [NSDictionary dictionaryWithObject:tempArray[1] forKey: NSLocaleCountryCode]];
        NSString *country = [[NSLocale currentLocale] displayNameForKey: NSLocaleIdentifier value: identifier];
        NSLocale *enLocale =[[NSLocale alloc] initWithLocaleIdentifier:@"en"];
        NSString *displayNameString = [enLocale displayNameForKey:NSLocaleIdentifier value:tempArray[0]];
	};
        
    mvSpeech.speechFinishBlock=^(AVSpeechSynthesizer *synthesizer, AVSpeechUtterance *utterence){
		// do something here
    };

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void) addeventView{
    
    CGRect eventViewFrame = CGRectMake(20, 62, 280, 180);
    
    _eventView = [[UIScrollView alloc] initWithFrame:eventViewFrame];
    
    
    _eventView.clipsToBounds = NO;
	_eventView.pagingEnabled = YES;
	_eventView.showsHorizontalScrollIndicator = NO;
    _eventView.backgroundColor = [UIColor clearColor];
    
    
    CGFloat ocontentOffset = 0.0f;
    NSInteger eventRemoveCur = 0;
    NSInteger eventUseCur = 0;
    
	for (NSDictionary *singleevent in eventList) {
        
        // ---------
        
        UIButton *removeButton = [[UIButton alloc] initWithFrame:CGRectMake(ocontentOffset + 22 , 125.0f, 60, 30)];
        UILabel* removetitleLabel = [[UILabel alloc]
                                     initWithFrame:removeButton.bounds ];
        
        removeButton.backgroundColor = [UIColor clearColor];
        removetitleLabel.Text = @"";
        removetitleLabel.font =  [UIFont fontWithName:@"Helvetica-Bold" size: 11.0];
        [removetitleLabel setTextAlignment:NSTextAlignmentCenter];
        removetitleLabel.backgroundColor = [UIColor clearColor];
        removetitleLabel.TextColor = [UIColor whiteColor];
        [removeButton addTarget:self action:@selector(removeevent:) forControlEvents:UIControlEventTouchUpInside];
        [removeButton addSubview:removetitleLabel];
        [removeButton setTag:eventRemoveCur];
        
        // ---------
        
        UIButton *useeventButton = [[UIButton alloc] initWithFrame:CGRectMake(ocontentOffset + 190 , 125.0f, 65, 30)];
        UILabel* usetitleLabel = [[UILabel alloc]
                                  initWithFrame:useeventButton.bounds ];
        
        useeventButton.backgroundColor = [UIColor clearColor];
        usetitleLabel.Text = @"";
        usetitleLabel.font =  [UIFont fontWithName:@"Helvetica-Bold" size: 11.0];
        [usetitleLabel setTextAlignment:NSTextAlignmentCenter];
        usetitleLabel.backgroundColor = [UIColor clearColor];
        usetitleLabel.TextColor = [UIColor whiteColor];
        [useeventButton addTarget:self action:@selector(useevent:) forControlEvents:UIControlEventTouchUpInside];
        [useeventButton addSubview:usetitleLabel];
        
        [useeventButton setTag:eventUseCur];
        
        // ----------
        
        
        CGRect eventImageViewFrame = CGRectMake(ocontentOffset, 0.0f, _eventView.frame.size.width, _eventView.frame.size.height);
		UIImageView *eventimageView = [[UIImageView alloc] initWithFrame:eventImageViewFrame];
        NSString *fName = @"offercard.png";
		eventimageView.image = [UIImage imageNamed:fName];
		eventimageView.contentMode = UIViewContentModeScaleAspectFit;
        
        // ----------
        
        CGRect eventtexViewFrame = CGRectMake(ocontentOffset , 40.0f, 280, 30);
        UITextView *eventtexView = [[UITextView alloc] initWithFrame:eventtexViewFrame];
        [eventtexView setUserInteractionEnabled:NO];
        
        [eventtexView setFont:[UIFont boldSystemFontOfSize:18]];
        [eventtexView setTextAlignment:NSTextAlignmentCenter];
        eventtexView.text = singleevent[ @"title" ];
        eventtexView.textColor = [UIColor whiteColor];
        [eventtexView setBackgroundColor:[UIColor clearColor]];
        
        // ---------
        
        
        CGRect eventEndsLabelFrame = CGRectMake(ocontentOffset +15 , 14.0f, 55, 21);
        UITextView *eventEndsLabel = [[UITextView alloc] initWithFrame:eventEndsLabelFrame];
        
        [eventEndsLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size: 10.0]];
        [eventEndsLabel setTextAlignment:NSTextAlignmentLeft];
        eventEndsLabel.text =  @"ends : " ;
        eventEndsLabel.textColor = [[UIColor alloc]initWithRed:150.0/255.0 green:150.0/255.0 blue:150.0/255.0 alpha:1];
        [eventEndsLabel setBackgroundColor:[UIColor clearColor]];
        [eventEndsLabel setUserInteractionEnabled:NO];
        
        
        CGRect eventEndsViewFrame = CGRectMake(ocontentOffset +58 , 14.0f, 250, 21);
        UITextView *eventEndsView = [[UITextView alloc] initWithFrame:eventEndsViewFrame];
        
        [eventEndsView setFont:[UIFont fontWithName:@"Helvetica-Bold" size: 10.0]];
        [eventEndsView setTextAlignment:NSTextAlignmentLeft];
        eventEndsView.text = singleevent[ @"ends" ];
        eventEndsView.textColor = [[UIColor alloc]initWithRed:150.0/255.0 green:150.0/255.0 blue:150.0/255.0 alpha:1];
        [eventEndsView setBackgroundColor:[UIColor clearColor]];
        [eventEndsView setUserInteractionEnabled:NO];
        
        
        // ---------
        
        CGRect eventDescViewFrame = CGRectMake(ocontentOffset +15 , 74.0f, 250, 45);
        UITextView *eventDescView = [[UITextView alloc] initWithFrame:eventDescViewFrame];
        
        [eventDescView setFont:[UIFont fontWithName:@"Helvetica-Bold" size: 10.0]];
        [eventDescView setTextAlignment:NSTextAlignmentCenter];
        eventDescView.text = singleevent[ @"message" ];
        eventDescView.textColor = [[UIColor alloc]initWithRed:150.0/255.0 green:150.0/255.0 blue:150.0/255.0 alpha:1];
        [eventDescView setBackgroundColor:[UIColor clearColor]];
        [eventDescView setUserInteractionEnabled:NO];
        
        // ---------
        
		[_eventView addSubview:eventimageView];
		[_eventView addSubview:eventtexView];
        [_eventView addSubview:eventDescView];
        [_eventView addSubview:eventEndsLabel];
        [_eventView addSubview:eventEndsView];
        [_eventView addSubview:removeButton];
        [_eventView addSubview:useeventButton];
        
		ocontentOffset += eventimageView.frame.size.width;
		
        _eventView.contentSize = CGSizeMake(ocontentOffset, _eventView.frame.size.height);
        eventRemoveCur = eventRemoveCur + 1;
        eventUseCur = eventUseCur + 1;
        
	}
    
    // ================= 


       
    CGRect addeventViewFrame = CGRectMake(ocontentOffset, 0.0f, _eventView.frame.size.width, _eventView.frame.size.height);
    
    UIImageView *addeventView = [[UIImageView alloc] initWithFrame:addeventViewFrame];
    NSString *fName = @"addoffercard.png";
    addeventView.image = [UIImage imageNamed:fName];
    addeventView.contentMode = UIViewContentModeScaleAspectFit;

	/*
    
    // ----------
    
    UIButton *addeventButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UILabel* addeventTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(ocontentOffset + 22 , 125.0f, 225, 30) ];
    [addeventButton setFrame:CGRectMake(ocontentOffset + 22 , 125.0f, 225, 30)];
    addeventButton.backgroundColor = [UIColor redColor];
    addeventButton.layer.cornerRadius = 5.0f;
    addeventTitleLabel.Text = @"scan event";
    addeventTitleLabel.font =  [UIFont fontWithName:@"Helvetica-Bold" size: 18.0];
    [addeventTitleLabel setTextAlignment:NSTextAlignmentCenter];
    addeventTitleLabel.backgroundColor = [UIColor clearColor];
    addeventTitleLabel.TextColor = [UIColor whiteColor];
    
    [addeventButton addTarget:self action:@selector(openScanner:) forControlEvents:UIControlEventTouchUpInside];
    [addeventButton addSubview:addeventTitleLabel];
    [addeventButton setTag:99];
    
    // ----------
    
    UIButton *addOkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UILabel* addOkTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(ocontentOffset + 185 , 70.0f, 45, 25) ];
    [addOkButton setFrame:CGRectMake(ocontentOffset + 185 , 70.0f, 45, 25)];
    addOkButton.backgroundColor = [UIColor redColor];
    addOkButton.layer.cornerRadius = 5.0f;
    addOkTitleLabel.Text = @"ok >";
    addOkTitleLabel.font =  [UIFont fontWithName:@"Helvetica-Bold" size: 15.0];
    [addOkTitleLabel setTextAlignment:NSTextAlignmentCenter];
    addOkTitleLabel.backgroundColor = [UIColor clearColor];
    addOkTitleLabel.TextColor = [UIColor whiteColor];
    
    [addOkButton addTarget:self action:@selector(openScanner:) forControlEvents:UIControlEventTouchUpInside];
    [addOkButton addSubview:addOkTitleLabel];
    [addOkButton setTag:88];
    
    // ----------

    
    CGRect addeventtexViewFrame = CGRectMake(ocontentOffset - 15, 22.0f, 280, 30);
    UITextView *addeventtexView = [[UITextView alloc] initWithFrame:addeventtexViewFrame];
    [addeventtexView setUserInteractionEnabled:NO];
    
    [addeventtexView setFont:[UIFont boldSystemFontOfSize:20]];
    [addeventtexView setTextAlignment:NSTextAlignmentCenter];
    addeventtexView.text = @"+ Add event" ;
    addeventtexView.textColor = [[UIColor alloc]initWithRed:150.0/255.0 green:150.0/255.0 blue:150.0/255.0 alpha:1];
    [addeventtexView setBackgroundColor:[UIColor clearColor]];
    
    // ---------
    
    CGRect addeventtexFieldFrame = CGRectMake(ocontentOffset +25 , 70.0f, 150, 25);
    UITextField *addTextevent = [[UITextField alloc] initWithFrame:addeventtexFieldFrame];
    addTextevent.backgroundColor = [UIColor whiteColor];
    addTextevent.placeholder = @"event code";
    addTextevent.borderStyle = UITextBorderStyleRoundedRect;
    
    
    [_eventView addSubview:addeventView];
    [_eventView addSubview:addTextevent];
    [_eventView addSubview:addeventButton];
    [_eventView addSubview:addeventtexView];
    [_eventView addSubview:addOkButton];
    [_eventView addSubview:addOkTitleLabel];
    [_eventView addSubview:addeventTitleLabel];
    
	*/
    
    ocontentOffset += addeventView.frame.size.width;
    _eventView.contentSize = CGSizeMake(ocontentOffset, _eventView.frame.size.height);
    
    // ===============================
    
    [_scrollView addSubview:_eventView];
}


- (IBAction)openScanner:(id)sender;{
//     ScanViewController *showScanController = [[ScanViewController alloc] initWithNibName:nil bundle:nil];
//    
//    [self.navigationController pushViewController:showScanController  animated:YES];
    
//    UIStoryboard * storyboard = self.storyboard;
//    
//    ScanViewController *scan = [storyboard instantiateViewControllerWithIdentifier: @ "scancontroller"];
//    
//    [self.navigationController pushViewController:scan animated: YES];
}

-(IBAction)useOffer:(id)sender {
    NSLog(@"using offer : %ld", (long)[sender tag]);
}

-(IBAction)scanOffer:(id)sender {
    NSLog(@"fireoff Scan offer View : %ld", (long)[sender tag]);
}

-(IBAction)removeOffer:(id)sender {
    NSLog(@"removing offer : %ld", (long)[sender tag]);
}

- (void)viewCart{

NSLog(@"VIEW EVENT : %@", @"NONE");
    
//    UIStoryboard * storyboard = self.storyboard;
//    
//    PurchaseDetailsViewController *purchases = [storyboard instantiateViewControllerWithIdentifier: @ "walletpurchases"];
//    
//    [self.navigationController pushViewController:purchases animated: YES];
}

- (IBAction)paySend:(id)sender
{

NSLog(@"SEND PAY : %@", @"NONE");

//    UIStoryboard * storyboard = self.storyboard;
//    NSLog(@"paySend - RUNNING");
//    
//    ConfirmPayViewController *purchases = [storyboard instantiateViewControllerWithIdentifier: @ "confirmtransaction"];
//    //TransConfirmViewController *purchases =  [[TransConfirmViewController alloc] initWithNibName:@"ConfirmTansActionViewController" bundle:nil];
//    
//    //ConfirmTansActionViewController *purchases = [[ConfirmTansActionViewController alloc] initWithNibName:@"ConfirmTansActionViewController" bundle:nil];
//    
//    
//    [self.navigationController pushViewController:purchases animated: YES];
}


@end
