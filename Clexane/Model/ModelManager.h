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

@protocol ModelManagerDelegate <NSObject>

- (void)saveClicked:(int)opCode result:(int)result errMsg:(NSString*)msg;

@end

@interface ModelManager : NSObject <UrlLoaderDelegate>

@property (nonatomic, weak) id<ModelManagerDelegate> delegate;

@property (nonatomic, strong) NSMutableArray* medicineData;
@property (nonatomic, strong) PicklineEntity* picklineEntity;
@property (nonatomic, strong)  NSMutableArray* historyMedIDsArray;
//@property (nonatomic, strong) NSMutableArray* medicineHistoryData;

- (void)loadData;
- (void)loadHistoryData;
- (void)loadMedicineHistoryDataForMedicineID:(NSString*)medicineID;
- (void)updateDBWithPair:(MedDatePair*)pair;
- (NSString*)getMedicineNameByID:(NSString*)medID;

- (void)deleteMedicine:(MedicineEntity*)entity;
- (void)saveMedicineInDB:(MedicineEntity*)medicineEntity isNewRecord:(BOOL)isNewRecord;


// APIs
- (void)signup:(User*)user;
- (void)updateMedicieRecord:(MedicineEntity*)entity;
- (void)createMedicieRecord:(MedicineEntity*)entity;
- (void)updatePicklineRecord:(PicklineEntity*)entity;

@end
