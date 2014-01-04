//
//  MainViewController.h
//  Clexane
//
//  Created by David Sayag on 10/12/13.refreshal

//  Copyright (c) 2013 David Sayag. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kClexaneMinHours            11
#define kClexaneQueryLimit          20
#define kMedicineHistoryQueryLimit  20

#define kAlertSoundName               @"bell_chimes.caf"
//@"notificationSound.caf"
#define kNotificationIDKeyName        @"notificationID"
#define kNotificationUniqueIDKeyName  @"notificationUniqueID"
#define kNotificationNameKeyName      @"notificationName"

#define kMedicineID                    @"MedicineID"

#define kPicklineNotificationID     0
#define kMedicineNotificationID     1

#define kVentilesIntervalDays       7

#define kMedicineNotificationName   @"MedicineNotification"
#define kPicklineNotificationName   @"PicklineNotification"
#define kCheckedItemsNotificationName   @"CheckedItemsNotification"
#define kMedicineHistoryNotificationName   @"MedicineHistoryNotification"
#define kNextNotificationCanceledNotificationName   @"NextAlertCanceledNotification"

#define kBandageAlertBody                       @"להחליף תחבושת היום"
#define kRedVentileAlertBody                      @"להחליף ונטיל אדום היום"
#define kBlueVentileAlertBody                      @"להחליף ונטיל כחול היום"
#define kParparAlertBody                      @"להחליף פרפר היום"

static const BOOL rails = 1;
static const BOOL debug = 1;

typedef enum {
    kDateFormatterFullType,
    kDateFormatterHourType,
    kDateFormatterNoTimeType,
    kDateFormatterNoYearType,
    kDateFormatterNoTimeNoYearType
} DateFormatterType;

@interface MainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

+ (NSString*)stringFromDate:(NSDate*)date withFormat:(int)formatType;
+ (NSString*)stringFromDate:(NSDate*)date withFormat:(int)formatType formatted:(BOOL)useTexts;
+ (NSDate*)dateFromString:(NSString*)strDate withFormat:(int)formatType;

+ (UILocalNotification*)createAlarmforDate:(NSDate*)fireDate withInterval:(NSCalendarUnit)interval withBody:(NSString*)alertBody withID:(int)notificationID andUniqueID:(NSString*)uniqueID;

+ (void)logAllLocalNotificationsForID:(int)notificationID;
+ (NSArray*)getAllLocalNotificationsForUniqueID:(NSString*)uniqueID;

+ (void)cancelAllLocalNotificationsForID:(int)notificationID;
+ (void)cancelAllLocalNotificationsForID:(int)notificationID andUniqueID:(NSString*)uniqueID;
//+ (void)cancelNextLocalNotificationForID:(int)notificationID andUniqueID:(NSString*)uniqueID;

+ (BOOL)isDate:(NSDate*)someDate earlierThanDate:(NSDate*)anotherDate;
+ (NSDate*)getTodaysStartDate;
+ (NSDate*)getTodaysEndDate;

@end
