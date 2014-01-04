//
//  MedicineDetailsViewController.m
//  Clexane
//
//  Created by David Sayag on 10/19/13.
//  Copyright (c) 2013 David Sayag. All rights reserved.
//

#import "MedicineDetailsViewController.h"
#import "AddOrEditMedicineViewController.h"
#import "MainViewController.h"
#import "AppDelegate.h"
#import "MedDatePair.h"
#import <Parse/Parse.h>

@interface MedicineDetailsViewController ()

@property (weak, nonatomic) IBOutlet UILabel        *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel        *daysLabel;
@property (weak, nonatomic) IBOutlet UILabel        *hoursLabel;
@property (weak, nonatomic) IBOutlet UILabel        *nextTimeLabel;
@property (weak, nonatomic) IBOutlet UITableView    *table;

- (IBAction)historyButtonClicked:(id)sender;

@property (nonatomic, strong)  NSArray *historyData;

@end

@implementation MedicineDetailsViewController

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
    
    [self historyButtonClicked:nil];

    self.nameLabel.text = @"";//self.medicineEntity.name;
    self.title = self.medicineEntity.name;
    
    // Hours
    NSString* hours;
    if (self.medicineEntity.secondHour) {
        hours = [NSString stringWithFormat:@"%@, %@",
                        [MainViewController stringFromDate:self.medicineEntity.firstHour withFormat:kDateFormatterHourType],
                        [MainViewController stringFromDate:self.medicineEntity.secondHour withFormat:kDateFormatterHourType]];
    } else {
        hours = [NSString stringWithFormat:@"%@",
                 [MainViewController stringFromDate:self.medicineEntity.firstHour withFormat:kDateFormatterHourType]];
        
    }
    self.hoursLabel.text = hours;
    
    // Selected days
    NSString* days = @"";
    if (self.medicineEntity.isSpecificDays) {
        NSString* space = @"";
        for (int i=0; i<7; i++) {
            
            int y = pow(2, (i));
            if (y & self.medicineEntity.specificDays) {
                
                NSString* str;
                switch (i) {
                    case 0:
                        str = @"א";
                        break;
                    case 1:
                        str = @"ב";
                        break;
                    case 2:
                        str = @"ג";
                        break;
                    case 3:
                        str = @"ד";
                        break;
                    case 4:
                        str = @"ה";
                        break;
                    case 5:
                        str = @"ו";
                        break;
                    case 6:
                        str = @"ש";
                        break;

                    default:
                        break;
                }
                days = [NSString stringWithFormat:@"%@%@%@", days, space, str];
                space = @", ";
            }
        }
    } else {
        days = [NSString stringWithFormat:@"כל %d ימים", self.medicineEntity.daysOffset];
    }
    self.daysLabel.text = days;
    
    self.nextTimeLabel.text = [self.medicineEntity getNextTimeString];
    
    if (debug) {
        NSArray* array = [MainViewController getAllLocalNotificationsForUniqueID:self.medicineEntity.medicineID];
        NSString* msg = @"";
        for (UILocalNotification* not in array) {
         
            msg = [NSString stringWithFormat:@"%@\n%@ type: %@, fire: %@", msg, self.medicineEntity.medicineID, [not.userInfo objectForKey:kNotificationIDKeyName], [MainViewController stringFromDate:not.fireDate withFormat:kDateFormatterNoYearType]];
    //        NSLog(@"notification type: %@, uniqueID: %@", (notID == kPicklineNotificationID) ? @"Pickline" : @"Medicine", notUniqueID);
        }
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"notifications" message:msg delegate:self cancelButtonTitle:@"אוקיי" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)setMedicineEntity:(MedicineEntity*)entity {
//    
//    self.medicineEntity = entity;
//}

#pragma mark - Storyboard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"segue.identifier %@", segue.identifier);
	if ([segue.identifier isEqualToString:@"editMedicine"])
	{
		//UINavigationController *navigationController = segue.destinationViewController;
		//DatePickerViewController *viewController = [[navigationController viewControllers] objectAtIndex:0];
		AddOrEditMedicineViewController *viewController = segue.destinationViewController;
        [viewController setMedicineEntity:self.medicineEntity];
        viewController.delegate = self;
	}
}


#pragma mark- AddOrEditMedicineViewControllerDelegate Delegate
- (void)saveClicked:(MedicineEntity *)entity {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)historyButtonClicked:(id)sender {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onHistoryDataReady:) name:kMedicineHistoryNotificationName object:nil];
    
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate.modelManager loadMedicineHistoryDataForMedicineID:self.medicineEntity.medicineID];
}

- (void)onHistoryDataReady:(NSNotification*)notification {
    
    self.historyData = [notification object];
//    [self updateUI];
    NSLog(@"historyData: %@", self.historyData);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kMedicineHistoryNotificationName object:nil];
    [self.table reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.historyData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"historyCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    int row = [indexPath row];
//    if (row % 2)
//        cell.contentView.backgroundColor = [UIColor lightGrayColor];
//    else
//        cell.contentView.backgroundColor = [UIColor whiteColor];
    
    MedDatePair* pair = [self.historyData objectAtIndex:row];
    cell.textLabel.text = [MainViewController stringFromDate:pair.actualHour withFormat:kDateFormatterFullType];
    
    return cell;
}

@end
