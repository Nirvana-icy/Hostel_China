//
//  CityHostelAnnotation.h
//  Hostel China
//
//  Created by Jinglong Bi on 12-3-4.
//  Copyright (c) 2012年 ZZULI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CityHostelAnnotation : NSObject <MKAnnotation>

+ (CityHostelAnnotation *) annotationForOneHostel:(NSDictionary *)hostel;

@property (nonatomic, strong) NSDictionary *hostel;
@end
