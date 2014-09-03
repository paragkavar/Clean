//
//  SetPlanViewController.m
//  Clean
//
//  Created by Sapan Bhuta on 9/1/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import "SetPlanViewController.h"
#import "UIColor+FlatUI.h"
#import "VCFlow.h"

@interface SetPlanViewController () <UIPickerViewDelegate>

@end

@implementation SetPlanViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    super.page.hidden = YES;
    [self createButtons];

    super.dayPicker.delegate = self;
    super.timePicker.delegate = self;
    //create 2 Buttons
    //hide save button
}

- (void)viewDidAppear:(BOOL)animated
{
    NSIndexPath *path = [NSIndexPath indexPathForItem:[[NSUserDefaults standardUserDefaults] integerForKey:@"plan"] inSection:0];
    [super.collectionView selectItemAtIndexPath:path animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    UICollectionViewCell *cell = [super.collectionView cellForItemAtIndexPath:path];
    cell.contentView.layer.borderWidth = 1;
    cell.contentView.layer.borderColor = [UIColor whiteColor].CGColor;

    int dayIndex = [super.days indexOfObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"day"]];
    [super.dayPicker selectRow:dayIndex inComponent:0 animated:YES];
    [super.timePicker selectRow:[[NSUserDefaults standardUserDefaults] integerForKey:@"hour"]-1 inComponent:0 animated:YES];
    [super.timePicker selectRow:[[NSUserDefaults standardUserDefaults] integerForKey:@"minute"] inComponent:1 animated:YES];
    [super.timePicker selectRow:[[NSUserDefaults standardUserDefaults] boolForKey:@"AM"] ? 0 : 1 inComponent:2 animated:YES];
}
#warning problem highlighting mansion box at index 3 in super.collectionView

- (void)createButtons
{
    super.back.frame = CGRectMake(0, self.view.frame.size.height-54, self.view.frame.size.width/2-.25, 54);
    super.save.frame = CGRectMake(self.view.frame.size.width/2+.25,self.view.frame.size.height-54,self.view.frame.size.width/2-.25,54);
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    super.save.enabled = [super dateChanged];
}

- (void)nextVC
{
    [VCFlow updateUserInParse];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#warning handle differnetial charges

@end
