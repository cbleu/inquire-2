//
//  AdminLoadingView.m
//  inquire 2
//
//  Created by Nicolas GARNAULT on 26/07/12.
//  Copyright (c) 2012 Counterwinds. All rights reserved.
//

#import "AdminLoadingView.h"
#import <QuartzCore/QuartzCore.h>

@implementation AdminLoadingView

@synthesize loadingLabel;

+ (AdminLoadingView *)viewWithTitle:(NSString *)title {
	NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"AdminLoadingView" owner:self options:nil];
	AdminLoadingView *v = (AdminLoadingView *)[arr lastObject];
    v.loadingLabel.text = title;
    v.backgroundColor = [UIColor colorWithRed:200 green:200 blue:200 alpha:0.0];
    v.loadingLabel.superview.layer.cornerRadius = 25;
	return v;
}

@end
