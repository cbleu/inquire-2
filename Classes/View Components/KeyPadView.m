//
//  KeyPadView.m
//  inquire 2
//
//  Created by Nicolas GARNAULT on 21/04/2014.
//  Copyright (c) 2014 Counterwinds. All rights reserved.
//

#import "KeyPadView.h"

@interface KeyPadView()
- (IBAction)keyPressed:(id)sender;
- (IBAction)backspacePressed:(id)sender;
@end

@implementation KeyPadView

+ (KeyPadView *)view {
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"KeyPadView"
                                                 owner:self options:nil];
	KeyPadView *v = (KeyPadView *)[arr lastObject];
    
    UIToolbar *t = [[UIToolbar alloc] initWithFrame:v.bounds];
    t.barStyle = UIBarStyleDefault;
    [v addSubview:t];
    [v sendSubviewToBack:t];
    t.frame = v.bounds;
    t.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	return v;
}

- (IBAction)keyPressed:(UIButton *)sender {
    _numberPressed(sender.tag - 1000);
}

- (IBAction)backspacePressed:(UIButton *)sender {
    _backspacePressed();
}

@end
