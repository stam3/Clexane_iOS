//
//  ShotEntity.m
//  Clexane
//
//  Created by David Sayag on 8/31/13.
//  Copyright (c) 2013 David Sayag. All rights reserved.
//

#import "ShotEntity.h"
#include "NSDate-Utilities.h"

@implementation ShotEntity

- (id)initWithDictionary:(NSDictionary*)record {
    self = [super init];
    if (self) {
        if (![[record objectForKey:kDosageColumn] isKindOfClass:[NSNull class]])
            _dosage = [[record objectForKey:kDosageColumn] intValue];
        if (![[record objectForKey:kIsRightColumn] isKindOfClass:[NSNull class]])
            _isRight = [record objectForKey:kIsRightColumn];
        if (![[record objectForKey:kShotDateColumn] isKindOfClass:[NSNull class]])
            _timestamp = [NSDate dateFromRFC822String:[record objectForKey:kShotDateColumn]];
    }
    return self;
}

//#pragma mark - NSCoding Methods
//-(void)encodeWithCoder:(NSCoder *)aCoder {
//	[aCoder encodeObject:self.date forKey:@"date"];
//    [aCoder encodeObject:self.isRight forKey:@"isRight"];
//}

//-(id) initWithCoder:(NSCoder *)aDecoder {
//  if((self = [super init])) {
//    self.date = [aDecoder decodeObjectForKey:@"date"];
//    self.isRight = [aDecoder decodeObjectForKey:@"isRight"];
//  }
//    return self;
//}
//
//#pragma mark - NSCopying Methods
//-(id) copyWithZone:(NSZone *)zone {
//   ShotEntity* copy = [[[self class] allocWithZone:zone] init];
//   copy.date = [self.date copyWithZone:zone];
//   copy.isRight = [self.isRight copyWithZone:zone];
//   return copy;
//}

- (NSDictionary*)convertObjToDictionary {
    
    NSDictionary* dict = @{@"dosage": [NSString stringWithFormat:@"%d", self.dosage],
                           @"isRight": self.isRight,
                           @"shotDate": self.timestamp};
    return dict;
}

@end
