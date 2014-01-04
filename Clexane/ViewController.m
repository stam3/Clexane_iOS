//
//  ViewController.m
//  Clexane
//
//  Created by David Sayag on 8/31/13.
//  Copyright (c) 2013 David Sayag. All rights reserved.
//

#import "ViewController.h"
#import "ShotEntity.h"
#import "MainViewController.h"
#import "AppDelegate.h"
#import "MainViewController.h"
#import "MedDatePair.h"
#import "SIAlertView.h"

#define kShotDateColumn @"shotDate"
#define kIsRightColumn  @"isRight"
#define kDosageColumn   @"dosage"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *addLeftButton;
@property (weak, nonatomic) IBOutlet UIButton *addRightButton;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextField *dosageTextField;

- (IBAction)addRightClicked:(id)sender;
- (IBAction)addLeftClicked:(id)sender;
- (IBAction)bgClicked:(id)sender;
- (IBAction)refreshClicked:(id)sender;

@property (nonatomic, strong)  NSMutableArray *data;
@property (nonatomic, strong)  NSDate *lastDate;
@property (nonatomic, strong)  PFObject *pfObject;
@property (nonatomic, strong)  NSString* className;
@property (nonatomic, strong)  SIAlertView *alertView;

@end

@implementation ViewController {
    
    double diffSinceLast;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.addRightButton.enabled = NO;
    self.addLeftButton.enabled = NO;
    self.dateLabel.text = @"טוען...";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:[UIApplication sharedApplication]];

   // self.shotsArray = [PFObject objectWithClassName:@"TestObject"];
    self.className = @"ShotsObject";
    if (debug) {
        self.className = @"TestObject";
        //objID = @"6jdYOeNc4V";
    }
    
    self.alertView = [[SIAlertView alloc] initWithTitle:@"Loading..." andMessage:@"Please Wait"];
    self.alertView.transitionStyle = SIAlertViewTransitionStyleBounce;

    [self loadData];


    
//=================================================
//    NSDate* now = [NSDate date];
//    NSDateComponents *nowComponents =
//    [[NSCalendar currentCalendar] components:(NSDayCalendarUnit |
//                                              NSWeekdayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit| NSHourCalendarUnit| NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:now];

    //    int year = [nowComponents year];
    //    int month = [nowComponents month];
    //    int week = [nowComponents week];
    //    int day = [nowComponents day];
    //int weekday = [nowComponents weekday];
    //   int hour = [nowComponents hour];
    //    int seconds = [nowComponents second];
    
    //=============================
    
    //=============================
    
//    int newHour = (24-hour) + 7 + hour;
//    int newDay = day+1;
//    [nowComponents setHour:((24-hour) + 7 + hour)];
//    [nowComponents setMinute:0];
//    [nowComponents setDay:day+1];
//    if (month == 12 && day == 31)
//        [nowComponents setYear:year+1];
    
   // newDate = [[NSCalendar currentCalendar] dateFromComponents:nowComponents];
    //NSLog(@"%@", newDate);
    
    
    
    
    //        NSDateComponents *dateComponents =
    //        [gregorian components:(NSDayCalendarUnit |
    //                               NSWeekdayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:date];
    //        BOOL today = NO;
    //        if ([nowComponents year] == [dateComponents year] &&
    //            [nowComponents month] == [dateComponents month] &&
    //            [nowComponents day] == [dateComponents day])
    //            today = YES;
    //        

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)applicationWillEnterForeground:(NSNotification*)notification {
    
    [self loadData];
    //[self setIntervalSinceLastDate];
}

- (void)loadData {
    
    [self.alertView show];
    
    self.data = [[NSMutableArray alloc] init];
    self.lastDate = nil;
    self.pfObject = [PFObject objectWithClassName:self.className];
    PFQuery *query = [PFQuery queryWithClassName:self.className];
    query.limit = kClexaneQueryLimit;
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            if (objects) {
                if (objects) {
                    NSLog(@"Successfully retrieved %d scores.", objects.count);
                    // Do something with the found objects
                    for (PFObject *object in objects) {
                        
                        ShotEntity *entity = [[ShotEntity alloc] init];
                        NSDate* shotDate = [object objectForKey:kShotDateColumn];
                        //[self.data addObject:[ViewController stringFromDate:shotDate]];
                        entity.timestamp = shotDate;
                        
                        NSNumber* num = [object objectForKey:kIsRightColumn];
                        //[self.data addObject:num];
                        entity.isRight = num;
                        //NSLog(@"%@", [object createdAt]);
                        
                        entity.dosage = [[object objectForKey:kDosageColumn] intValue];
                        
                        if (!self.lastDate) {
                            
                            self.lastDate = shotDate;
                            //                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                            //                [dateFormat setDateFormat:kDateFormat];
                            //                self.lastDate = [dateFormat dateFromString:date];
                        }
                        
                        //self.lastDate = [object createdAt];
                        [self.data addObject:entity];
                    }
                }
                [self.table reloadData];
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        
        self.dateLabel.text = @"";
        
        // for first run...
        self.addRightButton.enabled = YES;
        self.addLeftButton.enabled = YES;
        // ===============================
        
        [self setIntervalSinceLastDate];
        [self.alertView dismissAnimated:YES];
    }];
}

- (void)setIntervalSinceLastDate {
    
    if (self.lastDate) {
        diffSinceLast = -[self.lastDate timeIntervalSinceNow];
        
        int hours = diffSinceLast / 3600;
        double mins  = ((diffSinceLast/3600)-hours)*60;
        self.dateLabel.text = [NSString stringWithFormat:@"%d שעות, %d דקות", hours, (int)mins];
        
        // check right or left
        ShotEntity* entity = [self.data objectAtIndex:0];
        BOOL isLastSideRight = [entity.isRight boolValue];
        //hours = 12;
        if (hours < kClexaneMinHours) {
            self.addLeftButton.enabled = NO;
            self.addRightButton.enabled = NO;
        } else {
            self.addLeftButton.enabled = isLastSideRight;
            self.addRightButton.enabled = !isLastSideRight;
        }
    }

}

//+ (NSDate*)dateFromString:(NSString*)stringDate {
//    
//    return [MainViewController dateFromString:stringDate w];
//}

//+ (NSString*)stringFromDate:(NSDate*)date {
//    
//    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    [dateFormat setDateFormat:kDateFormat];
//    return [dateFormat stringFromDate:date];
//}

//+ (NSString*)stringFromDate:(NSDate*)date showYear:(BOOL)showYear showTime:(BOOL)showTime {
//    
//    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    
//    if (showYear) {
//        
//        if (showTime)
//            [dateFormat setDateFormat:kDateFormat];
//        else
//            [dateFormat setDateFormat:kDateFormatNoTime];
//    }
//    else {
//        if (showTime)
//            [dateFormat setDateFormat:kDateFormatNoYear];
//        else
//            [dateFormat setDateFormat:kDateFormatNoTimeNoYear];
//    }
//    return [dateFormat stringFromDate:date];
//}

- (void)addEntry:(NSNumber*)isRight {
    
    [self.alertView show];
    [self.dosageTextField resignFirstResponder];
    
    NSDate* now = [NSDate date];
    self.lastDate = now;

    ShotEntity* entity = [[ShotEntity alloc] init];
    entity.isRight = isRight;
    entity.timestamp = now;
    entity.dosage = [self.dosageTextField.text intValue];
    
   [self.data insertObject:entity atIndex:0];
    
    [self.table reloadData];
    
    self.pfObject = [PFObject objectWithClassName:self.className];
    
    //[self.pfObject setObject:self.data forKey:@"shotsArray"];
    [self.pfObject setObject:isRight forKey:kIsRightColumn];
    [self.pfObject setObject:now forKey:kShotDateColumn];
    NSNumber* dosage = [NSNumber numberWithInt:[self.dosageTextField.text intValue]];
    [self.pfObject setObject:dosage forKey:kDosageColumn];
    //[self.pfObject setObject:self.lastDate forKey:@"lastDate"];
    [self.pfObject save];
    
    [self setIntervalSinceLastDate];
    
//    // save to history
//    MedDatePair* pair = [[MedDatePair alloc] init];
//    pair.isDone = YES;
//    pair.actualHour = now;
//    
//    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//    [delegate.modelManager updateDBWithPair:pair];

    [self.alertView dismissAnimated:YES];
}

- (IBAction)addRightClicked:(id)sender {
    
    self.dateLabel.text = @"שומר נתונים...";
    [self addEntry:[NSNumber numberWithInt:1]];
}

- (IBAction)addLeftClicked:(id)sender {
    
    self.dateLabel.text = @"שומר נתונים...";
    [self addEntry:[NSNumber numberWithInt:0]];
}

- (IBAction)bgClicked:(id)sender {
    [self.dosageTextField resignFirstResponder];
}

- (IBAction)refreshClicked:(id)sender {
    
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate refreshData];
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
//    static NSString *CellIdentifier = @"CellIdentifier";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    //ShotEntity* entity = [self.data objectAtIndex:[indexPath row]];
//    
//    int e1 = [indexPath row]*2;
//    int e2 = [indexPath row]*2+1;
//    cell.textLabel.text = [self.data objectAtIndex:e1];
//    cell.detailTextLabel.text = (([[self.data objectAtIndex:e2] intValue]) == 1) ? @"ימין" : @"שמאל";
//    
//    return cell;
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    ShotEntity* entity = [self.data objectAtIndex:[indexPath row]];
    
    if ([indexPath row] == 0) {
        self.dosageTextField.text = [NSString stringWithFormat:@"%d", entity.dosage];
    }
    
    cell.textLabel.text = [MainViewController stringFromDate:entity.timestamp withFormat:kDateFormatterFullType];
    //[ViewController stringFromDate:entity.timestamp];
    NSString* detailedLabel = (([entity.isRight intValue]) == 1) ? @"ימין" : @"שמאל";
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@: %d מ\"ג", detailedLabel, entity.dosage];
    
    return cell;
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

@end
