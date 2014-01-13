//
//  PicklineTableViewController.m
//  Clexane
//
//  Created by David Sayag on 10/27/13.
//  Copyright (c) 2013 David Sayag. All rights reserved.
//

#import "PicklineTableViewController.h"
#import "AppDelegate.h"
#import "MainViewController.h"
#import "PicklineEntity.h"

#import "NSDate-Utilities.h"

#define kRedRow         0
#define kBlueRow        1
#define kBandageRow     2
#define kBlueVentileRow    3
#define kRedVentileRow    4
#define kParparRow      5

@interface PicklineTableViewController ()

- (IBAction)refreshClicked:(id)sender;
- (IBAction)bandageSegementedControlValueChanged:(id)sender;

@property (nonatomic, strong)  PicklineEntity *picklineEntity;

@end

@implementation PicklineTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDataReady:) name:kPicklineNotificationName object:nil];
    //
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (delegate.modelManager.medicineData) {
        self.picklineEntity = delegate.modelManager.picklineEntity;
        [self updateUI];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private Methods

- (void)setNextWashDate:(NSDate*)lastDate forTitleLabel:(UILabel*)titleLabel andDateLabel:(UILabel*)dateLabel withButton:(UIButton*)button {
    
    dateLabel.textColor = [UIColor blackColor];
    int interval = 60*60*4; // 4 hours
    if ([lastDate timeIntervalSinceNow] < -interval) {
        titleLabel.text = @"ניתן לשימוש";
        dateLabel.text = @"";
        titleLabel.textColor = [UIColor colorWithRed:24/255.0 green:153/255.0 blue:14/255.0 alpha:1.0];
        button.enabled = YES;
    }
    else {
        NSDate* nextDate = [lastDate dateByAddingTimeInterval:interval];
        dateLabel.text = [MainViewController stringFromDate:nextDate withFormat:kDateFormatterNoYearType];
        titleLabel.text = @"לא להשתמש עד:";
        titleLabel.textColor = [UIColor redColor];
        button.enabled = NO;
    }
}

//- (void)setPicklineEntity:(PicklineEntity *)newPicklineEntity {
//    
//    if (_picklineEntity != newPicklineEntity)  {
//        
//        //[[UIApplication sharedApplication] cancelAllLocalNotifications];
//        [MainViewController cancelLocalNotificationForID:kPicklineNotificationID];
//        _picklineEntity = newPicklineEntity;
//        
//        
////        [self.picklineEntity setLocalNotificationForPicklineComponent:kPicklineComponentBandage forDate:nextDate];
////        NSDate* fireDate = _picklineEntity.bandageFireDate;
////        if (fireDate)
////            [MainViewController createAlarmforDate:fireDate
////                                      withInterval:0 withBody:kBandageAlertBody andID:kPicklineNotificationID];
////        
////        fireDate = _picklineEntity.ventilesFireDate;
////        if (fireDate)
////            [MainViewController createAlarmforDate:fireDate
////                                      withInterval:0 withBody:kVentilesAlertBody andID:kPicklineNotificationID];
//    }
//}

- (NSDate*)setNextDate:(NSDate*)lastDate picklineComponent:(PicklineComponent)component forDateLabel:(UILabel*)dateLabel {
    
    NSDate* nextDate = [self.picklineEntity getComponentNextDate:component];
    
    dateLabel.text = [MainViewController stringFromDate:nextDate withFormat:kDateFormatterNoTimeNoYearType];
    if ([nextDate timeIntervalSinceNow] < 0 && ![nextDate isToday]) {  // earlier than today
        
        dateLabel.font = [UIFont systemFontOfSize:15];
        dateLabel.textColor = [UIColor redColor];
        if ([nextDate isYesterday])
            dateLabel.text = @"אתמול";
    }
    else {
        
        dateLabel.font = [UIFont boldSystemFontOfSize:15];
        if ([nextDate isToday]) { //([MainViewController isToday:nextDate]) {
            dateLabel.text = @"היום";
            dateLabel.textColor = [UIColor orangeColor];
        }
        else {
            if ([nextDate isTomorrow]) //([MainViewController isTommorow:nextDate])
                dateLabel.text = @"מחר";
            else if ([nextDate isDayAfterTomorrow])
                dateLabel.text = @"מחרתיים";
            dateLabel.textColor = [UIColor colorWithRed:24/255.0 green:153/255.0 blue:14/255.0 alpha:1.0];
        }
    }
    return nextDate;
}

- (void)onDataReady:(NSNotification*)notification {
    
    self.picklineEntity = [notification object];
    [self updateUI];
}

- (void)updateUI {
    
    [self.tableView reloadData];
}

#pragma mark - Buttons Methods

- (IBAction)buttonClicked:(id)sender {
    
    UIView* contentView = ((UIView*)sender).superview;
    UILabel* lastHandledDateLabel = (UILabel*)[contentView viewWithTag:300];
    UILabel* nextHandledTitleLabel = (UILabel*)[contentView viewWithTag:400];
    UILabel* nextHandledDateLabel = (UILabel*)[contentView viewWithTag:500];
    UIButton* button = (UIButton*)[contentView viewWithTag:600];

    switch (contentView.tag) {
        case kRedRow:
            self.picklineEntity.redLastWashDate = [NSDate date];
            lastHandledDateLabel.text = [MainViewController stringFromDate:self.picklineEntity.redLastWashDate withFormat:kDateFormatterNoYearType];
            [self setNextWashDate:self.picklineEntity.redLastWashDate forTitleLabel:nextHandledTitleLabel andDateLabel:nextHandledDateLabel withButton:button];
            [self.picklineEntity saveInBackground];
            break;
        case kBlueRow:
            self.picklineEntity.blueLastWashDate = [NSDate date];
            lastHandledDateLabel.text = [MainViewController stringFromDate:self.picklineEntity.blueLastWashDate withFormat:kDateFormatterNoYearType];
            [self setNextWashDate:self.picklineEntity.blueLastWashDate forTitleLabel:nextHandledTitleLabel andDateLabel:nextHandledDateLabel withButton:button];
            [self.picklineEntity saveInBackground];
            break;
        case kBandageRow: {
            
            self.picklineEntity.bandageLastReplacedDate = [NSDate date];
            
            lastHandledDateLabel.text = [MainViewController stringFromDate:self.picklineEntity.bandageLastReplacedDate withFormat:kDateFormatterNoTimeNoYearType formatted:YES];
            NSDate* nextDate = [self setNextDate:self.picklineEntity.bandageLastReplacedDate picklineComponent:kPicklineComponentBandage forDateLabel:nextHandledDateLabel];
            
            [self.picklineEntity setLocalNotificationForPicklineComponent:kPicklineComponentBandage forDate:nextDate];

            
            // save record
            [self.picklineEntity saveInBackground];
        }
            break;
        case kBlueVentileRow: {
            
            self.picklineEntity.blueVentileLastReplacedDate = [NSDate date];
            lastHandledDateLabel.text = [MainViewController stringFromDate:self.picklineEntity.blueVentileLastReplacedDate withFormat:kDateFormatterNoTimeNoYearType formatted:YES];
            NSDate* nextDate = [self setNextDate:self.picklineEntity.blueVentileLastReplacedDate picklineComponent:kPicklineComponentBlueVentile forDateLabel:nextHandledDateLabel];;
            
            [self.picklineEntity setLocalNotificationForPicklineComponent:kPicklineComponentBlueVentile forDate:nextDate];
            
            // save record
            [self.picklineEntity saveInBackground];
        }
            break;
        case kRedVentileRow: {
            
            self.picklineEntity.redVentileLastReplacedDate = [NSDate date];
            lastHandledDateLabel.text = [MainViewController stringFromDate:self.picklineEntity.redVentileLastReplacedDate withFormat:kDateFormatterNoTimeNoYearType formatted:YES];
            NSDate* nextDate = [self setNextDate:self.picklineEntity.redVentileLastReplacedDate picklineComponent:kPicklineComponentRedVentile forDateLabel:nextHandledDateLabel];;
            
            [self.picklineEntity setLocalNotificationForPicklineComponent:kPicklineComponentRedVentile forDate:nextDate];
            
            // save record
            [self.picklineEntity saveInBackground];
        }
            break;
        case kParparRow: {
            self.picklineEntity.parparLastReplacedDate = [NSDate date];
            lastHandledDateLabel.text = [MainViewController stringFromDate:self.picklineEntity.parparLastReplacedDate withFormat:kDateFormatterNoTimeNoYearType formatted:YES];
            NSDate* nextDate = [self setNextDate:self.picklineEntity.parparLastReplacedDate picklineComponent:kPicklineComponentParpar forDateLabel:nextHandledDateLabel];;
            
            [self.picklineEntity setLocalNotificationForPicklineComponent:kPicklineComponentParpar forDate:nextDate];
//            // remove current alarm
//            if (self.picklineEntity.parparLocalNotification)
//                [[UIApplication sharedApplication] cancelLocalNotification:self.picklineEntity.parparLocalNotification];
//            
//            // create new alarm
//            self.picklineEntity.parparLocalNotification = [MainViewController createAlarmforDate:nextDate withInterval:0 withBody:kParparAlertBody andID:kPicklineNotificationID];
            
            // save alaram to DB
            //self.picklineEntity.bandageFireDate = self.picklineEntity.bandageLocalNotification.fireDate;
            
            // save record
            [self.picklineEntity saveInBackground];
        }
            break;
            
        default:
            break;
    }

    
}

- (IBAction)bandageSegementedControlValueChanged:(id)sender {
    
    UISegmentedControl* segmentedControl = (UISegmentedControl*)sender;
    self.picklineEntity.bandageIntervalDays = [[segmentedControl titleForSegmentAtIndex:segmentedControl.selectedSegmentIndex] intValue];
    
    UIView* contentView = ((UIView*)sender).superview;
    UILabel* nextHandledDateLabel = (UILabel*)[contentView viewWithTag:500];
    
    NSDate* nextDate = [self setNextDate:self.picklineEntity.bandageLastReplacedDate picklineComponent:kPicklineComponentBandage forDateLabel:nextHandledDateLabel];;
            
    // remove current alarm
    if (self.picklineEntity.bandageLocalNotification)
        [[UIApplication sharedApplication] cancelLocalNotification:self.picklineEntity.bandageLocalNotification];
    
    // create new alarm
    self.picklineEntity.bandageLocalNotification = [MainViewController createAlarmforDate:nextDate withInterval:0 withBody:kBandageAlertBody withID:kPicklineNotificationID andUniqueID:[NSString stringWithFormat:@"%d", kPicklineComponentBandage]];
    
    // save alaram to DB
    //self.picklineEntity.bandageFireDate = self.picklineEntity.bandageLocalNotification.fireDate;
    
    // save record
    [self.picklineEntity saveInBackground];
}

- (IBAction)refreshClicked:(id)sender {
    
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate refreshData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (self.picklineEntity) ? 1 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PicklineCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UILabel* titleLabel = (UILabel*)[cell.contentView viewWithTag:100];
    UILabel* lastHandledTitleLabel = (UILabel*)[cell.contentView viewWithTag:200];
    UILabel* lastHandledDateLabel = (UILabel*)[cell.contentView viewWithTag:300];
    UILabel* nextHandledTitleLabel = (UILabel*)[cell.contentView viewWithTag:400];
    UILabel* nextHandledDateLabel = (UILabel*)[cell.contentView viewWithTag:500];
    UIButton* button = (UIButton*)[cell.contentView viewWithTag:600];
    UISegmentedControl* segmentedControl = (UISegmentedControl*)[cell.contentView viewWithTag:700];

    // Configure the cell...
    NSLog(@"row: %d", [indexPath section]);
    cell.contentView.tag = [indexPath section];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    switch ([indexPath section]) {
        case kRedRow:
            titleLabel.text = @"אדום";
            lastHandledTitleLabel.text = @"שטיפה אחרונה:";
            lastHandledDateLabel.text = [MainViewController stringFromDate:self.picklineEntity.redLastWashDate withFormat:kDateFormatterNoYearType];
            [self setNextWashDate:self.picklineEntity.redLastWashDate forTitleLabel:nextHandledTitleLabel andDateLabel:nextHandledDateLabel withButton:button];
            segmentedControl.hidden = YES;
            break;
        case kBlueRow:
            titleLabel.text = @"כחול";
            lastHandledTitleLabel.text = @"שטיפה אחרונה:";
            lastHandledDateLabel.text = [MainViewController stringFromDate:self.picklineEntity.blueLastWashDate withFormat:kDateFormatterNoYearType];
            [self setNextWashDate:self.picklineEntity.blueLastWashDate forTitleLabel:nextHandledTitleLabel andDateLabel:nextHandledDateLabel withButton:button];
            segmentedControl.hidden = YES;
            break;
        case kBandageRow:
            titleLabel.text = @"חבישה";
            lastHandledTitleLabel.text = @"החלפה אחרונה:";
            nextHandledTitleLabel.text = @"החלפה הבאה:";
            lastHandledDateLabel.text = [MainViewController stringFromDate:self.picklineEntity.bandageLastReplacedDate withFormat:kDateFormatterNoTimeNoYearType formatted:YES];
            
            [self setNextDate:self.picklineEntity.bandageLastReplacedDate picklineComponent:kPicklineComponentBandage forDateLabel:nextHandledDateLabel];
            
            segmentedControl.hidden = NO;
            [segmentedControl setSelectedSegmentIndex:(self.picklineEntity.bandageIntervalDays == 2) ? 0 : 1];
            [button setTitle:@"הוחלפה עכשיו" forState:UIControlStateNormal];
            button.enabled = YES;
            nextHandledTitleLabel.textColor = [UIColor blackColor];
            break;
        case kBlueVentileRow:
            titleLabel.text = @"ונטיל כחול";
            lastHandledTitleLabel.text = @"החלפה אחרונה:";
            nextHandledTitleLabel.text = @"החלפה הבאה:";
            lastHandledDateLabel.text = [MainViewController stringFromDate:self.picklineEntity.blueVentileLastReplacedDate withFormat:kDateFormatterNoTimeNoYearType formatted:YES];
            
            [self setNextDate:self.picklineEntity.blueVentileLastReplacedDate picklineComponent:kPicklineComponentBlueVentile forDateLabel:nextHandledDateLabel];
            
            segmentedControl.hidden = YES;
            [button setTitle:@"הוחלף עכשיו" forState:UIControlStateNormal];
            button.enabled = YES;
            nextHandledTitleLabel.textColor = [UIColor blackColor];
            break;
        case kRedVentileRow:
            titleLabel.text = @"ונטיל אדום";
            lastHandledTitleLabel.text = @"החלפה אחרונה:";
            nextHandledTitleLabel.text = @"החלפה הבאה:";
            lastHandledDateLabel.text = [MainViewController stringFromDate:self.picklineEntity.redVentileLastReplacedDate withFormat:kDateFormatterNoTimeNoYearType formatted:YES];
            
            [self setNextDate:self.picklineEntity.redVentileLastReplacedDate picklineComponent:kPicklineComponentRedVentile forDateLabel:nextHandledDateLabel];
            
            segmentedControl.hidden = YES;
            [button setTitle:@"הוחלף עכשיו" forState:UIControlStateNormal];
            button.enabled = YES;
            nextHandledTitleLabel.textColor = [UIColor blackColor];
            break;
        case kParparRow:
            titleLabel.text = @"פרפר";
            lastHandledTitleLabel.text = @"החלפה אחרונה:";
            nextHandledTitleLabel.text = @"החלפה הבאה:";
            lastHandledDateLabel.text = [MainViewController stringFromDate:self.picklineEntity.parparLastReplacedDate withFormat:kDateFormatterNoTimeNoYearType formatted:YES];

            [self setNextDate:self.picklineEntity.parparLastReplacedDate picklineComponent:kPicklineComponentParpar forDateLabel:nextHandledDateLabel];
            
            segmentedControl.hidden = YES;
            [button setTitle:@"הוחלף עכשיו" forState:UIControlStateNormal];
            button.enabled = YES;
            nextHandledTitleLabel.textColor = [UIColor blackColor];
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 134.0;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
