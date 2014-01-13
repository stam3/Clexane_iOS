//
//  ModelManager.m
//  Clexane
//
//  Created by David Sayag on 10/24/13.
//  Copyright (c) 2013 David Sayag. All rights reserved.
//

#import "ModelManager.h"
#import "MainViewController.h"
#import "SIAlertView.h"
#import "NSDate-Utilities.h"
#import "NSString+Utilities.h"

#import <Parse/Parse.h>

#define kAPIResponseUnauthorized    401


#define kAPILoginURL                        @"/login.json"
#define kAPISignupURL                        @"/signup.json"
#define kAPIMedicineURL                     @"/medicines.json"
#define kAPIMedicineUpdateURL               @"/medicines/%@.json"
#define kAPIPicklineURL                     @"/picklines/%@.json"
#define kAPIMedicineHistoriesCreateURL       @"/medicine_histories.json"
#define kAPIMedicineHistoriesURL            @"/medicine_histories.json?history_type=%d"
#define kAPIMedicineHistoriesPerMedicineURL @"/medicine_histories.json?history_type=2&medicine_id=%@"
#define kAPIMedicineDestroyURL              @"/medicines/%@.json"
#define kAPIMedicineHistoriesDestroyURL      @"/medicine_histories/%@.json"

typedef enum {
    kHistoryDataTodayType = 300,
    kHistoryDataPerMedicineType
} HistoryDataType;


@interface ModelManager ()


@property (nonatomic, strong)  NSString* medicineClassName;
@property (nonatomic, strong)  NSString* picklineClassName;
@property (nonatomic, strong)  NSString* medicineHistoryClassName;
@property (nonatomic, strong)  SIAlertView *alertView;

@end

@implementation ModelManager {
    
    BOOL isLoadingHistoryNow;
    BOOL loadFromRails;
    BOOL isLoggedin;
}

- (id)init {
    
    self = [super init];
    if (self) {
        
        self.medicineClassName = @"MedicineObject";
        self.picklineClassName = @"Pickline";
        self.medicineHistoryClassName = @"MedicineHistory";
            
        if (debug) {
            self.medicineClassName = @"MedicineTestObject";
            self.picklineClassName = @"PicklineTest";
            self.medicineHistoryClassName = @"MedicineHistoryTest";
        }
        
        _alertView = [[SIAlertView alloc] initWithTitle:@"Loading..." andMessage:@"Please Wait"];
        //    [alertView addButtonWithTitle:@"OK"
        //                             type:SIAlertViewButtonTypeDefault
        //                          handler:nil];
        /*handler:^(SIAlertView *alert) {
         NSLog(@"Button1 Clicked");
         }];*/
        _alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
        loadFromRails = YES;
        //[self loadData];
    }
    return self;
}

#pragma Private Methods

- (void)loadHistoryData {
    
    self.historyMedIDsArray = [[NSMutableArray alloc] init];

    if (isLoadingHistoryNow)
        return;
    isLoadingHistoryNow = YES;
    NSDate* todayStartDate = [MainViewController getTodaysStartDate];
    NSDate* todayEndDate = [MainViewController getTodaysEndDate];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(actualHour >= %@) AND (actualHour <= %@)", todayStartDate, todayEndDate];
    
    PFQuery *query = [PFQuery queryWithClassName:self.medicineHistoryClassName predicate:predicate];
    //[query orderByAscending:kNameColumn];
    //[query whereKey:kMedicineHistoryActualHourColumn notEqualTo:@"Michael Yabuti"];
//    [query whereKey:@"playerAge" greaterThan:@18];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            if (objects) {
                NSLog(@"Successfully retrieved %d scores.\nObjects: %@", objects.count, objects);
                
                for (PFObject* obj in objects) {
                    MedDatePair *pair = [[MedDatePair alloc] initWithPFObject:obj];
                    [self.historyMedIDsArray addObject:pair];
                }
                NSDictionary* info = @{@"name": kCheckedItemsNotificationName, @"object" : self.historyMedIDsArray};
                [self performSelectorOnMainThread:@selector(postNotificationNamed:) withObject:info waitUntilDone:NO];
            }
        }
    }];
}

- (void)loadMedicineData {
    
    self.medicineData = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:self.medicineClassName];
    [query orderByAscending:kNameColumn];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            if (objects) {
                
                NSLog(@"Successfully retrieved %d scores.", objects.count);
                
                [MainViewController cancelAllLocalNotificationsForID:kMedicineNotificationID];
                
                for (PFObject *object in objects) {
                    NSLog(@"object: %@", object);
                    MedicineEntity* entity = [[MedicineEntity alloc] initWithObject:object];
                    [self.medicineData addObject:entity];
//                    [entity refreshAlarms];
                }
                NSDictionary* info = @{@"name": kMedicineNotificationName, @"object" : self.medicineData};
                [self performSelectorOnMainThread:@selector(postNotificationNamed:) withObject:info waitUntilDone:NO];
//                NSLog(@"scheduledLocalNotifications: %@", [[UIApplication sharedApplication] scheduledLocalNotifications]);
//                for (UILocalNotification* not in [[UIApplication sharedApplication] scheduledLocalNotifications])
//                {
//                    NSLog(@"not name: %@    date: %@", not.alertBody, [MainViewController stringFromDate:not.fireDate withFormat:kDateFormatterNoYearType]);
//                }
                
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)loadPicklineData {
    
    //PFObject* pfObject = [PFObject objectWithClassName:self.className];
    PFQuery *query = [PFQuery queryWithClassName:self.picklineClassName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            if (objects) {
                if (objects) {
                    NSLog(@"Successfully retrieved %d scores.", objects.count);

                    for (PFObject *object in objects) {
                        NSLog(@"object: %@", object);
                        self.picklineEntity = [[PicklineEntity alloc] initWithObject:object];
                        //self.picklinePFObject = object;
                    }
                }
                NSDictionary* info = @{@"name": kPicklineNotificationName, @"object" : self.picklineEntity};
                [self performSelectorOnMainThread:@selector(postNotificationNamed:) withObject:info waitUntilDone:NO];
//                NSLog(@"notifications: %@", [[UIApplication sharedApplication] scheduledLocalNotifications]);
//                for (UILocalNotification* not in [[UIApplication sharedApplication] scheduledLocalNotifications])
//                {
//                    NSLog(@"not name: %@    date: %@", not.alertBody, [MainViewController stringFromDate:not.fireDate withFormat:kDateFormatterNoYearType]);
//                }

            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

}

- (void)loadRailsMedicineHistoryDataForMedicineID:(NSString*)medicineID {
 
    [self sendRequest:[NSString stringWithFormat:kAPIMedicineHistoriesPerMedicineURL, medicineID] withParams:nil method:kHTTPMethodGet];
}

- (void)loadMedicineHistoryDataForMedicineID:(NSString*)medicineID {
    
    if (rails) {
        [self loadRailsMedicineHistoryDataForMedicineID:medicineID];
        return;
    }
//    if (isLoadingHistoryNow)
//        return;
//    isLoadingHistoryNow = YES;
//    NSDate* todayStartDate = [MainViewController getTodaysStartDate];
//    NSDate* todayEndDate = [MainViewController getTodaysEndDate];
    
    PFQuery *query = [PFQuery queryWithClassName:self.medicineHistoryClassName];
    [query orderByDescending:kMedicineHistoryActualHourColumn];
    [query whereKey:kMedicineHistoryMedicineIDColumn equalTo:medicineID];
    query.limit = kMedicineHistoryQueryLimit;
    //    [query whereKey:@"playerAge" greaterThan:@18];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            if (objects) {
                NSMutableArray* medicineHistoryData = [[NSMutableArray alloc] initWithCapacity:20];
                NSLog(@"Successfully retrieved %d scores.\nObjects: %@", objects.count, objects);
                
                for (PFObject* obj in objects) {
                    MedDatePair *pair = [[MedDatePair alloc] initWithPFObject:obj];
                    [medicineHistoryData addObject:pair];
                }
                NSDictionary* info = @{@"name":kMedicineHistoryPerMedicineIDNotificationName, @"object":medicineHistoryData};
                [self performSelectorOnMainThread:@selector(postNotificationNamed:) withObject:info waitUntilDone:NO];
            }
        }
    }];
}

- (void)postNotificationNamed:(NSDictionary*)info  {
    
    [self.alertView dismissAnimated:NO];
//    NSLog(@"name = %@", [info objectForKey:@"name"]);
    if ([[info objectForKey:@"name"] isEqualToString:kCheckedItemsNotificationName])
        isLoadingHistoryNow = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:[info objectForKey:@"name"] object:[info objectForKey:@"object"]];
}

#pragma Public Methods

- (void)loadData {

    self.alertView.title = @"Loading...";
    [self.alertView show];
    
    if (rails) {
        
//        [self login:@"i" password:@"1"];
        if (!isLoggedin)
           // [self login:@"b" password:@"1"];
            [self.alertView dismissAnimated:NO];
        else {
            [self loadMedicineData1];
            [self loadRailsPicklineData];
            [self loadRailsHistoryData];
        }
        
        //[self loadHistoryData];
        
    } else {
        
        [self loadMedicineData];
        [self loadPicklineData];
        [self loadHistoryData];
    }
}

- (void)updateRailsDBWithPair:(MedDatePair*)pair {
    
    NSString* params = @"";
    if (pair.isDone) {
        
        //save pair to DB
        if (pair.medicineID) {
            params = [params addURLParameterForKey:kMedicineHistoryMedicineIDColumn andObjectValue:pair.medicineID];
            
            // remove alarm if exists
            NSDate* now = [NSDate date];
            NSDate* alertDate = [now dateWithTimeFrom:pair.date];
            if ([now isEarlierThanDate:alertDate]) {
                
                NSDictionary* userInfo = @{kMedicineID: pair.medicineID};
                [[NSNotificationCenter defaultCenter] postNotificationName:kNextNotificationCanceledNotificationName object:pair.date userInfo:userInfo];
            }
        }
        params = [params addURLParameterForKey:kMedicineHistoryTypeColumn andIntValue:pair.type];
        params = [params addURLParameterForKey:kMedicineHistoryActualHourColumn andDateValue:[NSDate date]];
        params = [params addURLParameterForKey:kMedicineHistoryIsFirstHourColumn andObjectValue:[NSNumber numberWithBool:pair.isFirstHour]];
        
        [self sendRequest:kAPIMedicineHistoriesCreateURL withParams:params method:kHTTPMethodPost];
        self.delegate = pair;
    } else {
        
        // resume alert if needed
        NSDate* now = [NSDate date];
        NSDate* alertDate = [now dateWithTimeFrom:pair.date];
        if ([now isEarlierThanDate:alertDate]) {
            NSDictionary* userInfo = @{kMedicineID: pair.medicineID};
            [[NSNotificationCenter defaultCenter] postNotificationName:kNextNotificationCanceledNotificationName object:nil userInfo:userInfo];
        }
        // remove from DB
        [self deleteMedicieHistoryRecord: pair];
    }

}

- (void)updateDBWithPair:(MedDatePair*)pair {
    
    if (rails) {
        [self updateRailsDBWithPair:pair];
        return;
    }
    self.alertView.title = @"Updating...";
    [self.alertView show];
    if (pair.isDone) {
        //save pair to DB
        PFObject *medicieObject = [PFObject objectWithClassName:self.medicineHistoryClassName];
        if (pair.medicineID) {
            [medicieObject setObject:pair.medicineID forKey:kMedicineHistoryMedicineIDColumn1];
            
            // remove alarm if exists
            NSDate* now = [NSDate date];
            NSDate* alertDate = [now dateWithTimeFrom:pair.date];
            if ([now isEarlierThanDate:alertDate]) {
//                [MainViewController cancelNextLocalNotificationForID:kMedicineNotificationID andUniqueID:pair.medicineID];
                
                NSDictionary* userInfo = @{kMedicineID: pair.medicineID};
                [[NSNotificationCenter defaultCenter] postNotificationName:kNextNotificationCanceledNotificationName object:pair.date userInfo:userInfo];
            }
        }
        [medicieObject setObject:[NSNumber numberWithInt:pair.type] forKey:kMedicineHistoryTypeColumn1];
        [medicieObject setObject:[NSDate date] forKey:kMedicineHistoryActualHourColumn];
        [medicieObject setObject:[NSNumber numberWithBool:pair.isFirstHour] forKey:kMedicineHistoryIsFirstHourColumn];

        [medicieObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            pair.pairID = medicieObject.objectId;
            [self performSelectorOnMainThread:@selector(dismissAlert) withObject:nil waitUntilDone:NO];
        }];
        
    } else {
        
        // resume alert if needed
        NSDate* now = [NSDate date];
        NSDate* alertDate = [now dateWithTimeFrom:pair.date];
        if ([now isEarlierThanDate:alertDate]) {
            NSDictionary* userInfo = @{kMedicineID: pair.medicineID};
            [[NSNotificationCenter defaultCenter] postNotificationName:kNextNotificationCanceledNotificationName object:nil userInfo:userInfo];
        }
        // remove from DB
        PFQuery *query = [PFQuery queryWithClassName:self.medicineHistoryClassName];
//        PFObject *medicieObject = [query getObjectWithId:pair.pairID];
        [query getObjectInBackgroundWithId:pair.pairID block:^(PFObject *medicieObject, NSError *error) {
            [medicieObject delete];
            [self performSelectorOnMainThread:@selector(dismissAlert) withObject:nil waitUntilDone:NO];
        }];
    }
}

- (NSString*)getMedicineNameByID:(NSString*)medID {
    
    for (MedicineEntity* med in self.medicineData) {
        
        if ([med.medicineID isEqualToString:medID])
            return med.name;
    }
    return nil;
}

- (void) dismissAlert {
    
    [self.alertView dismissAnimated:NO];
}

- (void)deleteMedicine:(MedicineEntity*)entity {
    
    if (rails) {
        
//        SIAlertView* alertView = [[SIAlertView alloc] initWithTitle:@"Error" andMessage:@"not supported yet..."];
//        [alertView addButtonWithTitle:@"OK"
//                                 type:SIAlertViewButtonTypeDefault
//                              handler:nil];
//        [alertView show];
        [self deleteMedicieRecord:entity];
        
    } else {
        // remove from DB
        self.alertView.title = @"Deleting...";
        [self.alertView show];
        
        // delete alerts
        [MainViewController cancelAllLocalNotificationsForID:kMedicineNotificationID andUniqueID:entity.medicineID];
        // delete from DB
        PFQuery *query = [PFQuery queryWithClassName:self.medicineClassName];
        [query getObjectInBackgroundWithId:entity.medicineID block:^(PFObject *medicieObject, NSError *error) {
            [medicieObject delete];
            [self performSelectorOnMainThread:@selector(dismissAlert) withObject:nil waitUntilDone:NO];
        }];
    }
}

- (void)saveMedicineInDB:(MedicineEntity*)medicineEntity isNewRecord:(BOOL)isNewRecord {
    
//    self.alertView.title = @"Saving...";
//    [self.alertView show];
    
    PFQuery *query = [PFQuery queryWithClassName:self.medicineClassName];
    PFObject *medicieObject;
    if (isNewRecord)
        medicieObject = [PFObject objectWithClassName:self.medicineClassName];
    else
        medicieObject = [query getObjectWithId:medicineEntity.medicineID];
    
    //NSLog(@"id: %@", medicieObject.);
    
    [medicieObject setObject:medicineEntity.name forKey:kNameColumn];
    [medicieObject setObject:[NSNumber numberWithBool:medicineEntity.isSpecificDays] forKey:kIsSpecificDaysColumn];
    [medicieObject setObject:[NSNumber numberWithInt:medicineEntity.specificDays] forKey:kSpecificDaysColumn];
    [medicieObject setObject:[NSNumber numberWithInt:medicineEntity.daysOffset] forKey:kDaysOffsetColumn];
    [medicieObject setObject:medicineEntity.firstHour forKey:kFirstHourColumn];
    if (medicineEntity.canceledNotificationDate)
        [medicieObject setObject:medicineEntity.canceledNotificationDate forKey:kCanceledNotificationDateColumn];
    else
        [medicieObject removeObjectForKey:kCanceledNotificationDateColumn];
    if (!medicineEntity.isSpecificDays)
        [medicieObject setObject:medicineEntity.daysOffsetStartDate forKey:kDaysOffsetStartDateColumn];
    
    if (medicineEntity.secondHour) {
        [medicieObject setObject:medicineEntity.secondHour forKey:kSecondHourColumn];
    } else {
        [medicieObject removeObjectForKey:kSecondHourColumn];
    }
    
    [medicieObject saveInBackground];
    medicineEntity.medicineID = medicieObject.objectId;
    //[self.alertView dismissAnimated:YES];
}

- (void)loadFromRails {
    
    UrlLoader* urlLoader = [[UrlLoader alloc] init];
    urlLoader.delegate = self;

   // [urlLoader startLoadingUrl:@"http://0.0.0.0:3000/medicines"];
    NSString* postData = @"email=h&password=1";
   // NSDictionary* data = @{@"email": @"h", @"password": @"1"};
    //BOOL check = [NSJSONSerialization isValidJSONObject:data];
//    /[NSJSONSerialization dataWithJSONObject:postData options:0 error:nil]
//    [urlLoader startPost:kAPILoginURL withPostDataStr:postData];
    [urlLoader sendRequest:kAPILoginURL withParams:postData httpMethod:kHTTPMethodPost];

}

#pragma mark- Private Calls

- (User*)getLoggedinUser {
    
    User* user = [[User alloc] init];
    user.password = [[NSUserDefaults standardUserDefaults] objectForKey:kProfilePswdID];
    user.email = [[NSUserDefaults standardUserDefaults] objectForKey:kProfileEmailID];
    return user;
}

#pragma mark- APIs Calls

- (void)signup:(User*)user delegate:(id<ModelManagerDelegate>) delegate {
    
    self.delegate = delegate;
    UrlLoader* urlLoader = [[UrlLoader alloc] init];
    urlLoader.delegate = self;
    
    NSString* postData = [NSString stringWithFormat:@"email=%@&password=%@&password_confirmation=%@", user.email, user.password, user.password];
    [urlLoader sendRequest:kAPISignupURL withParams:postData httpMethod:kHTTPMethodPost];
}

- (void)login:(NSString*)email password:(NSString*)password {
    
    UrlLoader* urlLoader = [[UrlLoader alloc] init];
    urlLoader.delegate = self;
    
    NSString* postData = [NSString stringWithFormat:@"email=%@&password=%@", email, password];
    [urlLoader sendRequest:kAPILoginURL withParams:postData httpMethod:kHTTPMethodPost];
}

- (void)login:(User*)user delegate:(id<ModelManagerDelegate>) delegate {
    
    self.delegate = delegate;
    UrlLoader* urlLoader = [[UrlLoader alloc] init];
    urlLoader.delegate = self;
    
    NSString* postData = [NSString stringWithFormat:@"email=%@&password=%@", user.email, user.password];
    [urlLoader sendRequest:kAPILoginURL withParams:postData httpMethod:kHTTPMethodPost];
}

- (void)loginExistingUserWithDelegate:(id<ModelManagerDelegate>) delegate {
    
    [self login:[self getLoggedinUser] delegate:delegate];
}

- (void)loadRailsPicklineData {
    
    UrlLoader* urlLoader = [[UrlLoader alloc] init];
    urlLoader.delegate = self;
    
    [self sendRequest:[NSString stringWithFormat:kAPIPicklineURL, [[NSUserDefaults standardUserDefaults] objectForKey:kProfilePicklineID]] withParams:nil method:kHTTPMethodGet];
//    [self sendRequest:[NSString stringWithFormat:kAPIPicklineURL, @"12"] withParams:nil method:kHTTPMethodGet];
}

- (void)loadMedicineData1 {
    
    UrlLoader* urlLoader = [[UrlLoader alloc] init];
    urlLoader.delegate = self;
    
    //NSString* postData = [NSString stringWithFormat:@"email=%@&password=%@", email, password];
//    //[urlLoader startPost:kAPIMedicineURL withPostDataStr:postData];
//    [urlLoader startLoadingUrl:kAPIMedicineURL];
    [urlLoader sendRequest:kAPIMedicineURL withParams:nil httpMethod:kHTTPMethodGet];
}

#pragma APIs Response Handlers

- (void)extractMedicineData:(NSDictionary*) jsonResult {
    
//    int result = [[jsonResult objectForKey:@"result"] intValue];
//    if (result == 0) {
    
        self.medicineData = [[NSMutableArray alloc] init];
        NSArray* array = [jsonResult objectForKey:@"medicines"];
        for (NSDictionary* medDictionary in array) {
            NSLog(@": %@", medDictionary);
            MedicineEntity* entity = [[MedicineEntity alloc] initWithDictionary:medDictionary];
                [self.medicineData addObject:entity];
        }
        NSDictionary* info = @{@"name": kMedicineNotificationName, @"object" : self.medicineData};
        [self performSelectorOnMainThread:@selector(postNotificationNamed:) withObject:info waitUntilDone:NO];
//    }
}

- (void)extractMedicineHistoriesDataForMedicineID:(NSDictionary*)jsonResult {
    
    NSMutableArray* medicineHistories = [[NSMutableArray alloc] init];
    NSArray* array = [jsonResult objectForKey:@"medicine_histories"];
    if (![array isKindOfClass:[NSNull class]] && [array count] > 0) {
        for (NSDictionary* pairDictionary in array) {
            MedDatePair *pair = [[MedDatePair alloc] initWithDictionary:pairDictionary];
            [medicineHistories addObject:pair];
        }
        
        NSDictionary* info = @{@"name": kMedicineHistoryPerMedicineIDNotificationName, @"object" : self.historyMedIDsArray};
        [self performSelectorOnMainThread:@selector(postNotificationNamed:) withObject:info waitUntilDone:NO];
    }
}

- (void)extractMedicineHistoriesData:(NSDictionary*)jsonResult {
    
    NSArray* array = [jsonResult objectForKey:@"medicine_histories"];
    if (![array isKindOfClass:[NSNull class]]) {
        for (NSDictionary* pairDictionary in array) {
            MedDatePair *pair = [[MedDatePair alloc] initWithDictionary:pairDictionary];
            [self.historyMedIDsArray addObject:pair];
        }

        NSDictionary* info = @{@"name": kCheckedItemsNotificationName, @"object" : self.historyMedIDsArray};
        [self performSelectorOnMainThread:@selector(postNotificationNamed:) withObject:info waitUntilDone:NO];
    }
}

#pragma mark- UrlLoaderDelegate

- (void)urlLoadingDone:(NSData *)data {
    
    NSString* resultsString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"Result: %@", resultsString);
    NSDictionary* jsonResult = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSLog(@"Result: %@", jsonResult);
    
    int response = [[jsonResult objectForKey:@"response"] intValue];
//    if (response == kAPIResponseUnauthorized) {
//        NSLog(@"Unauthorized");
//        return;
//    }
    if (response != 200) {
        NSLog(@"Error: %d", response);
        NSString* err_msg = [NSString stringWithFormat:@"Error: %d\n%@", response, [jsonResult objectForKey:@"error_msg"]];
        SIAlertView* alertView = [[SIAlertView alloc] initWithTitle:@"Error" andMessage:err_msg];
            [alertView addButtonWithTitle:@"OK"
                                type:SIAlertViewButtonTypeDefault
                                handler:nil];
        /*handler:^(SIAlertView *alert) {
         NSLog(@"Button1 Clicked");
         }];*/
//        alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
        [alertView show];
        return;
    }
    id obj = nil;
    int opCode = [[jsonResult objectForKey:@"opcode"] intValue];
    switch (opCode) {
        case kOpCodeSignup:
            if (self.delegate)
                [self.delegate loadingDoneForOpcode:opCode response:response object:obj errMsg:[jsonResult objectForKey:@"error_msg"]];
            break;
            // login
        case kOpCodeLogin:
            isLoggedin = YES;
            if (self.delegate)
                [self.delegate loadingDoneForOpcode:opCode response:response object:obj errMsg:[jsonResult objectForKey:@"error_msg"]];
            [[NSUserDefaults standardUserDefaults] setObject:[jsonResult objectForKey:@"picklineId"] forKey:kProfilePicklineID];
            //user auth_token
            [self loadMedicineData1];
            [self loadRailsPicklineData];
            [self loadRailsHistoryData];
            break;
        case kOpCodeMedicines:
            [self extractMedicineData:jsonResult];
            break;
        case kOpCodePicklineShow:
            self.picklineEntity = [[PicklineEntity alloc] initWithDictionary:[jsonResult objectForKey:@"pickline"]];
            break;
        case kOpCodeMedicineHistoriesToday:
            [self extractMedicineHistoriesData:jsonResult];
            break;
        case kOpCodeMedicineHistoriesTodayPerMedicine:
            [self extractMedicineHistoriesDataForMedicineID:jsonResult];
            break;
        case kOpCodeMedicineCreate:
            obj = [[MedicineEntity alloc] initWithDictionary:[jsonResult objectForKey:@"medicine"]];
            break;
        case kOpCodeMedicineHistorieCreate:
            obj = [[MedDatePair alloc] initWithDictionary:[jsonResult objectForKey:@"medicine_history"]];
            break;
        default:
            break;
    }
}

- (void)urlLoadingError {
    
}

#pragma mark- Rails Methods - Medicine

- (void)loadRailsHistoryData {
    
    self.historyMedIDsArray = [[NSMutableArray alloc] init];
    
    if (isLoadingHistoryNow)
        return;
    isLoadingHistoryNow = YES;
    [self sendRequest:[NSString stringWithFormat:kAPIMedicineHistoriesURL, 1] withParams:nil method:kHTTPMethodGet];
}


- (void)updateMedicieRecord:(MedicineEntity*)entity {
    
    NSString* params = [self getMedicineRequestParamsForEntity:entity];
    [self sendRequest:[NSString stringWithFormat:kAPIMedicineUpdateURL, entity.medicineID] withParams:params method:kHTTPMethodPut];
}

- (void)createMedicieRecord:(MedicineEntity*)entity {
    
    NSString* params = [self getMedicineRequestParamsForEntity:entity];
    [self sendRequest:kAPIMedicineURL withParams:params method:kHTTPMethodPost];
    self.delegate = entity;
}

- (void)deleteMedicieRecord:(MedicineEntity*)entity {
    
    [self sendRequest:[NSString stringWithFormat:kAPIMedicineDestroyURL, entity.medicineID]  withParams:nil method:kHTTPMethodDelete];
}

- (void)deleteMedicieHistoryRecord:(MedDatePair*)entity {
    
    [self sendRequest:[NSString stringWithFormat:kAPIMedicineHistoriesDestroyURL, entity.pairID]  withParams:nil method:kHTTPMethodDelete];
}


- (NSString*)getMedicineRequestParamsForEntity:(MedicineEntity*)entity {
    
    NSString* params;
    if (!entity.isSpecificDays) {
        //        [medicieObject setObject:self.medicineEntity.daysOffsetStartDate forKey:kDaysOffsetStartDateColumn];
        params = [NSString stringWithFormat:@"name=%@&daysOffset=%d&firstHour=%@&secondHour=%@&isSpecificDays=%@&specificDays=%d&canceledNotificationDate=%@&daysOffsetStartDate=%@",
                  entity.name,
                  entity.daysOffset,
                  entity.firstHour,
                  entity.secondHour,
                  [NSNumber numberWithBool:entity.isSpecificDays],
                  entity.specificDays,
                  entity.canceledNotificationDate,
                  entity.daysOffsetStartDate];
    } else {
        
        params = [NSString stringWithFormat:@"name=%@&daysOffset=%d&firstHour=%@&secondHour=%@&isSpecificDays=%d&specificDays=%d&canceledNotificationDate=%@",
                  entity.name,
                  entity.daysOffset,
                  entity.firstHour,
                  entity.secondHour,
                  entity.isSpecificDays,
                  entity.specificDays,
                  entity.canceledNotificationDate
                  /*@"3TyS62bNw8302hDsyD5KYQ"*/];
    }
    return params;
}

#pragma mark- Rails Methods - Pickline

- (void)updatePicklineRecord:(PicklineEntity*)entity {
    
    NSString* params = @"";

    if (entity.blueLastWashDate)
        params = [NSString stringWithFormat:@"%@=%@", kBlueLastWashDateColumn, entity.blueLastWashDate];
    if (entity.redLastWashDate)
        params = [NSString stringWithFormat:@"%@&%@=%@", params, kRedLastWashDateColumn, entity.redLastWashDate];
    if (entity.bandageLastReplacedDate)
        params = [NSString stringWithFormat:@"%@&%@=%@", params, kBandageReplacementDateColumn, entity.bandageLastReplacedDate];
    if (entity.bandageIntervalDays > 0)
        params = [NSString stringWithFormat:@"%@&%@=%d", params, kBandageReplacementIntervalColumn, entity.bandageIntervalDays];
    if (entity.blueVentileLastReplacedDate)
        params = [NSString stringWithFormat:@"%@&%@=%@", params, kBlueVentileReplacementDateColumn, entity.blueVentileLastReplacedDate];
    if (entity.redVentileLastReplacedDate)
        params = [NSString stringWithFormat:@"%@&%@=%@", params, kRedVentileReplacementDateColumn, entity.redVentileLastReplacedDate];
    if (entity.parparLastReplacedDate)
        params = [NSString stringWithFormat:@"%@&%@=%@", params, kParparReplacementDateColumn, entity.parparLastReplacedDate];
    
    [self sendRequest:[NSString stringWithFormat:kAPIPicklineURL, entity.picklineID] withParams:params method:kHTTPMethodPut];
}

#pragma mark- Conenction Methods

- (void)sendRequest:(NSString*)url withParams:(NSString*)params method:(NSString*)method {
    
    UrlLoader* urlLoader = [[UrlLoader alloc] init];
    urlLoader.delegate = self;
    [urlLoader sendRequest:url withParams:params httpMethod:method];
//    [urlLoader startPost:url withPostDataStr:params];
}

@end
