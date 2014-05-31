//
//  GeocodeViewController.m
//  REFrostedViewControllerStoryboards
//
//  Created by Dylan Rosario on 5/24/14.
//  Copyright (c) 2014 Roman Efimov. All rights reserved.
//

#import "GeocodeViewController.h"
#import "BSForwardGeocoder.h"
#import "MyAnnotation.h"
#import "MVSpeechSynthesizer.h"

@interface GeocodeViewController ()<MKMapViewDelegate> {
    MKPolyline *_routeOverlay;
    MKRoute *_currentRoute;
}
@end

@implementation GeocodeViewController

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

	_searchBar.delegate = self;
	self.navigationItem.titleView = _searchBar;
	_mapView.delegate = self;
	_mapView.showsUserLocation = YES;

	_activityIndicator.hidden = YES;
    _routeDetailsButton.hidden = YES;
    _routeDetailsButton.enabled = NO;

    // Do any additional setup after loading the view.

	MKUserLocation *userLocation = _mapView.userLocation;

	UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
	lpgr.minimumPressDuration = 2.0; //user needs to press for 2 seconds
	[_mapView addGestureRecognizer:lpgr];


	MKCoordinateRegion region =   MKCoordinateRegionMakeWithDistance(
    userLocation.location.coordinate,
    MilesToMeters(1.0f),
    MilesToMeters(1.0f)
	);

	[_mapView setRegion:region animated:YES];

	NSString *speech = @"Please enter the address of your destination or tap hold on the map to set a valet point. ";

	[self readText:speech];

}

float MilesToMeters(float miles) {
    return 1609.344f * miles;
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


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation
{
	if ([annotation isKindOfClass:[CustomPlacemark class]]) {
		MKPinAnnotationView *newAnnotation = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:[annotation title]];
		newAnnotation.pinColor = MKPinAnnotationColorGreen;
		newAnnotation.animatesDrop = YES; 
		newAnnotation.canShowCallout = YES;
		newAnnotation.enabled = YES;
		
		NSLog(@"Created annotation at: %f %f", ((CustomPlacemark*)annotation).coordinate.latitude, ((CustomPlacemark*)annotation).coordinate.longitude);
		
		[newAnnotation addObserver:self
						forKeyPath:@"selected"
						   options:NSKeyValueObservingOptionNew
						   context:@"GMAP_ANNOTATION_SELECTED"];
		
		return newAnnotation;
	}
	
	return nil;
}

- (void)forwardGeocoderConnectionDidFail:(BSForwardGeocoder *)geocoder withErrorMessage:(NSString *)errorMessage
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" 
													message:errorMessage
												   delegate:nil 
										  cancelButtonTitle:@"OK" 
										  otherButtonTitles: nil];
	[alert show];

}

- (void) forwardGeocodingDidFail:(BSForwardGeocoder *)geocoder withErrorCode:(int)errorCode andErrorMessage:(NSString *)errorMessage
{
    NSString *message = @"";
    
    switch (errorCode) {
        case G_GEO_BAD_KEY:
            message = @"The API key is invalid.";
            break;
            
        case G_GEO_UNKNOWN_ADDRESS:
            message = [NSString stringWithFormat:@"Could not find %@", @"searchQuery"];
            break;
            
        case G_GEO_TOO_MANY_QUERIES:
            message = @"Too many queries has been made for this API key.";
            break;
            
        case G_GEO_SERVER_ERROR:
            message = @"Server error, please try again.";
            break;
            
            
        default:
            break;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" 
                                                    message:message
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles: nil];
    [alert show];
}

- (void)forwardGeocodingDidSucceed:(BSForwardGeocoder *)geocoder withResults:(NSArray *)results
{
    // Add placemarks for each result
    for (int i = 0, resultCount = [results count]; i < resultCount; i++) {
        BSKmlResult *place = [results objectAtIndex:i];
        
        // Add a placemark on the map
        CustomPlacemark *placemark = [[CustomPlacemark alloc] initWithRegion:place.coordinateRegion] ;

		_location = [[CLLocation alloc] initWithLatitude:place.latitude longitude:place.longitude];

        placemark.title = place.address;
        placemark.subtitle = place.countryName;
        [self.mapView addAnnotation:placemark];	
    }
    
    if ([results count] == 1) {
        BSKmlResult *place = [results objectAtIndex:0];
        
        // Zoom into the location		
        [self.mapView setRegion:place.coordinateRegion animated:YES];
    }
    
    // Dismiss the keyboard
    [self.searchBar resignFirstResponder];
}

#pragma mark - UI Events
- (void)searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
	NSLog(@"Searching for: %@", self.searchBar.text);
	if (self.forwardGeocoder == nil) {
		self.forwardGeocoder = [[BSForwardGeocoder alloc] initWithDelegate:self] ;
	}
	
    // If you want to bias on coordinates pass a bounds object. This example is proof that the "Winnetka" example works (see https://developers.google.com/maps/documentation/geocoding/#Viewports)
	/*
	Traveling one mile provides the following changes in Degrees
	Change Lat: 50.75 seconds = 0.00140972 deg
	Change Lon: 78.09 seconds = 0.0216916 deg
	=======
	So to get a boundary 1 mile in diameter / square
	we will add the following to the current position and subtract the following from the current position
	*/

    CLLocationCoordinate2D southwest, northeast;
    southwest.latitude = 34.172684;
    southwest.longitude = -118.604794;
    northeast.latitude = 34.236144;
    northeast.longitude = -118.500938;
    BSForwardGeocoderCoordinateBounds *bounds = [BSForwardGeocoderCoordinateBounds boundsWithSouthWest:southwest northEast:northeast];

	// Forward geocode!
#if NS_BLOCKS_AVAILABLE
    [self.forwardGeocoder forwardGeocodeWithQuery:self.searchBar.text regionBiasing:nil viewportBiasing:bounds success:^(NSArray *results) {
        [self forwardGeocodingDidSucceed:self.forwardGeocoder withResults:results];
    } failure:^(int status, NSString *errorMessage) {
        if (status == G_GEO_NETWORK_ERROR) {
            [self forwardGeocoderConnectionDidFail:self.forwardGeocoder withErrorMessage:errorMessage];
        }
        else {
            [self forwardGeocodingDidFail:self.forwardGeocoder withErrorCode:status andErrorMessage:errorMessage];
        }
    }];
#else
    [self.forwardGeocoder forwardGeocodeWithQuery:self.searchBar.text regionBiasing:nil viewportBiasing:nil];
#endif
}

- (void)observeValueForKeyPath:(NSString *)keyPath  ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
	
	NSString *action = (__bridge NSString*)context;
	
	// We only want to zoom to location when the annotation is actaully selected. This will trigger also for when it's deselected
	if([[change valueForKey:@"new"] intValue] == 1 && [action isEqualToString:@"GMAP_ANNOTATION_SELECTED"])  {
		if ([((MKAnnotationView*) object).annotation isKindOfClass:[CustomPlacemark class]]) {
			CustomPlacemark *place = ((MKAnnotationView*) object).annotation;
			
			// Zoom into the location		
			[self.mapView setRegion:place.coordinateRegion animated:TRUE];
			NSLog(@"annotation selected: %f %f", ((MKAnnotationView*) object).annotation.coordinate.latitude, ((MKAnnotationView*) object).annotation.coordinate.longitude);
		}
	}
}

- (IBAction)handleRoutePressed:(id)sender {
    // We're working
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    self.routeButton.enabled = NO;
    self.routeDetailsButton.enabled = NO;
    
    // Make a directions request
    MKDirectionsRequest *directionsRequest = [MKDirectionsRequest new];
    // Start at our current location
    MKMapItem *source = [MKMapItem mapItemForCurrentLocation];
    [directionsRequest setSource:source];
    // Make the destination
    CLLocationCoordinate2D destinationCoords =     _location.coordinate ;
    MKPlacemark *destinationPlacemark = [[MKPlacemark alloc] initWithCoordinate:destinationCoords addressDictionary:nil];
    MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:destinationPlacemark];
    [directionsRequest setDestination:destination];
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        // We're done
        self.activityIndicator.hidden = YES;
        [self.activityIndicator stopAnimating];
        self.routeButton.enabled = YES;
        
        // Now handle the result
        if (error) {
            NSLog(@"There was an error getting your directions");
            return;
        }
        
        // So there wasn't an error - let's plot those routes
        self.routeDetailsButton.enabled = YES;
        self.routeDetailsButton.hidden = NO;
        _currentRoute = [response.routes firstObject];
        [self plotRouteOnMap:_currentRoute];
    }];
}

#pragma mark - Utility Methods
- (void)plotRouteOnMap:(MKRoute *)route
{
    if(_routeOverlay) {
        [self.mapView removeOverlay:_routeOverlay];
    }
    
    // Update the ivar
    _routeOverlay = route.polyline;
    
    // Add it to the map
    [self.mapView addOverlay:_routeOverlay];
    
}


#pragma mark - MKMapViewDelegate methods
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    renderer.strokeColor = [UIColor redColor];
    renderer.lineWidth = 4.0;
    return  renderer;
}

- (IBAction)changeMapType:(id)sender {
    if (_mapView.mapType == MKMapTypeStandard)
        _mapView.mapType = MKMapTypeSatellite;
    else
        _mapView.mapType = MKMapTypeStandard;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    _mapView.centerCoordinate = 
          userLocation.location.coordinate;
}




- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;

	CGPoint touchPoint = [gestureRecognizer locationInView:_mapView];
	CLLocationCoordinate2D touchMapCoordinate =
	[_mapView convertPoint:touchPoint toCoordinateFromView:_mapView];

	_myGeocoder = [[CLGeocoder alloc] init];
	_location = [[CLLocation alloc] initWithLatitude:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude];

  [_myGeocoder
	reverseGeocodeLocation:self.location
	completionHandler:^(NSArray *placemarks, NSError *error) {
     
     if (error == nil &&
         [placemarks count] > 0){
       
       CLPlacemark *placemark = [placemarks objectAtIndex:0];

       /* We received the results */
	   NSLog(@"ADDRESS: %@", placemark.addressDictionary);
       NSLog(@"Country = %@", placemark.country);
       NSLog(@"Postal Code = %@", placemark.postalCode);
       NSLog(@"Locality = %@", placemark.locality);

		NSDictionary *addressLocation = placemark.addressDictionary;
		NSMutableString *placeName = [addressLocation objectForKey:@"Name"];
		NSString *placeAddress = [addressLocation objectForKey:@"Street"];
		NSString *placeCity = [addressLocation objectForKey:@"Street"];
		NSString *placeState = [addressLocation objectForKey:@"State"];
		NSString *placePostal = [addressLocation objectForKey:@"PostCodeExtension"];

	NSString *result = [NSString stringWithFormat:@"%@ %@, %@ %@", placeAddress, placeCity, placeState, placePostal];

	if(placeName != nil){

	}else{
		placeName = [NSMutableString stringWithString:placeAddress];
	}

   		MyAnnotation *annotation =  [[MyAnnotation alloc]
                               initWithCoordinates:touchMapCoordinate
                               title:placeName
                               subTitle:result];
  
		[_mapView addAnnotation:annotation];

     }
     else if (error == nil &&
              [placemarks count] == 0){
       NSLog(@"No results were returned.");
     }
     else if (error != nil){
       NSLog(@"An error occurred = %@", error);
     }
     
   }];
}

@end
