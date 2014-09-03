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
#import "PKTextField.h"
#import "JSQFlatButton.h"
#import "UIColor+FlatUI.h"
#import "CardIO.h"
#import <Parse/Parse.h>
#import "RootViewController.h"
#import "VCFlow.h"

@interface GetPaymentCardViewController () <STPViewDelegate, CardIOPaymentViewControllerDelegate>
@property STPView *stripeView;
@property STPCard *stripeCard;
@property JSQFlatButton *subscribe;
@property JSQFlatButton *camera;
@property UIButton *cameraIcon;
@end

@implementation GetPaymentCardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor midnightBlueColor];
    [self createPage];
    [self createTitle];
    [self createStripeViewDefault];
    [self createSaveButton];
    [self createCameraButton];
}

- (void)createPage
{
    _page = [[UIPageControl alloc] init];
    _page.center = CGPointMake(self.view.center.x, 100);
    _page.numberOfPages = 5;
    _page.currentPage = 4;
    _page.backgroundColor = [UIColor clearColor];
    _page.tintColor = [UIColor whiteColor];
    _page.currentPageIndicatorTintColor = [UIColor colorWithRed:0.0f green:0.49f blue:0.96f alpha:1.0f];
    [self.view addSubview:_page];
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
    _subscribe = [[JSQFlatButton alloc] initWithFrame:CGRectMake(0,
                                                            self.view.frame.size.height-216-54,
                                                            self.view.frame.size.width,
                                                            54)
                                 backgroundColor:[UIColor colorWithRed:1.00f green:1.00f blue:1.00f alpha:1.0f]
                                 foregroundColor:[UIColor colorWithRed:0.35f green:0.35f blue:0.81f alpha:1.0f]
                                           title:@"subscribe"
                                           image:nil];
    [_subscribe addTarget:self action:@selector(subscribe:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_subscribe];
    _subscribe.enabled = NO;
}

- (void)subscribe:(UIButton *)sender
{
    _subscribe.enabled = NO;

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
                 [[NSUserDefaults standardUserDefaults] setObject:_stripeCard.last4 forKey:@"last4"];
             }
        }];
    }
    else
    {
        [UIView animateWithDuration:.3 animations:^{
            _subscribe.transform = CGAffineTransformMakeTranslation(0, _subscribe.transform.ty+216);
        }];
        [self.stripeView createToken:^(STPToken *token, NSError *error) {
             if (error)
             {
                 _subscribe.enabled = YES;
                 [self handleStripeError:error];
             }
             else
             {
                 [self createCustomer:token];
                 [[NSUserDefaults standardUserDefaults] setObject:_stripeView.paymentView.cardNumber.last4 forKey:@"last4"];
             }
        }];
    }
}

- (void)handleStripeError:(NSError *)error
{
    [UIView animateWithDuration:.3 animations:^{
        _subscribe.transform = CGAffineTransformMakeTranslation(0, _subscribe.transform.ty-216);
    }];
    _subscribe.enabled = YES;
    _stripeView.hidden = NO;
    _cameraIcon.hidden = ![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera];
    [_stripeView.paymentView becomeFirstResponder];
    [[[UIAlertView alloc] initWithTitle:@"Error trying to subscribe" message:@"Please try again with a good network connection and a working card" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
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
        _subscribe.transform = CGAffineTransformMakeTranslation(0, _subscribe.transform.ty+216);
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
        _subscribe.transform = CGAffineTransformMakeTranslation(0, _subscribe.transform.ty-216);
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
        _subscribe.enabled = YES;
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
    _subscribe.enabled = valid;
}

- (void)createCustomer:(STPToken *)token
{
    NSString *phoneNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
    [PFCloud callFunctionInBackground:@"createCustomer"
                       withParameters:@{@"token":token.tokenId, @"phoneNumber":phoneNumber}
                                block:^(NSString *customerId, NSError *error)
    {
        if (error)
        {
            [self handleStripeError:error];
        }
        else
        {
            NSLog(@"CustomerId: %@",customerId);
            [[NSUserDefaults standardUserDefaults] setObject:customerId forKey:@"customerId"];
            [[NSUserDefaults standardUserDefaults] synchronize];

            NSString *plan = [[NSUserDefaults standardUserDefaults] objectForKey:@"plan"];

            [PFCloud callFunctionInBackground:@"createSubscription"
                               withParameters:@{@"customer":customerId,
                                                @"plan":plan}
                                        block:^(NSString *subscriptionId, NSError *error)
             {
                  if (error)
                  {
                      [self handleStripeError:error];
                  }
                  else
                  {
                      NSLog(@"subscriptionId: %@",subscriptionId);
                      [[NSUserDefaults standardUserDefaults] setObject:subscriptionId forKey:@"subscriptionId"];
                      [[NSUserDefaults standardUserDefaults] synchronize];
                      [VCFlow addUserToDataBase];
                      [self presentViewController:[RootViewController new] animated:NO completion:nil];
                  }
             }];
        }
    }];
}

@end