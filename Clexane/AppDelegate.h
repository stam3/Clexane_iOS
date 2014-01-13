//
//  AppDelegate.h
//  Clexane
//
//  Created by David Sayag on 8/31/13.
//  Copyright (c) 2013 David Sayag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelManager.h"

// git test...

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) ModelManager* modelManager;

- (void)refreshData;
- (void)closeSignupController;
- (void)logout;
- (BOOL)isPicklineOn;
- (void)setPicklineOn:(BOOL)status;
- (NSString*)getUserEmail;

@end
