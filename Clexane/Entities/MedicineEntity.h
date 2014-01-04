//
//  MedicineEntity.h
//  Clexane
//
//  Created by David Sayag on 10/18/13.
//  Copyright (c) 2013 David Sayag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

#define kNameColumn                     @"name"
#define kIsSpecificDaysColumn           @"isSpecificDays"
#define kSpecificDaysColumn             @"specificDays"
#define kDaysOffsetColumn               @"daysOffset"
#define kFirstHourColumn                @"firstHour"
#define kSecondHourColumn               @"secondHour"
#define kCanceledNotificationDateColumn       @"canceledNotificationDate"

//#define kFirstRepeatIntervalsColumn           @"firstRepeatIntervals"
//#define kFirstFireDatesColumn                 @"firstHourFireDates"
//#define kSecondRepeatIntervalsColumn     @"secondRepeatIntervals"
//#define kSecondFireDatesColumn           @"secondHourFireDates"
#define kDaysOffsetStartDateColumn          @"daysOffsetStartDate"

@interface MedicineEntity : NSObject

@property (nonatomic, strong) NSString* medicineID;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, readwrite) BOOL isSpecificDays;
@property (nonatomic, readwrite) int specificDays;  // binary notation
@property (nonatomic, readwrite) int daysOffset;
@property (nonatomic, strong) NSDate* firstHour;
@property (nonatomic, strong) NSDate* secondHour;
@property (nonatomic, strong) NSDate* daysOffsetStartDate;
@property (nonatomic, strong) NSDate* canceledNotificationDate;


@property (nonatomic, strong) NSMutableArray* localNotifications;
@property (nonatomic, strong) NSMutableArray* secondLocalNotifications;

- (id)initWithObject:(PFObject*)record;
- (id)initWithDictionary:(NSDictionary*)record;

- (NSString*)getNextTimeString;
- (NSDate*)getNextTimeDate;
- (NSArray*)getTodayDates;
- (NSArray*)getTomorrowDates;

- (void)refreshAlarms;

// DB methods
- (void)createRecord;
- (void)updateRecord;

@end
