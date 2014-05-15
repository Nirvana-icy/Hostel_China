//
//  SelectCityHostelsMapViewController.h
//  Hostel China
//
//  Created by Jinglong Bi on 12-3-8.
//  Copyright (c) 2012年 ZZULI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "AppNavigationController.h"
#import "CityHostelAnnotation.h"

static sqlite3_stmt *hostelStmt = nil;

#define kDefatultMapViewSpan 0.55

@interface SelectCityHostelsMapViewController : UIViewController<MKMapViewDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) NSString *selectCity;
@property (nonatomic, strong) NSString *selectHostel;
@property (nonatomic, strong) NSMutableArray *annotations; //of id<MKAnnotation>

@end
