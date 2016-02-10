//
//  TextInputFormFieldUserView.m
//  inquire
//
//  Created by Nicolas GARNAULT on 04/02/11.
//  Copyright 2011 Counterwinds. All rights reserved.
//

#import "TextInputFormFieldUserView.h"
#import "CSVHelper.h"

@implementation TextInputFormFieldUserView

@synthesize formField;
@synthesize textField, label;


+ (UIView *)view {
	NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"TextInputFormFieldUserView" owner:self options:nil];
	return (TextInputFormFieldUserView *)[arr lastObject];	
}

- (NSArray *)values {
    return [NSArray arrayWithObject:[CSVHelper formattedValue:textField.text]];
}

- (BOOL)canBeAnswered {
    return YES;
}

- (BOOL)isFieldFilled {
    return [textField.text length] > 0;
}

@end
