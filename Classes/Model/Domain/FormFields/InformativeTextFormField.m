//
//  InformativeTextFormField.m
//  inquire
//
//  Created by Nicolas GARNAULT on 21/01/11.
//  Copyright 2011 Counterwinds. All rights reserved.
//

#import <RaptureXML/RXMLElement.h>

#import "SurveyConfiguration.h"
#import "InformativeTextFormField.h"
#import "InformativeTextUserView.h"

@implementation InformativeTextFormField

@synthesize title, text, isOptional;


- (UIView *)userViewForConfiguration:(SurveyConfiguration *)configuration {
	InformativeTextUserView *v = (InformativeTextUserView *)[InformativeTextUserView view];
	v.textView.text = self.text;
	v.textView.font = [UIFont systemFontOfSize:configuration.fontSize];
	v.textView.textColor = configuration.textColor;
	v.textView.contentInset = UIEdgeInsetsMake(-11,-8,0,0);

	CGRect f = v.textView.frame;
	f.size = v.textView.contentSize;
	v.textView.frame = f;

	v.titleLabel.text = self.title;
	v.titleLabel.font = [UIFont boldSystemFontOfSize:configuration.fontSize];
	v.titleLabel.textColor = configuration.textColor;

	CGRect r = v.frame;
	r.size.height = v.textView.frame.origin.y + v.textView.frame.size.height;
	v.frame = r;

    v.formField = self;

	return v;
}

- (BOOL)canBeAnswered {
    return NO;
}

#pragma mark --
#pragma mark XMLHandledProtocol
+ (id)loadFromElement:(RXMLElement *)element {
	InformativeTextFormField *f = [[InformativeTextFormField alloc] init];
    
    f.title = [[element child:@"title"] text];
    f.text = [[element child:@"text_content"] text];

	return f;
}

- (NSArray *)questions {
    return [NSArray array];
}

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"title : %@\ntext : %@", title, text];
}

- (BOOL)isOptional {
    return YES;
}

@end