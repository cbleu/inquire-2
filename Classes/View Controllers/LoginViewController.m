//
//  ConnectedLoginViewController.m
//  inquire 2
//
//  Created by Nicolas Garnault on 13/07/12.
//  Copyright (c) 2012 Counterwinds. All rights reserved.
//

#import "LoginViewController.h"
#import "inquireAppDelegate.h"
#import "GradientButton.h"

#import "SurveyConfiguration.h"

@interface LoginViewController ()
- (void)updateTimer:(NSTimer *)timer;
@end

@implementation LoginViewController

@synthesize loginTextField, passwordTextField, countdownLabel, delegate;

- (void)viewDidLoad {
	NSLog(@"%s", __PRETTY_FUNCTION__);
	[super viewDidLoad];
    // begin cbleu fix
//    self.view.backgroundColor = [UIColor underPageBackgroundColor];
    // il n'y a pas de remplacement ! le blanc est un fond acceptable !
    self.view.backgroundColor = [UIColor whiteColor];
    // end cbleu fix
}

- (void)viewWillDisappear:(BOOL)animated {
	NSLog(@"%s", __PRETTY_FUNCTION__);
    [loginTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];

    // begin cbleu fix
    [super viewWillDisappear:animated];
    // end cbleu fix
}

- (void)viewDidDisappear:(BOOL)animated {
	NSLog(@"%s", __PRETTY_FUNCTION__);
    loginTextField.text = @"";
    passwordTextField.text = @"";
    
    [userFormSchedule invalidate];
    userFormSchedule = nil;

    // begin cbleu fix
    [super viewDidDisappear:animated];
    // end cbleu fix
}

- (void)viewWillAppear:(BOOL)animated {
	NSLog(@"%s", __PRETTY_FUNCTION__);
    [submitButton useGreenConfirmStyle];

    if([SurveyConfiguration configuration] != nil) {
        
        // Configure user form button according to configuration available or not
        userFormButton.alpha = 1.0;
        userFormButton.enabled = YES;
        
        secondsBeforeUserForm = 30;
        [self updateTimer:nil];
    } else {
        
        // Configure user form button according to configuration available or not
        userFormButton.alpha = 0.5;
        userFormButton.enabled = NO;
        
        countdownLabel.text = NSLocalizedString(@"Aucune enquête n'a encore été déployée sur cet iPad", @"");
    }

    // begin cbleu fix
    [super viewWillAppear:animated];
    // end cbleu fix
}

- (IBAction)submitPressed:(id)sender {
    NSString *login = loginTextField.text;
    NSString *password = passwordTextField.text;

    //
    [delegate loginController:self didAskLoginWithPublicId:login secretKey:password];
}

- (IBAction)userFormPressed:(id)sender {
    [delegate loginControllerDidAskUserForm:self];
}

#pragma mark --
#pragma mark Rotation related
// < IOS6
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

// IOS6
/*
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeRight;
}
 */

// begin cbleu fix

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}
//#if __IPHONE_OS_VERSION_MAX_ALLOWED < 90000
//- (NSUInteger)supportedInterfaceOrientations
//#else
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations
//#endif
//{
//    return UIInterfaceOrientationMaskAll;
//}

// end cbleu fix

- (void)displayErrorMessageWithTitle:(NSString *)title message:(NSString *)message {
    [self displayErrorMessageWithTitle:title message:message delegate:nil];
}

- (void)displayErrorMessageWithTitle:(NSString *)title message:(NSString *)message delegate:(id<UIAlertViewDelegate>)_delegate {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:_delegate
                                          cancelButtonTitle:NSLocalizedString(@"Ok", @"")
                                          otherButtonTitles:nil];

    [alert show];
}


#pragma mark --
#pragma mark Private methods
- (void)updateTimer:(NSTimer *)timer {
    if(secondsBeforeUserForm < 0) {
        [delegate loginControllerDidAskUserForm:self];
    } else {
        userFormSchedule = [NSTimer scheduledTimerWithTimeInterval:1
                                                            target:self
                                                          selector:@selector(updateTimer:)
                                                          userInfo:nil
                                                           repeats:NO];

        countdownLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Lancement automatique du mode formulaire dans %d seconde(s)", @""), secondsBeforeUserForm];
    }

    secondsBeforeUserForm = secondsBeforeUserForm - 1;
}

@end
