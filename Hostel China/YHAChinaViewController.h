//
//  YHAChinaViewController.h
//  Hostel China
//
//  Created by Jinglong Bi on 12-2-21.
//  Copyright (c) 2012年 ZZULI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppNavigationController.h"

#define kRegionComponent 0
#define kProvinceComponent 1
#define kCityComponent 2
#define kDefaultSelectedRegionRow 2

@interface YHAChinaViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) NSString *selectCity;

@end
