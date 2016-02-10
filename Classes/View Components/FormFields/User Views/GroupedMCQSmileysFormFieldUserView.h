//
//  GroupedMCQSmileysFormFieldUserView.h
//  inquire
//
//  Created by Nicolas GARNAULT on 04/02/11.
//  Copyright 2011 Counterwinds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserViewProtocol.h"


@interface GroupedMCQSmileysFormFieldUserView : UIView<UserViewProtocol> {
	UILabel *questionTitleLabel;

	UILabel *answerLabel1;
	UILabel *answerLabel2;
	UILabel *answerLabel3;
	UILabel *answerLabel4;
}

@property IBOutlet UILabel *questionTitleLabel;

@property IBOutlet UILabel *answerLabel1;
@property IBOutlet UILabel *answerLabel2;
@property IBOutlet UILabel *answerLabel3;
@property IBOutlet UILabel *answerLabel4;

@property (weak, nonatomic, readonly) NSArray *answerLabels;

+ (GroupedMCQSmileysFormFieldUserView *)view;

@end