//
//  GroupedMCQFormFieldUserView.m
//  inquire
//
//  Created by Nicolas GARNAULT on 04/02/11.
//  Copyright 2011 Counterwinds. All rights reserved.
//

#import "GroupedMCQFormFieldUserView.h"
#import "MCQRowPartialView.h"
#import "CSVHelper.h"

@implementation GroupedMCQFormFieldUserView

@synthesize formField;
@synthesize questionTitleLabel, answersPartials;


+ (GroupedMCQFormFieldUserView *)view {
	NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"GroupedMCQFormFieldUserView"
                                                 owner:self options:nil];
	GroupedMCQFormFieldUserView *v = (GroupedMCQFormFieldUserView *)[arr lastObject];
	v.answersPartials = [NSMutableArray array];
	return v;
}


- (BOOL)canBeAnswered {
    return YES;
}

- (NSArray *)values {
    NSInteger i = 0;

    for(MCQRowPartialView *m in answersPartials) {
        if(m.isChecked) {
            return [NSArray arrayWithObject:[CSVHelper formattedValue:m.questionLabel.text]];
        }
        i++;
    }

    return [NSArray arrayWithObject:[CSVHelper formattedValue:@""]];
}

- (BOOL)isFieldFilled {    
    for(MCQRowPartialView *m in self.answersPartials) {
        if(m.isChecked) {
            return YES;
        }
    }
    return NO;
}

- (void)MCQRowViewWasChecked:(MCQRowPartialView *)view {
    for (MCQRowPartialView *p in self.answersPartials) {
        [p setIsChecked:NO];
    }
    [view setIsChecked:YES];
}

@end
