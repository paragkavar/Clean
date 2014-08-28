//
//  GetAddressViewController.m
//  Clean
//
//  Created by Sapan Bhuta on 8/28/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import "GetAddressViewController.h"
#import "GetPaymentCardViewController.h"
#import "JSQFlatButton.h"
#import "UIColor+FlatUI.h"
#import <CoreLocation/CoreLocation.h>

@interface GetAddressViewController () <CLLocationManagerDelegate>
@property JSQFlatButton *save;
@property UITextField *addressField;
@property UIButton *locationButton;
@property CLLocationManager *locationManager;
@end

@implementation GetAddressViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor midnightBlueColor];
    [self createTitle];
    [self createButton];
    [self createEntryField];
    [self createLocationButton];
}

- (void)createTitle
{
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, self.view.frame.size.width-2*10, 50)];
    title.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:50];
    title.textColor = [UIColor whiteColor];
    title.text = @"Address";
    title.adjustsFontSizeToFitWidth = YES;
    title.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:title];
}

- (void)createButton
{
    _save = [[JSQFlatButton alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-216-54,self.view.frame.size.width,54)
                                 backgroundColor:[UIColor colorWithRed:1.00f green:1.00f blue:1.00f alpha:1.0f]
                                 foregroundColor:[UIColor colorWithRed:0.35f green:0.35f blue:0.81f alpha:1.0f]
                                           title:@"save"
                                           image:nil];
    [_save addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_save];
    _save.enabled = NO;
}

- (void)createEntryField
{
    _addressField = [[UITextField alloc] initWithFrame:CGRectMake(20, 120, self.view.frame.size.width-2*20, 100)];
    _addressField.placeholder = @"enter address";
    _addressField.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:35];
    _addressField.textColor = [UIColor whiteColor];
    _addressField.adjustsFontSizeToFitWidth = YES;
    _addressField.keyboardAppearance = UIKeyboardAppearanceDark;
    _addressField.keyboardType = UIKeyboardTypePhonePad;
    _addressField.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_addressField];
    [_addressField becomeFirstResponder];
}

- (void)createLocationButton
{
    _locationButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _locationButton.tintColor = [UIColor whiteColor];
    [_locationButton addTarget:self action:@selector(location:) forControlEvents:UIControlEventTouchUpInside];
    [_locationButton setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
    _locationButton.frame = CGRectMake(self.view.frame.size.width - 53, 121.5, 48, 48);
    _locationButton.center = CGPointMake(self.view.frame.size.width/2, 110);
//    _locationButton.hidden = ![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera];
    [self.view addSubview:_locationButton];
}

- (void)location:(UIButton *)sender
{
    [self startTrackingLocation];

    _addressField.hidden = YES;
    [_addressField resignFirstResponder];
    [UIView animateWithDuration:.3 animations:^{
        _locationButton.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2+100);
        _save.transform = CGAffineTransformMakeTranslation(0, 216);
    }];
}

- (void)startTrackingLocation
{
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [_locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
#warning get and show location and then save it
    NSLog(@"OldLocation %f %f", oldLocation.coordinate.latitude, oldLocation.coordinate.longitude);
    NSLog(@"NewLocation %f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    _save.enabled = YES;
}

- (void)save:(JSQFlatButton *)sender
{
#warning check if have gps location and if so then save else save using enteredText
    [[NSUserDefaults standardUserDefaults] setObject:_addressField.text forKey:@"address"];
    [self presentViewController:[GetPaymentCardViewController new] animated:NO completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end