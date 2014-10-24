//
//  ParseLogic.m
//  Clean
//
//  Created by Sapan Bhuta on 9/6/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import "ParseLogic.h"
#import "User.h"
#import <Parse/Parse.h>
//#import "Visit.h"
#import "Cleaner.h"

@implementation ParseLogic

+ (void)checkForExistingUserWithCompletionHandler:(void (^)(bool exists))handler
{
    PFQuery *query = [PFQuery queryWithClassName:@"User"];
    [query whereKey:@"verifiedPhoneNumber" equalTo:[User phoneNumber]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

        NSLog(@"%@", objects);

        if (objects.count==0) {
            handler(NO);
        } else {
            PFObject *user = objects.firstObject;
            [self getParseDataFromUser:user];
            handler(YES);
        }
    }];
}

+ (void)getParseDataFromUser:(PFObject *)user
{
    [User setPhoneNumber:user[@"verifiedPhoneNumber"]];
    [User setAddress:user[@"address"]];
    [User setLatitude:[user[@"latitude"] floatValue]];
    [User setLongitude:[user[@"longitude"] floatValue]];
    [User setDay:user[@"day"]];
    [User setHour:[user[@"hour"] intValue]];
    [User setMinute:[user[@"minute"] intValue]];
    [User setAM:[user[@"AM"] boolValue]];
    [User setPlan:[user[@"plan"] intValue]];
    [User setLast4:user[@"last4"]];
    [User setCustomerId:user[@"customerId"]];
    [User setSubscriptionId:user[@"subscriptionId"]];
}

+ (void)addUserToDataBase
{
    PFObject *user = [PFObject objectWithClassName:@"User"];
    [self saveUserToParse:user];
}

+ (void)updateUserInParse
{
    PFQuery *query = [PFQuery queryWithClassName:@"User"];
    [query whereKey:@"phoneNumber" equalTo:[User phoneNumber]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error || objects.count !=1)
        {
            //fatal problems in database
        }
        else
        {
            [self saveUserToParse:objects.firstObject];
        }
    }];
}

+ (void)saveUserToParse:(PFObject *)user
{
    user[@"verifiedPhoneNumber"] = [User verifiedPhoneNumber];
    user[@"address"] = [User address];
    user[@"latitude"] = @([User latitude]);
    user[@"longitude"] = @([User longitude]);
    user[@"day"] = [User day];
    user[@"hour"] = @([User hour]);
    user[@"minute"] = @([User minute]);
    user[@"AM"] = @([User AM]);
    user[@"plan"] = @([User plan]).description;
    user[@"last4"] = [User last4];
    user[@"customerId"] = [User customerId];
    if ([User subscriptionId])
    {
        user[@"subscriptionId"] = [User subscriptionId];
    }
    [user saveInBackground];
}

+ (void)createVisits
{
    for (int i =0; i<4; i++)
    {
        [self createVisit];
    }
}

+ (void)createVisit
{
    PFObject *visit = [PFObject objectWithClassName:@"Visit"];
    visit[@"phoneNumber"] = [User phoneNumber];
    visit[@"date"] = @"Unscheduled";
    visit[@"latitude"] = @([User latitude]);
    visit[@"longitude"] = @([User longitude]);

    PFQuery *query = [PFQuery queryWithClassName:@"Cleaner"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        int index = arc4random_uniform(objects.count);
        visit[@"cleaners"] = @[objects[index]];
        [visit saveInBackground];
    }];
}

+ (void)createVisitWithCompletionHandler:(void (^)(BOOL succeeded, NSError *error))handler
{
    PFObject *visit = [PFObject objectWithClassName:@"Visit"];
    visit[@"phoneNumber"] = [User phoneNumber];
    visit[@"date"] = @"Unscheduled";
    visit[@"latitude"] = @([User latitude]);
    visit[@"longitude"] = @([User longitude]);

    PFQuery *query = [PFQuery queryWithClassName:@"Cleaner"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        int index = arc4random_uniform(objects.count);
        visit[@"cleaners"] = @[objects[index]];
        [visit saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            handler(succeeded, error);
        }];
    }];
}

+ (void)retrieveVisitsWithCompletionHandler:(void (^)(NSArray *visits))handler
{
    PFQuery *query = [PFQuery queryWithClassName:@"Visit"];
    [query whereKey:@"phoneNumber" equalTo:[User phoneNumber]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            handler(@[]);
        } else {
            NSMutableArray *visits = [NSMutableArray new];
            for (PFObject *object in objects)
            {
                Visit *visit = [Visit new];
                visit.objectId = object[@"objectId"];
                visit.phoneNumber = object[@"phoneNumber"];
                visit.date = object[@"date"];
                visit.latitude = [object[@"latitude"] floatValue];
                visit.longitude = [object[@"longitude"] floatValue];
                visit.cleaners = object[@"cleaners"];
                [visits addObject:visit];
            }

            handler([NSArray arrayWithArray:visits]);
        }
    }];
}

+ (void)updateVisitInParse:(Visit *)visit Notes:(NSString *)notes Date:(NSDate *)date Addons:(NSDictionary *)addons
{
#warning update things like Notes, Date, Time, and Addons

    
}

@end
