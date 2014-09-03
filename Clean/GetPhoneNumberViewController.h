//
//  GetPhoneNumberViewController.h
//  Cents
//
//  Created by Sapan Bhuta on 7/30/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSQFlatButton.h"

@interface GetPhoneNumberViewController : UIViewController
@property JSQFlatButton *verify;
@property UIPageControl *page;
- (void)saveTempPhoneNumber;
- (void)nextVC;
- (void)saveTempPhoneNumber:(NSString *)number;
@end
