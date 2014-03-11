//
//  YHAChinaViewController.m
//  Hostel China
//
//  Created by Jinglong Bi on 12-2-21.
//  Copyright (c) 2012年 ZZULI. All rights reserved.
//

#import "YHAChinaViewController.h"


static sqlite3_stmt *statement = nil;

@interface YHAChinaViewController()
@property (nonatomic, weak) IBOutlet UIPickerView *regionProvinceCityPicker;

@property (nonatomic, strong) NSDictionary *regionProvinces;
@property (nonatomic, strong) NSDictionary *provinceCities;

@property (nonatomic, strong) NSMutableArray *regions;
@property (nonatomic, strong) NSMutableArray *provinces;
@property (nonatomic, strong) NSMutableArray *cities;

@end

@implementation YHAChinaViewController
@synthesize regionProvinceCityPicker = _regionProvinceCityPicker;

@synthesize regionProvinces = _regionProvinces;
@synthesize provinceCities = _provinceCites;

@synthesize regions = _regions;
@synthesize provinces = _provinces;
@synthesize cities = _cities;

@synthesize selectCity = _selectCity;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    
    //init array self.regions 
    const char *selectSql = "select distinct RegionName from tableCityProvinceRegion"; 
    db = [AppNavigationController getDB];
    sqlite3_prepare_v2(db, selectSql, -1, &statement, nil);
        
    self.regions = [[NSMutableArray alloc] initWithCapacity:10];
    while (sqlite3_step(statement) == SQLITE_ROW) {
        NSString *regionName=[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding];
        [self.regions addObject:regionName];
    } 
    //reset the statement for next use
    sqlite3_reset(statement);
}

- (void)viewDidUnload
{
    // 释放资源  
    sqlite3_finalize(statement);  
    // e.g. self.myOutlet = nil;
    self.regionProvinceCityPicker = nil;
    // Release any retained subviews of the main view.
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //set the default region as the kDefaultSelectedRegionRow one in the region component
    [self.regionProvinceCityPicker selectRow:kDefaultSelectedRegionRow inComponent:kRegionComponent animated:YES];
    [self pickerView:self.regionProvinceCityPicker didSelectRow:kDefaultSelectedRegionRow inComponent:kRegionComponent];
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
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Picker Data Source Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger retValue = 0;
    if (kRegionComponent == component) {
        retValue = [self.regions count];
    }
    if (kProvinceComponent == component) {
        retValue = [self.provinces count];
    }
    if (kCityComponent == component) {
        retValue = [self.cities count];
    }
    return retValue;
}

#pragma make - Picker Delegate Methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger) row forComponent:(NSInteger)component
{
    switch (component) {
        case kRegionComponent:
            return [self.regions objectAtIndex:row];
        case kProvinceComponent:
            return [self.provinces objectAtIndex:row];
        default:
            return [self.cities objectAtIndex:row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (kRegionComponent == component) {
        //Get the select region in the region component
        NSString *selectRegion = [self.regions objectAtIndex:row];
        //init array self.province to prepare the data of the releated component                 
        NSString *sqlString = [NSString stringWithFormat:@"select distinct ProvinceName from tableCityProvinceRegion where RegionName = '%@'", selectRegion];
        
        sqlite3_prepare_v2(db, [sqlString UTF8String], -1, &statement, nil);
        
        self.provinces = [[NSMutableArray alloc] initWithCapacity:10];
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSString *provinceName=[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding];
            [self.provinces addObject:provinceName];
        } 
        //reset the statement
        sqlite3_reset(statement);  
        //reload the releated component
        [self.regionProvinceCityPicker reloadComponent:kProvinceComponent];
        //set the default selected row of the releated component(province component) and do the action of select this row by program to init the next component(city component)
        if ([self.provinces count] >= 5) {
            [self.regionProvinceCityPicker selectRow:2 inComponent:kProvinceComponent animated:YES];
            [self pickerView:self.regionProvinceCityPicker didSelectRow:2 inComponent:kProvinceComponent];
        }
        else
        {
            [self.regionProvinceCityPicker selectRow:0 inComponent:kProvinceComponent animated:YES];
            [self pickerView:self.regionProvinceCityPicker didSelectRow:0 inComponent:kProvinceComponent];
        }
    }
    if (kProvinceComponent == component) {
        //Get the select province in the province component
        NSString *selectProvince = [self.provinces objectAtIndex:row];
        //init array self.cites to prepare the data of the releated component from db
        NSString *sqlString = [NSString stringWithFormat:@"select distinct CityName from tableCityProvinceRegion where ProvinceName = '%@'", selectProvince];
        
        sqlite3_prepare_v2(db, [sqlString UTF8String], -1, &statement, nil);
        
        self.cities = [[NSMutableArray alloc] initWithCapacity:12];
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSString *cityName=[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding];
            [self.cities addObject:cityName];
        } 
        //reset the statement
        sqlite3_reset(statement);  
        //reload the releated component
        [self.regionProvinceCityPicker reloadComponent:kCityComponent];
        //set the default selected city in the releated component(city component)
        if ([self.cities count] >= 5) {
            [self.regionProvinceCityPicker selectRow:2 inComponent:kCityComponent animated:YES];
        }
        else
        {
            [self.regionProvinceCityPicker selectRow:0 inComponent:kCityComponent animated:YES];
        }
        
    }
}

//custom the componets's width
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    switch (component) {
        case kRegionComponent:
            return 100;
            break;
        case kProvinceComponent:
            return 90;
            break;            
        default:
            return 100;
    }
}

#pragma make - button pressed action 

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PushToSelectCityHostelsMapView"]) {
        [segue.destinationViewController setSelectCity:self.selectCity];
    }
}

- (IBAction)checkButtonPressed {
    NSInteger cityIndex = [self.regionProvinceCityPicker selectedRowInComponent:kCityComponent];
    self.selectCity = [self.cities objectAtIndex:cityIndex];
}


@end