//
//  FavouriteHostelDetailViewController.h
//  Hostel China
//
//  Created by Jinglong Bi on 12-3-10.
//  Copyright (c) 2012年 ZZULI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppNavigationController.h"

@interface FavouriteHostelDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *hostelNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *hostelPriceRangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *hostelTelLabel;
@property (weak, nonatomic) IBOutlet UILabel *hostelAddrLabel;
@property (weak, nonatomic) IBOutlet UITextView *hostelWayTextView;

@property (nonatomic, strong) NSString *hostelName;
@property (nonatomic, strong) NSString *hostelLatitude;
@property (nonatomic, strong) NSString *hostelLongtitude;
@property (nonatomic, strong) NSString *hostelTel;
@property (nonatomic, strong) NSString *hostelURL;

@end
