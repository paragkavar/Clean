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
#import "INTULocationManager.h"

@interface GetAddressViewController ()
@property JSQFlatButton *save;
@property UITextField *addressField;
@property UITextView *addressLabel;
@property UIButton *locationButton;
@property BOOL gettingLocation;
@property int requestID;
@property CLLocation *location;
@property NSArray *formattedAddress;
@property NSString *addressString;
@property UIActivityIndicatorView *activity;
@end

@implementation GetAddressViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor midnightBlueColor];
    [self createTitle];
    [self createButton];
    [self createEntryField];
    [self createAddressLabel];
    [self createLocationButton];
    [self createActivityView];
    _gettingLocation = NO;

#warning get number of bedrooms, bathrooms
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

- (void)createAddressLabel
{
    _addressLabel = [[UITextView alloc] initWithFrame:CGRectMake(20, 120, self.view.frame.size.width-2*20, 100)];
    _addressLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:25];
    _addressLabel.backgroundColor = [UIColor clearColor];
    _addressLabel.textColor = [UIColor whiteColor];
    _addressLabel.textAlignment = NSTextAlignmentCenter;
    _addressLabel.editable = NO;
    _addressLabel.selectable = NO;
    [self.view addSubview:_addressLabel];
    _addressLabel.hidden = YES;
}

- (void)createActivityView
{
    _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activity.center = _addressLabel.center;
    [_activity hidesWhenStopped];
    [self.view addSubview:_activity];
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
#warning check if GPS is available
    [self.view addSubview:_locationButton];
}

- (void)location:(UIButton *)sender
{
    if (_gettingLocation)
    {
        _gettingLocation = NO;
        [[INTULocationManager sharedInstance] cancelLocationRequest:_requestID];
        [self revertFromLocationGetting];
    }
    else
    {
        _gettingLocation = YES;
        _locationButton.enabled = NO;
        [_activity startAnimating];

        INTULocationManager *locMgr = [INTULocationManager sharedInstance];
        _requestID = [locMgr requestLocationWithDesiredAccuracy:INTULocationAccuracyHouse
                                                        timeout:30.0
                                           delayUntilAuthorized:YES
                                                          block:^(CLLocation *currentLocation,
                                                                  INTULocationAccuracy achievedAccuracy,
                                                                  INTULocationStatus status)
         {
             if (status == INTULocationStatusSuccess)
             {
                 [[CLGeocoder new] reverseGeocodeLocation:currentLocation
                                        completionHandler:^(NSArray *placemarks, NSError *error)
                 {
                     if (error || placemarks.count == 0)
                     {
                         [self revertFromLocationGetting];
                         [[[UIAlertView alloc] initWithTitle:@"Error Gettting Location" message:@"Please try again or enter manually" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                     }
                     else
                     {
                         [_activity stopAnimating];
                         _location = currentLocation;
                         _formattedAddress = [placemarks.firstObject addressDictionary][@"FormattedAddressLines"];
                         _addressString = [NSString stringWithFormat:@"%@\n%@",_formattedAddress[0],_formattedAddress[1]];
                         _addressLabel.text = _addressString;
                         _addressLabel.hidden = NO;
                         _locationButton.enabled = YES;
                         _save.enabled = YES;
                     }
                 }];
             }
             else if (status == INTULocationStatusTimedOut)
             {
                 [self revertFromLocationGetting];
                 [[[UIAlertView alloc] initWithTitle:@"Error Gettting Location" message:@"Please try again or enter manually" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
             }
             else
             {
                 [self revertFromLocationGetting];
                 [[[UIAlertView alloc] initWithTitle:@"Error Gettting Location" message:@"Please try again or enter manually" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
             }
         }];

        _addressField.hidden = YES;
        [_addressField resignFirstResponder];
        [UIView animateWithDuration:.3 animations:^{
            _locationButton.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2+100);
            _save.transform = CGAffineTransformMakeTranslation(0, 216);
        }];
    }
}

- (void)revertFromLocationGetting
{
    [_activity stopAnimating];
    _save.enabled = NO;
    _addressLabel.hidden = YES;
    [UIView animateWithDuration:.3 animations:^{
        _locationButton.center = CGPointMake(self.view.frame.size.width/2, 110);
        _save.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) {
        _addressField.hidden = NO;
        [_addressField becomeFirstResponder];
    }];
}

- (void)save:(JSQFlatButton *)sender
{
    if (!_addressString)
    {
        _addressString = _addressField.text;
    }
    [[NSUserDefaults standardUserDefaults] setObject:_addressString forKey:@"address"];
    [self presentViewController:[GetPaymentCardViewController new] animated:NO completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end