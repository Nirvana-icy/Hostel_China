//
//  FavouriteHostelTableViewController.m
//  Hostel China
//
//  Created by Jinglong Bi on 12-3-10.
//  Copyright (c) 2012年 ZZULI. All rights reserved.
//

#import "FavouriteHostelTableViewController.h"
#import "FavouriteHostelDetailViewController.h"

static sqlite3_stmt *favouriteHostelStmt = nil;

@implementation FavouriteHostelTableViewController
@synthesize selectIndex = _selectIndex;
@synthesize favouriteHostelArray = _favouriteHostelArray;
@synthesize provinceArray = _provinceArray;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSString * sqlString = @"select distinct HostelProvince from tableFavouriteHostels";
    
    db = [AppNavigationController getDB];
    self.provinceArray = [[NSMutableArray alloc] initWithCapacity:24];
    sqlite3_prepare_v2(db, [sqlString UTF8String], -1, &favouriteHostelStmt, nil);
    
    while (sqlite3_step(favouriteHostelStmt) == SQLITE_ROW) {
        NSString *tempString = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(favouriteHostelStmt, 0) encoding:NSUTF8StringEncoding];
        [self.provinceArray addObject:tempString];
    } 
    sqlite3_reset(favouriteHostelStmt);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    // 释放资源  
    sqlite3_finalize(favouriteHostelStmt);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.provinceArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    int count = 0;
    NSString *provinceName = [self.provinceArray objectAtIndex:section];
    NSString * sqlString = [NSString stringWithFormat: @"select HostelName from tableFavouriteHostels where HostelProvince = '%@'", provinceName];
    
    db = [AppNavigationController getDB];
    sqlite3_prepare_v2(db, [sqlString UTF8String], -1, &favouriteHostelStmt, nil);
    while (sqlite3_step(favouriteHostelStmt) == SQLITE_ROW) {
        count++;
    }
    sqlite3_reset(favouriteHostelStmt);
    return count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.provinceArray objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FavouriteHostelTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSString *provinceName = [self.provinceArray objectAtIndex:[indexPath section]];
    NSString * sqlString = [NSString stringWithFormat:@"select HostelName from tableFavouriteHostels where HostelProvince = '%@'", provinceName];
    self.favouriteHostelArray = [[NSMutableArray alloc] initWithCapacity:32];
    db = [AppNavigationController getDB];
    sqlite3_prepare_v2(db, [sqlString UTF8String], -1, &favouriteHostelStmt, nil);
    
    while (sqlite3_step(favouriteHostelStmt) == SQLITE_ROW) {
        NSString *tempString = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(favouriteHostelStmt, 0) encoding:NSUTF8StringEncoding];
        [self.favouriteHostelArray addObject:tempString];
    } 
    sqlite3_reset(favouriteHostelStmt);
    
    // Configure the cell...
    cell.textLabel.text = [self.favouriteHostelArray objectAtIndex:[indexPath row]]; 
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)deleteSelectedHostelInDB:(NSIndexPath *)indexPath
{
    //Find out the selected hostel's name from db
    NSString *provinceName = [self.provinceArray objectAtIndex:[indexPath section]];
    NSString * sqlString = [NSString stringWithFormat:@"select HostelName from tableFavouriteHostels where HostelProvince = '%@'", provinceName];
    self.favouriteHostelArray = [[NSMutableArray alloc] initWithCapacity:32];
    db = [AppNavigationController getDB];
    sqlite3_prepare_v2(db, [sqlString UTF8String], -1, &favouriteHostelStmt, nil);
    
    while (sqlite3_step(favouriteHostelStmt) == SQLITE_ROW) {
        NSString *tempString = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(favouriteHostelStmt, 0) encoding:NSUTF8StringEncoding];
        [self.favouriteHostelArray addObject:tempString];
    } 
    sqlite3_reset(favouriteHostelStmt);
    
    NSString *selectHostelName = [self.favouriteHostelArray objectAtIndex:[indexPath row]]; 
    //delete the selected hostel from db
    sqlString = [NSString stringWithFormat:@"delete from tableFavouriteHostels where HostelName = '%@'", selectHostelName];
    char *errorMsg;
    sqlite3_exec(db,[sqlString UTF8String],0,0,&errorMsg);
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self deleteSelectedHostelInDB:indexPath];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    /*
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
    */
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:self.selectIndex];
    [segue.destinationViewController setHostelName:cell.textLabel.text];    
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    self.selectIndex = indexPath;
    [self performSegueWithIdentifier:@"SeguePushToFavouriteHostelDetailInfoView" sender:self];
}


@end
