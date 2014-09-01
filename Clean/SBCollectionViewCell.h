//
//  SBCollectionViewCell.h
//  Clean
//
//  Created by Sapan Bhuta on 8/30/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSQFlatButton.h"

@interface SBCollectionViewCell : UICollectionViewCell
@property UIImageView *imageView;
@property UILabel *titleLabel;
@property UILabel *nameLabel;
@property UILabel *dateLabel;
@property JSQFlatButton *etaButton;
@end
