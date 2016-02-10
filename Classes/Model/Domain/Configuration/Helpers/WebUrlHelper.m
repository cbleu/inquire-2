//
//  WebUrlHelper.m
//  inquire 2
//
//  Created by Nicolas Garnault on 13/07/12.
//  Copyright (c) 2012 Counterwinds. All rights reserved.
//

#import "WebUrlHelper.h"
#import <OpenUDID/OpenUDID.h>

#define kIsLocal 0

#if kIsLocal
static NSString *baseUrl = @"http://inquire_web/api_dev.php/v1";
#else
static NSString *baseUrl = @"http://user.inquire.mu/api.php/v1";
#endif

@interface WebUrlHelper(Private)
+ (NSURL *)urlForString:(NSString *)string;
@end

@implementation WebUrlHelper

+ (NSURL *)surveysListURL {
    return [self urlForString:@"allowed_surveys"];
}

+ (NSURL *)surveyConfigurationURLWithSurveyId:(NSString *)surveyId {
    return [self urlForString:[NSString stringWithFormat:@"survey_configuration/%@", surveyId]];
}

+ (NSURL *)surveyResultsPostingURLWithSurveyId:(NSString *)surveyId
                            surveyDeploymentId:(NSString *)surveyDeploymentId {
    return [self urlForString:[NSString stringWithFormat:@"survey_results/%@/%@", surveyId, surveyDeploymentId]];
}

+ (NSURL *)deviceUpdatingURL {
    return [self urlForString:@"update_device_state"];
}

+ (NSURL *)deviceDisassociateURLWithDeviceToken:(NSString *)deviceToken {
    return [self urlForString:@"disassociate_device"];
}

+ (NSURL *)urlForString:(NSString *)string {
    return [NSURL URLWithString:
            [NSString stringWithFormat:@"%@/%@?device_token=%@",
             baseUrl, string, [OpenUDID value]]];
}

@end
