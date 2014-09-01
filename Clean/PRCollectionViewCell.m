//
//  PRCollectionViewCell.m
//  Clean
//
//  Created by Sapan Bhuta on 8/31/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import "PRCollectionViewCell.h"

@implementation PRCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _planNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 110, 30)];
        _planNameLabel.textAlignment = NSTextAlignmentCenter;
        _planNameLabel.textColor = [UIColor whiteColor];
        _planNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:30];
        _planNameLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_planNameLabel];

        _bedNbathLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 45, 110, 30)];
        _bedNbathLabel.textAlignment = NSTextAlignmentCenter;
        _bedNbathLabel.textColor = [UIColor whiteColor];
        _bedNbathLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:30];
        _bedNbathLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_bedNbathLabel];

        _costLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 85, 110, 30)];
        _costLabel.textAlignment = NSTextAlignmentCenter;
        _costLabel.textColor = [UIColor whiteColor];
        _costLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:30];
        _costLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_costLabel];
    }
    return self;
}

@end
