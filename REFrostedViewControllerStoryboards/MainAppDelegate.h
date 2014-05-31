//
//  DEMOAppDelegate.h
//  REFrostedViewControllerStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>
#import "TestFlight.h"
#import "RKTwitterViewController.h"
#import "RKTweet.h"
#import <CoreLocation/CoreLocation.h>

@interface MainAppDelegate : UIResponder <UIApplicationDelegate>{
	CLLocationManager *locationManager;
    NSArray *masterOffers;

	NSMutableArray *masterOfferArray;
    NSDictionary *masterDict;

}

@property (strong, nonatomic) UIWindow *window;
-(void) addToMasterOfferList;
-(void) setOfferList;
-(void) addRandomOfferList;
-(NSArray *) getOfferList;

@property (nonatomic, retain) CLLocationManager *locationManager;
@property(nonatomic, retain) NSArray *masterOffers2;
@property (nonatomic, retain) NSArray *masterOfferList;

@end
