//
//  SignupViewController.m
//  Clexane
//
//  Created by David Sayag on 1/4/14.
//  Copyright (c) 2014 David Sayag. All rights reserved.
//

#import "SignupViewController.h"
#import "AppDelegate.h"
#import "SIAlertView.h"
#import "ModelManager.h"

@interface SignupViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *pswdTextField;
@property (weak, nonatomic) IBOutlet UITextField *verifyTextField;

@property (strong, nonatomic) User* user;

- (IBAction)signupClicked:(id)sender;
@end

@implementation SignupViewController

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
    [self.emailTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Private Methods

- (User*)user {
    
    if (!_user) {
        _user = [[User alloc] init];
        _user.email = self.emailTextField.text;
        _user.password = self.pswdTextField.text;
    }
    return _user;
}

#pragma mark - handlers

- (IBAction)signupClicked:(id)sender {
    
    BOOL failed = NO;
    NSString* errMsg = @"";
    if (self.emailTextField.text.length == 0) {
        failed = YES;
        errMsg = @"Email cannot be blank";
    }
    if (![self.pswdTextField.text isEqualToString:self.verifyTextField.text]) {
        failed = YES;
        errMsg = [NSString stringWithFormat:@"%@\n%@", errMsg, @"Passwords do not match."];
    }
    if (self.pswdTextField.text.length <4) {
        failed = YES;
        errMsg = [NSString stringWithFormat:@"%@\n%@", errMsg, @"Passwords cannot be less than 4 characters."];
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
    
    [delegate.modelManager signup:self.user delegate:self];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row == 0)
//		[self.cellTextField becomeFirstResponder];
}

#pragma mark - ModelManagerDelegate

- (void)loadingDoneForOpcode:(int)opCode response:(int)response object:(id)obj errMsg:(NSString*)msg {

    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (opCode == kOpCodeSignup)
        [delegate.modelManager login:self.user delegate:self];
    else if (opCode == kOpCodeLogin) {
    
        [[NSUserDefaults standardUserDefaults] setObject:self.user.email forKey:kUserDefaultsProfileEmailID];
        [[NSUserDefaults standardUserDefaults] setObject:self.user.password forKey:kUserDefaultsProfilePswdID];
        [delegate closeSignupController];
    }
}

@end
