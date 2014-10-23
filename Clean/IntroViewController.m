//
//  IntroViewController.m
//  Clean
//
//  Created by Sapan Bhuta on 8/28/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import "IntroViewController.h"
#import "GetPhoneNumberViewController.h"
#import "JSQFlatButton.h"
#import "INCollectionViewCell.h"
#import "User.h"
#import "Constants.h"

@interface IntroViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property JSQFlatButton *start;
@property UICollectionView *collectionView;
@property UIPageControl *page;
@end

@implementation IntroViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [Constants backgroundColor];
    [self createPage];
    [self createButton];
    [self createCollectionView];
}

- (void)createPage
{
    _page = [[UIPageControl alloc] init];
    _page.center = CGPointMake(self.view.center.x, self.view.frame.size.height-27);
    _page.numberOfPages = 5;
    _page.currentPage = 0;
    _page.backgroundColor = [UIColor clearColor];
    _page.tintColor = [UIColor whiteColor];
    _page.currentPageIndicatorTintColor = [UIColor colorWithRed:0.0f green:0.49f blue:0.96f alpha:1.0f];
    [self.view addSubview:_page];
}

- (void)createButton
{
    _start = [[JSQFlatButton alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-54,self.view.frame.size.width,54)
                                      backgroundColor:[UIColor colorWithRed:1.00f green:1.00f blue:1.00f alpha:1.0f]
                                      foregroundColor:[UIColor colorWithRed:0.35f green:0.35f blue:0.81f alpha:1.0f]
                                                title:@"register now"
                                                image:nil];
    [_start addTarget:self action:@selector(start:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_start];
    _start.hidden = YES;
}

- (void)start:(JSQFlatButton *)sender
{
    [User setStarted:YES];
    [self presentViewController:[GetPhoneNumberViewController new] animated:NO completion:nil];
}

- (void)createCollectionView
{
    UICollectionViewFlowLayout *flow = [UICollectionViewFlowLayout new];
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flow.minimumLineSpacing = 0;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-54) collectionViewLayout:flow];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[INCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:_collectionView];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    INCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    _page.currentPage = indexPath.item;
    if (indexPath.item == 4)
    {
        _start.hidden = NO;
        cell.imageView.image = [UIImage imageNamed:@"arrow-left"];
        cell.shimmeringView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }
    else
    {
//        _start.hidden = YES;
        cell.imageView.image = [UIImage imageNamed:@"arrow-left"];
        cell.shimmeringView.transform = CGAffineTransformMakeRotation(M_PI);
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.frame.size.width, _collectionView.frame.size.height);
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
