    //
//  UserMainViewController.m
//  inquire
//
//  Created by Nicolas GARNAULT on 28/12/10.
//  Copyright 2010 Counterwinds. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>

#import "UserMainViewController.h"
#import "UserFormPageViewController.h"
#import "SurveyConfiguration.h"
#import "UrlHelper.h"
#import "FormPage.h"
#import "CSVHelper.h"
#import "inquireAppDelegate.h"
#import "AppCredentials.h"

@interface UserMainViewController(Private)
- (NSArray *)flatArrayFromRecursiveArray:(NSArray *)array;
- (void)writeValues:(NSArray *)deepArray toFile:(NSString *)filePath isOptin:(BOOL)isOptin;
- (void)displayUserGreetingsForCurrentControlller:(UserFormPageViewController *)controller;
- (void)dismissAlertView:(NSTimer *)timer;
@end

@implementation UserMainViewController

@synthesize configuration;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        valuesByFormPages = [[NSMutableArray alloc] init];
        valuesByOptinPages = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    currentStage = UserMainControllerSurveyStageForm;
}

- (void)viewDidAppear:(BOOL)animated {
    if(currentMode == UserMainControllerModeNone) {
        [valuesByFormPages removeAllObjects];
        [valuesByOptinPages removeAllObjects];

        currentStage = UserMainControllerSurveyStageForm;
        currentMode = UserMainControllerModeForm;
        currentPage = -1;
        [self formPageControllerDidAskNextPage:nil withValues:nil finalValidation:NO];
    }
}

#pragma mark --
#pragma mark Rotation-related
// < IOS6
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return YES;
}

// IOS6
/*
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeRight;
}
 */

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}


#pragma mark --
#pragma mark UserFormPageViewControllerDelegate
- (void)formPageController:(UserFormPageViewController *)controller didAskSwitchingStage:(UserMainControllerSurveyStage)surveyStage {
    currentStage = surveyStage;
}

- (void)formPageControllerDidAskNextPage:(UserFormPageViewController *)controller withValues:(NSArray *)values finalValidation:(BOOL)final {

    // Register values if needed
    if(controller != nil) {
        NSMutableArray *arrayToPush = controller.page.isOptin ? valuesByOptinPages : valuesByFormPages;

        // Pushing values
        if ([arrayToPush count] > currentPage && [values count] > 0) {
            [arrayToPush replaceObjectAtIndex:currentPage withObject:values];
        } else if([values count]) {
            [arrayToPush addObject:values];
        }
    }
    
    // If the page was the last of all
    if(final) {

        //
        currentStage = UserMainControllerSurveyStageForm;
        currentPage = -1;

        // Filling optin if needed
        for(NSInteger i = 0 ; i < [configuration.optinPages count] ; ++i) {
            
            if([valuesByOptinPages count] >= i) {
                [valuesByOptinPages addObject:[NSMutableArray array]];
            }
            
            NSInteger count = [((FormPage *)[configuration.optinPages objectAtIndex:i]).formFields count];
            if([[valuesByOptinPages objectAtIndex:i] count] < count) {
                for(NSInteger j = 0 ; j < count ; ++j) {
                    [[valuesByOptinPages objectAtIndex:i] addObject:[CSVHelper formattedValue:@""]];
                }
            }
        }

        // Write recolted data and drop them
        [self writeValues:valuesByFormPages toFile:[UrlHelper formResultsFilePath] isOptin:NO];
        [self writeValues:valuesByOptinPages toFile:[UrlHelper optinResultsFilePath] isOptin:YES];
        [valuesByFormPages removeAllObjects];
        [valuesByOptinPages removeAllObjects];

        // Display user greetings
        [self displayUserGreetingsForCurrentControlller:controller];
    }
    // Else
    else {
        //
        if(controller != nil) {
            [controller dismissViewControllerAnimated:NO completion:nil];
            controller = nil;
        }

        UserFormPageViewController *vc = [[UserFormPageViewController alloc] initWithNibName:@"UserFormPageView" bundle:nil];
        vc.delegate = self;

        if(currentStage == UserMainControllerSurveyStageForm) {
            currentPage = MIN(currentPage + 1, configuration.numberOfFormPages - 1);
            vc.page = [configuration.formPages objectAtIndex:currentPage];
        } else {
            currentPage = MIN(currentPage + 1, configuration.numberOfOptinPages - 1);
            vc.page = [configuration.optinPages objectAtIndex:currentPage];
        }

        //
        [self presentViewController:vc animated:NO completion:nil];
    }
}

- (void)formPageControllerDidAskUserExitToLogin:(UserFormPageViewController *)controller {
    [controller dismissViewControllerAnimated:NO completion:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)formPageControllerDidDetectIdleness:(UserFormPageViewController *)controller {
    currentMode = UserMainControllerModeScreensaver;
    
    // Dismissing the controller
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [controller dismissViewControllerAnimated:NO completion:NO];
    controller = nil;

    // Pushing the screensaver controller
    ScreensaverViewController *vc = [[ScreensaverViewController alloc] initWithNibName:@"ScreensaverView" bundle:nil];
    vc.pictures = configuration.screensaverPictures;

    vc.displayInterval = configuration.screensaverDisplayInterval;
    vc.delegate = self;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:nil];
}

- (BOOL)formPageControllerIsFirstPage:(UserFormPageViewController *)controller {
    return (currentPage == 0);
}

- (BOOL)formPageControllerIsLastPage:(UserFormPageViewController *)controller {
    if(currentStage == UserMainControllerSurveyStageForm) {
        return currentPage == [configuration.formPages count] - 1;
    }
    return currentPage == [configuration.optinPages count] - 1;
}

// Return true if the survey has at least one optin page
- (BOOL)formPageControllerHasOptinPage:(UserFormPageViewController *)controller {
    return [[configuration optinPages] count] > 0;
}

- (SurveyConfiguration *)configuration {
    return configuration;
}

#pragma mark --
#pragma mark ScreensaverViewControllerDelegate methods
- (void)screensaverDidAppear:(ScreensaverViewController *)screensaver {
    [valuesByFormPages removeAllObjects];
    [valuesByOptinPages removeAllObjects];
}

- (void)screensaverTouched:(ScreensaverViewController *)screensaver {
    currentMode = UserMainControllerModeNone;
    currentStage = UserMainControllerSurveyStageForm;

    // Dismissing the screensaver
    [screensaver dismissViewControllerAnimated:YES completion:nil];

    // Showing the first page of the form
    currentPage = -1;
    [self formPageControllerDidAskNextPage:nil withValues:nil finalValidation:NO];
}

#pragma mark --
#pragma mark Private stuff
- (void)dismissAlertView:(NSTimer *)timer {
    NSDictionary *arguments = (NSDictionary *)[timer userInfo];
    
    // Removing the alert
    UIAlertView *a = [arguments objectForKey:@"alert"];
    [a dismissWithClickedButtonIndex:0 animated:NO];

    // Removing the current page
    UIViewController *c = [arguments objectForKey:@"controller"];
    [c dismissViewControllerAnimated:NO completion:nil];
    c = nil;

    // Pushing the next page
    currentPage = -1;
    currentStage = UserMainControllerSurveyStageForm;
    [self formPageControllerDidAskNextPage:nil withValues:nil finalValidation:NO];
}

- (void)displayUserGreetingsForCurrentControlller:(UserFormPageViewController *)controller {
    NSString *title = NSLocalizedString(@"Vos réponses ont bien été prises en compte.\n\nMerci de votre participation.", @"");

    UIAlertView *a = [[UIAlertView alloc] initWithTitle:title
                                                message:nil
                                               delegate:nil
                                      cancelButtonTitle:nil
                                      otherButtonTitles:nil];
    [a show];

    NSDictionary *d = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:a, controller, nil]
                                                  forKeys:[NSArray arrayWithObjects:@"alert", @"controller", nil]];
    
    [NSTimer scheduledTimerWithTimeInterval:3.0
                                     target:self
                                   selector:@selector(dismissAlertView:)
                                   userInfo:d
                                    repeats:NO];
    
}


- (NSArray *)flatArrayFromRecursiveArray:(NSArray *)array {
    NSMutableArray *retArray = [NSMutableArray array];
    
    for(id a in array) {
        if ([a isKindOfClass:[NSArray class]]) {
            [retArray addObjectsFromArray:[self flatArrayFromRecursiveArray:a]];
        } else {
            [retArray addObject:a];
        }
    }
    return retArray;
}


- (void)writeValues:(NSArray *)deepArray toFile:(NSString *)filePath isOptin:(BOOL)isOptin {
    inquireAppDelegate *appDelegate = (inquireAppDelegate *)[UIApplication sharedApplication].delegate;
    
    
    // If the file does not exits, create it
    if(![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [@"" writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
    NSString *existingContent = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSString *contentToWrite = [[self flatArrayFromRecursiveArray:deepArray] componentsJoinedByString:@","];

    // Is Optin ?
    if(!isOptin) {
        CLLocationCoordinate2D c = appDelegate.lastLocation;

        NSLog(@"%f:%f", appDelegate.lastLocation.latitude, appDelegate.lastLocation.longitude);

        contentToWrite = [NSString stringWithFormat:@"\r\n%@,%@,%f,%f,%@",
                          // Date
                          [dateFormatter stringFromDate:[NSDate date]],
                          // iPad identifier
                          [AppCredentials publicId],
                          // Geolocation : latitude and longitude
                          c.latitude, c.longitude,
                          // Answers
                          contentToWrite];

        // If the file is empty, add csv labels
        if([existingContent length] == 0) {
            contentToWrite = [NSString stringWithFormat:@"%@%@", [configuration csvFormQuestions], contentToWrite];
        }
    } else {
        contentToWrite = [NSString stringWithFormat:@"\r\n%@", contentToWrite];

        // If the file is empty, add csv labels
        if([existingContent length] == 0) {
            contentToWrite = [NSString stringWithFormat:@"%@%@", [configuration csvOptinQuestions], contentToWrite];
        }
    }

    NSFileHandle *myHandle = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
    [myHandle seekToEndOfFile];
    [myHandle writeData:[contentToWrite dataUsingEncoding:NSUTF8StringEncoding]];
    [myHandle closeFile];
}

@end