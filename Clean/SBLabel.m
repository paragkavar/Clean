//
//  SBLabel.m
//  Clean
//
//  Created by Sapan Bhuta on 8/29/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import "SBLabel.h"

@implementation SBLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:50];
        self.textColor = [UIColor whiteColor];
        self.adjustsFontSizeToFitWidth = YES;
        self.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

@end
