//
//  ConfirmRequestViewController.m
//  REFrostedViewControllerStoryboards
//
//  Created by Dylan Rosario on 5/24/14.
//  Copyright (c) 2014 Roman Efimov. All rights reserved.
//

#import "ConfirmRequestViewController.h"
#import "MVSpeechSynthesizer.h"

@interface ConfirmRequestViewController ()

@end

@implementation ConfirmRequestViewController

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
	[self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                     forBarMetrics:UIBarMetricsDefault];
self.navigationController.navigationBar.shadowImage = [UIImage new];
self.navigationController.navigationBar.translucent = YES;
self.navigationController.view.backgroundColor = [UIColor clearColor];



	  NSString *speech = @" Your request is for the San Francisco Ballet, Located at 123 First Avenue East, San francisco, california. Drop off is at 6pm. You expect to be at the event for approximately 2 hours and 45 minutes.  If this is correct, please select the confirm button and we will begin assigning your valet.  ";

	[self readText:speech];

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
