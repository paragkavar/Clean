//
//  SBCollectionViewCell.h
//  Clean
//
//  Created by Sapan Bhuta on 8/30/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBCollectionViewCell : UICollectionViewCell
@property NSDate *selectedDate;
@property UILabel *titleLabel;
- (void)setContactImage:(NSString *)imageName;
- (void)setTitleLabelText:(int)num;
@end
