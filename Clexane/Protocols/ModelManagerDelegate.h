//
//  ModelManagerDelegate.h
//  Clexane
//
//  Created by David Sayag on 1/9/14.
//  Copyright (c) 2014 David Sayag. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ModelManagerDelegate <NSObject>

- (void)loadingDoneForOpcode:(int)opCode response:(int)response object:(id)obj msg:(NSString*)msg;

@end