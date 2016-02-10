//
//  FormPage.m
//  inquire
//
//  Created by Nicolas GARNAULT on 13/01/11.
//  Copyright 2011 Counterwinds. All rights reserved.
//

#import <RaptureXML/RXMLElement.h>

#import "FormPage.h"
#import "FormFieldProtocol.h"
#import "TextInputFormField.h"
#import "GroupedMCQSmileysFormField.h"
#import "GroupedMCQFormField.h"
#import "InformativeTextFormField.h"

@implementation FormPage

- (id)init {
	if((self = [super init])) {
		_formFields = [[NSMutableArray alloc] init];
	}
	return self;
}


#pragma mark --
#pragma mark XMLHandledProtocol

+ (id)loadFromElement:(RXMLElement *)element {
	FormPage *f = [[FormPage alloc] init];
    f.isOptin = [[element attribute:@"is_optin"] boolValue];

    [element iterate:@"*" usingBlock:^(RXMLElement *_element) {
        id <FormFieldProtocol>field = nil;

        if([_element.tag isEqualToString:@"text_input_field"]) {
			field = [TextInputFormField loadFromElement:_element];
		} else if([_element.tag isEqualToString:@"smiley_mcq_field"]) {
			field = [GroupedMCQSmileysFormField loadFromElement:_element];
		} else if([_element.tag isEqualToString:@"standard_mcq_field"]) {
			field = [GroupedMCQFormField loadFromElement:_element];
		} else if([_element.tag isEqualToString:@"text_notice_field"]) {
			field = [InformativeTextFormField loadFromElement:_element];
		}

		if(field != nil) {
			[f.formFields addObject:field];
		}
    }];

	return f;
}


@end
