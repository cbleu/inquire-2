//
//  MCQSmileysRowPartialView.h
//  inquire
//
//  Created by Nicolas GARNAULT on 04/02/11.
//  Copyright 2011 Counterwinds. All rights reserved.
//

#import "UserViewProtocol.h"

@interface MCQSmileysRowPartialView : UIView {
	UILabel *questionLabel;

    NSInteger checkedAnswer;

	IBOutlet UIButton *button1;
	IBOutlet UIButton *button2;
	IBOutlet UIButton *button3;
	IBOutlet UIButton *button4;
}

@property (nonatomic, assign) NSInteger checkedAnswer;
@property (nonatomic, strong) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic, readonly) IBOutlet NSArray *answserButtons;

+ (MCQSmileysRowPartialView *)view;
- (IBAction)buttonPressed:(UIButton *)button;
- (id)value;
- (BOOL)isFieldFilled;

@end
