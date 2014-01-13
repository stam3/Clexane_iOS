//
//  TodayViewController.m
//  Clexane
//
//  Created by David Sayag on 10/24/13.
//  Copyright (c) 2013 David Sayag. All rights reserved.
//

#import "TodayViewController.h"
#import "AppDelegate.h"
#import "MainViewController.h"
#import "MedicineEntity.h"
#import "MedDatePair.h"
#import "PicklineEntity.h"
#import "SIAlertView.h"

#import "NSDate-Utilities.h"


@interface TodayViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextView *tomorrowTextView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *houreTextView;
@property (weak, nonatomic) IBOutlet UITextView *tomorrowHoursTextView;
//@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITableView *table;

- (IBAction)closeClicked:(id)sender;
- (IBAction)refreshClicked:(id)sender;

@property (nonatomic, strong) NSArray* data;
@property (nonatomic, strong) PicklineEntity* picklineEntity;
@property (nonatomic, strong) NSArray* historyData;

@property (nonatomic, strong) NSMutableArray* todaysMedPairs;
@property (nonatomic, strong) NSMutableArray* tomorrowMedPairs;
@property (nonatomic, strong) NSMutableArray* todaysPicklinePairs;
@property (nonatomic, strong) NSMutableArray* tomorrowPicklinePairs;
@property (nonatomic, strong) NSArray* todaySortedCombinedArray;
@property (nonatomic, strong) NSArray* tomorrowSortedCombinedArray;
@property (nonatomic, strong)  SIAlertView *alertView;
@property (nonatomic, strong) NSIndexPath* selectedIndexPath;

@end

@implementation TodayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [[UIApplication sharedApplication] cancelAllLocalNotifications];
//    for (UILocalNotification* not in [[UIApplication sharedApplication] scheduledLocalNotifications])
//    {
//        NSLog(@"not name: %@    date: %@", not.alertBody, [MainViewController stringFromDate:not.fireDate withFormat:kDateFormatterNoYearType]);
//    }
    
    self.textView.editable = YES;
    self.textView.textAlignment = NSTextAlignmentRight;
    self.textView.font = [UIFont systemFontOfSize:18];
    self.textView.editable = NO;
    
    self.tomorrowTextView.editable = YES;
    self.tomorrowTextView.textAlignment = NSTextAlignmentRight;
    self.tomorrowTextView.font = [UIFont systemFontOfSize:18];
    self.tomorrowTextView.editable = NO;
    
    self.houreTextView.editable = YES;
    self.houreTextView.textAlignment = NSTextAlignmentRight;
    self.houreTextView.font = [UIFont systemFontOfSize:18];
    self.houreTextView.editable = NO;
    
    self.tomorrowHoursTextView.editable = YES;
    self.tomorrowHoursTextView.textAlignment = NSTextAlignmentRight;
    self.tomorrowHoursTextView.font = [UIFont systemFontOfSize:18];
    self.tomorrowHoursTextView.editable = NO;
    
    self.titleLabel.text = [MainViewController stringFromDate:[NSDate date] withFormat:kDateFormatterNoTimeNoYearType];

    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDataReady:) name:kMedicineNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPicklineDataReady:) name:kPicklineNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onHistoryDataReady:) name:kCheckedItemsNotificationName object:nil];
    
    if (delegate.modelManager.historyMedIDsArray) {
        self.historyData = delegate.modelManager.historyMedIDsArray;
        if (rails)
            [delegate.modelManager loadRailsHistoryData];
        else
            [delegate.modelManager loadHistoryData];
    }
    if (delegate.modelManager.medicineData) {
        self.data = delegate.modelManager.medicineData;
        [self setMedArrays];
    }
    if (delegate.modelManager.picklineEntity) {
        self.picklineEntity = delegate.modelManager.picklineEntity;
        [self setPickArrays];
    }
    self.alertView = [[SIAlertView alloc] initWithTitle:@"Updating..." andMessage:@"Please Wait"];
    self.alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)onDataReady:(NSNotification*)notification {
    
    self.data = [notification object];
    [self setMedArrays];
}

- (void)setCheckedItems {
    
    for (MedDatePair *pair in self.todaySortedCombinedArray) {
     
        BOOL found = NO;
        for (MedDatePair* historyPair in self.historyData) {
            
            if (historyPair.type == kHistoryMedType) {
                if ([historyPair.medicineID isEqualToString:pair.medicineID]  &&
                    historyPair.isFirstHour == pair.isFirstHour) {
                    pair.isDone = YES;
                    pair.pairID = historyPair.pairID;
                    pair.actualHour = historyPair.actualHour;
                    found = YES;
                    break;
                }
            } else if (historyPair.type == pair.type) {
                    pair.isDone = YES;
                    pair.pairID = historyPair.pairID;
                    pair.actualHour = historyPair.actualHour;
                    found = YES;
                    break;
            }
        }
        if (!found)
            pair.isDone = NO;
    }
    
//    for (MedDatePair* historyPair in self.historyData) {
//        
//        if (historyPair.type == kHistoryMedType) {
//            for (MedDatePair *pair in self.todaySortedCombinedArray) {
//                
//                if ([historyPair.medicineID isEqualToString:pair.medicineID]  &&
//                    historyPair.isFirstHour == pair.isFirstHour) {
//                    pair.isDone = YES;
//                    pair.pairID = historyPair.pairID;
//                }
//            }
//        } else {
//            for (MedDatePair *pair in self.todaySortedCombinedArray) {
//                
//                if (historyPair.type == pair.type) {
//                    pair.isDone = YES;
//                    pair.pairID = historyPair.pairID;
//                }
//            }
//
//        }
//    }
    [self.table reloadData];
}

- (void)onHistoryDataReady:(NSNotification*)notification {
    
    self.historyData = [notification object];
    [self setCheckedItems];
}

- (void)onPicklineDataReady:(NSNotification*)notification {
    
    self.picklineEntity = [notification object];
    [self setPickArrays];
}

- (void)setMedArrays {
    
    self.todaysMedPairs = [[NSMutableArray alloc] init];
    self.tomorrowMedPairs = [[NSMutableArray alloc] init];
    
    for (MedicineEntity* entity in self.data) {
        
        NSArray* pairs = [entity getTodayDates];
        for (MedDatePair* pair in pairs)
            [self.todaysMedPairs addObject:pair];
        
        pairs = [entity getTomorrowDates];
        for (MedDatePair* pair in pairs)
            [self.tomorrowMedPairs addObject:pair];
    }
    [self updateView];
}

- (void)setPickArrays {
    
    self.todaysPicklinePairs = [[NSMutableArray alloc] init];
    self.tomorrowPicklinePairs = [[NSMutableArray alloc] init];
    
    // bandage
    NSDate* date = [self.picklineEntity getBandageNextDate];
    MedDatePair* pair = [[MedDatePair alloc] init];
    pair.type = kHistoryBandageType;
    pair.name = @"החלפת תחבושת";
    pair.date = date;
    if ([date isToday])
        [self.todaysPicklinePairs addObject:pair];
    else if([date isTomorrow])
        [self.tomorrowPicklinePairs addObject:pair];
    
    // Blue Ventile
    date = [self.picklineEntity getVentileNextDate:kPicklineComponentBlueVentile];
    pair = [[MedDatePair alloc] init];
    pair.type = kHistoryBlueVentileType;
    pair.name = @"החלפת ונטיל כחול";
    pair.date = date;
    if ([date isToday])
        [self.todaysPicklinePairs addObject:pair];
    else if([date isTomorrow])
        [self.tomorrowPicklinePairs addObject:pair];
    
    // Red Ventile
    date = [self.picklineEntity getVentileNextDate:kPicklineComponentRedVentile];
    pair = [[MedDatePair alloc] init];
    pair.type = kHistoryRedVentileType;
    pair.name = @"החלפת ונטיל אדום";
    pair.date = date;
    if ([date isToday])
        [self.todaysPicklinePairs addObject:pair];
    else if([date isTomorrow])
        [self.tomorrowPicklinePairs addObject:pair];
    
    // Parpar
    date = [self.picklineEntity getParparNextDate];
    pair = [[MedDatePair alloc] init];
    pair.type = kHistoryParparType;
    pair.name = @"החלפת פרפר";
    pair.date = date;
    if ([date isToday])
        [self.todaysPicklinePairs addObject:pair];
    else if([date isTomorrow])
        [self.tomorrowPicklinePairs addObject:pair];

    [self updateView];
}

- (void)combineAndSortArrays {

    // combine all data:
    NSMutableArray* todayCombinedArray = [NSMutableArray arrayWithArray:self.todaysMedPairs];
    for (MedDatePair* pair in self.todaysPicklinePairs)
        [todayCombinedArray addObject:pair];
    
    NSMutableArray* tomorrowCombinedArray = [NSMutableArray arrayWithArray:self.tomorrowMedPairs];
    for (MedDatePair* pair in self.tomorrowPicklinePairs)
        [tomorrowCombinedArray addObject:pair];
    
    // sort arrays:
    self.todaySortedCombinedArray = [todayCombinedArray sortedArrayUsingComparator:^(MedDatePair *a, MedDatePair *b) {
        return [[MainViewController stringFromDate:a.date withFormat:kDateFormatterHourType] caseInsensitiveCompare:
                [MainViewController stringFromDate:b.date withFormat:kDateFormatterHourType]];
    }];
    
    self.tomorrowSortedCombinedArray = [tomorrowCombinedArray sortedArrayUsingComparator:^(MedDatePair *a, MedDatePair *b) {
        return [[MainViewController stringFromDate:a.date withFormat:kDateFormatterHourType] caseInsensitiveCompare:
                [MainViewController stringFromDate:b.date withFormat:kDateFormatterHourType]];
    }];
}

- (void)updateView {

    [self combineAndSortArrays];
    [self setCheckedItems];
   // [self.table reloadData];
}

- (IBAction)closeClicked:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)refreshClicked:(id)sender {
    
//    self.historyData = [
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate refreshData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (section == 0) ? [self.todaySortedCombinedArray count] : [self.tomorrowSortedCombinedArray count] ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"todayCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UILabel* medLabel = (UILabel*)[cell.contentView viewWithTag:1000];
    UILabel* hourLabel = (UILabel*)[cell.contentView viewWithTag:1001];
    
    // Configure the cell...
    //cell.contentView.tag = [indexPath section];
    
    switch ([indexPath section]) {
        case 0: {
            MedDatePair* pair = [self.todaySortedCombinedArray objectAtIndex:[indexPath row]];
            
            NSString* actualHour = @"";
            UIColor* color;
            if (pair.isDone) {
                color = [UIColor lightGrayColor];
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                actualHour = [NSString stringWithFormat:@" - (%@)", [MainViewController stringFromDate:pair.actualHour withFormat:kDateFormatterHourType]];
            }
            else {
                color = ([MainViewController isDate:pair.date earlierThanDate:[NSDate date]]) ? [UIColor redColor] : [UIColor blueColor];
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            
            medLabel.textColor = color;
            hourLabel.textColor = color;
            
            medLabel.text = [NSString stringWithFormat:@"%@%@", pair.name, actualHour];
            hourLabel.text = [MainViewController stringFromDate:pair.date withFormat:kDateFormatterHourType];
            
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            break;
        }
        case 1: {
            MedDatePair* pair = [self.tomorrowSortedCombinedArray objectAtIndex:[indexPath row]];
            medLabel.text = pair.name;
            hourLabel.text = [MainViewController stringFromDate:pair.date withFormat:kDateFormatterHourType];
            
            UIColor* color = [UIColor blueColor];
            medLabel.textColor = color;
            hourLabel.textColor = color;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            break;
        }
        default:
            break;
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 35.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *headerView = [self.table dequeueReusableHeaderFooterViewWithIdentifier:@"header1"];
//    return headerView;
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320, 30.0)];
    [customView setBackgroundColor:[UIColor lightGrayColor]];
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 5.0, 310, 30.0)];
    label.textAlignment = NSTextAlignmentRight;
    label.font = [UIFont boldSystemFontOfSize:20];
    [customView addSubview:label];
    
    switch (section) {
        case 0:
            label.text = [NSString stringWithFormat:@"%@ - %@", @"היום", [MainViewController stringFromDate:[NSDate date] withFormat:kDateFormatterNoTimeNoYearType] ];
            break;
        case 1:
            label.text = [NSString stringWithFormat:@"%@ - %@", @"מחר", [MainViewController stringFromDate:[NSDate dateWithTimeIntervalSinceNow:24*60*60] withFormat:kDateFormatterNoTimeNoYearType] ];
            break;
        default:
            break;
    }

    
    
    return customView;

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([indexPath section] == 0) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        self.selectedIndexPath = indexPath;
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            
            UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure you want to uncheck?"
                                                                     delegate:self
                                                            cancelButtonTitle:@"Cancel"
                                                       destructiveButtonTitle:@"Yes"
                                                            otherButtonTitles:nil];
            [actionSheet showInView:self.view];
        } else
            [self handleSelectedRow];
    }
}

- (void)handleSelectedRow {
    
    UITableViewCell* cell = [self.table cellForRowAtIndexPath:self.selectedIndexPath];
    
    MedDatePair* pair = [self.todaySortedCombinedArray objectAtIndex:[self.selectedIndexPath row]];
    
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        pair.isDone = NO;
    } else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        pair.isDone = YES;
        pair.actualHour = [NSDate date];
    }
    
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate.modelManager updateDBWithPair:pair];
    [self.table reloadData];
    
    //update pickline class
    PicklineComponent picklineComponent;
    switch (pair.type) {
        case kHistoryMedType:
            return;
        case kHistoryBandageType:
            picklineComponent = kPicklineComponentBandage;
            break;
        case kHistoryBlueVentileType:
            picklineComponent = kPicklineComponentBlueVentile;
            break;
        case kHistoryRedVentileType:
            picklineComponent = kPicklineComponentRedVentile;
            break;
        case kHistoryParparType:
            picklineComponent = kPicklineComponentParpar;
            break;
    }
    
    if (pair.isDone)
        [delegate.modelManager.picklineEntity setLastReplacedDate:pair.actualHour forComponent:picklineComponent];
    else {
        NSDate* earlierDate = [delegate.modelManager.picklineEntity getComponentPreviousDateFromNowForComponent:picklineComponent];
        [delegate.modelManager.picklineEntity setLastReplacedDate:earlierDate forComponent:picklineComponent];
    }
    NSDate* nextDate = [delegate.modelManager.picklineEntity getComponentNextDate:picklineComponent];
    [delegate.modelManager.picklineEntity setLocalNotificationForPicklineComponent:picklineComponent forDate:nextDate];
    
    // save record
    [self.picklineEntity saveInBackground];
}

#pragma merk- UIActionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex != [actionSheet cancelButtonIndex]) {
        
        [self handleSelectedRow];
    }
}

@end
