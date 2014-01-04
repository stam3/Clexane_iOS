////
////  PicklineViewController.m
////  Clexane
////
////  Created by David Sayag on 10/13/13.
////  Copyright (c) 2013 David Sayag. All rights reserved.
////
//
//#import "PicklineViewController.h"
//#import "ViewController.h"
//#import "AppDelegate.h"
//#import "MainViewController.h"
//#import "PicklineEntity.h"
//#import "NSDate-Utilities.h"
//
//@interface PicklineViewController ()
//@property (weak, nonatomic) IBOutlet UILabel *blueLastWashDateLabel;
//@property (weak, nonatomic) IBOutlet UILabel *bandageLastReplacedDateLabel;
//@property (weak, nonatomic) IBOutlet UILabel *ventilsLastReplacedDateLabel;
//@property (weak, nonatomic) IBOutlet UILabel *redNextWashDateLabel;
//@property (weak, nonatomic) IBOutlet UILabel *blueNextWashDateLabel;
//@property (weak, nonatomic) IBOutlet UILabel *bandageNextReplaceDateLabel;
//@property (weak, nonatomic) IBOutlet UILabel *ventilsNextReplaceDateLabel;
//@property (weak, nonatomic) IBOutlet UILabel *redInfoLabel;
//@property (weak, nonatomic) IBOutlet UILabel *blueInfoLabel;
//@property (weak, nonatomic) IBOutlet UIButton *redButton;
//@property (weak, nonatomic) IBOutlet UIButton *blueButton;
//@property (weak, nonatomic) IBOutlet UIButton *bandageButton;
//@property (weak, nonatomic) IBOutlet UIButton *ventilesButton;
//@property (weak, nonatomic) IBOutlet UISegmentedControl *bandageSegmentedControl;
//
//- (IBAction)bandageSegementedControl:(id)sender;
//- (IBAction)redPickWashButton:(id)sender;
//- (IBAction)bluePickWashButton:(id)sender;
//- (IBAction)bandageReplaceButton:(id)sender;
//- (IBAction)ventilsReplaceButton:(id)sender;
//- (IBAction)refreshClicked:(id)sender;
//
//@property (weak, nonatomic) IBOutlet UILabel *redLastWashDateLabel;
//
//@property (nonatomic, strong)  PFObject *pfObject;
//@property (nonatomic, strong)  PicklineEntity *picklineEntity;
//
//@property (nonatomic, strong)  NSString* className;
////@property (nonatomic, strong)  UILocalNotification* bandageLocalNotification;
////@property (nonatomic, strong)  UILocalNotification* ventilesLocalNotification;
//
//@end
//
//@implementation PicklineViewController {
//    
//    int bandageNumOfDays;
//}
//
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    
//    self.className = @"Pickline";
//    if (debug)
//        self.className = @"PicklineTest";
//    
//    self.redButton.enabled = NO;
//    self.blueButton.enabled = NO;
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDataReady:) name:kPicklineNotificationName object:nil];
////    
//    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//    if (delegate.modelManager.medicineData) {
//        self.picklineEntity = delegate.modelManager.picklineEntity;
//        [self updateUI];
//    }
//
//   // [self loadData];
//}
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//- (void)onDataReady:(NSNotification*)notification {
//    
//    self.picklineEntity = [notification object];
//    [self updateUI];
//}
//
////- (void)loadData {
////    
////   // [[UIApplication sharedApplication] cancelAllLocalNotifications];
////    
////    self.redButton.enabled = NO;
////    self.blueButton.enabled = NO;
////        
////    self.pfObject = [PFObject objectWithClassName:self.className];
////    PFQuery *query = [PFQuery queryWithClassName:self.className];
////    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
////        if (!error) {
////            // The find succeeded.
////            if (objects) {
////                if (objects) {
////                    NSLog(@"Successfully retrieved %d scores.", objects.count);
////                    for (PFObject *object in objects) {
////                        NSLog(@"object: %@", object);
////                        self.firstRecord = object;
////                    }
////                }
////                [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:NO];
////            }
////        } else {
////            // Log details of the failure
////            NSLog(@"Error: %@ %@", error, [error userInfo]);
////        }
////    }];
////}
//
////- (void)setFirstRecord:(PFObject *)newFirstRecord {
////    
////    if (_firstRecord != newFirstRecord)  {
////        
////        //[[UIApplication sharedApplication] cancelAllLocalNotifications];
////        [MainViewController cancelLocalNotificationForID:kPicklineNotificationID];
////        _firstRecord = newFirstRecord;
////        
////        NSDate* fireDate = [_firstRecord objectForKey:kBandageFireDateColumn];
////        if (fireDate)
////            [MainViewController createAlarmforDate:fireDate
////                                  withInterval:0 withBody:kBandageAlertBody andID:kPicklineNotificationID];
////        
////        fireDate = [_firstRecord objectForKey:kVentilesFireDateColumn];
////        if (fireDate)
////            [MainViewController createAlarmforDate:fireDate
////                                  withInterval:0 withBody:kVentilesAlertBody andID:kPicklineNotificationID];
////    }
////}
//
//- (void)setPicklineEntity:(PicklineEntity *)newPicklineEntity {
//    
//    if (_picklineEntity != newPicklineEntity)  {
//        
//        //[[UIApplication sharedApplication] cancelAllLocalNotifications];
//        [MainViewController cancelLocalNotificationForID:kPicklineNotificationID];
//        _picklineEntity = newPicklineEntity;
//        
//        NSDate* fireDate = _picklineEntity.bandageFireDate;
//        if (fireDate)
//            [MainViewController createAlarmforDate:fireDate
//                                      withInterval:0 withBody:kBandageAlertBody andID:kPicklineNotificationID];
//        
//        fireDate = _picklineEntity.ventilesFireDate;
//        if (fireDate)
//            [MainViewController createAlarmforDate:fireDate
//                                      withInterval:0 withBody:kVentilesAlertBody andID:kPicklineNotificationID];
//    }
//}
//
//- (void)updateUI {
//    
//    self.redLastWashDateLabel.text = [MainViewController stringFromDate:self.picklineEntity.redLastWashDate withFormat:kDateFormatterNoYearType];
//    [self setRedNextDate:self.picklineEntity.redLastWashDate];
//    
//    self.blueLastWashDateLabel.text = [MainViewController stringFromDate:self.picklineEntity.blueLastWashDate withFormat:kDateFormatterNoYearType];
//    [self setBlueNextDate:self.picklineEntity.blueLastWashDate];
//    
//    self.ventilsLastReplacedDateLabel.text = [MainViewController stringFromDate:self.picklineEntity.ventilesLastReplacedDate withFormat:kDateFormatterNoTimeNoYearType];
//    [self setVentilesNextDate:self.picklineEntity.ventilesLastReplacedDate];
//    
//    bandageNumOfDays = self.picklineEntity.bandageIntervalDays;
//    [self.bandageSegmentedControl setSelectedSegmentIndex:(bandageNumOfDays == 2) ? 0 : 1];
//    
//    self.bandageLastReplacedDateLabel.text = [MainViewController stringFromDate:self.picklineEntity.bandageLastReplacedDate withFormat:kDateFormatterNoTimeNoYearType];
//    [self setBandageNextDate:self.picklineEntity.bandageLastReplacedDate];
//}
//
//- (void)setRedNextDate:(NSDate*)lastDate {
//    
//    int interval = 60*60*4; // 4 hours
//    if ([lastDate timeIntervalSinceNow] < -interval) {
//        self.redInfoLabel.text = @"ניתן לשימוש";
//        self.redNextWashDateLabel.text = @"";
//        self.redInfoLabel.textColor = [UIColor colorWithRed:24/255.0 green:153/255.0 blue:14/255.0 alpha:1.0];
//        self.redButton.enabled = YES;
//    }
//    else {
//        NSDate* nextDate = [lastDate dateByAddingTimeInterval:interval];
//        self.redNextWashDateLabel.text = [MainViewController stringFromDate:nextDate withFormat:kDateFormatterNoYearType];
//        //self.redNextWashDateLabel.text = [ViewController stringFromDate:nextDate showYear:NO showTime:YES];
//        self.redInfoLabel.text = @"לא להשתמש עד:";
//        self.redInfoLabel.textColor = [UIColor redColor];
//        self.redButton.enabled = NO;
//    }
//
//}
//
//- (void)setBlueNextDate:(NSDate*)lastDate {
//    
//    int interval = 60*60*4; // 4 hours
//    if ([lastDate timeIntervalSinceNow] < -interval) {
//        self.blueInfoLabel.text = @"ניתן לשימוש";
//        self.blueNextWashDateLabel.text = @"";
//        self.blueInfoLabel.textColor = [UIColor colorWithRed:24/255.0 green:153/255.0 blue:14/255.0 alpha:1.0];
//        self.blueButton.enabled = YES;
//    }
//    else {
//        NSDate* nextDate = [lastDate dateByAddingTimeInterval:interval];
//        self.blueNextWashDateLabel.text = [MainViewController stringFromDate:nextDate withFormat:kDateFormatterNoYearType];
//        //self.blueNextWashDateLabel.text = [ViewController stringFromDate:nextDate showYear:NO showTime:YES];
//        self.blueInfoLabel.text = @"לא להשתמש עד:";
//        self.blueInfoLabel.textColor = [UIColor redColor];
//        self.blueButton.enabled = NO;
//    }
//}
//
//- (NSDate*)setHourForDate:(NSDate*)date {
//    
//    NSLog(@"date: %@", date);
//                        
//    NSDateComponents *dateComponents =
//    [[NSCalendar currentCalendar] components:(NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit
//                                              |NSWeekCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:date];
//    
//    [dateComponents setHour:7];
//    [dateComponents setMinute:45];
//    [dateComponents setSecond:0];
//    NSLog(@"date: %@", [[NSCalendar currentCalendar] dateFromComponents:dateComponents]);
//    return [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
//}
//
//- (NSDate*)setBandageNextDate:(NSDate*)lastDate {
//    
//    //NSDate* nextDate = [lastDate dateByAddingTimeInterval:60*60*24*bandageNumOfDays];
//    NSDate* nextDate = [self.picklineEntity getBandageNextDate];
//    nextDate = [self setHourForDate:nextDate];
//    self.bandageNextReplaceDateLabel.text = [MainViewController stringFromDate:nextDate withFormat:kDateFormatterNoTimeNoYearType];
//
//    if ([nextDate isToday]) { //([nextDate timeIntervalSinceNow] < 0 && ![MainViewController isToday:nextDate]) {  // earlier than today
//        self.bandageNextReplaceDateLabel.font = [UIFont systemFontOfSize:15];
//        self.bandageNextReplaceDateLabel.textColor = [UIColor redColor];
//    }
//    else {
//        
//        self.bandageNextReplaceDateLabel.font = [UIFont boldSystemFontOfSize:15];
//        if ([nextDate isToday]) { //([MainViewController isToday:nextDate]) {
//            self.bandageNextReplaceDateLabel.text = @"היום";
//            self.bandageNextReplaceDateLabel.textColor = [UIColor orangeColor];
//        }
//        else {
//            if ([nextDate isToday]) //([nextDate isTomorrow]) //([nextDate isTomorrow]) //([MainViewController isTommorow:nextDate])
//                self.bandageNextReplaceDateLabel.text = @"מחר";
//            self.bandageNextReplaceDateLabel.textColor = [UIColor colorWithRed:24/255.0 green:153/255.0 blue:14/255.0 alpha:1.0];
//        }
//    }
//    return nextDate;
//}
//
//- (NSDate*)setVentilesNextDate:(NSDate*)lastDate {
//    
//    NSDate* nextDate = [self.picklineEntity getVentilesNextDate];
//    //NSDate* nextDate = [lastDate dateByAddingTimeInterval:60*60*24*kVentilesIntervalDays];
//    nextDate = [self setHourForDate:nextDate];
//    self.ventilsNextReplaceDateLabel.text = [MainViewController stringFromDate:nextDate withFormat:kDateFormatterNoTimeNoYearType];
//    //[ViewController stringFromDate:nextDate showYear:NO showTime:NO];
//    if ([nextDate timeIntervalSinceNow] < 0 && ![nextDate isToday]) {  // earlier than today
//        
//        self.bandageNextReplaceDateLabel.font = [UIFont systemFontOfSize:15];
//        self.ventilsNextReplaceDateLabel.textColor = [UIColor redColor];
//    }
//    else {
//        
//        self.ventilsNextReplaceDateLabel.font = [UIFont boldSystemFontOfSize:15];
//        if ([nextDate isToday]) { //([MainViewController isToday:nextDate]) {
//            self.ventilsNextReplaceDateLabel.text = @"היום";
//            self.ventilsNextReplaceDateLabel.textColor = [UIColor orangeColor];
//        }
//        else {
//            if ([nextDate isTomorrow]) //([MainViewController isTommorow:nextDate])
//                self.ventilsNextReplaceDateLabel.text = @"מחר";
//            self.ventilsNextReplaceDateLabel.textColor = [UIColor colorWithRed:24/255.0 green:153/255.0 blue:14/255.0 alpha:1.0];
//        }
//    }
//    return nextDate;
//}
//
//
//- (IBAction)bandageSegementedControl:(id)sender {
//    
//    bandageNumOfDays = [[self.bandageSegmentedControl titleForSegmentAtIndex:self.bandageSegmentedControl.selectedSegmentIndex] intValue];
//    [self setBandageNextDate:self.picklineEntity.bandageLastReplacedDate];
//    self.picklineEntity.bandageIntervalDays = bandageNumOfDays;
//   // [self.firstRecord setObject:[NSNumber numberWithInt:bandageNumOfDays] forKey:kBandageReplacementIntervalColumn];
//    [self.picklineEntity saveInBackground];
//}
//
//- (IBAction)redPickWashButton:(id)sender {
//    
//    self.picklineEntity.redLastWashDate = [NSDate date];
////    [self.firstRecord setObject:[NSDate date] forKey:kRedLastWashDateColumn];
//    self.redLastWashDateLabel.text = [MainViewController stringFromDate:self.picklineEntity.redLastWashDate withFormat:kDateFormatterNoYearType];
//    //self.redLastWashDateLabel.text = [ViewController stringFromDate:[self.firstRecord objectForKey:kRedLastWashDateColumn] showYear:NO showTime:YES];
//    [self setRedNextDate:self.picklineEntity.redLastWashDate];
//    [self.picklineEntity saveInBackground];
//}
//
//- (IBAction)bluePickWashButton:(id)sender {
//    
//    self.picklineEntity.blueLastWashDate = [NSDate date];
//    //[self.firstRecord setObject:[NSDate date] forKey:kBlueLastWashDateColumn];
//    self.blueLastWashDateLabel.text = [MainViewController stringFromDate:self.picklineEntity.blueLastWashDate withFormat:kDateFormatterNoYearType];
//    //[ViewController stringFromDate:[self.firstRecord objectForKey:kBlueLastWashDateColumn] showYear:NO showTime:YES];
//    [self setBlueNextDate:self.picklineEntity.blueLastWashDate];
//    [self.picklineEntity saveInBackground];
//}
//
//- (IBAction)bandageReplaceButton:(id)sender {
//    
//    self.picklineEntity.bandageLastReplacedDate = [NSDate date];
////    [self.firstRecord setObject:[NSDate date] forKey:kBandageReplacementDateColumn];
//    self.bandageLastReplacedDateLabel.text = [MainViewController stringFromDate:self.picklineEntity.bandageLastReplacedDate withFormat:kDateFormatterNoTimeNoYearType];
//    //[ViewController stringFromDate:[self.firstRecord objectForKey:kBandageReplacementDateColumn] showYear:NO showTime:NO];
//    NSDate* nextDate = [self setBandageNextDate:self.picklineEntity.bandageLastReplacedDate];
//    
//    // remove current alarm
//    if (self.bandageLocalNotification)
//        [[UIApplication sharedApplication] cancelLocalNotification:self.bandageLocalNotification];
//    
//    // create new alarm
//    self.bandageLocalNotification = [MainViewController createAlarmforDate:nextDate withInterval:0 withBody:kBandageAlertBody andID:kPicklineNotificationID];
//    
//    // save alaram to DB
//    self.picklineEntity.bandageFireDate = self.bandageLocalNotification.fireDate;
////    [self.firstRecord setObject:self.bandageLocalNotification.fireDate forKey:kBandageFireDateColumn];
//    //[self.firstRecord setObject:[NSNumber numberWithInt:self.bandageLocalNotification.repeatInterval] forKey:kBandageAlarmIntervalColumn];
//    
//    // save record
//    [self.picklineEntity saveInBackground];
//}
//
//- (IBAction)ventilsReplaceButton:(id)sender {
//    
//    self.picklineEntity.ventilesLastReplacedDate = [NSDate date];
////    [self.firstRecord setObject:[NSDate date] forKey:kVentilesReplacementDateColumn];
//    self.ventilsLastReplacedDateLabel.text = [MainViewController stringFromDate:self.picklineEntity.ventilesLastReplacedDate withFormat:kDateFormatterNoTimeNoYearType];
//    //[ViewController stringFromDate:self.picklineEntity.ventilesLastReplacedDate showYear:NO showTime:NO];
//    NSDate* nextDate = [self setVentilesNextDate:self.picklineEntity.ventilesLastReplacedDate];
//    
//    // remove current alarm
//    if (self.ventilesLocalNotification)
//        [[UIApplication sharedApplication] cancelLocalNotification:self.ventilesLocalNotification];
//    
//    // create new alarm
//    self.ventilesLocalNotification = [MainViewController createAlarmforDate:nextDate withInterval:0 withBody:kVentilesAlertBody andID:kPicklineNotificationID];
//    
//    // save alaram to DB
//    self.picklineEntity.ventilesFireDate = self.ventilesLocalNotification.fireDate;
////    [self.firstRecord setObject:self.ventilesLocalNotification.fireDate forKey:kVentilesFireDateColumn];
//    //[self.firstRecord setObject:[NSNumber numberWithInt:self.ventilesLocalNotification.repeatInterval] forKey:kVentilesAlarmIntervalColumn];
//    
//    // save record
//    [self.picklineEntity saveInBackground];
//}
//
//- (IBAction)refreshClicked:(id)sender {
//    
//    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//    [delegate refreshData];
//}
//
//@end
