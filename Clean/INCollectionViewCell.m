//
//  INCollectionViewCell.m
//  Clean
//
//  Created by Sapan Bhuta on 9/1/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import "INCollectionViewCell.h"

@implementation INCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self createTitle];
        [self createImageView];
    }
    return self;
}

- (void)createTitle
{
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, self.contentView.frame.size.width-2*10, 50)];
    title.text = @"Clean";
    title.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:50];
    title.textColor = [UIColor whiteColor];
    title.adjustsFontSizeToFitWidth = YES;
    title.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:title];
}

- (void)createImageView
{
    _shimmeringView = [[FBShimmeringView alloc] initWithFrame:CGRectMake(0, 0, 64, 64)];
    _shimmeringView.center = self.contentView.center;
    [self.contentView addSubview:_shimmeringView];

    _imageView = [[UIImageView alloc] initWithFrame:_shimmeringView.bounds];
    _imageView.tintColor = [UIColor whiteColor];
    _shimmeringView.contentView = _imageView;
    _shimmeringView.shimmering = YES;
    _shimmeringView.shimmeringSpeed = 150;
}

@end
