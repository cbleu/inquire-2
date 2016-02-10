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

@class UserFormPageViewController;
@class SurveyConfiguration;

@interface UserMainViewController : UIViewController<UserFormPageViewControllerDelegate, ScreensaverViewControllerDelegate, UIAlertViewDelegate> {

    //
	NSInteger currentPage;
    
	NSMutableArray *valuesByFormPages;
	NSMutableArray *valuesByOptinPages;

    //
	SurveyConfiguration *configuration;
    UserMainControllerMode currentMode;
    UserMainControllerSurveyStage currentStage;
}

@property (nonatomic, strong) SurveyConfiguration *configuration;

@end
