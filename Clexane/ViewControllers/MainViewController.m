//
//  MainViewController.m
//  Clexane
//
//  Created by David Sayag on 10/12/13.
//  Copyright (c) 2013 David Sayag. All rights reserved.
//

#import "MainViewController.h"
#import "NudnikViewController.h"
#import "AppDelegate.h"
#import "NSDate-Utilities.h"

#define kClexaneRow     0
#define kPicklineRow    2
#define kMedicineRow    1
#define kSignoutRow     3

#define kDateFormat                 @"EEE, MMM d, yy - kk:mm"
#define kDateFormatHour             @"kk:mm"
#define kDateFormatNoTime           @"EEE, MMM d, yy"
#define kDateFormatNoYear           @"EEE, MMM d, kk:mm"
#define kDateFormatNoTimeNoYear     @"EEE, MMM d"

@interface MainViewController ()

@property (nonatomic, strong)  NSArray* data;

- (IBAction)refreshClicked:(id)sender;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    //[self performSegueWithIdentifier:@"signup" sender:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (rails)
        self.data = [[NSArray alloc] initWithObjects:@"Clexane", @"תרופות",@"פיקליין", @"יציאה", nil];
    else
        self.data = [[NSArray alloc] initWithObjects:@"Clexane", @"תרופות", @"פיקליין", nil];
	// Do any additional setup after loading the view.
    
   // [[UIApplication sharedApplication] cancelAllLocalNotifications];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:)
//                                                 name:UIApplicationWillResignActiveNotification object:[UIApplication sharedApplication]];
//    
    
    //==============================
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MainCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    ShotEntity* entity = [self.data objectAtIndex:[indexPath row]];
//    
//    if ([indexPath row] == 0) {
//        self.dosageTextField.text = [NSString stringWithFormat:@"%d", entity.dosage];
//    }
//    
//    cell.textLabel.text = [ViewController stringFromDate:entity.timestamp];
//    NSString* detailedLabel = (([entity.isRight intValue]) == 1) ? @"ימין" : @"שמאל";
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@: %d מ\"ג", detailedLabel, entity.dosage];
//
    cell.textLabel.text = [self.data objectAtIndex:[indexPath row]];
    cell.detailTextLabel.text = @"";
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([indexPath row]) {
        case kClexaneRow:
            [self performSegueWithIdentifier:@"clexane" sender:self];
            break;
        case kPicklineRow:
            [self performSegueWithIdentifier:@"pickTable" sender:self];
            break;
        case kMedicineRow:
            [self performSegueWithIdentifier:@"medicine" sender:self];
            break;
        case kSignoutRow:
            [self performSegueWithIdentifier:@"profile" sender:self];
            break;
        default:
            break;
    }
    
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

//+ (BOOL)isToday:(NSDate*)someDate {
//    
//    NSDateComponents *otherDay = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:someDate];
//    NSDateComponents *today = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
//    if([today day] == [otherDay day] &&
//       [today month] == [otherDay month] &&
//       [today year] == [otherDay year] &&
//       [today era] == [otherDay era]) {
//        
//        return YES;
//    }
//    return NO;
//}

//+ (BOOL)isTommorow:(NSDate*)someDate {
//    
//    NSDateComponents *otherDay = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:someDate];
//    NSDateComponents *today = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
//    if([today day] +1 == [otherDay day] &&
//       [today month] == [otherDay month] &&
//       [today year] == [otherDay year] &&
//       [today era] == [otherDay era]) {
//        
//        return YES;
//    }
//    return NO;
//}
+ (NSString*)stringFromDate:(NSDate*)date withFormat:(int)formatType {
    
    return [self stringFromDate:date withFormat:formatType formatted:NO];
}

+ (NSString*)stringFromDate:(NSDate*)date withFormat:(int)formatType formatted:(BOOL)useTexts {
    
    if (useTexts) {
        if ([date isYesterday])
            return @"אתמול";
        else if ([date isToday])
            return @"היום";
        else if ([date isTomorrow])
            return @"מחר";
    }
    NSDateFormatter *dateFormat = [MainViewController getDateFormatterForType:formatType];
    return [dateFormat stringFromDate:date];
}

+ (NSDate*)dateFromString:(NSString*)strDate withFormat:(int)formatType {
    
    NSDateFormatter *dateFormat = [MainViewController getDateFormatterForType:formatType];
    return [dateFormat dateFromString:strDate];
}

+ (NSDateFormatter*)getDateFormatterForType:(int)formatType {
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    switch (formatType) {
        case kDateFormatterFullType:
            [dateFormat setDateFormat:kDateFormat];
            break;
        case kDateFormatterHourType:
            [dateFormat setDateFormat:kDateFormatHour];
            break;
        case kDateFormatterNoTimeType:
            [dateFormat setDateFormat:kDateFormatNoTime];
            break;
        case kDateFormatterNoYearType:
            [dateFormat setDateFormat:kDateFormatNoYear];
            break;
        case kDateFormatterNoTimeNoYearType:
            [dateFormat setDateFormat:kDateFormatNoTimeNoYear];
            break;
        default:
            [dateFormat setDateFormat:kDateFormat];
            break;
    }
    return dateFormat;
}


+ (UILocalNotification*)createAlarmforDate:(NSDate*)fireDate withInterval:(NSCalendarUnit)interval withBody:(NSString*)alertBody withID:(int)notificationID andUniqueID:(NSString*)uniqueID {
    
    UILocalNotification* not =[[UILocalNotification alloc] init];
    not.fireDate = fireDate;
    not.alertBody = alertBody;
    not.alertAction = @"Action";
    not.repeatInterval = interval;
    not.soundName = kAlertSoundName;
    NSDictionary* userInfo;
    if (uniqueID)
        userInfo = @{kNotificationIDKeyName: [NSNumber numberWithInt:notificationID],
                                   kNotificationUniqueIDKeyName: uniqueID };
    else
        userInfo = @{kNotificationIDKeyName: [NSNumber numberWithInt:notificationID]};
    not.userInfo = userInfo;
    [[UIApplication sharedApplication] scheduleLocalNotification:not];
    return not;
}

+ (void)logAllLocalNotificationsForID:(int)notificationID {
    
    for (UILocalNotification* not in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        
        int notID = [[not.userInfo objectForKey:kNotificationIDKeyName] intValue];
        NSString* notUniqueID = [not.userInfo objectForKey:kNotificationUniqueIDKeyName];
        NSLog(@"notification type: %@, uniqueID: %@", (notID == kPicklineNotificationID) ? @"Pickline" : @"Medicine", notUniqueID);
    }
}

+ (NSArray*)getAllLocalNotificationsForUniqueID:(NSString*)uniqueID {
    
    NSMutableArray* array = [[NSMutableArray alloc] init];
    for (UILocalNotification* not in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        
        int notID = [[not.userInfo objectForKey:kNotificationIDKeyName] intValue];
        NSString* notUniqueID = [not.userInfo objectForKey:kNotificationUniqueIDKeyName];
        if ([uniqueID isEqualToString:notUniqueID]) {
            NSLog(@"notification type: %@, uniqueID: %@", (notID == kPicklineNotificationID) ? @"Pickline" : @"Medicine", notUniqueID);
            [array addObject:not];
        }
    }
    return array;
}


+ (void)cancelAllLocalNotificationsForID:(int)notificationID {
    
    [self cancelAllLocalNotificationsForID:notificationID andUniqueID:nil];
//    for (UILocalNotification* not in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
//        
//        int notID = [[not.userInfo objectForKey:kNotificationIDKeyName] intValue];
//        if (notID == notificationID)
//            [[UIApplication sharedApplication] cancelLocalNotification:not];
//    }
}

+ (void)cancelAllLocalNotificationsForID:(int)notificationID andUniqueID:(NSString*)uniqueID {
    
    for (UILocalNotification* not in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        
        int notID = [[not.userInfo objectForKey:kNotificationIDKeyName] intValue];
        if (notID == notificationID) {
            
            if (uniqueID) {
                
                NSString* notUniqueID = [not.userInfo objectForKey:kNotificationUniqueIDKeyName];
                if (notUniqueID && [notUniqueID isEqualToString:uniqueID])
                    [[UIApplication sharedApplication] cancelLocalNotification:not];
            } else
                [[UIApplication sharedApplication] cancelLocalNotification:not];
        }
    }
}


//+ (void)cancelNextLocalNotificationForID:(int)notificationID andUniqueID:(NSString*)uniqueID {
//    
//    NSMutableArray* array = [[NSMutableArray alloc] init];
//    UILocalNotification* nextLocalNotification;
//    
//    // find relevant alerts
//    for (UILocalNotification* not in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
//        
//        int notID = [[not.userInfo objectForKey:kNotificationIDKeyName] intValue];
//        if (notID == notificationID) {
//            
//            if (uniqueID) {
//                
//                NSString* notUniqueID = [not.userInfo objectForKey:kNotificationUniqueIDKeyName];
//                if (notUniqueID && [notUniqueID isEqualToString:uniqueID])
//                    [array addObject:not];
//                   // [[UIApplication sharedApplication] cancelLocalNotification:not];
//            } else {
//                nextLocalNotification = not;
//                //[[UIApplication sharedApplication] cancelLocalNotification:not];
//            }
//        }
//    }
//    // find next alert
//    if (uniqueID && ([array count] > 0)) {
//        
//     NSArray *sortedArray = [array sortedArrayUsingComparator:^(UILocalNotification *a, UILocalNotification *b) {
//            return [a.fireDate compare:b.fireDate];
//        }];
//        NSLog(@"sorted array: %@", sortedArray);
//        nextLocalNotification = [sortedArray objectAtIndex:0];
//    }
//    NSLog(@"next alert: %@", nextLocalNotification);
//    if (!nextLocalNotification)
//        return;
//    
//    NSDate* nextDate = nextLocalNotification.fireDate;
//    switch (nextLocalNotification.repeatInterval) {
//        case NSWeekCalendarUnit:
//            nextDate = [nextDate dateByAddingDays:7];
//            break;
//        // TODO
//        default:
//            break;
//    }
//    [MainViewController createAlarmforDate:nextDate withInterval:NSWeekCalendarUnit withBody:nextLocalNotification.alertBody withID:[nextLocalNotification.userInfo objectForKey:kNotificationIDKeyName] andUniqueID:[nextLocalNotification.userInfo objectForKey:kNotificationUniqueIDKeyName]];
//    
//    NSDictionary* userInfo = @{kMedicineID: uniqueID};
//    [[NSNotificationCenter defaultCenter] postNotificationName:kNextNotificationCanceledNotificationName object:nextLocalNotification.fireDate userInfo:userInfo];
//    NSLog(@"Canceling: %@", nextLocalNotification);
//    [[UIApplication sharedApplication] cancelLocalNotification:nextLocalNotification];
//}


#pragma mark - Storyboard

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    NSLog(@"segue.identifier %@", segue.identifier);
//	if ([segue.identifier isEqualToString:@"nudnik"])
//	{
//		//UINavigationController *navigationController = segue.destinationViewController;
//		//DatePickerViewController *viewController = [[navigationController viewControllers] objectAtIndex:0];
//		NudnikViewController *viewController = segue.destinationViewController;
//        viewController.delegate = self;
//        
//        viewController.pickerHour = (tagOfSetHourButton == kFixedDaysSetFirstHour || tagOfSetHourButton == kDaysOffsetSetFirstHour) ?
//        self.medicineEntity.firstHour : self.medicineEntity.secondHour;
//	}
//}


- (IBAction)refreshClicked:(id)sender {
    
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate refreshData];
}

+ (BOOL)isDate:(NSDate*)someDate earlierThanDate:(NSDate*)anotherDate {
    
    NSDateComponents* someComponents = [[NSCalendar currentCalendar] components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:someDate];
    NSDateComponents* anotherComponents = [[NSCalendar currentCalendar] components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:anotherDate];
    return (
            ([someComponents hour] < [anotherComponents hour])  ||
            (([someComponents hour] == [anotherComponents hour])  &&  ([someComponents minute] < [anotherComponents minute])));
}

+ (NSDate*)getTodaysStartDate {
    
    NSDate* now = [NSDate date];
    NSDateComponents *nowComponents =
    [[NSCalendar currentCalendar] components:(NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:now];
    
    [nowComponents setHour:0];
    [nowComponents setMinute:0];
    [nowComponents setSecond:0];
    
    return [[NSCalendar currentCalendar] dateFromComponents:nowComponents];
}

+ (NSDate*)getTodaysEndDate {
    
    NSDateComponents *nowComponents =
    [[NSCalendar currentCalendar] components:(NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:[NSDate date]];
    
    [nowComponents setHour:23];
    [nowComponents setMinute:59];
    [nowComponents setSecond:59];
    
    return [[NSCalendar currentCalendar] dateFromComponents:nowComponents];
}

@end
