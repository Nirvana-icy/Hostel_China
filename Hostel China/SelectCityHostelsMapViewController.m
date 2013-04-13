//
//  SelectCityHostelsMapViewController.m
//  Hostel China
//
//  Created by Jinglong Bi on 12-3-8.
//  Copyright (c) 2012年 ZZULI. All rights reserved.
//

#import "SelectCityHostelsMapViewController.h"

@interface SelectCityHostelsMapViewController() 
@property (weak, nonatomic) IBOutlet MKMapView *cityHostelMapView;
@end

@implementation SelectCityHostelsMapViewController
@synthesize selectCity = _selectCity;
@synthesize selectHostel = _selectHostel;
@synthesize cityHostelMapView = _cityHostelMapView;
@synthesize annotations = _annotations;


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

- (void)getCityHostelInfoAndInitMapAnnotationsArray
{
    NSString * sqlString = [NSString stringWithFormat:@"select HostelName, HostelPriceRange, HostelLatitude, HostelLongtitude from tableChinaHostels where HostelCity = '%@'", self.selectCity];
    
    db = [AppNavigationController getDB];
    sqlite3_prepare_v2(db, [sqlString UTF8String], -1, &hostelStmt, nil);
    
    self.annotations = [[NSMutableArray alloc] initWithCapacity:18];
    while (sqlite3_step(hostelStmt) == SQLITE_ROW) {
        NSString *hostelName = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(hostelStmt, 0) encoding:NSUTF8StringEncoding];
        
        NSString *hostelPriceRange = [NSString stringWithFormat:@" ¥: %@", [[NSString alloc] initWithCString:(char *)sqlite3_column_text(hostelStmt, 1) encoding:NSUTF8StringEncoding]];
        
        NSString *hostelLatitude = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(hostelStmt, 2) encoding:NSUTF8StringEncoding];
        
        NSString *hostelLongtitude = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(hostelStmt, 3) encoding:NSUTF8StringEncoding];
        NSDictionary *hostelInfoDict = [NSDictionary dictionaryWithObjectsAndKeys:hostelName, @"hostelName",
                                        hostelPriceRange, @"hostelSubtitle",
                                        hostelLatitude, @"hostelLatitude",
                                        hostelLongtitude, @"hostelLongtitude",
                                        nil];
        [self.annotations addObject:[CityHostelAnnotation annotationForOneHostel:hostelInfoDict]];
    } 
    // 释放资源  
    sqlite3_finalize(hostelStmt);
    
    if ([self.cityHostelMapView.annotations count] != 0) {
        [self.cityHostelMapView removeAnnotations:self.cityHostelMapView.annotations];
    }
    [self.cityHostelMapView addAnnotations:self.annotations];
}

- (void)navigateMapViewToTheSelectCity
{

    //calculate the center coordinate of all the hostels in this city 
    CLLocationCoordinate2D mapCenterCoordinate;
    mapCenterCoordinate.latitude = 0.0;
    mapCenterCoordinate.longitude = 0.0;
    id<MKAnnotation> tempAnnotation = nil;
    
    for (tempAnnotation in self.annotations)
    {
        mapCenterCoordinate.latitude += [tempAnnotation coordinate].latitude;
        mapCenterCoordinate.longitude += [tempAnnotation coordinate].longitude;
    }
    
    mapCenterCoordinate.latitude = mapCenterCoordinate.latitude / [self.annotations count];
    mapCenterCoordinate.longitude = mapCenterCoordinate.longitude / [self.annotations count];
    //set the mapView's span
    MKCoordinateSpan mapViewSpan = MKCoordinateSpanMake(kDefatultMapViewSpan, kDefatultMapViewSpan);
    
    MKCoordinateRegion mapViewRegion = MKCoordinateRegionMake(mapCenterCoordinate, mapViewSpan);
    //navigation the map view to the select city
    [self.cityHostelMapView setRegion:mapViewRegion animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getCityHostelInfoAndInitMapAnnotationsArray];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self.annotations count] != 0) {
        self.title = self.selectCity;
        [self navigateMapViewToTheSelectCity];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if ([self.annotations count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Sorry.", "Do not find hostel alert title") message:NSLocalizedString(@"Oops.No Hostel avaliable in the select city right now.", "Do not find hostel alert msg") delegate:self cancelButtonTitle:NSLocalizedString(@"Okay", "Okay button") otherButtonTitles:nil];
        [alert show];
    }
}

-(void)alertView:(UIAlertView *)alertView  clickedButtonAtIndex:(int)index
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [self setCityHostelMapView:nil];
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
    MKPinAnnotationView *aView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"MapVC"];
    if (!aView) {
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MapVC"];
        aView.animatesDrop = YES;
        aView.canShowCallout = YES;
        aView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        // could put a rightCalloutAccessoryView here
        aView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    
    aView.annotation = annotation;
    
    return aView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)aView
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Annotation_Image" ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    [(UIImageView *)aView.leftCalloutAccessoryView setImage:image];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SeguePushToHostelDetialInfoView"]) {
        [segue.destinationViewController setSelectHostel:self.selectHostel];
        [segue.destinationViewController setSelectCity:self.selectCity];
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    self.selectHostel = [view.annotation title];
    [self performSegueWithIdentifier:@"SeguePushToHostelDetialInfoView" sender:self];
}

@end
