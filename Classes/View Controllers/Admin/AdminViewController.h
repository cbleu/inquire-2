//
//  AdminViewController.h
//  inquire 2
//
//  Created by Nicolas Garnault on 15/07/12.
//  Copyright (c) 2012 Counterwinds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentManager.h"
#import "LoginViewController.h"

typedef enum {
    AdminViewControllerOperationNone,
    AdminViewControllerOperationChangeConfiguration
} AdminViewControllerOperation;

@interface AdminViewController : UITableViewController<ContentManagerDelegate, LoginViewControllerDelegate, UIAlertViewDelegate> {
    LoginViewController *loginController;
    NSMutableArray *allowedSurveys;

    BOOL loggedIn;
    BOOL shouldDisplayLoginController;

    AdminViewControllerOperation currentOperation;
    NSInteger configurationToLoad;
    UIAlertView *loadingAlertView;
}

@end
