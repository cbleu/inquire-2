//
//  WebUrlHelper.h
//  inquire 2
//
//  Created by Nicolas Garnault on 13/07/12.
//  Copyright (c) 2012 Counterwinds. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebUrlHelper : NSObject

+ (NSURL *)surveysListURL;
+ (NSURL *)surveyConfigurationURLWithSurveyId:(NSString *)surveyId;
+ (NSURL *)surveyResultsPostingURLWithSurveyId:(NSString *)surveyId
                            surveyDeploymentId:(NSString *)surveyDeploymentId;
+ (NSURL *)deviceUpdatingURL;
+ (NSURL *)deviceDisassociateURLWithDeviceToken:(NSString *)deviceToken;

@end
