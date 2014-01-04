//
//  ShotEntity.h
//  Clexane
//
//  Created by David Sayag on 8/31/13.
//  Copyright (c) 2013 David Sayag. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShotEntity : NSObject /*<NSCoding, NSCopying>*/

@property (nonatomic, strong) NSDate* timestamp;
@property (nonatomic, strong) NSNumber* isRight;
@property (nonatomic, readwrite) int dosage;

@end
