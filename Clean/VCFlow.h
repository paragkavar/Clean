//
//  VCFlow.h
//  Clean
//
//  Created by Sapan Bhuta on 8/31/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VCFlow : NSObject
+ (UIViewController *)nextVC;
+ (void)checkForExistingUserWithCompletionHandler:(void (^)(bool exists))handler;
+ (void)addUserToDataBase;
+ (void)updateUserInParse;
@end
