//
//  SBCollectionViewCell.m
//  Clean
//
//  Created by Sapan Bhuta on 8/30/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import "SBCollectionViewCell.h"
#import "CKCalendarView.h"
#import "UIColor+FlatUI.h"
#import <MapKit/MapKit.h>
#import "RMDateSelectionViewController.h"

@interface SBCollectionViewCell () <CKCalendarDelegate, MKMapViewDelegate, RMDateSelectionViewControllerDelegate>
@property CKCalendarView *calendar;
@property UIView *mapContainer;
@property MKMapView *map;
@property UIView *front;
@property BOOL flipped;
@property BOOL turned;
@property JSQFlatButton *etaBackButton;
@property JSQFlatButton *dateButton;
@property JSQFlatButton *addonButton;
@property NSDate *selectedDate;
@end

@implementation SBCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
//        [self createCalendar];
        [self createMap];
        [self createFront];
        [self createTitle];
        [self createWhen];
        [self createWho];
    }
    return self;
}

- (void)createCalendar
{
    _calendar = [[CKCalendarView alloc] init];
    _calendar.delegate = self;
    _calendar.center = self.contentView.center;
    _turned = NO;
}

- (void)createMap
{
    _mapContainer = [[UIView alloc] initWithFrame:self.contentView.bounds];
    _map = [[MKMapView alloc] initWithFrame:self.contentView.bounds];
    _map.delegate = self;
    [_mapContainer addSubview:_map];
    _flipped = NO;
    _etaBackButton = [[JSQFlatButton alloc] initWithFrame:CGRectMake(self.contentView.bounds.origin.x+.25,
                                                               self.contentView.bounds.size.height-54,
                                                               self.contentView.bounds.size.width-.5,
                                                               54)
                                   backgroundColor:[UIColor whiteColor]
                                   foregroundColor:[UIColor colorWithRed:0.0f green:0.49f blue:0.96f alpha:1.0f]
                                             title:@"back"
                                             image:nil];
    _etaBackButton.alpha = .8;
    [_etaBackButton addTarget:self action:@selector(flip) forControlEvents:UIControlEventTouchUpInside];
    [_mapContainer addSubview:_etaBackButton];
}

- (void)createFront
{
    _front = [[UIView alloc] initWithFrame:self.contentView.bounds];
    _front.backgroundColor = [UIColor wetAsphaltColor];
//    _front.layer.borderWidth = 1;
//    _front.layer.cornerRadius = 3;
//    _front.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.contentView addSubview:_front];
    _etaButton = [[JSQFlatButton alloc] initWithFrame:CGRectMake(self.contentView.bounds.origin.x+.25,
                                                              self.contentView.bounds.size.height-54,
                                                              self.contentView.bounds.size.width-.5,
                                                              54)
                                   backgroundColor:[UIColor whiteColor]
                                   foregroundColor:[UIColor colorWithRed:0.0f green:0.49f blue:0.96f alpha:1.0f]
                                             title:@"ETA"
                                             image:nil];
    [_etaButton addTarget:self action:@selector(flip) forControlEvents:UIControlEventTouchUpInside];
    [_front addSubview:_etaButton];
}

- (void)createTitle
{
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_front.bounds.origin.x+20,
                                                           _front.bounds.origin.y+10,
                                                           _front.bounds.size.width-20*2,
                                                           30)];
    _titleLabel.text = @"Visit #1";
    _titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:30];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.textColor = [UIColor whiteColor];
    [_front addSubview:_titleLabel];
}

- (BOOL)calendar:(CKCalendarView *)calendar willChangeToMonth:(NSDate *)date
{
    [self turn];
    return NO;
}

- (void)flip
{
    if (!_flipped)
    {
        [UIView transitionFromView:_front//viewToReplace
                            toView:_mapContainer//replacementView
                          duration:1
                           options:UIViewAnimationOptionTransitionFlipFromTop
                        completion:^(BOOL finished) {
                            _flipped = !_flipped;
                        }];
    }
    else
    {
        [UIView transitionFromView:_mapContainer//viewToReplace
                            toView:_front//replacementView
                          duration:1
                           options:UIViewAnimationOptionTransitionFlipFromBottom
                        completion:^(BOOL finished) {
                            _flipped = !_flipped;
                        }];
    }
}

- (void)turn
{
    if (!_turned)
    {
        [UIView transitionFromView:_front//viewToReplace
                            toView:_calendar//replacementView
                          duration:1
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        completion:^(BOOL finished) {
                            _turned = !_turned;
                        }];
    }
    else
    {
        [UIView transitionFromView:_calendar//viewToReplace
                            toView:_front//replacementView
                          duration:1
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        completion:^(BOOL finished) {
                            _turned = !_turned;
                        }];
    }
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date
{
    _selectedDate = date;
    _dateLabel.text = [self getDate:date];
    _dateLabel.hidden = NO;
    _dateButton.hidden = YES;
}

- (void)calendar:(CKCalendarView *)calendar didDeselectDate:(NSDate *)date
{
    _selectedDate = nil;
    _dateLabel.text = nil;
    _dateLabel.hidden = YES;
    _dateButton.hidden = NO;
}

- (void)createWhen
{
    UILabel *when = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 280, 30)];
    when.center = CGPointMake(self.contentView.center.x, self.contentView.center.y-110);
    when.text = @"when";
    when.textColor = [UIColor whiteColor];
    when.textAlignment = NSTextAlignmentRight;
    when.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:30];
    [_front addSubview:when];

    _dateButton = [[JSQFlatButton alloc] initWithFrame:CGRectMake(138, 80, 320-148, 40)
                                    backgroundColor:[UIColor clearColor]
                                    foregroundColor:[UIColor whiteColor]
                                              title:@"Set a date"
                                              image:nil];
    _dateButton.normalBorderColor = [UIColor whiteColor];
    _dateButton.borderWidth = 1;
    _dateButton.highlightedBorderColor = [UIColor colorWithRed:0.0f green:0.49f blue:0.96f alpha:1.0f];
    _dateButton.highlightedForegroundColor = [UIColor colorWithRed:0.35f green:0.35f blue:0.81f alpha:1.0f];
    [_dateButton addTarget:self action:@selector(turn) forControlEvents:UIControlEventTouchUpInside];             //turn
    [_front addSubview:_dateButton];
    _dateButton.hidden = YES;

    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, 320-40, 40)];
    _dateLabel.textColor = [UIColor whiteColor];
    _dateLabel.textAlignment = NSTextAlignmentRight;
    _dateLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    [_front addSubview:_dateLabel];
//    _dateLabel.hidden = YES;
}

- (void)popup
{
    RMDateSelectionViewController *dateSelectionVC = [RMDateSelectionViewController dateSelectionController];
    dateSelectionVC.delegate = self;
    [dateSelectionVC show];
}

- (void)dateSelectionViewController:(RMDateSelectionViewController *)vc didSelectDate:(NSDate *)aDate
{
    _selectedDate = aDate;
    _dateLabel.text = [self getDate:aDate];
    _dateLabel.hidden = NO;
    _dateButton.hidden = YES;
}

- (void)dateSelectionViewControllerDidCancel:(RMDateSelectionViewController *)vc
{
    _selectedDate = nil;
    _dateLabel.text = nil;
    _dateLabel.hidden = YES;
    _dateButton.hidden = NO;
}

- (void)createWho
{
    UILabel *who = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 280, 30)];
    who.center = CGPointMake(self.contentView.center.x, self.contentView.center.y-15);
    who.text = @"who";
    who.textColor = [UIColor whiteColor];
    who.textAlignment = NSTextAlignmentRight;
    who.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:30];
    [_front addSubview:who];

    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 150, 128*.75, 128*.75)];
    _imageView.image = [UIImage imageNamed:@"headshot1"];
    _imageView.layer.masksToBounds = YES;
    _imageView.layer.cornerRadius = _imageView.frame.size.width/2;
    [_front addSubview:_imageView];

    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(138, 194, 320-148, 40)];
    _nameLabel.center = CGPointMake(_nameLabel.center.x, _imageView.center.y);
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    [_front addSubview:_nameLabel];
}

- (void)setContactImage:(NSString *)imageName
{
}

- (NSString *)getDate:(NSDate *)date
{
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSString *selectionString = [[NSString alloc] initWithFormat:@"%@", [date descriptionWithLocale:usLocale]];
    return selectionString;
}

@end
