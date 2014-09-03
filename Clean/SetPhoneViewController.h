//
//  SetPhoneViewController.h
//  Clean
//
//  Created by Sapan Bhuta on 9/1/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetPhoneNumberViewController.h"

@interface SetPhoneViewController : GetPhoneNumberViewController
- (void)saveTempPhoneNumber:(NSString *)number;
@end
