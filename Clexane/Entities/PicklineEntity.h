//
//  PicklineEntity.h
//  Clexane
//
//  Created by David Sayag on 10/26/13.
//  Copyright (c) 2013 David Sayag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

#define kRedLastWashDateColumn                  @"red_last_wash_date"
#define kBlueLastWashDateColumn                 @"blue_last_wash_date"
#define kBandageReplacementDateColumn           @"bandage_replacement_date"
#define kBlueVentileReplacementDateColumn          @"blue_ventile_replacement_date"
#define kRedVentileReplacementDateColumn          @"red_ventile_replacement_date"
#define kBandageReplacementIntervalColumn       @"bandage_interval_days"
//#define kBandageFireDateColumn                  @"bandageFireDate"
//#define kVentilesFireDateColumn                 @"ventilesFireDate"
#define kParparReplacementDateColumn            @"parpar_replacement_date"

typedef enum {
    kPicklineComponentBandage,
    kPicklineComponentBlueVentile,
    kPicklineComponentRedVentile,
    kPicklineComponentParpar
} PicklineComponent;

@interface PicklineEntity : NSObject

@property (nonatomic, strong)   NSString* picklineID;
@property (nonatomic, strong)   NSDate* redLastWashDate;
@property (nonatomic, strong)   NSDate* blueLastWashDate;
@property (nonatomic, strong)   NSDate* bandageLastReplacedDate;
@property (nonatomic, strong)   NSDate* blueVentileLastReplacedDate;
@property (nonatomic, strong)   NSDate* redVentileLastReplacedDate;
//@property (nonatomic, strong)   NSDate* bandageFireDate;
//@property (nonatomic, strong)   NSDate* ventilesFireDate;
@property (nonatomic, readwrite) int bandageIntervalDays;
@property (nonatomic, strong)   NSDate* parparLastReplacedDate;
@property (nonatomic, strong)  UILocalNotification* bandageLocalNotification;
@property (nonatomic, strong)  UILocalNotification* blueVentilesLocalNotification;
@property (nonatomic, strong)  UILocalNotification* redVentilesLocalNotification;

@property (nonatomic, strong)  UILocalNotification* parparLocalNotification;


- (id)initWithObject:(PFObject*)record;
- (id)initWithDictionary:(NSDictionary*)record;

- (void)saveInBackground;

//- (NSDate*)getVentilesNextDate;
- (NSDate*)getVentileNextDate:(PicklineComponent)component;
- (NSDate*)getBandageNextDate;
- (NSDate*)getParparNextDate;
    
- (NSDate*)getComponentNextDate:(PicklineComponent)component;
- (NSDate*)getComponentPreviousDateFromNowForComponent:(PicklineComponent)component;
- (void)setLastReplacedDate:(NSDate*)date forComponent:(PicklineComponent)component;
- (void)setLocalNotificationForPicklineComponent:(PicklineComponent)component forDate:(NSDate*)nextDate;

@end
