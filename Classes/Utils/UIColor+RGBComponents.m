//
//  UIColor+RGBComponents.m
//  inquire
//
//  Created by Nicolas GARNAULT on 08/01/11.
//  Copyright 2011 Counterwinds. All rights reserved.
//

#import "UIColor+RGBComponents.h"


@implementation UIColor(Private)

- (CGFloat)red {
	CGFloat retValue = 0.0;
	CGColorRef color = [self CGColor];
	int numComponents = CGColorGetNumberOfComponents(color);
	if (numComponents == 4) {
		const CGFloat *components = CGColorGetComponents(color);
		retValue = components[0];
	}
	return retValue;
}

- (CGFloat)green {
	CGFloat retValue = 0.0;
	CGColorRef color = [self CGColor];
	int numComponents = CGColorGetNumberOfComponents(color);
	if (numComponents == 4) {
		const CGFloat *components = CGColorGetComponents(color);
		retValue = components[1];
	}
	return retValue;
}

- (CGFloat)blue {
	CGFloat retValue = 0.0;
	CGColorRef color = [self CGColor];
	int numComponents = CGColorGetNumberOfComponents(color);
	if (numComponents == 4) {
		const CGFloat *components = CGColorGetComponents(color);
		retValue = components[2];
	}
	return retValue;
}

- (CGFloat)alpha {
	CGFloat retValue = 0.0;
	CGColorRef color = [self CGColor];
	int numComponents = CGColorGetNumberOfComponents(color);
	if (numComponents == 4) {
		const CGFloat *components = CGColorGetComponents(color);
		retValue = components[3];
	}
	return retValue;
}

@end
