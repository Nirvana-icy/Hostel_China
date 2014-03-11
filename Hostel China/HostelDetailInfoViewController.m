//
//  HostelDetailInfoViewController.m
//  Hostel China
//
//  Created by Jinglong Bi on 12-3-8.
//  Copyright (c) 2012年 ZZULI. All rights reserved.
//

#import "HostelDetailInfoViewController.h"

@implementation HostelDetailInfoViewController

@synthesize hostelNameLabel = _hostelNameLabel;
@synthesize hostelPriceLabel = _hostelPriceLabel;
@synthesize hostelTelLabel = _hostelTelLabel;
@synthesize hostelAddrLabel = _hostelAddrLabel;

@synthesize selectHostel = _selectHostel;
@synthesize selectCity = _selectCity;
@synthesize hostelURL = _hostelURL;

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
    
    self.hostelNameLabel.text = self.selectHostel;
    
    sqlite3_stmt *detialInfoStmt = nil;
    NSString * sqlString = [NSString stringWithFormat:@"select HostelPriceRange, HostelTel, HostelURL, HostelAddr from tableChinaHostels where HostelName = '%@'", self.selectHostel];
    
    db = [AppNavigationController getDB];
    sqlite3_prepare_v2(db, [sqlString UTF8String], -1, &detialInfoStmt, nil);
    
    while (sqlite3_step(detialInfoStmt) == SQLITE_ROW) {
        
        NSString *priceRange = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(detialInfoStmt, 0) encoding:NSUTF8StringEncoding];
        self.hostelPriceLabel.text = [NSString stringWithFormat:@"¥: %@", priceRange];
        self.hostelTelLabel.text = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(detialInfoStmt, 1) encoding:NSUTF8StringEncoding];
        self.hostelURL = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(detialInfoStmt, 2) encoding:NSUTF8StringEncoding];
        self.hostelAddrLabel.text = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(detialInfoStmt, 3) encoding:NSUTF8StringEncoding]; 

    } 
    // 释放资源  
    sqlite3_finalize(detialInfoStmt);
}


- (void)viewDidUnload
{
    [self setHostelPriceLabel:nil];
    [self setHostelAddrLabel:nil];
    [self setHostelTelLabel:nil];
    [self setHostelNameLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)btnVisitInWebsitePressed {
    //Call Safari to open the select hostel's URL
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.hostelURL]];
}

- (IBAction)btnCallPressed {
    //adjust the Phone NO. to the useable NSURL string
    NSString *cleanedString = [[self.hostelTelLabel.text componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
    NSString *escapedPhoneNumber = [cleanedString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", escapedPhoneNumber]];
    //call phone app to make this call
    [[UIApplication sharedApplication] openURL:telURL];
}

- (IBAction)btnAddToFavouritePressed {
    //check does this select hostel has been in the db's table
    sqlite3_stmt *favouriteStmt = nil;
    NSString * sqlCheck = [NSString stringWithFormat:@"select * from tableFavouriteHostels where HostelName = '%@'", self.selectHostel];
    
    db = [AppNavigationController getDB];
    sqlite3_prepare_v2(db, [sqlCheck UTF8String], -1, &favouriteStmt, nil);
    
    if (sqlite3_step(favouriteStmt) != SQLITE_ROW) 
    {
        sqlite3_reset(favouriteStmt);
        NSString *provinceName;
        //the select hostel do not in the db's table,so we insert this hostel to the db's table.
        //Now first we get the hostel's province info
        NSString * sqlQuery = [NSString stringWithFormat:@"select ProvinceName from tableCityProvinceRegion where CityName = '%@'", self.selectCity];
        sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &favouriteStmt, nil);
        if (sqlite3_step(favouriteStmt) == SQLITE_ROW) {
            provinceName = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(favouriteStmt, 0) encoding:NSUTF8StringEncoding];
            sqlite3_reset(favouriteStmt);
            NSString *sqlInsert = [NSString stringWithFormat:@"insert into tableFavouriteHostels values('%@', '%@')", self.selectHostel, provinceName];
            
            char *errorMsg;
            if (sqlite3_exec(db, [sqlInsert UTF8String], NULL, NULL, &errorMsg) == SQLITE_OK) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Success.", "Add to favourite successfully alert title") message:NSLocalizedString(@"Added Successfully.", "Add to favourite successfully alert msg") delegate:nil cancelButtonTitle:NSLocalizedString(@"Okay", "Okay button") otherButtonTitles:nil];
                [alert show];
            }
        }
    } 
    else 
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Oops.", "Add to favourite fail alert title") message:NSLocalizedString(@"You have add this hostel to the favourite hostels before.", "Add to favourite fail alert msg") delegate:nil cancelButtonTitle:NSLocalizedString(@"Okay", "Okay button") otherButtonTitles:nil];
        [alert show];
    }
    // 释放资源  
    sqlite3_finalize(favouriteStmt);
}

@end
