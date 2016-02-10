//
//  GroupedMQCSmileysFormField.m
//  inquire
//
//  Created by Nicolas GARNAULT on 14/01/11.
//  Copyright 2011 Counterwinds. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "SurveyConfiguration.h"
#import "GroupedMCQSmileysFormField.h"
#import "GroupedMCQSmileysFormFieldUserView.h"
#import "MCQSmileysRowPartialView.h"
#import "CSVHelper.h"
#import "NSString+maxFontSizeThatFitsRect.h"

#define ROW_MARGIN 5

@interface GroupedMCQSmileysFormField()
@property BOOL isOptional;
@end

@implementation GroupedMCQSmileysFormField

@synthesize groupTitle, groupQuestions, groupAnswers, isOptional;

- (id)init {
	if((self = [super init])) {
		groupQuestions = [[NSMutableArray alloc] init];
		groupAnswers = [[NSMutableArray alloc] initWithObjects:
						NSLocalizedString(@"Très satisfaisant", @""),
                        NSLocalizedString(@"Satisfaisant", @""),
                        NSLocalizedString(@"Peu satisfaisant", @""),
                        NSLocalizedString(@"Mauvais", @""), nil];
	}
	return self;
}


- (UIView *)userViewForConfiguration:(SurveyConfiguration *)configuration {
	GroupedMCQSmileysFormFieldUserView *v = [GroupedMCQSmileysFormFieldUserView view];
	double yOffset = v.frame.size.height + ROW_MARGIN;
	double maxSize = 100;
	
	v.questionTitleLabel.text = self.groupTitle;
	v.questionTitleLabel.font = [UIFont systemFontOfSize:configuration.fontSize];
	v.questionTitleLabel.textColor = configuration.textColor;

	for (NSInteger i = 0 ; i < [groupAnswers count]; ++i) {
		((UILabel *)[v.answerLabels objectAtIndex:i]).text = [groupAnswers objectAtIndex:i];
		maxSize = MIN(maxSize, [[groupAnswers objectAtIndex:i] maxFontSizeThatFitsRect:((UILabel *)[v.answerLabels objectAtIndex:i]).frame
																			  withFont:((UILabel *)[v.answerLabels objectAtIndex:i]).font.fontName
																			  baseSize:40]);
	}

	for (UILabel *l in v.answerLabels) {
		l.font = [UIFont fontWithName:l.font.fontName size:maxSize];
	}
	
	for (NSString *q in self.groupQuestions) {
		MCQSmileysRowPartialView *sv = [MCQSmileysRowPartialView view];
		sv.questionLabel.text = q;
		sv.questionLabel.font = [UIFont systemFontOfSize:configuration.fontSize];
		sv.questionLabel.textColor = configuration.textColor;

		CGRect r = sv.frame;
		r.origin.y = yOffset;
		sv.frame = r;
		yOffset += r.size.height + ROW_MARGIN;
		[v addSubview:sv];
	}

	CGRect r = v.frame;
	r.size.height = yOffset;
	v.frame = r;

    v.formField = self;

	return v;
}

- (NSArray *)questions {
    NSMutableArray *questions = [NSMutableArray array];
    for(NSString *question in groupQuestions) {
        [questions addObject:[CSVHelper formattedValue:question]];
    }

    return questions;
}

- (BOOL)canBeAnswered {
    return YES;
}

#pragma mark --
#pragma mark XMLHandledProtocol

+ (id)loadFromElement:(RXMLElement *)element {
	GroupedMCQSmileysFormField *f = [[GroupedMCQSmileysFormField alloc] init];

    f.groupTitle = [[element child:@"title"] text];
    f.isOptional = [[element attribute:@"is_optional"] boolValue];
    [f.groupAnswers removeAllObjects];
    [f.groupQuestions removeAllObjects];

    for(RXMLElement *_element in [[element child:@"answers"] children:@"answer"]) {
        [f.groupAnswers addObject:_element.text];
    }
    
    for(RXMLElement *_element in [[element child:@"questions"] children:@"question"]) {
        [f.groupQuestions addObject:_element.text];
    }

	return f;
}

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"Title: %@\nQuestions : %@\nAnswers : %@",
            groupTitle, groupAnswers, groupQuestions];
}

@end
