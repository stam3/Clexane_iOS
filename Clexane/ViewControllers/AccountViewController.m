//
//  AccountViewController.m
//  Clexane
//
//  Created by David Sayag on 1/13/14.
//  Copyright (c) 2014 David Sayag. All rights reserved.
//

#import "AccountViewController.h"
#import "AppDelegate.h"

@interface AccountViewController ()

- (IBAction)logoutClicked:(id)sender;

@end

@implementation AccountViewController

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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"accountCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    cell.detailTextLabel.text = @"אימייל:";
    cell.textLabel.text = [delegate getUserEmail];
    // Configure the cell...
    
    return cell;
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}



- (IBAction)logoutClicked:(id)sender {

    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"Logout?"
                                                             delegate:self
                                                            cancelButtonTitle:@"Cancel"
                                                            destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Yes", nil];
    [actionSheet showInView:self.view];
}

#pragma merk- UIActionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex != [actionSheet cancelButtonIndex]) {
        
        AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [delegate logout];
    }
}

@end
