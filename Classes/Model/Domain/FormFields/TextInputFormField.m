//
//  TextInputFormField.m
//  inquire
//
//  Created by Nicolas ;; on 13/01/11.
//  Copyright 2011 Counterwinds. All rights reserved.
//

#import <RaptureXML/RXMLElement.h>

#import "SurveyConfiguration.h"
#import "TextInputFormField.h"
#import "TextInputFormFieldUserView.h"
#import "CSVHelper.h"

@interface TextInputFormField ()
@property BOOL isOptional;
@end

@implementation TextInputFormField

@synthesize questionTitle, isOptional;

#pragma mark --
#pragma mark FormFieldProtocol
- (UIView *)userViewForConfiguration:(SurveyConfiguration *)configuration {
	TextInputFormFieldUserView *v = (TextInputFormFieldUserView *)[TextInputFormFieldUserView view];
    
	v.label.text = self.questionTitle;
	v.label.font = [UIFont systemFontOfSize:configuration.fontSize];
	v.label.textColor = configuration.textColor;

	v.textField.font = [UIFont systemFontOfSize:configuration.fontSize];
    v.textField.textColor = UIColor.blackColor;
    v.textField.keyboardType = UIKeyboardTypeEmailAddress;

    v.formField = self;
    
    switch (_dataType) {
        case TextInputDataTypeInteger: {
            v.textField.keyboardType = UIKeyboardTypeNumberPad;
            break;
        }
        case TextInputDataTypeEmailAddress: {
            v.textField.keyboardType = UIKeyboardTypeEmailAddress;
            break;
        }
        case TextInputDataTypeDate:
        default: {
            v.textField.keyboardType = UIKeyboardTypeDefault;
            break;
        }
    }
    
	return v;
}

- (NSArray *)questions {
    return [NSArray arrayWithObject:[CSVHelper formattedValue:self.questionTitle]];
}

- (BOOL)canBeAnswered {
    return YES;
}

#pragma mark --
#pragma mark XMLHandledProtocol
+ (id)loadFromElement:(RXMLElement *)element {
	TextInputFormField *f = [[TextInputFormField alloc] init];

    f.questionTitle = [[element child:@"question"] text];
    f.isOptional = [[element attribute:@"is_optional"] boolValue];
    
    f.dataType = TextInputDataTypeText;
    if([[element attribute:@"data_type"] isEqualToString:@"text"]) {
        f.dataType = TextInputDataTypeText;
//        NSLog(@"text: %@", f.questionTitle);
    } else if([[element attribute:@"data_type"] isEqualToString:@"date"]) {
        f.dataType = TextInputDataTypeDate;
//        NSLog(@"date: %@", f.questionTitle);
    } else if([[element attribute:@"data_type"] isEqualToString:@"integer"]) {
        f.dataType = TextInputDataTypeInteger;
//        NSLog(@"integer: %@", f.questionTitle);
    } else if([[element attribute:@"data_type"] isEqualToString:@"email_address"]) {
        f.dataType = TextInputDataTypeEmailAddress;
//        NSLog(@"emailAddress: %@", f.questionTitle);
    }
    
    
	return f;
}

@end
