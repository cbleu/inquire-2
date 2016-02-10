//
//  InformativeTextUserView.m
//  inquire
//
//  Created by Nicolas GARNAULT on 04/02/11.
//  Copyright 2011 Counterwinds. All rights reserved.
//

#import "InformativeTextUserView.h"


@implementation InformativeTextUserView

@synthesize formField;
@synthesize textView, titleLabel;

+ (UIView *)view {
	NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"InformativeTextUserView"
                                                 owner:self options:nil];
	return (InformativeTextUserView *)[arr lastObject];	
}

- (NSArray *)values {
    return [NSArray array];
}

- (BOOL)canBeAnswered {
    return NO;
}

- (BOOL)isFieldFilled {
    return YES;
}

@end
