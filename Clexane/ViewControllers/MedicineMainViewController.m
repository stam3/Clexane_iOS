//
//  MedicineMainViewController.m
//  Clexane
//
//  Created by David Sayag on 10/18/13.
//  Copyright (c) 2013 David Sayag. All rights reserved.
//

#import "MedicineMainViewController.h"
#import "MedicineEntity.h"
#import "AddOrEditMedicineViewController.h"
#import "MedicineDetailsViewController.h"
#import "MainViewController.h"
#import "AppDelegate.h"

#define bAddButtonTag   99

@interface MedicineMainViewController ()

@property (weak, nonatomic) IBOutlet UITableView *table;

@property (nonatomic, strong) NSMutableArray* data;
@property (nonatomic, strong)  NSString* className;
- (IBAction)editClicked:(id)sender;

@end

@implementation MedicineMainViewController {
    
    int selectedRow;
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

    self.className = @"MedicineObject";
    if (debug)
        self.className = @"MedicineTestObject";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDataReady:) name:kMedicineNotificationName object:nil];
    
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (delegate.modelManager.medicineData) {
        self.data = delegate.modelManager.medicineData;
        [self updateTable];
    }
   // [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.table reloadData];
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
//    for (MedicineEntity* entity in self.data)
//        [entity refreshAlarms];
    [self updateTable];
}

//- (void)loadData {
//    
////    self.redButton.enabled = NO;
////    self.blueButton.enabled = NO;
//    
//    self.data = [[NSMutableArray alloc] init];
//    
//    //PFObject* pfObject = [PFObject objectWithClassName:self.className];
//    PFQuery *query = [PFQuery queryWithClassName:self.className];
//    [query orderByAscending:kNameColumn];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (!error) {
//            // The find succeeded.
//            if (objects) {
//                
//                NSLog(@"Successfully retrieved %d scores.", objects.count);
//                
//                //[[UIApplication sharedApplication] cancelAllLocalNotifications];
//                [MainViewController cancelAllLocalNotificationsForID:kMedicineNotificationID];
//                
//                for (PFObject *object in objects) {
//                    NSLog(@"object: %@", object);
//                    MedicineEntity* entity = [[MedicineEntity alloc] initWithObject:object];
//                    [self.data addObject:entity];
//                }
//                [self performSelectorOnMainThread:@selector(updateTable) withObject:nil waitUntilDone:NO];
//                NSLog(@"scheduledLocalNotifications: %@", [[UIApplication sharedApplication] scheduledLocalNotifications]);
//
//            }
//        } else {
//            // Log details of the failure
//            NSLog(@"Error: %@ %@", error, [error userInfo]);
//        }
//    }];
//}

- (void)updateTable {
    
    [self.table reloadData];
    [MainViewController logAllLocalNotificationsForID:kMedicineNotificationID];
}

- (void)deleteMedicine:(MedicineEntity*)entity {

    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate.modelManager deleteMedicine:entity];
    [self.data removeObject:entity];
}

- (IBAction)addButtonClicked:(id)sender {
    
    [self performSegueWithIdentifier:@"addMedicine" sender:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MedicineMainCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if ([indexPath row] == [self.data count]) {
        
        // add button
        UIButton* button = (UIButton*)[cell.contentView viewWithTag:bAddButtonTag];
        if (!button) {
            button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            button.frame =CGRectMake(100, 10, 150, 25);
            [button setTitle:@"הוסף" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(addButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = bAddButtonTag;
            [cell.contentView addSubview:button];
        }
        
        cell.textLabel.text = @"";
        cell.detailTextLabel.text = @"";
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else {
        
        MedicineEntity* entity = [self.data objectAtIndex:[indexPath row]];
        cell.textLabel.text = entity.name; //[self.data objectAtIndex:[indexPath row]];
        cell.detailTextLabel.text = [entity getNextTimeString]; //[NSString stringWithFormat:@"%d", entity.specificDays];
        UIView* button = [cell.contentView viewWithTag:bAddButtonTag];
        if (button)
            [button removeFromSuperview];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.data count] == 0)
        return;
    int row = [indexPath row];
    if (row != [self.data count])
        selectedRow = row;
    
    [self performSegueWithIdentifier:@"showMedicine" sender:self];
}


 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
     if ([indexPath row] == [self.data count])
         return NO;
     return YES;
 }



 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
     
     [self deleteMedicine:[self.data objectAtIndex:[indexPath row]]];
     
     [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
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


#pragma mark- AddOrEditMedicineViewControllerDelegate Delegate
- (void)saveClicked:(MedicineEntity *)entity {
    
    [self.data addObject:entity];
    [self.table reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Storyboard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"segue.identifier %@", segue.identifier);
	if ([segue.identifier isEqualToString:@"addMedicine"])
	{
		//UINavigationController *navigationController = segue.destinationViewController;
		//DatePickerViewController *viewController = [[navigationController viewControllers] objectAtIndex:0];
        AddOrEditMedicineViewController *viewController = segue.destinationViewController;
        viewController.delegate = self;
		
	} else { // showMedicine
        MedicineDetailsViewController *viewController = segue.destinationViewController;
        [viewController setMedicineEntity:[self.data objectAtIndex:selectedRow]];
    }
}

- (IBAction)editClicked:(id)sender {
    
    self.table.editing = !self.table.editing;
    UIBarButtonItem* btn = (UIBarButtonItem*)sender;
    if (self.table.editing) {
        [btn setTitle:@"Done"];
        btn.style = UIBarButtonItemStyleDone;
    }
    else {
        [btn setTitle:@"Edit"];
        btn.style = UIBarButtonItemStylePlain;
    }
}
@end
