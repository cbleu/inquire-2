//
//  ContentManager.h
//  inquire 2
//
//  Created by Nicolas Garnault on 13/07/12.
//  Copyright (c) 2012 ;. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class ContentManager, SurveyConfiguration;

@protocol ContentManagerDelegate <NSObject>
- (void)contentManager:(ContentManager *)manager didFetchSurveysList:(NSArray *)surveys;
- (void)contentManager:(ContentManager *)manager didFetchSurveyConfiguration:(SurveyConfiguration *)configuration;
- (void)contentManagerDidPostSurveyResults:(ContentManager *)manager;
- (void)contentManagerDidUpdateDevice:(ContentManager *)manager;
- (void)contentManagerDidDisassociateDevice:(ContentManager *)manager;

- (void)contentManager:(ContentManager *)manager didFailWithError:(NSError *)error;
- (void)contentManager:(ContentManager *)manager didUpdateProgress:(double *)progress;

@end

typedef enum {
    ContentManagerOperationNone,
    ContentManagerOperationSurveysList,
    ContentManagerOperationSurveyConfiguration,
    ContentManagerOperationSurveyResults,
    ContentManagerOperationDeviceUpdate,
    ContentManagerOperationDeviceDisassociate
} ContentManagerOperation;

typedef enum {
    ContentManagerErrorCodeNone,
    ContentManagerErrorCodeUnknown,
    ContentManagerErrorCodeNoConnection,
    ContentManagerErrorCodeBadRequest,
    ContentManagerErrorCodeResourceNotFound,
    ContentManagerErrorCodeLoginConnectionFailed,
    ContentManagerErrorCodeLoginFailed,
    ContentManagerErrorCodeDeviceAlreadyAssociated,
} ContentManagerErrorCode;

@interface ContentManager : NSObject<NSURLConnectionDelegate, NSURLConnectionDataDelegate> {
    NSString *publicId;
    NSString *secretKey;

    // 
    ContentManagerOperation currentOperation;
    NSMutableData *receivedData;
    NSInteger expectedDataLength;

    //
    id<ContentManagerDelegate> __weak delegate;
}

@property (nonatomic, strong) NSString *publicId;
@property (nonatomic, strong) NSString *secretKey;
@property (nonatomic, readonly) ContentManagerOperation currentOperation;
@property (nonatomic, weak) id<ContentManagerDelegate> delegate;

- (BOOL)fetchSurveysList;
- (BOOL)fetchSurveyConfigurationForSurveyId:(NSString *)surveyId;
- (BOOL)postSurveysResultsWithSurveyId:(NSString *)surveyId surveyDeploymentId:(NSString *)surveyDeploymentId formResults:(NSString *)formResults optinResults:(NSString *)optinResults;
- (BOOL)updateDeviceWithCoordinates:(CLLocationCoordinate2D)location deviceToken:(NSString *)deviceToken;
- (BOOL)disassociateDeviceWithToken:(NSString *)deviceToken;

@end
