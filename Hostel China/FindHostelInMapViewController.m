//
//  FindHostelInMapViewController.m
//  Hostel China
//
//  Created by Jinglong Bi on 12-3-12.
//  Copyright (c) 2012年 ZZULI. All rights reserved.
//

#import "FindHostelInMapViewController.h"

@implementation FindHostelInMapViewController
@synthesize findHostelInMapMapView = _findHostelInMapMapView;
@synthesize myLocation = _myLocation;

@synthesize hostelAddr = _hostelAddr;
@synthesize hostelName = _hostelName;
@synthesize hostelLatitude = _hostelLatitude;
@synthesize hostelLongtitude = _hostelLongtitude;

@synthesize locationManager = _locationManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    //init the hostel's Annotation
    NSDictionary *hostelInfoDict = [NSDictionary dictionaryWithObjectsAndKeys:self.hostelName, @"hostelName",
                                    self.hostelAddr, @"hostelSubtitle",
                                    self.hostelLatitude, @"hostelLatitude",
                                    self.hostelLongtitude, @"hostelLongtitude",
                                    nil];
    [self.findHostelInMapMapView addAnnotation:[CityHostelAnnotation annotationForOneHostel:hostelInfoDict]];
}

- (void)tryToStartLocationService
{
    //init the location manager
    if ([CLLocationManager locationServicesEnabled])
    {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        self.locationManager.distanceFilter = 100.0f;
        self.locationManager.headingFilter = 5;
        self.locationManager.purpose = @"Hostel China app will get you location and then navigate you to your favourite hostel.";
        [self.locationManager startUpdatingLocation];
        [self.locationManager startUpdatingHeading];
    }
}

- (void)makeMapViewContainMyLocationAndHostelLocation
{
    //calculate the center coordinate of the mapview
    CLLocationCoordinate2D mapCenterCoordinate;
    mapCenterCoordinate.latitude = ([self.hostelLatitude doubleValue] + self.myLocation.coordinate.latitude) / 2;
    mapCenterCoordinate.longitude = ([self.hostelLongtitude doubleValue] + self.myLocation.coordinate.longitude) / 2;
   
    CLLocationCoordinate2D compareCoordinateValue;
    compareCoordinateValue.latitude = fabs([self.hostelLatitude doubleValue] - self.myLocation.coordinate.latitude);
    compareCoordinateValue.longitude = fabs([self.hostelLongtitude doubleValue] - self.myLocation.coordinate.longitude);
    double span = compareCoordinateValue.latitude > compareCoordinateValue.longitude ? compareCoordinateValue.latitude * 2 : compareCoordinateValue.longitude * 2;
    //set the mapView's span
    MKCoordinateSpan mapViewSpan = MKCoordinateSpanMake(span, span); 
    //check whether the custom span is avaliable
    if (span > kMaxMapViewSpan) {
        mapViewSpan = MKCoordinateSpanMake(kMaxMapViewSpan, kMaxMapViewSpan);  //When the span is beyond the max value,we set it to the max value 
        mapCenterCoordinate.latitude = [self.hostelLatitude doubleValue];
        mapCenterCoordinate.longitude = [self.hostelLongtitude doubleValue];
    }
    if (span < kMinMapViewSpan) {
        mapViewSpan = MKCoordinateSpanMake(kMinMapViewSpan, kMinMapViewSpan);
    }
    
    //calculate the mapViewRegion
    MKCoordinateRegion mapViewRegion = MKCoordinateRegionMake(mapCenterCoordinate, mapViewSpan);
    //navigate the mapview
    [self.findHostelInMapMapView setRegion:mapViewRegion animated:YES];
}

- (void)locationManager:(CLLocationManager *)manager 
    didUpdateToLocation:(CLLocation *)newLocation 
           fromLocation:(CLLocation *)oldLocation {
    
    if([newLocation horizontalAccuracy] < 0.0f) return;
    if(fabs([[newLocation timestamp] timeIntervalSinceNow]) > 5) return;

    self.myLocation = newLocation;
    //calculate the distance from myLocation the hostel.Then set the distance to the title
    CLLocationDistance distance = [self.myLocation distanceFromLocation:[[CLLocation alloc] initWithLatitude:[self.hostelLatitude doubleValue] longitude:[self.hostelLongtitude doubleValue]]];
    if (distance >= 1000) {
        self.title = [NSString stringWithFormat:NSLocalizedString(@"%f km away~", "FindHostelMapView title KM one"), distance/1000];
    }
    else
        self.title = [NSString stringWithFormat:NSLocalizedString(@"%f m away~", "FindHostelMapView title m one"), distance];
    [self makeMapViewContainMyLocationAndHostelLocation];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self tryToStartLocationService];
    //calculate the center coordinate of the mapview
    CLLocationCoordinate2D mapCenterCoordinate;
    mapCenterCoordinate.latitude = [self.hostelLatitude doubleValue];
    mapCenterCoordinate.longitude = [self.hostelLongtitude doubleValue];
    
    //set the mapView's span
    MKCoordinateSpan mapViewSpan = MKCoordinateSpanMake(kDefatultMapViewSpan, kDefatultMapViewSpan); 
    
    //calculate the mapViewRegion
    MKCoordinateRegion mapViewRegion = MKCoordinateRegionMake(mapCenterCoordinate, mapViewSpan);
    //navigate the mapview
    [self.findHostelInMapMapView setRegion:mapViewRegion animated:YES];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.locationManager stopUpdatingLocation];
    [self.locationManager stopUpdatingHeading];
}

- (void)viewDidUnload
{
    [self setFindHostelInMapMapView:nil];
    self.locationManager = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    // if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    // handle our custom annotation
    else
    {
        MKPinAnnotationView *aView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"MapVC"];
        if (!aView) {
            aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MapVC"];
            aView.canShowCallout = YES;
            aView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        }
        aView.annotation = annotation;
        return aView;
    }
}


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)aView
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Annotation_Image" ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    [(UIImageView *)aView.leftCalloutAccessoryView setImage:image];
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    //pop up callout of annotation programlly
    [self.findHostelInMapMapView selectAnnotation:[self.findHostelInMapMapView.annotations objectAtIndex:0] animated:YES];
}
@end
