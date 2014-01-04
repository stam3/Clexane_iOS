//
//  NSString+Utilities.h
//  Clexane
//
//  Created by David Sayag on 12/21/13.
//  Copyright (c) 2013 David Sayag. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utilities)

- (NSString*)addURLParameterForKey:(NSString*)key andObjectValue:(NSObject*)value;
- (NSString*)addURLParameterForKey:(NSString*)key andDateValue:(NSDate*)value;
- (NSString*)addURLParameterForKey:(NSString*)key andIntValue:(int)value;

@end
