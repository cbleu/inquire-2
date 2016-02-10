//
//  UserFormPageViewController.h
//  inquire
//
//  Created by Nicolas GARNAULT on 03/02/11.
//  Copyright 2011 Counterwinds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserController_types.h"
#import "FormPage.h"
#import "GradientButton.h"
#import "TappableScrollView.h"

@class SurveyConfiguration, UserFormPageViewController;

@protocol UserFormPageViewControllerDelegate

// Delegate-related
- (void)formPageController:(UserFormPageViewController *)controller didAskSwitchingStage:(UserMainControllerSurveyStage)surveyStage;
- (void)formPageControllerDidDetectIdleness:(UserFormPageViewController *)controller;
- (void)formPageControllerDidAskUserExitToLogin:(UserFormPageViewController *)controller;

//// Navigation 
- (void)formPageControllerDidAskNextPage:(UserFormPageViewController *)controller withValues:(NSArray *)values finalValidation:(BOOL)final;
- (BOOL)formPageControllerIsFirstPage:(UserFormPageViewController *)controller;
- (BOOL)formPageControllerIsLastPage:(UserFormPageViewController *)controller;

// Protocol-related
- (SurveyConfiguration *)configuration;


@end

@interface UserFormPageViewController : UIViewController<UIScrollViewDelegate,TappableScrollViewDelegate, UITextFieldDelegate> {

    FormPage *page;
	NSMutableArray *formFieldViews;

	id<UserFormPageViewControllerDelegate> __weak delegate;

    // view related
    CGPoint initialContentOffset;

	// view components
	IBOutlet UIImageView *backgroundImageView;
	IBOutlet UIImageView *logoImageView;
	IBOutlet TappableScrollView *scrollView;

	IBOutlet UITextView *headerTextView1;
	IBOutlet UITextView *headerTextView2;
	IBOutlet UITextView *headerTextView3;

	IBOutlet UITextView *footerTextView1;
	
	// Bottom control view
	IBOutlet UIView *controlView;
	IBOutlet GradientButton *nextPageButton;
	IBOutlet GradientButton *prevPageButton;
	IBOutlet GradientButton *userDetailsFormButton;
    
    // Idleness-related
    NSTimer *idleTimer;
    BOOL idleMeasureEnabled;
    BOOL slideMovementStarted;
}

@property (nonatomic, strong) FormPage *page;
@property (nonatomic, weak) id<UserFormPageViewControllerDelegate> delegate;

- (IBAction)nextPagePressed:(id)sender;
- (IBAction)prevPagePressed:(id)sender;
- (IBAction)userDetailsFormPressed:(id)sender;

@end