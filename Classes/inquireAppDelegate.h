//
//  inquireAppDelegate.h
//  inquire
//
//  Created by Nicolas GARNAULT on 22/12/10.
//  Copyright 2010 Blinding Lights. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>
#import "ContentManager.h"
#import <CoreLocation/CoreLocation.h>

@class MGSplitViewController;
@class DataExporter;

@interface inquireAppDelegate : NSObject <UIApplicationDelegate, ContentManagerDelegate, CLLocationManagerDelegate> {
    
    UIWindow *window;
    UIViewController *rootViewController;

    // Content Manager
    ContentManager *contentManager;
    NSInteger postDataTick;

    // Location
    CLLocationManager *locationManager;

    id<ContentManagerDelegate> contentManagerSubdelegate;
}

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) ContentManager *contentManager;
@property CLLocationCoordinate2D lastLocation;

- (NSString *)applicationDocumentsDirectory;


@end

