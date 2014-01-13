//
//  MedicineEntity.m
//  Clexane
//
//  Created by David Sayag on 10/18/13.
//  Copyright (c) 2013 David Sayag. All rights reserved.
//

#import "MedicineEntity.h"
#import "MainViewController.h"
#import "MedDatePair.h"
#import "NSDate-Utilities.h"
#import "AppDelegate.h"

@interface MedicineEntity ()

@end

@implementation MedicineEntity
//@synthesize localNotification = _localNotification;

- (id)init {
    
    self = [super init];
    if (self) {
        
        self.localNotifications = [[NSMutableArray alloc] init];
        self.secondLocalNotifications = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithObject:(PFObject*)record {
    
    self = [self init];
    if (self) {
        
        self.medicineID = record.objectId;
        self.isSpecificDays = [[record objectForKey:kIsSpecificDaysColumn] boolValue];
        self.name = [record objectForKey:kNameColumn];
        self.daysOffset = [[record objectForKey:kDaysOffsetColumn] intValue];
        self.specificDays = [[record objectForKey:kSpecificDaysColumn] intValue];
        self.firstHour = [record objectForKey:kFirstHourColumn];
        self.secondHour = [record objectForKey:kSecondHourColumn];
        self.daysOffsetStartDate = [record objectForKey:kDaysOffsetStartDateColumn];
        self.canceledNotificationDate = [record objectForKey:kCanceledNotificationDateColumn];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNextNotificationCanceled:) name:kNextNotificationCanceledNotificationName object:nil];
        [self refreshAlarms];
    }
    return self;
}

-(void) dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithDictionary:(NSDictionary*)record {

    self = [self init];
    if (self) {
        
        int recordId = [[record objectForKey:@"id"] intValue];
        _medicineID = [NSString stringWithFormat:@"%d",recordId];
        _isSpecificDays = [[record objectForKey:kIsSpecificDaysColumn] boolValue];
        _name = [record objectForKey:kNameColumn];
        _specificDays = [[record objectForKey:kSpecificDaysColumn] intValue];
        _firstHour = [NSDate dateFromRFC822String:[record objectForKey:kFirstHourColumn]];
        _secondHour = [NSDate dateFromRFC822String:[record objectForKey:kSecondHourColumn]];
        _daysOffsetStartDate = [NSDate dateFromRFC822String:[record objectForKey:kDaysOffsetStartDateColumn]];
        _canceledNotificationDate = [NSDate dateFromRFC822String:[record objectForKey:kCanceledNotificationDateColumn]];
        if (!_isSpecificDays)
            _daysOffset = [[record objectForKey:kDaysOffsetColumn] intValue];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNextNotificationCanceled:) name:kNextNotificationCanceledNotificationName object:nil];
        [self refreshAlarms];
    }
    return self;
}


- (void)setSecondHour:(NSDate *)newSecondHour {
    
    if (_secondHour != newSecondHour) {
        _secondHour = newSecondHour;
        if (!_secondHour) {
            
            for (UILocalNotification* notification in self.secondLocalNotifications) {
                
                [[UIApplication sharedApplication] cancelLocalNotification:notification];
            }
        }
    }
}

- (void)cancelMedicineCurrentLocalNotifications {
    
    for (UILocalNotification* notification in self.localNotifications) {
        
        [[UIApplication sharedApplication] cancelLocalNotification:notification];
    }
    [self.localNotifications removeAllObjects];
    
    for (UILocalNotification* notification in self.secondLocalNotifications) {
        
        [[UIApplication sharedApplication] cancelLocalNotification:notification];
    }
    [self.secondLocalNotifications removeAllObjects];
}

- (NSString*)getNextTimeString {
    
    if (self.isSpecificDays)
        return [MainViewController stringFromDate:[self getNextTimeDate] withFormat:kDateFormatterNoYearType];
    else
        return [MainViewController stringFromDate:[self getOffsetFirstDate] withFormat:kDateFormatterNoYearType];
}

- (NSDate*)getNextTimeDate {
    
    NSMutableArray* combinedArray = [[NSMutableArray alloc] initWithArray:self.localNotifications];
    for (UILocalNotification* notification in self.secondLocalNotifications) {
        [combinedArray addObject:notification];
    }
    
    NSDate* minDate;
    for (UILocalNotification* notification in combinedArray) {
        
        NSDate* date = notification.fireDate;
        if (!minDate)
            minDate = date;
        else
            minDate = [minDate earlierDate:date];
    }
    
    return minDate;
}

- (NSArray*)getTodayDates {
    
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    if (self.isSpecificDays) {
        NSDate* today = [NSDate date];
        NSDateComponents* components = [[NSCalendar currentCalendar] components:(NSWeekdayCalendarUnit) fromDate:today];
        
        int y = pow(2, ([components weekday]-1));
        if (y & self.specificDays) { // today
            
            MedDatePair* pair = [[MedDatePair alloc] init];
            pair.medicineID = self.medicineID;
            pair.isFirstHour = YES;
            pair.name = self.name;
            pair.date = self.firstHour;
            pair.type = kHistoryMedType;
            [array addObject:pair];
            
            if (self.secondHour) {
                
                pair = [[MedDatePair alloc] init];
                pair.medicineID = self.medicineID;
                pair.isFirstHour = NO;
                pair.name = self.name;
                pair.date = self.secondHour;
                pair.type = kHistoryMedType;
                [array addObject:pair];
            }
        }
    } else {
        NSDate* offsetTodaysDate = [self getOffsetTodaysDate];
        if (offsetTodaysDate) {
            
            MedDatePair* pair = [[MedDatePair alloc] init];
            pair.medicineID = self.medicineID;
            pair.isFirstHour = YES;
            pair.name = self.name;
            pair.date = self.firstHour;
            pair.type = kHistoryMedType;
            [array addObject:pair];
        }
    }
    
    return array;
}

- (NSArray*)getTomorrowDates {
    
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    if (self.isSpecificDays) {
        NSDate* today = [NSDate date];
        NSDateComponents* components = [[NSCalendar currentCalendar] components:(NSWeekdayCalendarUnit) fromDate:today];
        
        int y = pow(2, (([components weekday] == 7) ? 0 : [components weekday]));
        if (y & self.specificDays) { // today
            
            MedDatePair* pair = [[MedDatePair alloc] init];
            pair.medicineID = self.medicineID;
            pair.name = self.name;
            pair.date = self.firstHour;
            [array addObject:pair];
            
            if (self.secondHour) {
                
                pair = [[MedDatePair alloc] init];
                pair.medicineID = self.medicineID;
                pair.name = self.name;
                pair.date = self.secondHour;
                [array addObject:pair];
            }
        }
    } else {
        NSDate* offsetFirstDate = [self getOffsetFirstDate];
        if ([offsetFirstDate isTomorrow]) {
            
            MedDatePair* pair = [[MedDatePair alloc] init];
            pair.medicineID = self.medicineID;
            pair.isFirstHour = YES;
            pair.name = self.name;
            pair.date = self.firstHour;
            pair.type = kHistoryMedType;
            [array addObject:pair];
        }
    }
    
    return array;

}

//- (NSArray*)getTodayNotificationDates {
//    
//    NSMutableArray* array = [[NSMutableArray alloc] init];
//    NSMutableArray* combinedArray = [[NSMutableArray alloc] initWithArray:self.localNotifications];
//    for (UILocalNotification* notification in self.secondLocalNotifications) {
//        [combinedArray addObject:notification];
//    }
//    
//    for (UILocalNotification* notification in combinedArray) {
//        
//        if ([notification.fireDate isToday]) {//([MainViewController isToday:notification.fireDate]) {
//            MedDatePair* pair = [[MedDatePair alloc] init];
//            pair.medicineID = self.medicineID;
////            pair.name = self.name;
//            pair.date = notification.fireDate;
//            [array addObject:pair];
//        }
//    }
//    return array;
//}
//
//- (NSArray*)getTomorrowNotificationDates {
//    
//    NSMutableArray* array = [[NSMutableArray alloc] init];
//    NSMutableArray* combinedArray = [[NSMutableArray alloc] initWithArray:self.localNotifications];
//    for (UILocalNotification* notification in self.secondLocalNotifications) {
//        [combinedArray addObject:notification];
//    }
//    
//    for (UILocalNotification* notification in combinedArray) {
//        
////        if ([MainViewController isTommorow:notification.fireDate]) {
//        if ([notification.fireDate isTomorrow]) {
//        
//            MedDatePair* pair = [[MedDatePair alloc] init];
//            pair.medicineID = self.medicineID;
////            pair.name = self.name;
//            pair.date = notification.fireDate;
//            [array addObject:pair];
//        }
//    }
//    
//    return array;
//    //    NSLog(@"%@", array);
//    //    return [array sortedArrayUsingSelector:@selector(compare:)];
//    //    NSLog(@"%@", array);
//}

//- (NSArray*)getNextDatesForOffsetStartingAtDate:(NSDate*)date {
//    
//    NSMutableArray* array = [[NSMutableArray alloc] init];
//    for (int i=0; i < 10; i++) {
//        
//        NSDate* d = [date dateByAddingDays:i];
//        [array addObject:d];
//    }
//}


- (void)refreshAlarms {
    
    [self cancelMedicineCurrentLocalNotifications];
//    if ([self.medicineID isEqualToString:@"RS8gu21StD"])
     //   NSLog(@"temp");
    if (self.isSpecificDays) {
        // set selected days
        for (int weedDay=0; weedDay<7; weedDay++) {
            
            int y = pow(2, weedDay);
            if (y & self.specificDays) {
                
                NSDate* alarmDate = [self getNextDateForWeekDay:weedDay+1 hour:self.firstHour];
                UILocalNotification* localNotification = [self setLocalNotificationForDate:alarmDate isFirstHour:YES repeatInterval:NSWeekCalendarUnit];
                if (localNotification)
                    [self.localNotifications addObject:localNotification];
                if (self.secondHour) {
                    alarmDate = [self getNextDateForWeekDay:weedDay+1 hour:self.secondHour];
                    localNotification = [self setLocalNotificationForDate:alarmDate isFirstHour:NO repeatInterval:NSWeekCalendarUnit];
                    if (localNotification)
                        [self.secondLocalNotifications addObject:localNotification];
                }

            }
        }
    } else { // offset days
        
        //self.daysOffsetStartDate = [MainViewController dateFromString:@"Wed, oct 30, 13 - 12:00" withFormat:kDateFormatterFullType];
        
        NSDate* date = [self getOffsetFirstDate];
        
        for (int i=0; i < 9; i++) {
            
            NSLog(@"offset alarm: %@", [MainViewController stringFromDate:date withFormat:kDateFormatterFullType]);
            UILocalNotification* localNotification = [self setLocalNotificationForDate:date isFirstHour:YES repeatInterval:0];
            if (localNotification)
                [self.localNotifications addObject:localNotification];
            
            date = [date dateByAddingDays:self.daysOffset];
        }
    }
}

- (NSDate*)getOffsetTodaysDate {
    
    NSDate* now = [NSDate date];
    NSDate* date = self.daysOffsetStartDate;
    int passedDays = [date daysBeforeDate:[now dateWithTimeFrom:self.daysOffsetStartDate]];
    int mod = passedDays % self.daysOffset;
    if (mod < 0)
        mod = -mod;
    if (mod != 0) {
        date = nil;
    } else { //  = 0
        
        NSDate* today = [now dateWithTimeFrom:self.daysOffsetStartDate];
        if ([now isEarlierThanDate:today])
            date = today;
    }
    return date;
}

- (NSDate*)getOffsetFirstDate {
    
    NSDate* now = [NSDate date];
    NSDate* date = self.daysOffsetStartDate;
    int passedDays = [date daysBeforeDate:[now dateWithTimeFrom:self.daysOffsetStartDate]];
    int mod = passedDays % self.daysOffset;
    if (mod < 0)
        mod = -mod;
    if (mod != 0) {
        date = [now dateByAddingDays:(self.daysOffset-mod)];
        date = [date dateWithTimeFrom:self.daysOffsetStartDate];
    } else { //  = 0
        
        NSDate* today = [now dateWithTimeFrom:self.daysOffsetStartDate];
        if ([now isEarlierThanDate:today])
            date = today;
        else
            date = [today dateByAddingDays:self.daysOffset];
    }
    return date;
}

- (NSDate*)getNextDateForWeekDay:(int)nextWeekDay hour:(NSDate*)hour {
    
//    if ([self.name isEqualToString:@"זנטק"])
//        NSLog(@"DD");
    NSDateComponents *hourComponents =
    [[NSCalendar currentCalendar] components:(NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:hour];
    
    NSDate* now = [NSDate date];
    
    NSDateComponents *nowComponents =
    [[NSCalendar currentCalendar] components:(NSDayCalendarUnit |
                                              NSWeekdayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit| NSHourCalendarUnit| NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:now];
    NSDateComponents *nextDateComponents = [nowComponents copy];
    //NSLog(@"next date: %@", [[NSCalendar currentCalendar] dateFromComponents:nextDateComponents]);
    
    int nowDay = [nowComponents day];
    int nowWeekday = [nowComponents weekday];
    
    [nextDateComponents setWeekday:nextWeekDay];
    int offsetDays = (nextWeekDay-nowWeekday);
    if (offsetDays == 0) {
        
        if ([nowComponents hour] > [hourComponents hour] || ([nowComponents hour] == [hourComponents hour] && [nowComponents minute] >= [hourComponents minute]))
            offsetDays = 7;
    }
    if (offsetDays < 0)
        offsetDays += 7;
    [nextDateComponents setDay:nowDay+offsetDays];
    [nextDateComponents setHour:[hourComponents hour]];
    [nextDateComponents setMinute:[hourComponents minute]];
    [nextDateComponents setSecond:0];
    
    NSDate* nextDate = [[NSCalendar currentCalendar] dateFromComponents:nextDateComponents];
    return nextDate;
}

- (UILocalNotification*)setLocalNotificationForDate:(NSDate*)alarmDate isFirstHour:(BOOL)isFirstHour repeatInterval:(NSCalendarUnit)repeatInterval {
    
    if ([self.name isEqualToString:@"test1"])
        NSLog(@"SDS");
    if (self.canceledNotificationDate  &&  [alarmDate timeIntervalSinceDate:self.canceledNotificationDate] == 0)
        alarmDate = [alarmDate dateByAddingDays:7];
    
//    if ([self.medicineID isEqualToString:@"RS8gu21StD"])
//        NSLog(@"temp");
    NSString* hour = [MainViewController stringFromDate:(isFirstHour) ? self.firstHour : self.secondHour withFormat:kDateFormatterHourType];
    NSString* alertBody = [NSString stringWithFormat:@"(%@) - %@", hour, self.name];
   // NSLog(@"%@, alarmDate: %@, body: %@", self.name, alarmDate, alertBody);
    return [MainViewController createAlarmforDate:alarmDate
                                     withInterval:repeatInterval
                                         withBody:alertBody
                                            withID:kMedicineNotificationID
                                            andUniqueID:self.medicineID];
}

- (void)onNextNotificationCanceled:(NSNotification*)notification {
    
    //NSLog(@"onNextNotificationCanceled...");
    if (![[[notification userInfo] objectForKey:kMedicineID] isEqualToString:self.medicineID])
        return;
    self.canceledNotificationDate = [notification object];
    [self refreshAlarms];
    // save change
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate.modelManager saveMedicineInDB:self isNewRecord:NO];
}

//- (void)cancelLocalNotificationForDate:(NSDate*)fireDate {
//    
//    BOOL found = NO;
//    for (UILocalNotification* notification in self.localNotifications) {
//        
//        if ([notification.fireDate timeIntervalSinceDate:fireDate] == 0) {
//            
//            found = YES;
//            break;
//        }
//    }
//    if (!found) {
//        
//        for (UILocalNotification* notification in self.secondLocalNotifications) {
//            
//            if ([notification.fireDate timeIntervalSinceDate:fireDate] == 0) {
//                
//                found = YES;
//                break;
//            }
//        }
//    }
//    if (found) {
//        [self refreshAlarms];
//        self.canceledNotificationDate = fireDate;
//}

#pragma mark- DB methods

- (void)createRecord {
    
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate.modelManager createMedicieRecord:self];
}

- (void)updateRecord {
    
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate.modelManager updateMedicieRecord:self];
}

#pragma mark- ModelManagerDelegate methods

- (void)loadingDoneForOpcode:(int)opCode response:(int)response object:(id)obj errMsg:(NSString*)msg {

    self.medicineID = ((MedicineEntity*)obj).medicineID;
}

@end
