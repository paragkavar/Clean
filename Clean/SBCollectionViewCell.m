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
#import "RMDateSelectionViewController.h"

@interface SBCollectionViewCell () <CKCalendarDelegate, MKMapViewDelegate, RMDateSelectionViewControllerDelegate, UITextViewDelegate>
@property CKCalendarView *calendar;
@property UIView *mapContainer;
@property UIView *front;
@property UIView *addons;
@property UIView *notesContainer;
@property UITextView *notes;
@property BOOL turned;
@property JSQFlatButton *etaBackButton;
@property JSQFlatButton *dateButton;
@property JSQFlatButton *addonButton;
@property JSQFlatButton *addonBackButton;
@property JSQFlatButton *notesButtons;
@property JSQFlatButton *notesBackButton;
@property UIButton *dishesButton;
@property UIButton *laundryButton;
@property NSDate *selectedDate;
@property int padding;
@end

@implementation SBCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
//        [self createCalendar];
        _padding = 10;
        [self createMap];
        [self createFront];
        [self createAddons];
        [self createNotes];
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

- (void)createNotes
{
    _notesContainer = [[UIView alloc] initWithFrame:CGRectMake(self.contentView.bounds.origin.x+_padding,
                                                               self.contentView.bounds.origin.y+_padding,
                                                               self.contentView.bounds.size.width-2*_padding,
                                                               self.contentView.bounds.size.height-2*_padding)];
    _notesContainer.backgroundColor = [UIColor wetAsphaltColor];

    UILabel *notesLabel = [[UILabel alloc] initWithFrame:CGRectMake(_notesContainer.bounds.origin.x, _notesContainer.bounds.origin.y+10, _notesContainer.bounds.size.width, 40)];
    notesLabel.text = @"leave a note";
    notesLabel.textColor = [UIColor whiteColor];
    notesLabel.textAlignment = NSTextAlignmentCenter;
    notesLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:30];
    [_notesContainer addSubview:notesLabel];

    _notes = [[UITextView alloc] initWithFrame:CGRectMake(_notesContainer.bounds.origin.x+_padding,
                                                           _notesContainer.bounds.origin.y+50,
                                                           _notesContainer.bounds.size.width-_padding*2,
                                                           _notesContainer.bounds.size.height-50)];
    _notes.backgroundColor = [UIColor clearColor];
    _notes.textColor = [UIColor whiteColor];
    _notes.text = @"1) building code is 1234\n2) front door key is under mat";
    _notes.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    _notes.keyboardAppearance = UIKeyboardAppearanceDark;
    _notes.returnKeyType = UIReturnKeyDone;
    _notes.delegate = self;
    [_notesContainer addSubview:_notes];

    _notesBackButton = [[JSQFlatButton alloc] initWithFrame:CGRectMake(_notesContainer.bounds.origin.x,
                                                                       _notesContainer.bounds.size.height-54+_padding,
                                                                       _notesContainer.bounds.size.width,
                                                                       54-_padding)
                                            backgroundColor:[UIColor whiteColor]
                                            foregroundColor:[UIColor colorWithRed:0.0f green:0.49f blue:0.96f alpha:1.0f]
                                                      title:@"back"
                                                      image:nil];
    _notesBackButton.alpha = .8;
    [_notesBackButton addTarget:self action:@selector(hideNotes) forControlEvents:UIControlEventTouchUpInside];
    [_notesContainer addSubview:_notesBackButton];
}

- (void)textViewDidChange:(UITextView *)textView
{
    if ([[textView.text substringWithRange:NSMakeRange(textView.text.length - 1, 1)] isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
    }
}

- (void)createMap
{
    _mapContainer = [[UIView alloc] initWithFrame:self.contentView.bounds];
    _map = [[MKMapView alloc] initWithFrame:CGRectMake(self.contentView.bounds.origin.x+_padding,
                                                       self.contentView.bounds.origin.y+_padding,
                                                       self.contentView.bounds.size.width-2*_padding,
                                                       self.contentView.bounds.size.height-2*_padding)];
    _map.delegate = self;
    [_mapContainer addSubview:_map];
    _etaBackButton = [[JSQFlatButton alloc] initWithFrame:CGRectMake(self.contentView.bounds.origin.x+_padding,
                                                                     self.contentView.bounds.size.height-54,
                                                                     self.contentView.bounds.size.width-2*_padding,
                                                                     54-_padding)
                                   backgroundColor:[UIColor whiteColor]
                                   foregroundColor:[UIColor colorWithRed:0.0f green:0.49f blue:0.96f alpha:1.0f]
                                             title:@"back"
                                             image:nil];
    _etaBackButton.alpha = .8;
    [_etaBackButton addTarget:self action:@selector(hideMap) forControlEvents:UIControlEventTouchUpInside];
    [_mapContainer addSubview:_etaBackButton];
}

- (void)createFront
{
    _front = [[UIView alloc] initWithFrame:self.contentView.bounds];
    [self.contentView addSubview:_front];

    UIView *background = [[UIView alloc] initWithFrame:CGRectMake(_front.bounds.origin.x+_padding,
                                                                  _front.bounds.origin.y+_padding,
                                                                  _front.bounds.size.width-2*_padding,
                                                                  _front.bounds.size.height-2*_padding)];
    background.backgroundColor = [UIColor wetAsphaltColor];
    [_front addSubview:background];

    int buttonX = background.frame.origin.x;
    int buttonY = self.contentView.bounds.size.height-54;
    int buttonWidth = (background.frame.size.width-1)/3;
    int buttonHeight = 54-_padding;

    _addonButton = [[JSQFlatButton alloc] initWithFrame:CGRectMake(buttonX,
                                                                   buttonY,
                                                                   buttonWidth,
                                                                   buttonHeight)
                                        backgroundColor:[UIColor whiteColor]
                                        foregroundColor:[UIColor colorWithRed:0.0f green:0.49f blue:0.96f alpha:1.0f]
                                                  title:@"extras"
                                                  image:nil];
    [_addonButton addTarget:self action:@selector(showAddons) forControlEvents:UIControlEventTouchUpInside];
    [_front addSubview:_addonButton];

    _etaButton = [[JSQFlatButton alloc] initWithFrame:CGRectMake(buttonX+(.5+buttonWidth),
                                                                 buttonY,
                                                                 buttonWidth,
                                                                 buttonHeight)
                                   backgroundColor:[UIColor whiteColor]
                                   foregroundColor:[UIColor colorWithRed:0.0f green:0.49f blue:0.96f alpha:1.0f]
                                             title:@"map"
                                             image:nil];
    [_etaButton addTarget:self action:@selector(showMap) forControlEvents:UIControlEventTouchUpInside];
    [_front addSubview:_etaButton];

    _notesButtons = [[JSQFlatButton alloc] initWithFrame:CGRectMake(buttonX+2*(.5+buttonWidth),
                                                                    buttonY,
                                                                    buttonWidth,
                                                                    buttonHeight)
                                        backgroundColor:[UIColor whiteColor]
                                        foregroundColor:[UIColor colorWithRed:0.0f green:0.49f blue:0.96f alpha:1.0f]
                                                  title:@"notes"
                                                  image:nil];
    [_notesButtons addTarget:self action:@selector(showNotes) forControlEvents:UIControlEventTouchUpInside];
    [_front addSubview:_notesButtons];
}

- (void)createAddons
{
    _addons = [[UIView alloc] initWithFrame:CGRectMake(self.contentView.bounds.origin.x+_padding,
                                                       self.contentView.bounds.origin.y+_padding,
                                                       self.contentView.bounds.size.width-2*_padding,
                                                       self.contentView.bounds.size.height-2*_padding)];
    _addons.backgroundColor = [UIColor wetAsphaltColor];

    _addonBackButton = [[JSQFlatButton alloc] initWithFrame:CGRectMake(_addons.bounds.origin.x,
                                                                       _addons.bounds.size.height-54+_padding,
                                                                       _addons.bounds.size.width,
                                                                       54-_padding)
                                          backgroundColor:[UIColor whiteColor]
                                          foregroundColor:[UIColor colorWithRed:0.0f green:0.49f blue:0.96f alpha:1.0f]
                                                    title:@"back"
                                                    image:nil];
    [_addonBackButton addTarget:self action:@selector(hideAddons) forControlEvents:UIControlEventTouchUpInside];
    [_addons addSubview:_addonBackButton];

    _laundryButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _laundryButton.frame = CGRectMake(0, 30, 120, 120);
    _laundryButton.tintColor = [UIColor lightGrayColor];
    _laundryButton.center = CGPointMake(_addons.bounds.size.width*.25, _addons.bounds.size.height*.4);
    _laundryButton.tag = 0;
    [_laundryButton setImage:[UIImage imageNamed:@"laundry"] forState:UIControlStateNormal];
    [_laundryButton addTarget:self action:@selector(laundry:) forControlEvents:UIControlEventTouchUpInside];
    [_addons addSubview:_laundryButton];

    _dishesButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _dishesButton.frame = CGRectMake(60, 30, 120, 120);
    _dishesButton.tintColor = [UIColor lightGrayColor];
    _dishesButton.center = CGPointMake(_addons.bounds.size.width*.75, _addons.bounds.size.height*.4);
    _dishesButton.tag = 0;
    [_dishesButton setImage:[UIImage imageNamed:@"dishes"] forState:UIControlStateNormal];
    [_dishesButton addTarget:self action:@selector(dishes:) forControlEvents:UIControlEventTouchUpInside];
    [_addons addSubview:_dishesButton];

    UILabel *laundryLabel = [[UILabel alloc] initWithFrame:CGRectMake(_laundryButton.frame.origin.x,
                                                                      _laundryButton.frame.origin.y - 40,
                                                                      _laundryButton.frame.size.width,
                                                                      30)];
    laundryLabel.text = @"laundry";
    laundryLabel.textColor = [UIColor whiteColor];
    laundryLabel.textAlignment = NSTextAlignmentCenter;
    laundryLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:30];
    [_addons addSubview:laundryLabel];

    UILabel *dishesLabel = [[UILabel alloc] initWithFrame:CGRectMake(_dishesButton.frame.origin.x,
                                                                     _dishesButton.frame.origin.y - 40,
                                                                     _dishesButton.frame.size.width,
                                                                     30)];
    dishesLabel.text = @"dishes";
    dishesLabel.textColor = [UIColor whiteColor];
    dishesLabel.textAlignment = NSTextAlignmentCenter;
    dishesLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:30];
    [_addons addSubview:dishesLabel];

    UILabel *laundryCostLabel = [[UILabel alloc] initWithFrame:CGRectMake(_laundryButton.frame.origin.x,
                                                                          190,
                                                                          _laundryButton.frame.size.width,
                                                                          30)];
    laundryCostLabel.text = @"$10/load";
    laundryCostLabel.textColor = [UIColor whiteColor];
    laundryCostLabel.textAlignment = NSTextAlignmentCenter;
    laundryCostLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    [_addons addSubview:laundryCostLabel];

    UILabel *dishesCostLabel = [[UILabel alloc] initWithFrame:CGRectMake(_dishesButton.frame.origin.x,
                                                                         190,
                                                                         _dishesButton.frame.size.width,
                                                                         30)];
    dishesCostLabel.text = @"$10/load";
    dishesCostLabel.textColor = [UIColor whiteColor];
    dishesCostLabel.textAlignment = NSTextAlignmentCenter;
    dishesCostLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    [_addons addSubview:dishesCostLabel];
}

- (void)dishes:(UIButton *)sender
{
    if (sender.tag == 0)
    {
        sender.tag = 1;
        sender.tintColor = [UIColor whiteColor];//[UIColor colorWithRed:0.0f green:0.49f blue:0.96f alpha:1.0f];
        //ask how many loads & charge stripe
        //tell parse to do dishes
    }
    else
    {
        sender.tag = 0;
        sender.tintColor  = [UIColor lightGrayColor];
        //remove/refund stripe charges
        //tell parse to not do dishes
    }
}

- (void)laundry:(UIButton *)sender
{
    if (sender.tag == 0)
    {
        sender.tag = 1;
        sender.tintColor = [UIColor whiteColor];//[UIColor colorWithRed:0.0f green:0.49f blue:0.96f alpha:1.0f];
        //ask how many loads & charge stripe
        //tell parse to do dishes
    }
    else
    {
        sender.tag = 0;
        sender.tintColor  = [UIColor lightGrayColor];
        //remove/refund stripe charges
        //tell parse to not do dishes
    }
}

- (void)showMap
{
    [UIView transitionFromView:_front//viewToReplace
                        toView:_mapContainer//replacementView
                      duration:1
                       options:UIViewAnimationOptionTransitionFlipFromTop
                    completion:^(BOOL finished) {
                        CLLocationCoordinate2D location;
                        location.latitude = [[NSUserDefaults standardUserDefaults] floatForKey:@"latitude"];
                        location.longitude = [[NSUserDefaults standardUserDefaults] floatForKey:@"longitude"];

                        MKCoordinateRegion mapRegion;
                        mapRegion.center = location;
                        mapRegion.span.latitudeDelta = 0.05;
                        mapRegion.span.longitudeDelta = 0.05;
                        [_map setRegion:mapRegion animated:YES];

                        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
                        [annotation setCoordinate:location];
                        [annotation setTitle:@"Me"];
                        [annotation setSubtitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"address"]];
                        [_map addAnnotation:annotation];
                    }];
}

- (void)hideMap
{
    [UIView transitionFromView:_mapContainer//viewToReplace
                        toView:_front//replacementView
                      duration:1
                       options:UIViewAnimationOptionTransitionFlipFromBottom
                    completion:^(BOOL finished) {
                    }];
}

- (void)showAddons
{
    [UIView transitionFromView:_front//viewToReplace
                        toView:_addons//replacementView
                      duration:1
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    completion:^(BOOL finished) {
                    }];
}

- (void)hideAddons
{
    [UIView transitionFromView:_addons//viewToReplace
                        toView:_front//replacementView
                      duration:1
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    completion:^(BOOL finished) {
                    }];
}

- (void)showNotes
{
    [UIView transitionFromView:_front//viewToReplace
                        toView:_notesContainer//replacementView
                      duration:1
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    completion:^(BOOL finished) {
//                        [_notes becomeFirstResponder];
                    }];
}

- (void)hideNotes
{
    [UIView transitionFromView:_notesContainer//viewToReplace
                        toView:_front//replacementView
                      duration:1
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    completion:^(BOOL finished) {
                    }];
}

- (void)createTitle
{
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_front.bounds.origin.x+20,
                                                           _front.bounds.origin.y+10+_padding,
                                                           _front.bounds.size.width-20*2,
                                                           30)];
    _titleLabel.text = @"Visit";
    _titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:40];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.textColor = [UIColor whiteColor];
    [_front addSubview:_titleLabel];
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
    [_dateButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];             //turn
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

- (NSString *)getDate:(NSDate *)date
{
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSString *selectionString = [[NSString alloc] initWithFormat:@"%@", [date descriptionWithLocale:usLocale]];
    return selectionString;
}

@end
