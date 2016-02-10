//
//  LoginViewController.h
//  inquire 2
//
//  Created by Nicolas Garnault on 13/07/12.
//  Copyright (c) 2012 Counterwinds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentManager.h"

@class LoginViewController, GradientButton;

@protocol LoginViewControllerDelegate<NSObject>
- (void)loginController:(LoginViewController *)controller didAskLoginWithPublicId:(NSString *)publicId secretKey:(NSString *)secretKey;
- (void)loginControllerDidAskUserForm:(LoginViewController *)controller;
@end

@interface LoginViewController : UIViewController {
    IBOutlet UITextField *loginTextField;
    IBOutlet UITextField *passwordTextField;
    IBOutlet UILabel *countdownLabel;
    IBOutlet GradientButton *submitButton;
    IBOutlet GradientButton *userFormButton;

    NSTimer *userFormSchedule;
    NSInteger secondsBeforeUserForm;

    id<LoginViewControllerDelegate> __weak delegate;
}

@property (nonatomic, weak) id<LoginViewControllerDelegate> delegate;
@property (nonatomic, strong) IBOutlet UITextField *loginTextField;
@property (nonatomic, strong) IBOutlet UITextField *passwordTextField;
@property (nonatomic, strong) IBOutlet UILabel *countdownLabel;

- (IBAction)userFormPressed:(id)sender;
- (IBAction)submitPressed:(id)sender;
- (void)displayErrorMessageWithTitle:(NSString *)title message:(NSString *)message;
- (void)displayErrorMessageWithTitle:(NSString *)title message:(NSString *)message delegate:(id<UIAlertViewDelegate>)delegate;

@end
