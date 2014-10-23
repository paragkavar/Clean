//
//  RootViewController.m
//  Clean
//
//  Created by Sapan Bhuta on 8/27/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#warning systemize plans and cost through Parse
#warning systemize assigning cleaners via Parse (get their availability)
#warning save notes and charge addons per visit

#define shimmeringFrame CGRectMake(15,20,290,55)
#define dateFrame CGRectMake(0, 80, 320, 115)
#define buttonFrame CGRectMake(0, self.view.frame.size.height-54, self.view.frame.size.width, 54)

#import "RootViewController.h"
#import <Parse/Parse.h>
#import "JSQFlatButton.h"
#import "FBShimmeringView.h"
#import "SBCollectionViewCell.h"
#import "SettingsViewController.h"
#import "User.h"
#import "RQScrollView.h"
#import "ScheduleViewController.h"
#import "ParseLogic.h"
#import "Visit.h"
#import "Cleaner.h"
#import "Constants.h"

@interface RootViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
@property UICollectionView *collectionView;
@property NSArray *visits;
@property UIPageControl *page;
@property JSQFlatButton *subscribe;
@property UIDatePicker *datePicker;
@property UIActivityIndicatorView *activity;
@property UIView *infoView;
@property BOOL showingBack;
@property UIView *containerView;
@property NSDate *selectedDate;
@property BOOL popupOn;
@property UIView *darken;
@property UIButton *settings;
@property JSQFlatButton *request;
@property UIView *darkView;
@property RQScrollView *requestView;
@property JSQFlatButton *cancel;
@property JSQFlatButton *schedule;
@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [Constants backgroundColor];
    [self createPage];
    [self createTitle];
    [self createSettings];
    [self createCollectionView];
    [self createRequestView];
    [self createRequest];
    [self createRequestButtons];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(spin) name:@"spin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableSchedule:) name:@"schedule" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateVisits];
}

- (void)updateVisits
{
    [ParseLogic retrieveVisitsWithCompletionHandler:^(NSArray *visits) {
        _visits = visits;
        _page.numberOfPages = _visits.count;
        [_collectionView reloadData];
    }];
}

- (void)createRequest
{
    _request = [[JSQFlatButton alloc] initWithFrame:CGRectMake(0,
                                                               self.view.frame.size.height-54,
                                                               self.view.frame.size.width,
                                                               54)
                                   backgroundColor:[UIColor colorWithRed:1.00f green:1.00f blue:1.00f alpha:1.0f]
                                   foregroundColor:[UIColor colorWithRed:0.35f green:0.35f blue:0.81f alpha:1.0f]
                                             title:@"request a clean"
                                             image:nil];
    [_request addTarget:self action:@selector(request:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_request];
}

- (void)request:(JSQFlatButton *)sender
{
//    [self presentViewController:[ScheduleViewController new] animated:YES completion:nil];
    [self presentRequestView];
}

- (void)presentRequestView
{
    [UIView animateWithDuration:.3 animations:^{
        if (CGAffineTransformIsIdentity(_requestView.transform)) {
            _darkView.alpha = 0;
            _requestView.transform = CGAffineTransformMakeTranslation(0, self.view.frame.size.height);
            _cancel.hidden = YES;
            _schedule.hidden = YES;
            _request.hidden = NO;
        } else {
            _darkView.alpha = .8;
            _requestView.transform = CGAffineTransformIdentity;
            _request.hidden = YES;
            _cancel.hidden = NO;
            _schedule.hidden = NO;
        }
    }];
}

- (void)createRequestView
{
    _darkView = [[UIView alloc] initWithFrame:self.view.bounds];
    _darkView.backgroundColor = [UIColor blackColor];
    _darkView.alpha = 0;
    [self.view addSubview:_darkView];

    _requestView = [[RQScrollView alloc] initWithFrame:CGRectMake(10, 80, self.view.frame.size.width-20, self.view.frame.size.width-20)];
    _requestView.center = self.view.center;
    _requestView.backgroundColor = [UIColor blackColor];
    _requestView.transform = CGAffineTransformMakeTranslation(0, self.view.frame.size.height);
    [self.view addSubview:_requestView];
}

- (void)createRequestButtons
{
    _cancel = [[JSQFlatButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-54, self.view.frame.size.width/2-.25, 54)
                                   backgroundColor:[UIColor colorWithRed:0.18f green:0.67f blue:0.84f alpha:1.0f]
                                   foregroundColor:[UIColor colorWithRed:1.00f green:1.00f blue:1.00f alpha:1.0f]
                                             title:@"cancel"
                                             image:nil];
    [_cancel addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancel];
    _cancel.hidden = YES;

    _schedule = [[JSQFlatButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2+.25, self.view.frame.size.height-54, self.view.frame.size.width/2-.25, 54)
                                     backgroundColor:[UIColor colorWithRed:1.00f green:1.00f blue:1.00f alpha:1.0f]
                                     foregroundColor:[UIColor colorWithRed:0.35f green:0.35f blue:0.81f alpha:1.0f]
                                               title:@"schedule"
                                               image:nil];
    [_schedule addTarget:self action:@selector(schedule:) forControlEvents:UIControlEventTouchUpInside];
    _schedule.enabled = NO;
    [self.view addSubview:_schedule];
    _schedule.hidden = YES;
}

- (void)enableSchedule:(NSNotification *)notification
{
    _schedule.enabled = [notification.object boolValue];
}

- (void)cancel:(JSQFlatButton *)sender
{
    [self presentRequestView];
}

- (void)schedule:(JSQFlatButton *)sender
{
    [self presentRequestView];
    NSDictionary *params = @{@"amount":@(_requestView.cost).description, @"customer":[User customerId]};

    [PFCloud callFunctionInBackground:@"createCharge" withParameters:params block:^(NSString *chargeId, NSError *error) {
        if (chargeId && !error)
        {
            [ParseLogic createVisitWithCompletionHandler:^(BOOL succeeded, NSError *error) {
                if (succeeded)
                {
                    [self updateVisits];
                }
            }];
        }
        else
        {
            NSLog(@"error: %@",error);
            [[[UIAlertView alloc] initWithTitle:@"Error charging your card" message:@"Please check if your card is valid" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }
    }];
}

- (void)createPage
{
    _page = [[UIPageControl alloc] init];
    _page.center = CGPointMake(self.view.center.x, 500);
    _page.numberOfPages = _visits.count;
    _page.currentPage = 0;
    _page.hidesForSinglePage = YES;
    _page.backgroundColor = [UIColor clearColor];
    _page.tintColor = [UIColor whiteColor];
    _page.currentPageIndicatorTintColor = [UIColor colorWithRed:0.0f green:0.49f blue:0.96f alpha:1.0f];
    [self.view addSubview:_page];
}

- (void)createTitle
{
    FBShimmeringView *shimmeringView = [[FBShimmeringView alloc] initWithFrame:shimmeringFrame];
    [self.view addSubview:shimmeringView];
    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:shimmeringView.bounds];
    loadingLabel.textAlignment = NSTextAlignmentCenter;
    loadingLabel.textColor = [UIColor whiteColor];
    loadingLabel.text = @"Clean";
    loadingLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:50];
    shimmeringView.contentView = loadingLabel;
    shimmeringView.shimmering = YES;
}

- (void)createSettings
{
    _settings = [UIButton buttonWithType:UIButtonTypeSystem];
    _settings.frame = CGRectMake(20, 20, 36, 36);
    _settings.center = CGPointMake(270, 52);
    _settings.tintColor = [UIColor lightGrayColor];
    [_settings setImage:[UIImage imageNamed:@"gear"] forState:UIControlStateNormal];
    [_settings addTarget:self action:@selector(spin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_settings];
}

- (void)spin
{
    [UIView animateWithDuration:.8 delay:0 usingSpringWithDamping:.6 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseOut animations:^{
        if (CGAffineTransformIsIdentity(_settings.transform))
        {
            _settings.transform = CGAffineTransformMakeRotation(M_PI);
        }
        else
        {
            _settings.transform = CGAffineTransformIdentity;
        }
    } completion:^(BOOL finished) {

    }];

    [self presentViewController:[SettingsViewController new] animated:YES completion:nil];
}

- (void)createCollectionView
{
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,
                                                                         80,
                                                                         self.view.frame.size.width,
                                                                         self.view.frame.size.width)
                                         collectionViewLayout:flow];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;

    if (flow.scrollDirection == UICollectionViewScrollDirectionHorizontal)
    {
        _collectionView.center = self.view.center;
        flow.minimumLineSpacing = 0;
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    _collectionView.pagingEnabled = (flow.scrollDirection == UICollectionViewScrollDirectionHorizontal);
    _page.hidden = (flow.scrollDirection != UICollectionViewScrollDirectionHorizontal);
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[SBCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:_collectionView];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _visits.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SBCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    _page.currentPage = indexPath.item;
    cell.titleLabel.text = [NSString stringWithFormat:@"visit %i",indexPath.item+1];

    if (_visits && [_visits[indexPath.item] cleaners])
    {
        Visit *visit = _visits[indexPath.item];
        Cleaner *cleaner = visit.cleaners.firstObject;

        cell.nameLabel.text = cleaner.name;
        cell.dateLabel.text = visit.date;
        cell.imageView.image = cleaner.profilePic;
    }
    else
    {
        cell.nameLabel.text = @"Michelle Borromeo";
        cell.dateLabel.text = @"12:00pm on 8/30/2014";
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"headshot%i",(indexPath.item%4)+1]];
    }

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.frame.size.width, self.view.frame.size.width);
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
