//
//  ScreensaverViewController.h
//  inquire
//
//  Created by Nicolas GARNAULT on 15/04/11.
//  Copyright 2011 Counterwinds. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppConfiguration;
@class ScreensaverViewController;

@protocol ScreensaverViewControllerDelegate <NSObject>
- (void)screensaverDidAppear:(ScreensaverViewController *)screensaver;
- (void)screensaverTouched:(ScreensaverViewController *)screensaver;
@end


@interface ScreensaverViewController : UIViewController {
    NSArray *pictures;
    NSInteger displayInterval;
    
    NSInteger currentScreen;
    NSTimer *timer;

    IBOutlet UIImageView *imageview1;
    IBOutlet UIImageView *imageview2;

    id<ScreensaverViewControllerDelegate> __weak delegate;
}

@property (nonatomic, strong) NSArray *pictures;
@property (nonatomic, assign) NSInteger displayInterval;
@property (nonatomic, weak) id<ScreensaverViewControllerDelegate> delegate;

@end
