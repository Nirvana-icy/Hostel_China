//
//  FindHostelInMapViewController.h
//  Hostel China
//
//  Created by Jinglong Bi on 12-3-12.
//  Copyright (c) 2012年 ZZULI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CityHostelAnnotation.h"
#import <CoreLocation/CoreLocation.h>
#import <math.h>

#define kDefatultMapViewSpan 0.55
#define kMinMapViewSpan 0.006
#define kMaxMapViewSpan 65

@interface FindHostelInMapViewController : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *findHostelInMapMapView;

@property (nonatomic, strong) NSString *hostelName;
@property (nonatomic, strong) NSString *hostelAddr;
@property (nonatomic, strong) NSString *hostelLatitude;
@property (nonatomic, strong) NSString *hostelLongtitude;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *myLocation;
@end
