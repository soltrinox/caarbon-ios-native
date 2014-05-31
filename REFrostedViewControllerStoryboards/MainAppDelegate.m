//
//  DEMOAppDelegate.m
//  REFrostedViewControllerStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "MainAppDelegate.h"
#import <GeotriggerSDK/GeotriggerSDK.h>
#import "Constants.h"

@implementation MainAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	 [TestFlight takeOff:@"7d0016d5-23bd-47fe-abe0-64435f966a21"];

	// Create a reference to a Firebase location
	Firebase* f = [[Firebase alloc] initWithUrl:@"https://flickering-fire-6332.firebaseio.com/"];

	// Write data to Firebase
	[f setValue:@"Do you have data? You'll love Firebase."];

	// Read data and react to changes
	[f observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
		NSLog(@"%@ -> %@", snapshot.name, snapshot.value);
	}];


	[AGSGTGeotriggerManager setupWithClientId:kClientId isProduction:NO tags:@[@"test"] completion:^(NSError *error) {
         if (error != nil) {
             NSLog(@"Geotrigger Service setup encountered error: %@", error);
         } else {
             NSLog(@"Geotrigger Service ready to go!");

             // Turn on location tracking in adaptive mode
             [AGSGTGeotriggerManager sharedManager].trackingProfile = kAGSGTTrackingProfileAdaptive;
         }
    }];

// required
	return YES;
}


-(void) addToMasterOfferList{
    NSLog(@"%@", _masterOffers2);
    masterOffers = _masterOffers2;
    NSLog(@"%@", masterOffers);
    
}

-(void) addRandomOfferList{
    NSMutableArray *newOfferList = masterOfferArray;
    NSString *iii = [self genRandStringLength:20];
     NSDictionary *offer = @{@"title" : iii, @"ends" : @"12/15/2013", @"message" : @"This is some text for this offer and some details about the offer that will display on offer card.", @"badge":@"10"};
    [newOfferList addObject:offer];
     _masterOfferList = newOfferList;
}

NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

-(NSString *) genRandStringLength: (int) len {
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    return randomString;
}



							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
