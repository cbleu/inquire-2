//
//  GroupedMCQSmileysFormFieldUserView.m
//  inquire
//
//  Created by Nicolas GARNAULT on 04/02/11.
//  Copyright 2011 Counterwinds. All rights reserved.
//

#import "GroupedMCQSmileysFormFieldUserView.h"
#import "MCQSmileysRowPartialView.h"
#import "CSVHelper.h"

#define QUESTIONS_MARGIN 10

@implementation GroupedMCQSmileysFormFieldUserView

@synthesize formField;
@synthesize questionTitleLabel, answerLabel1, answerLabel2, answerLabel3, answerLabel4;


- (NSArray *)answerLabels {
	return [NSArray arrayWithObjects:answerLabel1, answerLabel2, answerLabel3, answerLabel4, nil];
}

- (BOOL)canBeAnswered {
    return YES;
}

+ (GroupedMCQSmileysFormFieldUserView *)view {
	NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"GroupedMCQSmileysFormFieldUserView"
                                                 owner:self options:nil];
	return (GroupedMCQSmileysFormFieldUserView *)[arr lastObject];
}

- (NSArray *)values {
    NSMutableArray *values = [NSMutableArray array];

    for(UIView *v in self.subviews) {
        if([v isKindOfClass:[MCQSmileysRowPartialView class]]) {
            MCQSmileysRowPartialView *_v = (MCQSmileysRowPartialView *)v;
            NSInteger rowValue = [[_v value] intValue];
            if(rowValue >= 0 && rowValue <= self.answerLabels.count - 1) {
                NSString *text = ((UILabel *)[[self answerLabels] objectAtIndex:rowValue]).text;
                [values addObject:[CSVHelper formattedValue:text]];
            } else {
                [values addObject:[CSVHelper formattedValue:@""]];
            }
        }
    }

    return values;
}

- (BOOL)isFieldFilled {
    BOOL validated = YES;

    for(UIView *v in self.subviews) {
        if([v isKindOfClass:[MCQSmileysRowPartialView class]]) {
            MCQSmileysRowPartialView *_v = (MCQSmileysRowPartialView *)v;
            validated = validated && [_v isFieldFilled];
        }
    }

    return validated;
}

@end
