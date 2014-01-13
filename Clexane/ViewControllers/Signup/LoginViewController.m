//
//  LoginViewController.m
//  Clexane
//
//  Created by David Sayag on 1/6/14.
//  Copyright (c) 2014 David Sayag. All rights reserved.
//

#import "LoginViewController.h"
#import "User.h"
#import "SIAlertView.h"
#import "AppDelegate.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *pswdTextField;
- (IBAction)loginClicked:(id)sender;

@end

@implementation LoginViewController

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


/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

#pragma mark - handlers

- (IBAction)loginClicked:(id)sender {
    
    BOOL failed = NO;
    NSString* errMsg = @"";
    if (self.emailTextField.text.length == 0) {
        failed = YES;
        errMsg = @"Email cannot be blank";
    }
    if (self.pswdTextField.text.length == 0) {
        failed = YES;
        errMsg = [NSString stringWithFormat:@"%@\n%@", errMsg, @"Password cannot be blank"];
    }
    
    if (failed) {
        SIAlertView* alertView = [[SIAlertView alloc] initWithTitle:@"Failed"
                                                         andMessage:errMsg];
        [alertView addButtonWithTitle:@"OK"
                                 type:SIAlertViewButtonTypeDefault
                              handler:nil];
        [alertView show];
        return;
    }
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    User* user = [[User alloc] init];
    user.email = self.emailTextField.text;
    user.password = self.pswdTextField.text;
    [delegate.modelManager login:user delegate:self];
}

#pragma mark - ModelManagerDelegate

- (void)loadingDoneForOpcode:(int)opCode response:(int)response object:(id)obj errMsg:(NSString*)msg {

    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (opCode == kOpCodeLogin) {
        
        [[NSUserDefaults standardUserDefaults] setObject:self.emailTextField.text forKey:kUserDefaultsProfileEmailID];
        [[NSUserDefaults standardUserDefaults] setObject:self.pswdTextField.text forKey:kUserDefaultsProfilePswdID];
        [delegate closeSignupController];
    }
}

@end
