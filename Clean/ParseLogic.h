//
//  ParseLogic.h
//  Clean
//
//  Created by Sapan Bhuta on 9/6/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Visit.h"

@interface ParseLogic : NSObject
+ (void)checkForExistingUserWithCompletionHandler:(void (^)(bool exists))handler;
+ (void)addUserToDataBase;
+ (void)updateUserInParse;
+ (void)createVisit;
+ (void)createVisitWithCompletionHandler:(void (^)(BOOL succeeded, NSError *error))handler;
+ (void)createVisits;
+ (void)retrieveVisitsWithCompletionHandler:(void (^)(NSArray *visits))handler;
+ (void)updateVisitInParse:(Visit *)visit Notes:(NSString *)notes Date:(NSDate *)date Addons:(NSDictionary *)addons;
@end
