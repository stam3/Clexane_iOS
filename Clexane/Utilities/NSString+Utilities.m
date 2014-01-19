//
//  NSString+Utilities.m
//  Clexane
//
//  Created by David Sayag on 12/21/13.
//  Copyright (c) 2013 David Sayag. All rights reserved.
//

#import "NSString+Utilities.h"

@implementation NSString (Utilities)

- (NSString*)addURLParameterForKey:(NSString*)key andObjectValue:(NSObject*)value {
    
    NSString* delimiter = ([self isEqualToString:@""]) ? @"" : @"&";
    NSString* params = [NSString stringWithFormat:@"%@%@%@=%@", self, delimiter, key, value];
    return params;
}

- (NSString*)addURLParameterForKey:(NSString*)key andDateValue:(NSDate*)value {

    NSString* delimiter = ([self isEqualToString:@""]) ? @"" : @"&";
    NSString* params = [NSString stringWithFormat:@"%@%@%@=%@", self, delimiter, key, value];
    return params;
}

- (NSString*)addURLParameterForKey:(NSString*)key andIntValue:(int)value {

    NSString* delimiter = ([self isEqualToString:@""]) ? @"" : @"&";
    NSString* params = [NSString stringWithFormat:@"%@%@%@=%d", self, delimiter, key, value];
    return params;
}

+ (NSString*)generateJSONWithKey:(NSString*)key andDataFromDictionary:(NSDictionary*)values {
    
    //{"user":{"email":"test@example.com", "password":"Test123", "password_confirmation":"Test123"}}
    NSString* json = [NSString stringWithFormat:@"{\"%@\":{", key];
    int i = 0;
    for (NSString* jsonKey in [values allKeys]) {
        json = [NSString stringWithFormat:@"%@%@\"%@\":\"%@\"", json, (i > 0) ? @"," : @"", jsonKey, [values objectForKey:jsonKey]];
        i++;
    }
    json = [NSString stringWithFormat:@"%@}}", json];
    return json;
}

@end
