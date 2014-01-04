//
//  NudnikViewController.m
//  Clexane
//
//  Created by David Sayag on 10/23/13.
//  Copyright (c) 2013 David Sayag. All rights reserved.
//

#import "NudnikViewController.h"

@interface NudnikViewController ()

@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (nonatomic, strong) UIBarButtonItem* saveButtonItem;
@property (nonatomic, strong) NSArray* data;
@property (nonatomic, strong) NSArray* intervals;
@end

@implementation NudnikViewController

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

   // self.data = [NSArray arrayWithObjects:@"a", @"b",@"c",@"d",@"e",@"f", nil];
    self.data = @[@"בדיקה", @"חמש דקות", @"רבע שעה",@"חצי שעה",@"שעה",@"שעתיים",@"שלוש שעות",];
    self.intervals = @[[NSNumber numberWithInt:4],
                       [NSNumber numberWithInt:5*60],
                        [NSNumber numberWithInt:15*60],
                        [NSNumber numberWithInt:30*60],
                        [NSNumber numberWithInt:60*60],
                        [NSNumber numberWithInt:120*60],
                        [NSNumber numberWithInt:180*60]];
    
    // set save button
    self.saveButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveClicked:)];
    self.navigationItem.rightBarButtonItem = self.saveButtonItem;
     self.navigationItem.leftBarButtonItem = nil;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveClicked:(id)sender {
    
    [self.picker selectedRowInComponent:0];
    //NSDate* currentAlertDate = self.localNotification.fireDate;
    int interval = [[self.intervals objectAtIndex:[self.picker selectedRowInComponent:0]] intValue];
    self.localNotification.fireDate = [NSDate dateWithTimeInterval:interval sinceDate:[NSDate date]];
    if (![self.localNotification.alertBody hasPrefix:@"נודניק"])
        self.localNotification.alertBody = [NSString stringWithFormat:@"%@ :נודניק", self.localNotification.alertBody];
    
    self.localNotification.repeatInterval = 0;
    [[UIApplication sharedApplication] scheduleLocalNotification:self.localNotification];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- Picker Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [self.data count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return [self.data objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    
}


//numberOfComponentsInPickerView:
//numberOfRowsInComponent:
//
//rowHeightForComponent:
//widthForComponent:
//
//titleForRow:forComponent:
//viewForRow:forComponent:reusingView:
//


@end
