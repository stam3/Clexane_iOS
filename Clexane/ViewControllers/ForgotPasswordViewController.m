//
//  ForgotPasswordViewController.m
//  Clexane
//
//  Created by David Sayag on 1/15/14.
//  Copyright (c) 2014 David Sayag. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "AppDelegate.h"
#include "UtilsAndConstants.h"
#include "SIAlertView.h"

@interface ForgotPasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;

- (IBAction)resetButtonClicked:(id)sender;
- (IBAction)closedButtonClicked:(id)sender;

@end

@implementation ForgotPasswordViewController

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
//    NSLog(@"forgot pass url: %@", [NSString stringWithFormat:@"%@%@", kAPIBaseURL, kAPIForgotPasswordURL]);
//    NSURLRequest* request = [[NSURLRequest alloc] initWithURL:
//                             [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kAPIBaseURL, kAPIForgotPasswordURL]]];
//    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closedButtonClicked:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)resetButtonClicked:(id)sender {
    
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate.modelManager resetPassword:self.emailTextField.text delegate:self];
    self.resetButton.enabled = NO;
}

#pragma mark - ModelManagerDelegate

- (void)loadingDoneForOpcode:(int)opCode response:(int)response object:(id)obj msg:(NSString*)msg {
    
    NSString *message = (response == 200) ? [NSString stringWithFormat:
                                        @"Reset email sent to:%@. please follow the instructions in the email.",
                                         self.emailTextField.text] :
                                        [NSString stringWithFormat:
                                         @"Email address:%@ does not exist.",
                                         self.emailTextField.text];
    SIAlertView* alertView = [[SIAlertView alloc] initWithTitle:@""
                                                     andMessage:message];
    [alertView addButtonWithTitle:@"OK"
                             type:SIAlertViewButtonTypeDefault
                          handler:nil];
    [alertView show];
    
    if (response == 200)
        [self dismissViewControllerAnimated:YES completion:nil];
    else
        self.resetButton.enabled = YES;
}



@end
