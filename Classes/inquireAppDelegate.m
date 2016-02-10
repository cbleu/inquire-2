//
//  inquireAppDelegate.m
//  inquire
//
//  Created by Nicolas GARNAULT on 22/12/10.
//  Copyright 2010 Blinding Lights. All rights reserved.
//

#import "inquireAppDelegate.h"

#import "AppCredentials.h"
#import "AdminViewController.h"
#import "OpenUDID.h"
#import "UrlHelper.h"

#import "UserMainViewController.h"
#import "SurveyConfiguration.h"

@interface inquireAppDelegate(Private)
- (void)postDataOrResults:(NSTimer *)timer;
@end

@implementation inquireAppDelegate

@synthesize contentManager;
@synthesize window;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    

    // Initializing loginController
//    AdminViewController *vc = [[AdminViewController alloc] initWithStyle:UITableViewStyleGrouped];
//    rootViewController = [[UINavigationController alloc] initWithRootViewController:vc];

    // Initializing contentManager
    contentManager = [[ContentManager alloc] init];
    contentManager.delegate = self;
    contentManagerSubdelegate = [((UINavigationController *)window.rootViewController).viewControllers objectAtIndex:0];

    if([AppCredentials areCredentialSet]) {
        contentManager.publicId = [AppCredentials publicId];
        contentManager.secretKey = [AppCredentials secretKey];
    }

    // Launch that
//	[window addSubview:rootViewController.view];
    [window makeKeyAndVisible];

    // Initializing location
    locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;

// begin cbleu fix
// need authorization for IOS8
	[locationManager requestWhenInUseAuthorization];

	if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
		[locationManager requestWhenInUseAuthorization];
	}
	[locationManager startUpdatingLocation];

// end cbleu fix

    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	
//	[locationManager requestLocation];

    [NSTimer scheduledTimerWithTimeInterval:40
                                     target:self
                                   selector:@selector(postDataOrResults:)
                                   userInfo:nil
                                    repeats:YES];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {}

- (void)applicationDidBecomeActive:(UIApplication *)application {}

#pragma mark --
#pragma mark ContentManager delegate methods
- (void)contentManager:(ContentManager *)manager didFailWithError:(NSError *)error {
    // Propagating
    [contentManagerSubdelegate contentManager:manager didFailWithError:error];
}

- (void)contentManager:(ContentManager *)manager didFetchSurveyConfiguration:(SurveyConfiguration *)configuration {
    // Propagating
    [contentManagerSubdelegate contentManager:manager didFetchSurveyConfiguration:configuration];
}

- (void)contentManager:(ContentManager *)manager didFetchSurveysList:(NSArray *)surveys {
    // Propagating
    [contentManagerSubdelegate contentManager:manager didFetchSurveysList:surveys];
}

- (void)contentManager:(ContentManager *)manager didUpdateProgress:(double *)progress {
    // Propagating
    [contentManagerSubdelegate contentManager:manager didUpdateProgress:progress];
}

- (void)contentManagerDidPostSurveyResults:(ContentManager *)manager {
    // Propagating
    [contentManagerSubdelegate contentManagerDidPostSurveyResults:manager];

    NSError *error = nil;

    // Erasing previous form content
    [@"" writeToFile:[UrlHelper formResultsFilePath]  atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if(error) {
        NSLog(@"Error while erasing previous form results : %@", error);
    }

    // Erasing previous optin content
    [@"" writeToFile:[UrlHelper optinResultsFilePath] atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if(error) {
        NSLog(@"Error while erasing previous optin results : %@", error);
    }

    [AppCredentials setLastResultsPostDate:[NSDate date]];
}

- (void)contentManagerDidUpdateDevice:(ContentManager *)manager {
    // Propagating
    [contentManagerSubdelegate contentManagerDidUpdateDevice:manager];
}

- (void)contentManagerDidDisassociateDevice:(ContentManager *)manager {
    // Propagating
    [contentManagerSubdelegate contentManagerDidDisassociateDevice:manager];
}

#pragma mark --
#pragma mark Private methods
- (void)postDataOrResults:(NSTimer *)timer {
    
    NSLog(@"postDataOrResults");
    
    // If the credentials are not set, do nothing
    if(![AppCredentials areCredentialSet]) {
        return;
    }

    postDataTick++;

    if(contentManager.currentOperation == ContentManagerOperationNone && [AppCredentials areCredentialSet]) {
        if((postDataTick%2)) {
//			NSLog(@"%f:%f", self.lastLocationOld.latitude, self.lastLocationOld.longitude);
			NSLog(@"%f:%f", self.lastLocation.coordinate.latitude, self.lastLocation.coordinate.longitude);
            [contentManager updateDeviceWithCoordinates:self.lastLocationOld
                                            deviceToken:[OpenUDID value]];
        } else {
            NSString *formResults = [NSString stringWithContentsOfFile:[UrlHelper formResultsFilePath]
                                                              encoding:NSUTF8StringEncoding
                                                                 error:nil];

            NSString *optinResults = [NSString stringWithContentsOfFile:[UrlHelper optinResultsFilePath]
                                                               encoding:NSUTF8StringEncoding
                                                                  error:nil];

            if([optinResults length] > 0 || [formResults length] > 0) {
                [contentManager postSurveysResultsWithSurveyId:[AppCredentials currentSurveyId]
                                            surveyDeploymentId:[AppCredentials currentSurveyDeploymentId]
                                                   formResults:formResults
                                                  optinResults:optinResults];                
            }
            
            postDataTick = 0;
        }
    }
}

#pragma mark --
#pragma mark Application's Documents directory
/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

#pragma mark --
#pragma mark Location
// begin cbleu fix
//deprecated
//- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
//    self.lastLocationOld = newLocation.coordinate;
//}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
	CLLocation *newLocation = locations.lastObject;

	self.lastLocationOld = newLocation.coordinate;	// Keep for legacy
	self.lastLocation = newLocation;				// use that one now
}

// end cbleu fix



#pragma mark -
#pragma mark Memory management


@end

