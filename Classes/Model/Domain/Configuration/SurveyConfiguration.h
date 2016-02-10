//
//  SurveyConfiguration.h
//  inquire 2
//
//  Created by Nicolas Garnault on 16/07/12.
//  Copyright (c) 2012 Counterwinds. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SurveyConfiguration : NSObject

@property NSString *version;
@property NSString *surveyId;
@property NSString *surveyDeploymentId;

@property NSArray *headers;
@property (readonly) NSInteger numberOfHeaders;

@property NSArray *footers;
@property (readonly) NSInteger numberOfFooters;
@property (readonly) NSString *optinButtonLabel;

@property NSArray *formPages;
@property (readonly) NSInteger numberOfFormPages;

@property NSArray *optinPages;
@property (readonly) NSInteger numberOfOptinPages;

@property UIImage *logoImage;
@property UIImage *backgroundImage;

@property UIColor *backgroundGradientColorTop;
@property UIColor *backgroundGradientColorBottom;

@property NSInteger screensaverInactivityTrigger;
@property NSInteger screensaverDisplayInterval;
@property NSArray *screensaverPictures;

@property NSInteger fontSize;
@property UIColor *textColor;

@property (readonly) NSString *csvFormQuestions;
@property (readonly) NSString *csvOptinQuestions;

+ (SurveyConfiguration *)configuration;

@end
