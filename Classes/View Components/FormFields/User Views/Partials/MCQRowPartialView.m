//
//  MCQRowPartialView.m
//  inquire
//
//  Created by Nicolas GARNAULT on 22/02/11.
//  Copyright 2011 Counterwinds. All rights reserved.
//

#import "MCQRowPartialView.h"

#import <QuartzCore/QuartzCore.h>

@implementation MCQRowPartialView

@synthesize questionLabel, checkButton, isChecked, delegate;

+ (MCQRowPartialView *)view {
	NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"MCQRowPartialView" owner:self options:nil];
	MCQRowPartialView *view = (MCQRowPartialView *)[arr lastObject];
    return view;
}

- (void)dealloc {
    delegate = nil;
}

- (IBAction)buttonPressed:(UIButton *)button {
    isChecked = YES;
	[button setImage:[UIImage imageNamed:@"radio_selected.png"] forState:UIControlStateNormal];
    
    [delegate MCQRowViewWasChecked:self];
}

- (void)setIsChecked:(BOOL)checked {

    if(checked) {
        [checkButton setImage:[UIImage imageNamed:@"radio_selected.png"] forState:UIControlStateNormal];
    } else {
        [checkButton setImage:[UIImage imageNamed:@"radio_unselected.png"] forState:UIControlStateNormal];
    }

    isChecked = checked;
}

@end
