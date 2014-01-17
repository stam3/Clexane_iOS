//
//  AddOrEditMedicineViewController.h
//  Clexane
//
//  Created by David Sayag on 10/18/13.
//  Copyright (c) 2013 David Sayag. All rights reserved.
//

//#import "ViewController.h"
#import "DatePickerViewController.h"
#import "MedicineEntity.h"

@protocol AddOrEditMedicineViewControllerDelegate <NSObject>

- (void)saveClicked:(MedicineEntity*)entity;

@end

@interface AddOrEditMedicineViewController : UIViewController <DatePickerViewControllerDelegate>

@property (nonatomic, weak) id<AddOrEditMedicineViewControllerDelegate> delegate;
@property (nonatomic, strong) MedicineEntity* medicineEntity;

//- (void)setMedicineEntity:(MedicineEntity*)entity;

@end
