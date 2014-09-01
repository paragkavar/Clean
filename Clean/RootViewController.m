//
//  RootViewController.m
//  Clean
//
//  Created by Sapan Bhuta on 8/27/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#define shimmeringFrame CGRectMake(15,20,290,55)
#define dateFrame CGRectMake(0, 80, 320, 115)
#define buttonFrame CGRectMake(0, self.view.frame.size.height-54, self.view.frame.size.width, 54)

#import "RootViewController.h"
#import <Parse/Parse.h>
#import "JSQFlatButton.h"
#import "UIColor+FlatUI.h"
#import "FBShimmeringView.h"
#import "SBCollectionViewCell.h"

@interface RootViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
@property UICollectionView *collectionView;
@property int visits;
@property UIPageControl *page;
@property JSQFlatButton *clean;
@property JSQFlatButton *subscribe;
@property UIDatePicker *datePicker;
@property UIActivityIndicatorView *activity;
@property UIView *infoView;
@property BOOL showingBack;
@property UIView *containerView;
@property NSDate *selectedDate;
@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor midnightBlueColor];
    _visits = [[[NSUserDefaults standardUserDefaults] objectForKey:@"visits"] intValue];
    [self createPage];
    [self createTitle];
    [self createCollectionView];
//    [self createContainer];
//    [self createCalendar];
//    [self createInfoView];
//    [self createButton];
//    [self createActivityView];
}

- (void)createPage
{
    _page = [[UIPageControl alloc] init];
    _page.center = CGPointMake(self.view.center.x, 500);
    _page.numberOfPages = _visits;
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

- (void)createCollectionView
{
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,
                                                                         80,
                                                                         self.view.frame.size.width,
                                                                         self.view.frame.size.height-80)
                                         collectionViewLayout:flow];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;

    if (flow.scrollDirection == UICollectionViewScrollDirectionHorizontal)
    {
        _collectionView.center = self.view.center;
        flow.minimumLineSpacing = 0;
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
    return _visits;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SBCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    _page.currentPage = indexPath.item;
    cell.titleLabel.text = [NSString stringWithFormat:@"Visit #%i",indexPath.item+1];
    cell.nameLabel.text = @"Michelle Borromeo";
    cell.dateLabel.text = @"12:00pm on 8/30/2014";
    if (indexPath.item < 5)
    {
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"headshot%i",indexPath.item+1]];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.frame.size.width, self.view.frame.size.width);
}

- (void)createContainer
{
    _containerView = [[UIView alloc] initWithFrame:self.view.bounds];
    _containerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_containerView];
}

- (void)createActivityView
{
    _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activity.center = self.view.center;
    [_activity hidesWhenStopped];
    [self.view addSubview:_activity];
}

- (void)createButton
{
    self.clean = [[JSQFlatButton alloc] initWithFrame:buttonFrame
                                      backgroundColor:[UIColor colorWithRed:1.00f green:1.00f blue:1.00f alpha:1.0f]
                                      foregroundColor:[UIColor colorWithRed:0.35f green:0.35f blue:0.81f alpha:1.0f]
                                                title:@"Clean"
                                                image:nil];
    [self.clean addTarget:self action:@selector(clean:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.clean];
//    self.clean.enabled = NO;
}

- (void)clean:(JSQFlatButton *)sender
{

}

- (void)recordTransaction:(NSString *)chargeId
{
    PFObject *transaction = [PFObject objectWithClassName:@"Transaction"];
    transaction[@"phoneNumber"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
    transaction[@"address"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"address"];
//    transaction[@"date"] = [self getDate:_selectedDate];
    transaction[@"customerId"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"customerId"];
    transaction[@"chargeId"] = chargeId;
    [transaction saveInBackground];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
