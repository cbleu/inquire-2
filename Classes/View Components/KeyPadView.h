//
//  KeyPadView.h
//  inquire 2
//
//  Created by Nicolas GARNAULT on 21/04/2014.
//  Copyright (c) 2014 Counterwinds. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KeyPadView : UIView

@property (nonatomic, copy) void (^numberPressed)(NSInteger number);
@property (nonatomic, copy) void (^backspacePressed)();

+ (KeyPadView *)view;

@end
