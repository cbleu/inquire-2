//
//  TextInputFormFieldUserView.h
//  inquire
//
//  Created by Nicolas GARNAULT on 04/02/11.
//  Copyright 2011 Counterwinds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserViewProtocol.h"

@interface TextInputFormFieldUserView : UIView<UserViewProtocol> {
	UITextField *textField;
	UILabel *label;
}

@property IBOutlet UILabel *label;
@property IBOutlet UITextField *textField;

+ (UIView *)view;

@end
