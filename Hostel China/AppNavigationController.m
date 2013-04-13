//
//  AppNavigationController.m
//  Hostel China
//
//  Created by Jinglong Bi on 12-3-3.
//  Copyright (c) 2012年 ZZULI. All rights reserved.
//

#import "AppNavigationController.h"

@implementation AppNavigationController

+ (sqlite3 *)getDB
{
    return db;
}

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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    //Copy db from read only app bundle to dir documents
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *dirToCopyTo = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/HostelChina.db"];
    if(NO == [manager fileExistsAtPath:dirToCopyTo])
    {
        //Get the HostelChina.db's path in the app's bundle
        NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"HostelChina" ofType:@"db"];
        NSError*error;
        [manager copyItemAtPath:dbPath toPath:dirToCopyTo error:&error];
        
    }
    //init the picker's region data from HostelChina.db via sqlite3
    //Open db
    if(sqlite3_open([dirToCopyTo UTF8String], &db) != SQLITE_OK)
    {
        sqlite3_close(db);
        NSAssert(0, @"Open db failed");
    }
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    // 关闭Sqlite3数据库  
    sqlite3_close(db);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
