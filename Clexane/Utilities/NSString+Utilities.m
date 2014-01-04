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

@end
