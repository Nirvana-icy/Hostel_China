//
//  CityHostelAnnotation.m
//  Hostel China
//
//  Created by Jinglong Bi on 12-3-4.
//  Copyright (c) 2012年 ZZULI. All rights reserved.
//

#import "CityHostelAnnotation.h"

@implementation CityHostelAnnotation
@synthesize hostel = _hostel;

+ (CityHostelAnnotation *) annotationForOneHostel:(NSDictionary *)hostel
{
    CityHostelAnnotation *annotation = [[CityHostelAnnotation alloc] init];
    annotation.hostel = hostel;
    return annotation;
}

- (NSString *)title
{
    return [self.hostel objectForKey:@"hostelName"];
}

- (NSString *)subtitle
{
    NSString *subtitle = [self.hostel objectForKey:@"hostelSubtitle"];
    return subtitle;
}

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [[self.hostel objectForKey:@"hostelLatitude"] doubleValue];
    coordinate.longitude = [[self.hostel objectForKey:@"hostelLongtitude"] doubleValue];
    return coordinate;
}
@end
