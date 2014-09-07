//
//  RQScrollView.m
//  Clean
//
//  Created by Sapan Bhuta on 9/6/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import "RQScrollView.h"
#import "JSQFlatButton.h"
#import "PRCollectionViewCell.h"
#import "CKCalendarView.h"

@interface RQScrollView () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, CKCalendarDelegate>
@property NSArray *views;
@property UILabel *title;
@property UILabel *sizeLabel;
@property UILabel *dateLabel;
@property UICollectionView *collectionView;
@property UIDatePicker *pickerView;
@property CKCalendarView *calendar;
@property int plan;
@property NSDate *date;
@property JSQFlatButton *schedule;
@end

@implementation RQScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self createTitle];
        [self createCollectionView];
        [self createDates];
        [self createExtras];
        self.contentSize = CGSizeMake(self.frame.size.width, 600);
    }
    return self;
}

- (void)createTitle
{
    _title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
    _title.textAlignment = NSTextAlignmentCenter;
    _title.textColor = [UIColor whiteColor];
    _title.text = @"schedule a clean";
    _title.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:40];
    _title.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_title];
}

- (void)createCollectionView
{
    _sizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, self.frame.size.width, 30)];
    _sizeLabel.textAlignment = NSTextAlignmentCenter;
    _sizeLabel.textColor = [UIColor whiteColor];
    _sizeLabel.text = @"size";
    _sizeLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:30];
    _sizeLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_sizeLabel];

    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 90, self.frame.size.width, 120) collectionViewLayout:flow];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[PRCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self addSubview:_collectionView];
}

- (void)createDates
{
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 220, self.frame.size.width, 30)];
    _dateLabel.textAlignment = NSTextAlignmentCenter;
    _dateLabel.textColor = [UIColor whiteColor];
    _dateLabel.text = @"date";
    _dateLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:30];
    _dateLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_dateLabel];

    _calendar = [[CKCalendarView alloc] initWithFrame:CGRectMake(0, 260, self.frame.size.width, 0)];
    _calendar.delegate = self;
    [self addSubview:_calendar];
}

- (void)createExtras
{
    
}

#pragma mark - CollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PRCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

    cell.contentView.layer.borderColor = indexPath.item != _plan-1 ? [UIColor clearColor].CGColor : [UIColor whiteColor].CGColor;

    if (indexPath.item == 0)
    {
        cell.backgroundColor = [UIColor colorWithRed:0.541 green:0.475 blue:0.365 alpha:1.0];
        cell.planNameLabel.text = @"Apartment";
        cell.bedNbathLabel.text = @"1-2 bedrooms";
        cell.costLabel.text = @"$75";
    }
    else if (indexPath.item == 1)
    {
        cell.backgroundColor = [UIColor colorWithRed:0.651 green:0.651 blue:0.651 alpha:1.0];
        cell.planNameLabel.text = @"Small Home";
        cell.bedNbathLabel.text = @"3-4 bedrooms";
        cell.costLabel.text = @"$150";
    }
    else if (indexPath.item == 2)
    {
        cell.backgroundColor = [UIColor colorWithRed:0.765 green:0.600 blue:0.325 alpha:1.0];
        cell.planNameLabel.text = @"Large Home";
        cell.bedNbathLabel.text = @"5-6 bedrooms";
        cell.costLabel.text = @"$225";
    }
    else
    {
        cell.backgroundColor = [UIColor colorWithRed:0.459 green:0.459 blue:0.459 alpha:1.0];
        cell.planNameLabel.text = @"Mansion";
        cell.bedNbathLabel.text = @"7-8 bedrooms";
        cell.costLabel.text = @"$300";
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(120,120);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    for (UICollectionViewCell *cell in collectionView.visibleCells)
    {
        cell.contentView.layer.borderColor = [UIColor clearColor].CGColor;
    }

    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.contentView.layer.borderWidth = 1;
    cell.contentView.layer.borderColor = [UIColor whiteColor].CGColor;
    _plan = indexPath.item+1;

    [self enableScheduleButton];
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date
{
    _date = date;
    [self enableScheduleButton];
}

- (void)calendar:(CKCalendarView *)calendar didDeselectDate:(NSDate *)date
{
    _date = nil;
}

- (void)enableScheduleButton
{
    if (_plan && _date) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"schedule" object:@YES];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"schedule" object:@NO];
    }
}

@end
