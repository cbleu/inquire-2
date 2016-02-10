//
//  GroupedMCQFormField.m
//  inquire
//
//  Created by Nicolas GARNAULT on 21/01/11.
//  Copyright 2011 Counterwinds. All rights reserved.
//

#import "GroupedMCQFormField.h"

#import "CSVHelper.h"
#import "GroupedMCQFormFieldUserView.h"
#import "MCQRowPartialView.h"
#import "SurveyConfiguration.h"
#import "NSString+maxFontSizeThatFitsRect.h"

#define ROW_MARGIN 5

@interface GroupedMCQFormField ()
@property BOOL isOptional;
@end

@implementation GroupedMCQFormField

@synthesize question, answers, title, isOptional;

- (id)init {
	if((self = [super init])) {
		answers = [[NSMutableArray alloc] init];
	}
	return self;
}


- (UIView *)userViewForConfiguration:(SurveyConfiguration *)configuration {
	GroupedMCQFormFieldUserView *v = [GroupedMCQFormFieldUserView view];
	
//	double maxFontSize = 100;
	double yOffset = v.frame.size.height + ROW_MARGIN;

	v.questionTitleLabel.text = question;
	v.questionTitleLabel.font = [UIFont systemFontOfSize:configuration.fontSize];
	v.questionTitleLabel.textColor = configuration.textColor;
	v.questionTitleLabel.numberOfLines = 2;

    /*
	for (NSInteger i = 0 ; i < [self.answers count] ; ++i) {
		NSString *s = [self.answers objectAtIndex:i];
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
		label.backgroundColor = [UIColor clearColor];
		label.font = [UIFont systemFontOfSize:[configuration.fontSize intValue]];
		label.textColor = configuration.fontColor;
		label.text = s;
		label.textAlignment = UITextAlignmentCenter;
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
		label.numberOfLines = 2;

		CGRect rect = CGRectZero;
		rect.size.height = v.frame.size.height;
		rect.size.width = (v.frame.size.width/2)/[answers count];
		label.frame = rect;
		label.center = CGPointMake(v.frame.size.width*(1.0/2.0 + (((double)i)/((double)[answers count]))/2.0), v.frame.size.height/2);

		[v addSubview:label];
//		[label release];
		[v.answerLabels addObject:label];
		[label release];

		maxFontSize = MIN(maxFontSize, [[answers objectAtIndex:i] maxFontSizeThatFitsRect:label.frame
																					  withFont:label.font.fontName
																					  baseSize:40]);
	}
	
	for (UILabel *l in v.answerLabels) {
		l.font = [UIFont fontWithName:l.font.fontName size:maxFontSize];
	}
*/

	for (NSString *q in self.answers) {
		MCQRowPartialView *sv = [MCQRowPartialView view];
		sv.questionLabel.text = q;
		sv.questionLabel.font = [UIFont systemFontOfSize:configuration.fontSize];
		sv.questionLabel.textColor = configuration.textColor;
		sv.questionLabel.numberOfLines = 2;
        sv.delegate = v;

        /*
		for (NSInteger j = 0 ; j < [self.groupAnswers count] ; ++j) {
			UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
			[b addTarget:sv action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
			UIImage *i = [UIImage imageNamed:@"radio_unselected.png"];
			[b setImage:i forState:UIControlStateNormal];
			CGRect rect = b.frame;
			rect.size = CGSizeMake(sv.frame.size.height, sv.frame.size.height);
            rect.size = CGSizeMake(50, 50);
			b.frame = rect;
			b.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
			b.center = CGPointMake(sv.frame.size.width*(1.0/2.0 + (((double)j)/((double)[self.groupAnswers count]))/2.0), sv.frame.size.height/2);			
			[sv addSubview:b];
			[sv.answserButtons addObject:b];
		}
         */

		CGRect r = sv.frame;
		r.origin.y = yOffset;
		sv.frame = r;
		yOffset += r.size.height + ROW_MARGIN;
		[v addSubview:sv];
        [v.answersPartials addObject:sv];
	}

	
	CGRect r = v.frame;
	r.size.height = yOffset;
	v.frame = r;

    v.formField = self;

	return v;
}

- (NSArray *)questions {
    return [NSArray arrayWithObject:[CSVHelper formattedValue:question]];
}

- (BOOL)canBeAnswered {
    return YES;
}

#pragma mark --
#pragma mark XMLHandledProtocol
+ (id)loadFromElement:(RXMLElement *)element {
	GroupedMCQFormField *f = [[GroupedMCQFormField alloc] init];

    f.title = [[element child:@"title"] text];
    f.isOptional = [[element attribute:@"is_optional"] boolValue];

    for(RXMLElement *_element in [[element child:@"answers"] children:@"answer"]) {
        [f.answers addObject:_element.text];
    }
    
    for(RXMLElement *_element in [[element child:@"questions"] children:@"question"]) {
        f.question = _element.text;
    }

	return f;
}

@end
