//
//  MCQSmileysRowPartialView.m
//  inquire
//
//  Created by Nicolas GARNAULT on 04/02/11.
//  Copyright 2011 Counterwinds. All rights reserved.
//

#import "MCQSmileysRowPartialView.h"
#import <QuartzCore/QuartzCore.h>

@implementation MCQSmileysRowPartialView

@synthesize questionLabel, checkedAnswer;


- (IBAction)buttonPressed:(UIButton *)button {
    for(UIButton *b in [self answserButtons]) {
        [b setSelected:NO];
    }

    checkedAnswer = [[self answserButtons] indexOfObject:button];

    [button setSelected:YES];
}

- (void)setCheckedAnswer:(NSInteger)_checkedAnswer {
    NSArray *buttons = [self answserButtons];
    
    if(_checkedAnswer > 0 && _checkedAnswer < [buttons count]) {
        checkedAnswer = _checkedAnswer;
        [self buttonPressed:[buttons objectAtIndex:_checkedAnswer]];
    } else {
        checkedAnswer = -1;
    }
}

+ (MCQSmileysRowPartialView *)view {
	NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"MCQSmileysRowPartialView" owner:self options:nil];
    MCQSmileysRowPartialView *v = (MCQSmileysRowPartialView *)[arr lastObject];
    v.checkedAnswer = -1;
    
    for(UIButton *b in [v answserButtons]) {
        [b setSelected:YES];
    }
    
	return v;
}

- (NSArray *)answserButtons {
	return [NSArray arrayWithObjects:button1, button2, button3, button4, nil];
}

- (id)value {
    return [NSString stringWithFormat:@"%ld", (long)checkedAnswer];
}

- (BOOL)isFieldFilled {
    return checkedAnswer >= 0;
}

@end
