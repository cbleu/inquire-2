//
//  FormFieldProtocol.h
//  inquire
//
//  Created by Nicolas GARNAULT on 13/01/11.
//  Copyright 2011 Counterwinds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMLHandledProtocol.h"

@class SurveyConfiguration;

@protocol FormFieldProtocol <XMLHandledProtocol>
// User stuff
- (UIView *)userViewForConfiguration:(SurveyConfiguration *)configuration;
- (NSArray *)questions;

@property (readonly) BOOL canBeAnswered;
@property (readonly) BOOL isOptional;

@end