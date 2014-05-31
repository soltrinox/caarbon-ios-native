//
//  DurationViewController.m
//  REFrostedViewControllerStoryboards
//
//  Created by Dylan Rosario on 5/24/14.
//  Copyright (c) 2014 Roman Efimov. All rights reserved.
//

#import "DurationViewController.h"
#import "MVSpeechSynthesizer.h"

@interface DurationViewController ()

@end

@implementation DurationViewController

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

	 _hours = @[  @"0 hrs", @"1 hrs",@"2 hrs",@"3 hrs",@"4 hrs",@"5 hrs",@"6 hrs",@"7 hrs",@"8 hrs",@"9 hrs",@"10 hrs",@"11 hrs",@"12 hrs"];

      _minutes = @[ @"00 mins", @"1 mins",@"2 mins",@"3 mins",@"4 mins",@"5 mins",@"6 mins",@"7 mins",@"8 mins",@"9 mins", @"10 mins", @"11 mins",@"12 mins",@"13 mins",@"14 mins",@"15 mins",@"16 mins",@"17 mins",@"18 mins",@"19 mins",
	  @"20 mins", @"21 mins",@"22 mins",@"23 mins",@"24 mins",@"25 mins",@"26 mins",@"27 mins",@"28 mins",@"29 mins",@"30 mins", @"31 mins",@"32 mins",@"33 mins",@"34 mins",@"35 mins",@"36 mins",@"37 mins",@"38 mins",@"39 mins",
	  @"40 mins", @"41 mins",@"42 mins",@"43 mins",@"44 mins",@"45 mins",@"46 mins",@"47 mins",@"48 mins",@"49 mins",@"50 mins", @"51 mins",@"52 mins",@"53 mins",@"54 mins",@"55 mins",@"56 mins",@"57 mins",@"58 mins",@"59 mins"];

	  NSString *speech = @"Please select the length of your event. ";

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

#pragma mark PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
        return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
      numberOfRowsInComponent:(NSInteger)component
{
	if(pickerView.tag == 9){
        return _hours.count;
	}else{
		return _minutes.count;
	}
}

- (NSString *)pickerView:(UIPickerView *)pickerView
titleForRow:(NSInteger)row
forComponent:(NSInteger)component
{
	if(pickerView.tag == 9){
		return _hours[row];
	}else{
		return _minutes[row];
	}
}

@end
