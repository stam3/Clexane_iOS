//
//  AddOrEditMedicineViewController.m
//  Clexane
//
//  Created by David Sayag on 10/18/13.
//  Copyright (c) 2013 David Sayag. All rights reserved.
//

#import "AddOrEditMedicineViewController.h"
#import "DatePickerViewController.h"
#import "MedicineEntity.h"
#import "MainViewController.h"
#import "NSDate-Utilities.h"


#define kFixedDaysSetFirstHour      100
#define kFixedDaysSetSecondHour     101
#define kDaysOffsetSetFirstHour     102
#define kDaysOffsetStartDate        103

@interface AddOrEditMedicineViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UISwitch *fixedDaysSwitch;
@property (weak, nonatomic) IBOutlet UIView *fixedDaysBGView;
@property (weak, nonatomic) IBOutlet UISwitch *daysOfsetSwitch;
@property (weak, nonatomic) IBOutlet UIView *daysOfsetBGView;
@property (weak, nonatomic) IBOutlet UILabel *daysLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *daysSegmentedControl;
@property (weak, nonatomic) IBOutlet UIButton *resetSecondHourButton;
@property (weak, nonatomic) IBOutlet UIButton *fixedStartDayButton;

- (IBAction)fixedDaysSwitchValueChanges:(id)sender;
- (IBAction)daysOfsetSwitchValueChanges:(id)sender;
- (IBAction)dayButtonClicked:(id)sender;
- (IBAction)fixedDaysSetHourButtonClicked:(id)sender;
- (IBAction)daysOffsetSetHourButtonClicked:(id)sender;
- (IBAction)daysSegmentedControlValueChanged:(id)sender;
- (IBAction)resetSecondHourButtonClicked:(id)sender;
- (IBAction)fixedStartDayButtonClicked:(id)sender;
- (IBAction)bgClicked:(id)sender;

@property (nonatomic, strong)  NSString* className;

@end

@implementation AddOrEditMedicineViewController {
    
    int tagOfSetHourButton;
    BOOL isEditMode;
}

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

    [self setNavBar];
    if (self.medicineEntity) {
        self.fixedDaysSwitch.on = self.medicineEntity.isSpecificDays;
    }
    [self setControlsState];
    if (self.medicineEntity)
        self.nameTextField.text = self.medicineEntity.name;
    
    self.className = @"MedicineObject";
    if (debug) {
        self.className = @"MedicineTestObject";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)setMedicineEntity:(MedicineEntity*)entity {
//    
//    isEditMode = YES;
//    self.medicineEntity = entity;
//}

- (IBAction)fixedDaysSwitchValueChanges:(id)sender {
    
    [self.nameTextField resignFirstResponder];
    self.daysOfsetSwitch.on = !self.fixedDaysSwitch.on;
    [self setControlsState];
}

- (void)setNavBar {
    
    // set save button
    UIBarButtonItem* saveButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveClicked:)];
    self.navigationItem.rightBarButtonItem = saveButtonItem;
    
    // set cancel button
    UIBarButtonItem* cancelButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelClicked:)];
    self.navigationItem.leftBarButtonItem = cancelButtonItem;
}

- (IBAction)daysOfsetSwitchValueChanges:(id)sender {

    [self.nameTextField resignFirstResponder];
    self.fixedDaysSwitch.on = !self.daysOfsetSwitch.on;
     [self setControlsState];
}

- (IBAction)dayButtonClicked:(id)sender {
    
    [self.nameTextField resignFirstResponder];
    
    UIButton* button = (UIButton*)sender;
    if ((button.tag % 2) == 0) {
        
        // button not selected
        button.tag = button.tag + 1;
        button.titleLabel.font = [UIFont boldSystemFontOfSize:26];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    } else {
        
        button.tag = button.tag - 1;
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
//    
//    int selectedDays = 0;
//    for (int i=11; i<80; i+=10) {
//        
//        UIView* button = [self.view viewWithTag:i];
//        if (button) {
//            int x = (i-1)/10;
//            int y = pow(2, (x-1));
//            selectedDays |= y;
//        }
//    }
//    NSLog(@"selected days number: %d", selectedDays);
}

- (IBAction)fixedDaysSetHourButtonClicked:(id)sender {
    
    [self.nameTextField resignFirstResponder];
    
    UIView* v = (UIView*)sender;
    if (v.tag == kFixedDaysSetFirstHour)
        tagOfSetHourButton = kFixedDaysSetFirstHour;
    else
        tagOfSetHourButton = kFixedDaysSetSecondHour;
}

- (IBAction)daysOffsetSetHourButtonClicked:(id)sender {
    
    [self.nameTextField resignFirstResponder];
    tagOfSetHourButton = kDaysOffsetSetFirstHour;
}

- (IBAction)daysSegmentedControlValueChanged:(id)sender {
    
    self.daysLabel.text = [self.daysSegmentedControl titleForSegmentAtIndex:[self.daysSegmentedControl selectedSegmentIndex]];
}

- (IBAction)resetSecondHourButtonClicked:(id)sender {
    
    [self.nameTextField resignFirstResponder];
    UIButton* btn = (UIButton*)[self.view viewWithTag:kFixedDaysSetSecondHour];
    [btn setTitle:@"קבע שעה נוספת" forState:UIControlStateNormal];
    self.medicineEntity.secondHour = nil;
    self.resetSecondHourButton.enabled = NO;
    
}

- (IBAction)fixedStartDayButtonClicked:(id)sender {
    
    [self.nameTextField resignFirstResponder];
    tagOfSetHourButton = kDaysOffsetStartDate;
}

- (IBAction)bgClicked:(id)sender {
    
    [self.nameTextField resignFirstResponder];
}

- (void)setControlsState {
    
    for (UIControl* control in [self.fixedDaysBGView subviews]) {
        
        if (control != self.fixedDaysSwitch)
            control.enabled = self.fixedDaysSwitch.on;
    }
    for (UIControl* control in [self.daysOfsetBGView subviews]) {
        
        if (control != self.daysOfsetSwitch)
            control.enabled = !self.fixedDaysSwitch.on;
    }
    self.daysOfsetSwitch.on = !self.fixedDaysSwitch.on;
    
    self.resetSecondHourButton.enabled = NO;
    
    if (self.medicineEntity) {
        
        // set hours
        
        UIButton* setHourButton;
        if (self.medicineEntity.isSpecificDays) {
            setHourButton = (UIButton*)[self.view viewWithTag:kFixedDaysSetFirstHour];
            [setHourButton setTitle:[MainViewController stringFromDate:self.medicineEntity.firstHour withFormat:kDateFormatterHourType] forState:UIControlStateNormal];
            if (self.medicineEntity.secondHour) {
                setHourButton = (UIButton*)[self.view viewWithTag:kFixedDaysSetSecondHour];
                [setHourButton setTitle:[MainViewController stringFromDate:self.medicineEntity.secondHour withFormat:kDateFormatterHourType] forState:UIControlStateNormal];
            }
        } else {
            setHourButton = (UIButton*)[self.view viewWithTag:kDaysOffsetSetFirstHour];
            [setHourButton setTitle:[MainViewController stringFromDate:self.medicineEntity.firstHour withFormat:kDateFormatterHourType] forState:UIControlStateNormal];
            self.daysLabel.text = [NSString stringWithFormat:@"%d", self.medicineEntity.daysOffset];
            [self.daysSegmentedControl setSelectedSegmentIndex:self.medicineEntity.daysOffset-1];
            [self.fixedStartDayButton setTitle:[MainViewController stringFromDate:self.medicineEntity.daysOffsetStartDate withFormat:kDateFormatterNoTimeType] forState:UIControlStateNormal];
        }
        
        if (self.medicineEntity.secondHour)
            self.resetSecondHourButton.enabled = YES;
        
        // set selected days
        for (int i=10; i<80; i+=10) {
            
            UIButton* button = (UIButton*)[self.view viewWithTag:i];
            if (button) {
                int x = (i-1)/10;
                int y = pow(2, (x));
                if (y&self.medicineEntity.specificDays)
                    [self dayButtonClicked:button];
            }
        }
    }
}

- (IBAction)saveClicked:(id)sender {
    
    [self.nameTextField resignFirstResponder];
    
    BOOL newRecord = NO;
    if (self.medicineEntity == nil) {
        self.medicineEntity = [[MedicineEntity alloc] init];
        newRecord = YES;
    }
    
    self.medicineEntity.name = self.nameTextField.text;
    self.medicineEntity.isSpecificDays = self.fixedDaysSwitch.on;
    
    UIButton* setHourButton;
    if (self.medicineEntity.isSpecificDays) {
        setHourButton = (UIButton*)[self.view viewWithTag:kFixedDaysSetFirstHour];
        if (setHourButton)
            self.medicineEntity.firstHour = [MainViewController dateFromString:setHourButton.titleLabel.text withFormat:kDateFormatterHourType];
        setHourButton = (UIButton*)[self.view viewWithTag:kFixedDaysSetSecondHour];
        if (setHourButton)
            self.medicineEntity.secondHour = [MainViewController dateFromString:setHourButton.titleLabel.text withFormat:kDateFormatterHourType];
        
        int selectedDays = 0;
        for (int i=11; i<80; i+=10) {
            
            UIView* button = [self.view viewWithTag:i];
            if (button) {
                int x = (i-1)/10;
                int y = pow(2, (x-1));
                selectedDays |= y;
            }
        }
        self.medicineEntity.specificDays = selectedDays;
       // NSLog(@"selected days number: %d", selectedDays);
        
    } else {
    
        setHourButton = (UIButton*)[self.view viewWithTag:kDaysOffsetSetFirstHour];
        if (setHourButton)
            self.medicineEntity.firstHour = [MainViewController dateFromString:setHourButton.titleLabel.text withFormat:kDateFormatterHourType];
        setHourButton = (UIButton*)[self.view viewWithTag:kDaysOffsetStartDate];
        if (setHourButton) {
            NSDate* date = [MainViewController dateFromString:setHourButton.titleLabel.text withFormat:kDateFormatterNoTimeType];
            self.medicineEntity.daysOffsetStartDate = [date dateWithTimeFrom:self.medicineEntity.firstHour];
        }
        self.medicineEntity.daysOffset = [self.daysLabel.text intValue];
    }
    
    [self saveMedicineInDBWithNewRecord:newRecord];
    [self.medicineEntity refreshAlarms];
    [self updateDelegate];
}

//- (void)setAlarms {
//    
//    [self.medicineEntity.localNotifications removeAllObjects];
//    [self.medicineEntity.secondLocalNotifications removeAllObjects];
//    
//    for (int i=11   ; i<80; i+=10) {
//        
//        UIButton* button = (UIButton*)[self.view viewWithTag:i];
//        if (button) {
//            int weedDay = (i-1)/10;
//            NSDate* alarmDate = [self getNextDateForWeekDay:weedDay hour:self.medicineEntity.firstHour];
//            UILocalNotification* localNotification = [self setLocalNotificationForDate:alarmDate isFirstHour:YES];
//            [self.medicineEntity.localNotifications addObject:localNotification];
//            if (self.medicineEntity.secondHour) {
//                alarmDate = [self getNextDateForWeekDay:weedDay hour:self.medicineEntity.secondHour];
//                localNotification = [self setLocalNotificationForDate:alarmDate isFirstHour:NO];
//                [self.medicineEntity.secondLocalNotifications addObject:localNotification];
//            }
//        }
//    }
//}

- (UILocalNotification*)setLocalNotificationForDate:(NSDate*)alarmDate isFirstHour:(BOOL)isFirstHour {
    
    NSString* hour = [MainViewController stringFromDate:(isFirstHour) ? self.medicineEntity.firstHour : self.medicineEntity.secondHour withFormat:kDateFormatterHourType];
    NSString* alertBody = [NSString stringWithFormat:@"(%@) - %@", hour, self.medicineEntity.name];
    return [MainViewController createAlarmforDate:alarmDate
                              withInterval:NSWeekCalendarUnit
                                         withBody:alertBody
                                            withID:kMedicineNotificationID
                                      andUniqueID:self.medicineEntity.medicineID ];
}

- (NSDate*)getNextDateForWeekDay:(int)nextWeekDay hour:(NSDate*)hour {
    
   // NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    //[dateFormat setDateFormat:kDateFormat];
   // NSLog(@"Hour: %@", [dateFormat stringFromDate:hour]);
    
    NSDateComponents *hourComponents =
    [[NSCalendar currentCalendar] components:(NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:hour];
    
    NSDate* now = [NSDate date];
    
    NSDateComponents *nowComponents =
    [[NSCalendar currentCalendar] components:(NSDayCalendarUnit |
                                              NSWeekdayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit| NSHourCalendarUnit| NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:now];
    NSDateComponents *nextDateComponents = [nowComponents copy];
    //NSLog(@"next date: %@", [[NSCalendar currentCalendar] dateFromComponents:nextDateComponents]);
    
    int nowDay = [nowComponents day];
    int nowWeekday = [nowComponents weekday];
    
    [nextDateComponents setWeekday:nextWeekDay];
    int offsetDays = (nextWeekDay-nowWeekday);
    if (offsetDays == 0) {
        
        if ([nowComponents hour] > [hourComponents hour] || ([nowComponents hour] == [hourComponents hour] && [nowComponents minute] >= [hourComponents minute]))
            offsetDays = 7;
    }
    if (offsetDays < 0)
        offsetDays += 7;
    [nextDateComponents setDay:nowDay+offsetDays];
    [nextDateComponents setHour:[hourComponents hour]];
    [nextDateComponents setMinute:[hourComponents minute]];
    [nextDateComponents setSecond:0];
    
    NSDate* nextDate = [[NSCalendar currentCalendar] dateFromComponents:nextDateComponents];
    //NSLog(@"next date: %@", [dateFormat stringFromDate:nextDate]);
    return nextDate;
}

- (IBAction)cancelClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateDelegate {
    
    [self.delegate saveClicked:self.medicineEntity];
}

- (void)saveMedicineInDBWithNewRecord:(BOOL)isNewRecord {
    
    if (rails) {
        if (isNewRecord)
            [self.medicineEntity createRecord];
        else
            [self.medicineEntity updateRecord];
        return;
    }
    
    PFQuery *query = [PFQuery queryWithClassName:self.className];
    PFObject *medicieObject;
    if (isNewRecord)
        medicieObject = [PFObject objectWithClassName:self.className];
    else
        medicieObject = [query getObjectWithId:self.medicineEntity.medicineID];
    
    //NSLog(@"id: %@", medicieObject.);
    
    [medicieObject setObject:self.medicineEntity.name forKey:kNameColumn];
    [medicieObject setObject:[NSNumber numberWithBool:self.medicineEntity.isSpecificDays] forKey:kIsSpecificDaysColumn];
    [medicieObject setObject:[NSNumber numberWithInt:self.medicineEntity.specificDays] forKey:kSpecificDaysColumn];
    [medicieObject setObject:[NSNumber numberWithInt:self.medicineEntity.daysOffset] forKey:kDaysOffsetColumn];
    [medicieObject setObject:self.medicineEntity.firstHour forKey:kFirstHourColumn];
    if (!self.medicineEntity.isSpecificDays)
        if (self.medicineEntity.daysOffsetStartDate)
            [medicieObject setObject:self.medicineEntity.daysOffsetStartDate forKey:kDaysOffsetStartDateColumn];
    
    if (self.medicineEntity.secondHour) {
        [medicieObject setObject:self.medicineEntity.secondHour forKey:kSecondHourColumn];
        
    }
    else {
        [medicieObject removeObjectForKey:kSecondHourColumn];
    }
    
    [medicieObject save];
    self.medicineEntity.medicineID = medicieObject.objectId;
}

#pragma mark- DatePicker Delegate
- (void)doneClicked:(NSDate*)date {
    
    UIButton* setHourButton = (UIButton*)[self.view viewWithTag:tagOfSetHourButton];
    if (setHourButton) {
    
        NSString* btnTitle = (tagOfSetHourButton == kDaysOffsetStartDate) ?
                        [MainViewController stringFromDate:date withFormat:kDateFormatterNoTimeType] :
                        [MainViewController stringFromDate:date withFormat:kDateFormatterHourType];
        
        [setHourButton setTitle:btnTitle forState:UIControlStateNormal];
    }
    if (tagOfSetHourButton == kFixedDaysSetSecondHour)
        self.resetSecondHourButton.enabled = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Storyboard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"segue.identifier %@", segue.identifier);
	if ([segue.identifier isEqualToString:@"hourSet"])
	{
		//UINavigationController *navigationController = segue.destinationViewController;
		//DatePickerViewController *viewController = [[navigationController viewControllers] objectAtIndex:0];
		DatePickerViewController *viewController = segue.destinationViewController;
        viewController.delegate = self;
        
        switch (tagOfSetHourButton) {
            case kFixedDaysSetFirstHour:
            case kDaysOffsetSetFirstHour:
                viewController.pickerHour = self.medicineEntity.firstHour;
                break;
            case kFixedDaysSetSecondHour:
                viewController.pickerHour = self.medicineEntity.secondHour;
                break;
            case kDaysOffsetStartDate:
                viewController.isDaysPicker = YES;
                viewController.pickerHour = [NSDate date];
                break;
            default:
                break;
        }
	}
}

@end
