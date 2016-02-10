//
//  ScreensaverViewController.m
//  inquire
//
//  Created by Nicolas GARNAULT on 15/04/11.
//  Copyright 2011 Counterwinds. All rights reserved.
//

#import "ScreensaverViewController.h"

@interface ScreensaverViewController(Private)
- (void)nextScreen;
@end

@implementation ScreensaverViewController

@synthesize pictures, displayInterval, delegate;

- (void)dealloc {
    delegate = nil;
    [timer invalidate];
    timer = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        displayInterval = 10;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    currentScreen = -1;
    [self nextScreen];
}

- (void)viewDidAppear:(BOOL)animated {
    [delegate screensaverDidAppear:self];
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

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (void)nextScreen {
    self.view.backgroundColor = [UIColor blackColor];
    
    if([pictures count] == 0)
        return;

    currentScreen = (currentScreen + 1)%[pictures count];
    
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.5];
    
    if(imageview1.alpha <= 0.0) {
        imageview1.image = [pictures objectAtIndex:currentScreen];
        imageview1.alpha = 1.0;
        imageview2.alpha = 0.0;        
    } else {
        imageview2.image = [pictures objectAtIndex:currentScreen];
        imageview1.alpha = 0.0;
        imageview2.alpha = 1.0;
    }

    [UIView commitAnimations];
    
    [timer invalidate];
    timer = nil;

    timer = [NSTimer scheduledTimerWithTimeInterval:displayInterval
                                             target:self 
                                           selector:@selector(nextScreen) 
                                           userInfo:nil 
                                            repeats:NO];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [delegate screensaverTouched:self];
}

@end
