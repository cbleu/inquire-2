//
//  InformativeTextUserView.h
//  inquire
//
//  Created by Nicolas GARNAULT on 04/02/11.
//  Copyright 2011 Counterwinds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserViewProtocol.h"


@interface InformativeTextUserView : UIView<UserViewProtocol> {
	UITextView *textView;
	UILabel *titleLabel;
}

@property IBOutlet UITextView *textView;
@property IBOutlet UILabel *titleLabel;

+ (UIView *)view;

@end
