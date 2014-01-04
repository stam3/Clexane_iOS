//
//  NudnikViewController.h
//  Clexane
//
//  Created by David Sayag on 10/23/13.
//  Copyright (c) 2013 David Sayag. All rights reserved.
//

#import "ViewController.h"

@interface NudnikViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UILocalNotification* localNotification;

@end
