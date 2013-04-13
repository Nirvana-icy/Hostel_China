//
//  FavouriteHostelTableViewController.h
//  Hostel China
//
//  Created by Jinglong Bi on 12-3-10.
//  Copyright (c) 2012年 ZZULI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppNavigationController.h"

@interface FavouriteHostelTableViewController : UITableViewController
@property (nonatomic, strong) NSIndexPath *selectIndex;
@property (nonatomic, strong) NSMutableArray *favouriteHostelArray;
@property (nonatomic, strong) NSMutableArray *provinceArray;
@end
