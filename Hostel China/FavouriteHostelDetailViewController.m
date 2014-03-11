//
//  FavouriteHostelDetailViewController.m
//  Hostel China
//
//  Created by Jinglong Bi on 12-3-10.
//  Copyright (c) 2012年 ZZULI. All rights reserved.
//

#import "FavouriteHostelDetailViewController.h"
#import "FindHostelInMapViewController.h"

@implementation FavouriteHostelDetailViewController

@synthesize hostelNameLabel = _hostelNameLabel;
@synthesize hostelPriceRangeLabel = _hostelPriceRangeLabel;
@synthesize hostelTelLabel = _hostelTelLabel;
@synthesize hostelAddrLabel = _hostelAddrLabel;
@synthesize hostelWayTextView = _hostelWayTextView;

@synthesize hostelName = _hostelName;
@synthesize hostelLatitude = _hostelLatitude;
@synthesize hostelLongtitude = _hostelLongtitude;
@synthesize hostelTel = _hostelTel;
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
    self.hostelNameLabel.text = self.hostelName;
    
    sqlite3_stmt *detialInfoStmt = nil;
    NSString * sqlString = [NSString stringWithFormat:@"select HostelLatitude, HostelLongtitude, HostelPriceRange, HostelTel,HostelUrl, HostelAddr, HostelWay from tableChinaHostels where HostelName = '%@'", self.hostelName];
    
    db = [AppNavigationController getDB];
    sqlite3_prepare_v2(db, [sqlString UTF8String], -1, &detialInfoStmt, nil);
    
    if (sqlite3_step(detialInfoStmt) == SQLITE_ROW) {
        
        self.hostelLatitude = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(detialInfoStmt, 0) encoding:NSUTF8StringEncoding];
        self.hostelLongtitude = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(detialInfoStmt, 1) encoding:NSUTF8StringEncoding];  
        self.hostelPriceRangeLabel.text = [NSString stringWithFormat:@"¥: %@", [[NSString alloc] initWithCString:(char *)sqlite3_column_text(detialInfoStmt, 2) encoding:NSUTF8StringEncoding]];
        self.hostelTelLabel.text = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(detialInfoStmt, 3) encoding:NSUTF8StringEncoding];
        self.hostelURL = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(detialInfoStmt, 4) encoding:NSUTF8StringEncoding];
        self.hostelAddrLabel.text = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(detialInfoStmt, 5) encoding:NSUTF8StringEncoding];
        self.hostelWayTextView.text = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(detialInfoStmt, 6) encoding:NSUTF8StringEncoding];
    } 
    // 释放资源  
    sqlite3_finalize(detialInfoStmt);
}


- (void)viewDidUnload
{
    [self setHostelNameLabel:nil];
    [self setHostelPriceRangeLabel:nil];
    [self setHostelTelLabel:nil];
    [self setHostelAddrLabel:nil];
    [self setHostelWayTextView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (IBAction)btnMakeCallPressed {
    //adjust the Phone NO. to the useable NSURL string
    NSString *cleanedString = [[self.hostelTel componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
    NSString *escapedPhoneNumber = [cleanedString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", escapedPhoneNumber]];
    //call phone app to make this call
    [[UIApplication sharedApplication] openURL:telURL];
}

- (IBAction)btnVisitBySafariPressed {
    //Call Safari to open the select hostel's URL
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.hostelURL]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [segue.destinationViewController setHostelName:self.hostelName];
    [segue.destinationViewController setHostelLatitude:self.hostelLatitude];
    [segue.destinationViewController setHostelLongtitude:self.hostelLongtitude];
    [segue.destinationViewController setHostelAddr:self.hostelAddrLabel.text];
}

@end
