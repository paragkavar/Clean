//
//  GetPaymentCardViewController.m
//  Cents
//
//  Created by Sapan Bhuta on 7/30/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#define kStripePublishableKey @"pk_test_fO6i0Qb9j3ohWjPyxdTxXrft"
#define kCardioToken @"87d236fddee4492c930cad66875ff1ab"

#import "GetPayCardViewController.h"
#import "PKTextField.h"
#import "UIColor+FlatUI.h"
#import "CardIO.h"
#import <Parse/Parse.h>
#import "GetPlanViewController.h"
#import "VCFlow.h"
#import "User.h"

@interface GetPayCardViewController () <STPViewDelegate, CardIOPaymentViewControllerDelegate>
@property STPView *stripeView;
@property STPCard *stripeCard;
@property JSQFlatButton *camera;
@property UIButton *cameraIcon;
@end

@implementation GetPayCardViewController

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
    _back = [[JSQFlatButton alloc] initWithFrame:CGRectZero
                                 backgroundColor:[UIColor colorWithRed:0.18f green:0.67f blue:0.84f alpha:1.0f]
                                 foregroundColor:[UIColor colorWithRed:1.00f green:1.00f blue:1.00f alpha:1.0f]
                                           title:@"back"
                                           image:nil];
    [_back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_back];
    
    _subscribe = [[JSQFlatButton alloc] initWithFrame:CGRectMake(0,
                                                            self.view.frame.size.height-216-54,
                                                            self.view.frame.size.width,
                                                            54)
                                 backgroundColor:[UIColor colorWithRed:1.00f green:1.00f blue:1.00f alpha:1.0f]
                                 foregroundColor:[UIColor colorWithRed:0.35f green:0.35f blue:0.81f alpha:1.0f]
                                           title:@"save"
                                           image:nil];
    [_subscribe addTarget:self action:@selector(subscribe:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_subscribe];
    _subscribe.enabled = NO;
}

- (void)back:(JSQFlatButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)subscribe:(UIButton *)sender
{
    _subscribe.enabled = NO;
    _back.enabled = NO;
    [self validateCard];
}

- (void)validateCard
{
    if (_stripeCard && [_stripeCard validateCardReturningError:nil])
    {
        [Stripe createTokenWithCard:_stripeCard publishableKey:kStripePublishableKey completion:^(STPToken *token, NSError *error) {
            if (error)
            {
                [self handleStripeError:error];
            }
            else
            {
                _last4 = _stripeCard.last4;
                [self handleStripeToken:token];
            }
        }];
    }
    else
    {
        [UIView animateWithDuration:.3 animations:^{
            _subscribe.transform = CGAffineTransformMakeTranslation(0, _subscribe.transform.ty+216);
            _back.transform = CGAffineTransformMakeTranslation(0, _back.transform.ty+216);
        }];
        [self.stripeView createToken:^(STPToken *token, NSError *error) {
            if (error)
            {
                [self handleStripeError:error];
            }
            else
            {
                _last4 = _stripeView.paymentView.cardNumber.last4;
                [self handleStripeToken:token];
            }
        }];
    }
}

- (void)handleStripeToken:(STPToken *)token
{
    [self createCustomer:token];
}

- (void)handleStripeError:(NSError *)error
{
    [UIView animateWithDuration:.3 animations:^{
        _subscribe.transform = CGAffineTransformMakeTranslation(0, _subscribe.transform.ty-216);
        _back.transform = CGAffineTransformMakeTranslation(0, _back.transform.ty-216);
    }];
    _subscribe.enabled = YES;
    _back.enabled = YES;
    _stripeView.hidden = NO;
    _cameraIcon.hidden = ![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera];
    [_stripeView.paymentView becomeFirstResponder];
    [self displayErrorAlert];
}

- (void)displayErrorAlert
{
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
        _subscribe.transform = CGAffineTransformMakeTranslation(0, _subscribe.transform.ty+216);
        _back.transform = CGAffineTransformMakeTranslation(0, _back.transform.ty+216);
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
        _back.transform = CGAffineTransformMakeTranslation(0, _back.transform.ty-216);
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
}

- (void)stripeView:(STPView *)view withCard:(PKCard *)card isValid:(BOOL)valid
{
    _subscribe.enabled = valid;
}

- (void)createCustomer:(STPToken *)token
{
    NSString *phoneNumber = [User phoneNumber];
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
            [User setCustomerId:customerId];
            [User setLast4:_last4];
            [self presentViewController:[GetPlanViewController new] animated:NO completion:nil];
        }
    }];
}

@end