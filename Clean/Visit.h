//
//  Visit.h
//  Clean
//
//  Created by Sapan Bhuta on 9/6/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "User.h"

@interface Visit : NSObject
@property NSString *objectId;
@property NSString *phoneNumber;
@property NSString *date;
@property CGFloat latitude;
@property CGFloat longitude;
@property NSArray *cleaners;
@property NSString *notes;
@end