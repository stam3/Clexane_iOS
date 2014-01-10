//
//  MedDatePair.h
//  Clexane
//
//  Created by David Sayag on 10/26/13.
//  Copyright (c) 2013 David Sayag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

#import "ModelManagerDelegate.h"

#define kMedicineHistoryMedicineIDColumn          @"medicine_id"
#define kMedicineHistoryTypeColumn          @"c_type"
#define kMedicineHistoryActualHourColumn    @"actualHour"
#define kMedicineHistoryIsFirstHourColumn    @"isFirstHour"

// pasrse.com
#define kMedicineHistoryMedicineIDColumn1          @"medicineID"
#define kMedicineHistoryTypeColumn1          @"type"


typedef enum {
    kHistoryMedType = 100,
    kHistoryBandageType,
    kHistoryBlueVentileType,
    kHistoryRedVentileType,
    kHistoryParparType
} HistoryType;

@interface MedDatePair : NSObject <ModelManagerDelegate>

@property (nonatomic, strong)       NSString*   name;
@property (nonatomic, strong)       NSString*   pairID;
@property (nonatomic, strong)       NSString*   medicineID;
@property (nonatomic, strong)       NSDate*     date;
@property (nonatomic, strong)       NSDate*     actualHour;
@property (nonatomic, readwrite)    BOOL        isDone;
@property (nonatomic, readwrite)    BOOL        isFirstHour;

@property (nonatomic, readwrite)    HistoryType        type;

- (id)initWithPFObject:(PFObject*)record;
- (id)initWithDictionary:(NSDictionary*)record;

@end
