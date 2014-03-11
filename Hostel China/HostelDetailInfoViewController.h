//
//  HostelDetailInfoViewController.h
//  Hostel China
//
//  Created by Jinglong Bi on 12-3-8.
//  Copyright (c) 2012年 ZZULI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppNavigationController.h"

@interface HostelDetailInfoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *hostelNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *hostelPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *hostelTelLabel;
@property (weak, nonatomic) IBOutlet UILabel *hostelAddrLabel;

@property (nonatomic, strong) NSString *selectHostel;
@property (nonatomic, strong) NSString *selectCity;
@property (nonatomic, strong) NSString *hostelURL;

@end
