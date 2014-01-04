//
//  DatePickerViewController.m
//  Clexane
//
//  Created by David Sayag on 10/18/13.
//  Copyright (c) 2013 David Sayag. All rights reserved.
//

#import "DatePickerViewController.h"
#import "NSDate-Utilities.h"

@interface DatePickerViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *picker;

@end

@implementation DatePickerViewController

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
	
    // set save button
    UIBarButtonItem* saveButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveClicked:)];
    self.navigationItem.rightBarButtonItem = saveButtonItem;
    
    if (self.isDaysPicker) {
        self.picker.datePickerMode = UIDatePickerModeDate;
        self.picker.minimumDate = self.pickerHour;
        self.picker.maximumDate = [self.pickerHour dateByAddingDays:7];
    }
    
    if (self.pickerHour)
        self.picker.date = self.pickerHour;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveClicked:(id)sender {
    
    [self.delegate doneClicked:[self.picker date]];
}

@end
