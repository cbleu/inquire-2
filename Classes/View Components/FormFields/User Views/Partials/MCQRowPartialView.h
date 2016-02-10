//
//  MCQRowPartialView.h
//  inquire
//
//  Created by Nicolas GARNAULT on 22/02/11.
//  Copyright 2011 Counterwinds. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MCQRowPartialView;

@protocol MCQRowPartialViewDelegate <NSObject>

- (void)MCQRowViewWasChecked:(MCQRowPartialView *)view;

@end

@interface MCQRowPartialView : UIView {
    BOOL isChecked;

	UILabel *questionLabel;
    UIButton *checkButton;
    
    id<MCQRowPartialViewDelegate> __weak delegate;
}

@property (nonatomic, weak) id<MCQRowPartialViewDelegate> delegate;
@property (nonatomic, assign) BOOL isChecked;
@property (nonatomic, strong) IBOutlet UILabel *questionLabel;
@property (nonatomic, strong) IBOutlet UIButton *checkButton;

+ (MCQRowPartialView *)view;
- (IBAction)buttonPressed:(UIButton *)button;

@end