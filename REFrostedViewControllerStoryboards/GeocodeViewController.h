//
//  GeocodeViewController.h
//  REFrostedViewControllerStoryboards
//
//  Created by Dylan Rosario on 5/24/14.
//  Copyright (c) 2014 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BSForwardGeocoder.h"
#import "BSKmlResult.h"
#import "CustomPlacemark.h"
#import "REFrostedViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface GeocodeViewController : UIViewController <MKMapViewDelegate, UISearchBarDelegate, BSForwardGeocoderDelegate>{
	
	MKMapView *mapView;


}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) BSForwardGeocoder *forwardGeocoder;

@property (nonatomic, strong) CLGeocoder *myGeocoder;

//- (IBAction)showMenu;
- (IBAction)zoomIn:(id)sender;
- (IBAction)changeMapType:(id)sender;

@property (strong, nonatomic) CLLocation *location;

@property (weak, nonatomic) IBOutlet UIButton *routeButton;
@property (weak, nonatomic) IBOutlet UIButton *routeDetailsButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
- (IBAction)handleRoutePressed:(id)sender;

@end
