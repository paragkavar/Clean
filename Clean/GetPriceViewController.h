//
//  GetHomeInfoViewController.h
//  Clean
//
//  Created by Sapan Bhuta on 8/29/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSQFlatButton.h"

@interface GetPriceViewController : UIViewController
@property UIPageControl *page;
@property JSQFlatButton *back;
@property JSQFlatButton *save;
@property UIPickerView *dayPicker;
@property UIPickerView *timePicker;
@property UICollectionView *collectionView;
@property NSArray *days;
@property NSInteger selectedIndex;
- (BOOL)dateChanged;
- (void)nextVC;
@end