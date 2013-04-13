//
//  AppNavigationController.h
//  Hostel China
//
//  Created by Jinglong Bi on 12-3-3.
//  Copyright (c) 2012年 ZZULI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
static sqlite3 *db = nil;

@interface AppNavigationController : UINavigationController

+ (sqlite3 *)getDB;

@end

