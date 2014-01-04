//
//  DatePickerViewController.h
//  Clexane
//
//  Created by David Sayag on 10/18/13.
//  Copyright (c) 2013 David Sayag. All rights reserved.
//

#import "ViewController.h"

@protocol DatePickerViewControllerDelegate <NSObject>

- (void)doneClicked:(NSDate*)date;

@end

@interface DatePickerViewController : UIViewController

@property (nonatomic, weak) id<DatePickerViewControllerDelegate> delegate;
@property (nonatomic, strong) NSDate* pickerHour;
@property (nonatomic, readwrite) BOOL isDaysPicker;

@end
