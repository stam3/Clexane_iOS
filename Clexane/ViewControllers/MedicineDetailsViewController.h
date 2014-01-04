//
//  MedicineDetailsViewController.h
//  Clexane
//
//  Created by David Sayag on 10/19/13.
//  Copyright (c) 2013 David Sayag. All rights reserved.
//

#import "ViewController.h"
#import "MedicineEntity.h"
#import "AddOrEditMedicineViewController.h"

@interface MedicineDetailsViewController : UIViewController <AddOrEditMedicineViewControllerDelegate>

//@property (nonatomic, weak) id<AddOrEditMedicineViewControllerDelegate> delegate;
@property (nonatomic, weak) MedicineEntity* medicineEntity;

//- (void)setMedicineEntity:(MedicineEntity*)entity;


@end
