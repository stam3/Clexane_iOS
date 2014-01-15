//
//  MedDatePair.m
//  Clexane
//
//  Created by David Sayag on 10/26/13.
//  Copyright (c) 2013 David Sayag. All rights reserved.
//

#import "MedDatePair.h"
#import "AppDelegate.h"
#import "NSDate-Utilities.h"

@implementation MedDatePair



- (id)initWithPFObject:(PFObject*)record {
    
    self = [super init];
    if (self) {
        self.isDone = YES;
        self.pairID = record.objectId;
        self.medicineID = [record objectForKey:kMedicineHistoryMedicineIDColumn1];
        self.actualHour = [record objectForKey:kMedicineHistoryActualHourColumn];
        self.type = [[record objectForKey:kMedicineHistoryTypeColumn1] intValue];
        self.isFirstHour = [[record objectForKey:kMedicineHistoryIsFirstHourColumn] boolValue];
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary*)record {
    
    self = [super init];
    if (self) {
        _isDone = YES;
        
        int recordId = [[record objectForKey:@"id"] intValue];
        _pairID = [NSString stringWithFormat:@"%d",recordId];
        
        int medId = [[record objectForKey:kMedicineHistoryMedicineIDColumn] intValue];
        _medicineID = [NSString stringWithFormat:@"%d",medId];

        _actualHour = [NSDate dateFromRFC822String:[record objectForKey:kMedicineHistoryActualHourColumn]];
        _type = [[record objectForKey:kMedicineHistoryTypeColumn] intValue];
        _isFirstHour = [[record objectForKey:kMedicineHistoryIsFirstHourColumn] boolValue];
    }
    return self;
}

- (void)setDate:(NSDate *)newDate {
    
    if (_date != newDate) {
        
        _date = [[NSDate date] dateWithTimeFrom:newDate];
    }
}

#pragma mark- ModelManagerDelegate methods

- (void)loadingDoneForOpcode:(int)opCode response:(int)response object:(id)obj msg:(NSString*)msg {
    
    self.pairID = ((MedDatePair*)obj).pairID;
}

@end
