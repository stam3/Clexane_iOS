//
//  PicklineEntity.m
//  Clexane
//
//  Created by David Sayag on 10/26/13.
//  Copyright (c) 2013 David Sayag. All rights reserved.
//

#import "PicklineEntity.h"
#import "MainViewController.h"
#import "NSDate-Utilities.h"
#import "AppDelegate.h"
#import "SIAlertView.h"

@interface PicklineEntity ()

@property (nonatomic, strong) PFObject* pfObject;
@property (nonatomic, strong)  SIAlertView *alertView;

@end

@implementation PicklineEntity

- (id)initWithObject:(PFObject*)record {
    
    self = [super init];
    if (self) {
        
        _pfObject = record;
        _picklineID = record.objectId;
        _redLastWashDate = [record objectForKey:kRedLastWashDateColumn];
        _blueLastWashDate = [record objectForKey:kBlueLastWashDateColumn];
        _bandageIntervalDays = [[record objectForKey:kBandageReplacementIntervalColumn] intValue];
        _bandageLastReplacedDate = [record objectForKey:kBandageReplacementDateColumn];
        _blueVentileLastReplacedDate = [record objectForKey:kBlueVentileReplacementDateColumn];
        _redVentileLastReplacedDate = [record objectForKey:kRedVentileReplacementDateColumn];
//        self.bandageFireDate = [record objectForKey:kBandageFireDateColumn];
//        self.ventilesFireDate = [record objectForKey:kVentilesFireDateColumn];
        _parparLastReplacedDate = [record objectForKey:kParparReplacementDateColumn];
        
        [self setAlarms];
        _alertView = [[SIAlertView alloc] initWithTitle:@"Update Pickline..." andMessage:@"Please Wait"];
        _alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary*)record {
    
    self = [super init];
    if (self) {
        
        int recordId = [[record objectForKey:@"id"] intValue];
        _picklineID = [NSString stringWithFormat:@"%d",recordId];
        _redLastWashDate = [NSDate dateFromRFC822String:[record objectForKey:kRedLastWashDateColumn]];
        _blueLastWashDate = [NSDate dateFromRFC822String:[record objectForKey:kBlueLastWashDateColumn]];
        _bandageIntervalDays = [[record objectForKey:kBandageReplacementIntervalColumn] intValue];
        _bandageLastReplacedDate = [NSDate dateFromRFC822String:[record objectForKey:kBandageReplacementDateColumn]];
        _blueVentileLastReplacedDate = [NSDate dateFromRFC822String:[record objectForKey:kBlueVentileReplacementDateColumn]];
        _redVentileLastReplacedDate = [NSDate dateFromRFC822String:[record objectForKey:kRedVentileReplacementDateColumn]];
        _parparLastReplacedDate = [NSDate dateFromRFC822String:[record objectForKey:kParparReplacementDateColumn]];
        
        [self setAlarms];
        _alertView = [[SIAlertView alloc] initWithTitle:@"Update Pickline..." andMessage:@"Please Wait"];
        _alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    }
    return self;
}

- (void)setAlarms {
    
    [MainViewController cancelAllLocalNotificationsForID:kPicklineNotificationID];
    
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if ([delegate isPicklineOn]) {
        
        NSDate* nextDate = [self getComponentNextDate:kPicklineComponentBandage];
        [self setLocalNotificationForPicklineComponent:kPicklineComponentBandage forDate:nextDate];
        
        nextDate = [self getComponentNextDate:kPicklineComponentBlueVentile];
        [self setLocalNotificationForPicklineComponent:kPicklineComponentBlueVentile forDate:nextDate];
        
        nextDate = [self getComponentNextDate:kPicklineComponentRedVentile];
        [self setLocalNotificationForPicklineComponent:kPicklineComponentRedVentile forDate:nextDate];
        
        nextDate = [self getComponentNextDate:kPicklineComponentParpar];
        [self setLocalNotificationForPicklineComponent:kPicklineComponentParpar forDate:nextDate];
    }
}

#pragma mark- Custom Methods

- (NSDate*)getVentileNextDate:(PicklineComponent)component {

    NSDate* date;
    if (component == kPicklineComponentBlueVentile)
        date = self.blueVentileLastReplacedDate;
    else if (component == kPicklineComponentRedVentile)
        date = self.redVentileLastReplacedDate;
    else
        return nil;
    
    NSDate* nextDate = [date dateByAddingTimeInterval:60*60*24*kVentilesIntervalDays];
    return [nextDate setHour:7 minute:45 second:0];
}

- (NSDate*)getBandageNextDate {
    
    NSDate* nextDate = [self.bandageLastReplacedDate dateByAddingTimeInterval:60*60*24*self.bandageIntervalDays];
    return [nextDate setHour:7 minute:45 second:0];
}

- (NSDate*)getParparNextDate {
    
    NSDate* nextDate = [self.parparLastReplacedDate getNextMonth];
    return [nextDate setHour:7 minute:45 second:0];
}

- (NSDate*)getComponentNextDate:(PicklineComponent)component {

    switch (component) {
        case kPicklineComponentBandage:
            return [self getBandageNextDate];
            
        case kPicklineComponentRedVentile:
        case kPicklineComponentBlueVentile:
            return [self getVentileNextDate:component];
            
        case kPicklineComponentParpar:
            return [self getParparNextDate];
            
        default:
            return nil;
    }
}

- (NSDate*)getComponentPreviousDateFromNowForComponent:(PicklineComponent)component {
    
    switch (component) {
        case kPicklineComponentBandage: {
            NSDate* nextDate = [[NSDate date] dateByAddingTimeInterval:-60*60*24*self.bandageIntervalDays];
            return [nextDate setHour:7 minute:45 second:0];
        }
        case kPicklineComponentBlueVentile:
        case kPicklineComponentRedVentile:  {
            NSDate* nextDate = [[NSDate date] dateByAddingTimeInterval:-60*60*24*kVentilesIntervalDays];
            return [nextDate setHour:7 minute:45 second:0];
        }
        case kPicklineComponentParpar: {
            NSDate* nextDate = [[NSDate date] getLastMonth];
            return [nextDate setHour:7 minute:45 second:0];
        }
        default:
            return nil;
    }
}

- (void)setLastReplacedDate:(NSDate*)date forComponent:(PicklineComponent)component {
    
    switch (component) {
        case kPicklineComponentBandage:
            self.bandageLastReplacedDate = date;
            break;
        case kPicklineComponentBlueVentile:
            self.blueVentileLastReplacedDate = date;
            break;
        case kPicklineComponentRedVentile:
            self.redVentileLastReplacedDate = date;
            break;
        case kPicklineComponentParpar:
            self.parparLastReplacedDate = date;
            break;
        default:
            break;
    }
}


- (void)setLocalNotificationForPicklineComponent:(PicklineComponent)component forDate:(NSDate*)nextDate {
    
    
    switch (component) {
        case kPicklineComponentBandage:
            // remove current alarm
            if (self.bandageLocalNotification)
                [[UIApplication sharedApplication] cancelLocalNotification:self.bandageLocalNotification];
            
            // create new alarm
            self.bandageLocalNotification = [MainViewController createAlarmforDate:nextDate withInterval:0 withBody:kBandageAlertBody withID:kPicklineNotificationID andUniqueID:[NSString stringWithFormat:@"%d", component]];
            break;
        case kPicklineComponentBlueVentile:
            if (self.blueVentilesLocalNotification)
                [[UIApplication sharedApplication] cancelLocalNotification:self.blueVentilesLocalNotification];

            self.blueVentilesLocalNotification = [MainViewController createAlarmforDate:nextDate withInterval:0 withBody:kBlueVentileAlertBody withID:kPicklineNotificationID andUniqueID:[NSString stringWithFormat:@"%d", component]];
            break;
        case kPicklineComponentRedVentile:
            if (self.redVentilesLocalNotification)
                [[UIApplication sharedApplication] cancelLocalNotification:self.redVentilesLocalNotification];
            
            self.redVentilesLocalNotification = [MainViewController createAlarmforDate:nextDate withInterval:0 withBody:kRedVentileAlertBody withID:kPicklineNotificationID andUniqueID:[NSString stringWithFormat:@"%d", component]];
            break;
        case kPicklineComponentParpar:
            if (self.parparLocalNotification)
                [[UIApplication sharedApplication] cancelLocalNotification:self.parparLocalNotification];
            
            self.parparLocalNotification = [MainViewController createAlarmforDate:nextDate withInterval:0 withBody:kParparAlertBody withID:kPicklineNotificationID andUniqueID:[NSString stringWithFormat:@"%d", component]];
            break;
        default:
            break;
    }
}

- (void)saveInBackground {
    
    if (rails) {
        [self updateRecord];
        return;
    }
    
    if (self.blueLastWashDate)
        [self.pfObject setObject:self.blueLastWashDate forKey:kBlueLastWashDateColumn];
    if (self.redLastWashDate)
        [self.pfObject setObject:self.redLastWashDate forKey:kRedLastWashDateColumn];
    if (self.bandageLastReplacedDate)
        [self.pfObject setObject:self.bandageLastReplacedDate forKey:kBandageReplacementDateColumn];
    if (self.bandageIntervalDays > 0)
        [self.pfObject setObject:[NSNumber numberWithInt:self.bandageIntervalDays] forKey:kBandageReplacementIntervalColumn];
//    if (self.bandageFireDate)
//        [self.pfObject setObject:self.bandageFireDate forKey:kBandageFireDateColumn];
    if (self.blueVentileLastReplacedDate)
        [self.pfObject setObject:self.blueVentileLastReplacedDate forKey:kBlueVentileReplacementDateColumn];
    if (self.redVentileLastReplacedDate)
        [self.pfObject setObject:self.redVentileLastReplacedDate forKey:kRedVentileReplacementDateColumn];
//    if (self.ventilesFireDate)
//        [self.pfObject setObject:self.ventilesFireDate forKey:kVentilesFireDateColumn];
    if (self.parparLastReplacedDate)
        [self.pfObject setObject:self.parparLastReplacedDate forKey:kParparReplacementDateColumn];

    [self.alertView show];
    [self.pfObject save];
    [self.alertView dismissAnimated:YES];
}

#pragma mark- DB methods

- (void)updateRecord {
    
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate.modelManager updatePicklineRecord:self];
}

@end
