//
//  GetPaymentCardViewController.m
//  Cents
//
//  Created by Sapan Bhuta on 7/30/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#define kStripePublishableKey @"pk_test_fO6i0Qb9j3ohWjPyxdTxXrft"
#define kCardioToken @"87d236fddee4492c930cad66875ff1ab"

#import "GetPaymentCardViewController.h"
#import "STPView.h"
#import "JSQFlatButton.h"
#import "UIColor+FlatUI.h"
#import "CardIO.h"
#import <Parse/Parse.h>
#import "RootViewController.h"
#import "PKTextField.h"

@interface GetPaymentCardViewController () <STPViewDelegate, CardIOPaymentViewControllerDelegate>
@property STPView *stripeView;
@property STPCard *stripeCard;
@property JSQFlatButton *save;
@property JSQFlatButton *camera;
@property UIButton *cameraIcon;
@end

@implementation GetPaymentCardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor midnightBlueColor];
    [self createTitle];
    [self createStripeViewDefault];
    [self createSaveButton];
    [self createCameraButton];
}

- (void)createTitle
{
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, self.view.frame.size.width-2*10, 50)];
    title.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:50];
    title.textColor = [UIColor whiteColor];
    title.text = @"Credit or Debit Card";
    title.adjustsFontSizeToFitWidth = YES;
    title.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:title];
}

- (void)createSaveButton
{
    _save = [[JSQFlatButton alloc] initWithFrame:CGRectMake(0,
                                                            self.view.frame.size.height-216-54,
                                                            self.view.frame.size.width,
                                                            54)
                                 backgroundColor:[UIColor colorWithRed:1.00f green:1.00f blue:1.00f alpha:1.0f]
                                 foregroundColor:[UIColor colorWithRed:0.35f green:0.35f blue:0.81f alpha:1.0f]
                                           title:@"save"
                                           image:nil];
    [_save addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_save];
    _save.enabled = NO;
}

- (void)save:(UIButton *)sender
{
    _save.enabled = NO;

    if (_stripeCard && [_stripeCard validateCardReturningError:nil])
    {
        [Stripe createTokenWithCard:_stripeCard publishableKey:kStripePublishableKey completion:^(STPToken *token, NSError *error) {
             if (error)
             {
                 [self handleStripeError:error];
             }
             else
             {
                 [self createCustomer:token];
             }
        }];
    }
    else
    {
        [UIView animateWithDuration:.3 animations:^{
            _save.transform = CGAffineTransformMakeTranslation(0, _save.transform.ty+216);
        }];
        [self.stripeView createToken:^(STPToken *token, NSError *error) {
             if (error)
             {
                 _save.enabled = YES;
                 [self handleStripeError:error];
             }
             else
             {
                 [self createCustomer:token];
             }
        }];
    }
}

- (void)handleStripeError:(NSError *)error
{
    [UIView animateWithDuration:.3 animations:^{
        _save.transform = CGAffineTransformMakeTranslation(0, _save.transform.ty-216);
    }];
    _save.enabled = YES;
    _stripeView.hidden = NO;
    _cameraIcon.hidden = ![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera];
    [_stripeView.paymentView becomeFirstResponder];
    [[[UIAlertView alloc] initWithTitle:@"Error trying to save card" message:@"Please try again with a good network connection and a working card" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}

- (void)createCameraButton
{
    _cameraIcon = [UIButton buttonWithType:UIButtonTypeSystem];
    _cameraIcon.tintColor = [UIColor whiteColor];
    [_cameraIcon addTarget:self action:@selector(camera:) forControlEvents:UIControlEventTouchUpInside];
    [_cameraIcon setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    _cameraIcon.frame = CGRectMake(self.view.frame.size.width - 53, 121.5, 48, 48);
    _cameraIcon.hidden = ![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera];
    [self.view addSubview:_cameraIcon];
}

- (void)camera:(UIButton *)sender
{
    _stripeView.hidden = YES;
    _cameraIcon.hidden = YES;
    [UIView animateWithDuration:.3 animations:^{
        _save.transform = CGAffineTransformMakeTranslation(0, _save.transform.ty+216);
    }];
    [self scanCard];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Card.io

- (void)scanCard
{
    CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
    scanViewController.appToken = kCardioToken;
    [self presentViewController:scanViewController animated:YES completion:nil];
}

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)scanViewController
{
    NSLog(@"User canceled payment info");
    [scanViewController dismissViewControllerAnimated:YES completion:nil];
    _stripeView.hidden = NO;
    _cameraIcon.hidden = NO;
    [_stripeView.paymentView becomeFirstResponder];
    [UIView animateWithDuration:.3 animations:^{
        _save.transform = CGAffineTransformMakeTranslation(0, _save.transform.ty-216);
    }];
}

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info
             inPaymentViewController:(CardIOPaymentViewController *)scanViewController
{
    [scanViewController dismissViewControllerAnimated:YES completion:nil];

    _stripeCard = [[STPCard alloc] init];
    _stripeCard.number = info.cardNumber;
    _stripeCard.expMonth = info.expiryMonth;
    _stripeCard.expYear = info.expiryYear;
    _stripeCard.cvc = info.cvv;

    if ([_stripeCard validateCardReturningError:nil])
    {
        _save.enabled = YES;
    }
}

#pragma mark - Stripe

- (void)createStripeViewDefault
{
    self.stripeView = [[STPView alloc] initWithFrame:CGRectMake(15,127.5,290,55) andKey:kStripePublishableKey];
    self.stripeView.delegate = self;
    [self.view addSubview:self.stripeView];

    self.stripeView.paymentView.cardNumberField.keyboardAppearance = UIKeyboardAppearanceDark;
    self.stripeView.paymentView.cardExpiryField.keyboardAppearance = UIKeyboardAppearanceDark;
    self.stripeView.paymentView.cardCVCField.keyboardAppearance = UIKeyboardAppearanceDark;
//    self.stripeView.paymentView.cardNumberField.textColor = [UIColor whiteColor];
//    self.stripeView.paymentView.cardExpiryField.textColor = [UIColor whiteColor];
//    self.stripeView.paymentView.cardCVCField.textColor = [UIColor whiteColor];
    [self.stripeView.paymentView.subviews[0] setHidden:YES];
    [self.stripeView.paymentView.innerView.subviews[1] setHidden:YES];
    [self.stripeView.paymentView.innerView.subviews[2] setHidden:YES];

    NSLog(@"%@",self.stripeView.paymentView.innerView.subviews);
}

- (void)stripeView:(STPView *)view withCard:(PKCard *)card isValid:(BOOL)valid
{
    _save.enabled = valid;
}

- (void)createCustomer:(STPToken *)token
{
    NSString *phoneNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
    [PFCloud callFunctionInBackground:@"createCustomer"
                       withParameters:@{@"token":token.tokenId, @"phoneNumber":phoneNumber}
                                block:^(id customer, NSError *error)
    {
        if (error)
        {
            NSLog(@"Error in creating customer: %@",error);
            [self handleStripeError:error];
//            [self presentViewController:self animated:NO completion:nil];
#warning figure out
        }
        else
        {
            NSLog(@"Customer created successfully with id: %@", customer);
            [[NSUserDefaults standardUserDefaults] setObject:customer[@"id"] forKey:@"customerId"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self addUserToDataBase];
            [self presentViewController:[RootViewController new] animated:NO completion:nil];
        }
    }];
}

- (void)addUserToDataBase
{
    PFQuery *query = [PFQuery queryWithClassName:@"User"];
    [query whereKey:@"phoneNumber" equalTo:[[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (PFObject *object in objects) {
            [object deleteInBackground];
        }
        PFObject *user = [PFObject objectWithClassName:@"User"];
        user[@"phoneNumber"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
        user[@"address"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"address"];
        user[@"customerId"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"customerId"];
        [user saveInBackground];
    }];
}

@end

