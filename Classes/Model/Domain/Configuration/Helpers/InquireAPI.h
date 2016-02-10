//
//  InquireAPI.h
//  inquire 2
//
//  Created by Nicolas GARNAULT on 21/10/13.
//  Copyright (c) 2013 Counterwinds. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@class SurveyConfiguration;

@interface InquireAPI : NSObject

- (void)fetchSurveysListWithSuccess:(void(^)(NSArray *surveys))success
                            failure:(void(^)(NSError *error))failure;

- (void)fetchSurveyConfigurationForSurveyId:(NSString *)surveyId
                                    success:(void(^)(SurveyConfiguration *survey))success
                                    failure:(void(^)(NSError *error))failure;

- (void)postSurveysResultsWithSurveyId:(NSString *)surveyId
                    surveyDeploymentId:(NSString *)surveyDeploymentId
                           formResults:(NSString *)formResults
                          optinResults:(NSString *)optinResults
                               success:(void(^)())success
                               failure:(void(^)(NSError *error))failure;

- (void)updateDeviceWithCoordinates:(CLLocationCoordinate2D)location
                        deviceToken:(NSString *)deviceToken
                            success:(void(^)())success
                            failure:(void(^)(NSError *error))failure;

- (void)disassociateDeviceWithToken:(NSString *)deviceToken
                            success:(void(^)())success
                            failure:(void(^)(NSError *error))failure;

@end
