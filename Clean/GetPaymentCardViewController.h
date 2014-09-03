//
//  GetPaymentCardViewController.h
//  Cents
//
//  Created by Sapan Bhuta on 7/30/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSQFlatButton.h"
#import "STPView.h"

@interface GetPaymentCardViewController : UIViewController
@property UIPageControl *page;
@property JSQFlatButton *back;
@property JSQFlatButton *subscribe;
@property NSString *last4;
- (void)validateCard;
- (void)handleStripeToken:(STPToken *)token;
- (void)handleStripeError:(NSError *)error;
- (void)displayErrorAlert;
@end