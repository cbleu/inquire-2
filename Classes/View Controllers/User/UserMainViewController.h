//
//  UserMainViewController.h
//  inquire
//
//  Created by Nicolas GARNAULT on 28/12/10.
//  Copyright 2010 Counterwinds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserController_types.h"
#import "UserFormPageViewController.h"
#import "ScreensaverViewController.h"
#import "AdminViewController.h"

@class UserFormPageViewController;
@class SurveyConfiguration;
@class AdminViewController;

@interface UserMainViewController : UIViewController<UserFormPageViewControllerDelegate, ScreensaverViewControllerDelegate, UIAlertViewDelegate> {

    //
	NSInteger currentPage;
    
	NSMutableArray *valuesByFormPages;
	NSMutableArray *valuesByOptinPages;

    //
	SurveyConfiguration *configuration;
    UserMainControllerMode currentMode;
    UserMainControllerSurveyStage currentStage;
	
	// pointer back to AdminViewController
	AdminViewController *adminVC;
}

@property (nonatomic, strong) SurveyConfiguration *configuration;
@property (nonatomic, strong) AdminViewController *adminVC;

@end
