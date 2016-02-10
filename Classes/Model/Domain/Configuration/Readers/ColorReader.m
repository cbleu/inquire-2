//
//  ColorReader.m
//  inquire
//
//  Created by Nicolas GARNAULT on 30/01/11.
//  Copyright 2011 Counterwinds. All rights reserved.
//

#import "ColorReader.h"


@implementation ColorReader

+ (UIColor *)colorFromElement:(RXMLElement *)element {
	return [UIColor colorWithRed:[[element attribute:@"red"] doubleValue]
                           green:[[element attribute:@"green"] doubleValue]
                            blue:[[element attribute:@"blue"] doubleValue]
                           alpha:[[element attribute:@"alpha"] doubleValue]];
}

@end
