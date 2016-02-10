//
//  GroupedMCQFormFieldUserView.h
//  inquire
//
//  Created by Nicolas GARNAULT on 04/02/11.
//  Copyright 2011 Counterwinds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCQRowPartialView.h"
#import "UserViewProtocol.h"

@interface GroupedMCQFormFieldUserView : UIView<MCQRowPartialViewDelegate, UserViewProtocol> {
	UILabel *questionTitleLabel;
	NSMutableArray *answersPartials;
}

@property (nonatomic, strong) IBOutlet UILabel *questionTitleLabel;
@property (nonatomic, strong) NSMutableArray *answersPartials;

+ (GroupedMCQFormFieldUserView *)view;

@end
