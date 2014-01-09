//
//  ModelManager.h
//  Clexane
//
//  Created by David Sayag on 10/24/13.
//  Copyright (c) 2013 David Sayag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PicklineEntity.h"
#import "MedDatePair.h"
#import "MedicineEntity.h"
#import "UrlLoader.h"
#import "User.h"
#import "ModelManagerDelegate.h"

//#import "AppDelegate.h"

#define kOpCodeLogin                1
#define kOpCodeSignup               2
#define kOpCodeMedicines            100
#define kOpCodeMedicineCreate       101
#define kOpCodePicklineShow         200
#define kOpCodeMedicineHistories    300
#define kOpCodeMedicineHistorieCreate    301


#define kProfilePicklineID          @"pickID"
#define kProfileEmailID             @"emailID"
#define kProfilePswdID              @"pswdID"

@interface ModelManager : NSObject <UrlLoaderDelegate>

@property (nonatomic, weak) id<ModelManagerDelegate> delegate;

@property (nonatomic, strong) NSMutableArray* medicineData;
@property (nonatomic, strong) PicklineEntity* picklineEntity;
@property (nonatomic, strong)  NSMutableArray* historyMedIDsArray;
//@property (nonatomic, strong) NSMutableArray* medicineHistoryData;

- (void)loadData;
- (void)loadHistoryData;
- (void)loadRailsHistoryData;
- (void)loadMedicineHistoryDataForMedicineID:(NSString*)medicineID;
- (void)updateDBWithPair:(MedDatePair*)pair;
- (NSString*)getMedicineNameByID:(NSString*)medID;

- (void)deleteMedicine:(MedicineEntity*)entity;
- (void)saveMedicineInDB:(MedicineEntity*)medicineEntity isNewRecord:(BOOL)isNewRecord;

// APIs
- (void)signup:(User*)user delegate:(id<ModelManagerDelegate>) delegate;
- (void)login:(User*)user delegate:(id<ModelManagerDelegate>) delegate;
- (void)loginExistingUserWithDelegate:(id<ModelManagerDelegate>) delegate;
- (void)updateMedicieRecord:(MedicineEntity*)entity;
- (void)createMedicieRecord:(MedicineEntity*)entity;
- (void)deleteMedicieRecord:(MedicineEntity*)entity;
- (void)updatePicklineRecord:(PicklineEntity*)entity;

@end
