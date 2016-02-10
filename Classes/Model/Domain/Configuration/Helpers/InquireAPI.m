//
//  InquireAPI.m
//  inquire 2
//
//  Created by Nicolas GARNAULT on 21/10/13.
//  Copyright (c) 2013 Counterwinds. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

#import "WebUrlHelper.h"
#import "UrlHelper.h"

#import "InquireAPI.h"
#import "AppCredentials.h"
#import "SurveyConfiguration.h"
#import "SurveyDescription.h"


#define kDebugSuccess       0
#define kDebugFailure       0

#if kDebugSuccess
#define SuccessLog(fmt,...) NSLog((@"Success : %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define SuccessLog(fmt,...)
#endif

#if kDebugFailure
#define FailureLog(fmt,...) NSLog((@"Failure : %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define FailureLog(fmt,...)
#endif

@interface NSURL(Private)
- (NSString *)fullPath;

@end

@implementation NSURL(Private)
- (NSString *)fullPath {
    NSString *path = nil;
    
    if([self query].length) {
        path = [NSString stringWithFormat:@"%@?%@", [self path], [self query]];
    } else {
        path = [self path];
    }
    
    return path;
}
@end

@interface InquireAPI(Private)
+ (NSError *)errorFromContent:(NSString *)content originalError:(NSError *)_error;
@end

@implementation InquireAPI

- (void)fetchSurveysListWithSuccess:(void(^)(NSArray *surveys))success
                            failure:(void(^)(NSError *error))failure {
    //
    NSURL *url = [WebUrlHelper surveysListURL];
    
    /*
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    [client setDefaultCredential:[AppCredentials userCredentials]];
    [client getPath:url.fullPath
         parameters:nil
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                SuccessLog(@"%@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
                
                //
                NSError *error = nil;
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                    options:kNilOptions
                                                                      error:&error];
                NSArray *a = [dic objectForKey:@"events"];
                NSMutableArray *events = [NSMutableArray array];
                
                for (NSDictionary *d in a) {
                    [events addObject:[SurveyDescription fromDictionary:a]];
                }
                
                //
                if(error) {
                    FailureLog(@"%@ - %@ - %@",
                               error, error.localizedRecoverySuggestion, operation.responseString);
                    failure(error);
                } else {
                    success(events);
                }
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                //
                FailureLog(@"%@ - %@ - %@",
                           error, error.localizedDescription, operation.responseString);
                //
                failure([self errorFromContent:operation.responseString originalError:error]);
            }];
     */
}

- (void)fetchSurveyConfigurationForSurveyId:(NSString *)surveyId
                                    success:(void(^)(SurveyConfiguration *survey))success
                                    failure:(void(^)(NSError *error))failure {
    
}

- (void)postSurveysResultsWithSurveyId:(NSString *)surveyId
                    surveyDeploymentId:(NSString *)surveyDeploymentId
                           formResults:(NSString *)formResults
                          optinResults:(NSString *)optinResults
                               success:(void(^)())success
                               failure:(void(^)(NSError *error))failure {
    
}

- (void)updateDeviceWithCoordinates:(CLLocationCoordinate2D)location
                        deviceToken:(NSString *)deviceToken
                            success:(void(^)())success
                            failure:(void(^)(NSError *error))failure {
    
}

- (void)disassociateDeviceWithToken:(NSString *)deviceToken
                            success:(void(^)())success
                            failure:(void(^)(NSError *error))failure {
    
}



#pragma mark --
#pragma mark Private
+ (NSArray *)surveysListFromString:(NSString *)content {
    NSError *error = nil;
#warning FIXMe
    /*
	CXMLDocument *doc = [[CXMLDocument alloc] initWithXMLString:content
                                                        options:0
                                                          error:&error];
    
    if(error != nil) {
        NSLog(@"error while parsing content : %@", error);
    }
    
    NSArray *nodes = [doc nodesForXPath:@"/surveys/*" error:nil];
    NSMutableArray *surveys = [NSMutableArray array];
    
	//! searching for item nodes
    for(CXMLElement *e in nodes) {
        if([e.name isEqualToString:@"survey"]) {
            [surveys addObject:[SurveyDescription fromXml:e]];
        }
    }

    return surveys;
          */
    return nil;
}



+ (NSError *)errorForStatusCode:(NSInteger)statusCode {
    
    NSString *domain = [NSString stringWithFormat:@"Unknown error (HTTP status code : %ld)", (long)statusCode];
    //ContentManagerErrorCode errorCode = ContentManagerErrorCodeUnknown;
    
    switch (statusCode) {
            // Malformed request (missing arguments)
        case 400: {
            domain = NSLocalizedString(@"Requête invalide (arguments manquants)", @"");
            //errorCode = ContentManagerErrorCodeBadRequest;
            break;
        }
            // Bad method to access the resource
        case 404: {
            domain = NSLocalizedString(@"Resource introuvable (enquête/déploiement)", @"");
            //errorCode = ContentManagerErrorCodeResourceNotFound;
            break;
        }
            // Bad method to access the resource
        case 405: {
            domain = NSLocalizedString(@"Requête invalide (méthode invalide pour accéder à la ressource)", @"");
            //errorCode = ContentManagerErrorCodeBadRequest;
            break;
        }
            // Device already associed
        case 409: {
            domain = NSLocalizedString(@"Les identifiants spécifiés ont été associés à un autre périphérique", @"");
            //errorCode = ContentManagerErrorCodeDeviceAlreadyAssociated;
            break;
        }
        default:
            break;
    }
    return [NSError errorWithDomain:domain code:/*errorCode*/0 userInfo:nil];
}



- (void)dumpConfigurationFile:(NSString *)content {
    [content writeToFile:[UrlHelper configurationFilePath]
              atomically:YES
                encoding:NSUTF8StringEncoding
                   error:nil];
}

- (NSError *)errorForError:(NSError *)error {
    return error;
}

- (NSError *)errorWhithAuthenticationChallenge {
    NSString *message = NSLocalizedString(@"L'authentification a échoué", @"");
    return [NSError errorWithDomain:message
                               code:0/*ContentManagerErrorCodeLoginFailed*/
                           userInfo:nil];
}


+ (NSError *)errorFromContent:(NSString *)content originalError:(NSError *)_error {
    if(!content.length) {
        return _error;
    }
    
    //
    NSError *error = nil;
    NSDictionary *d = [NSJSONSerialization JSONObjectWithData:[content dataUsingEncoding:NSUTF8StringEncoding]
                                                      options:kNilOptions
                                                        error:&error];
    
    //
    if(error) {
        FailureLog(@"%@", error.localizedDescription);
        return error;
    }
    
    //
    NSMutableDictionary *details = [NSMutableDictionary dictionary];
    [details setObject:[[[d objectForKey:@"errors"] allValues] lastObject]
                forKey:NSLocalizedDescriptionKey];
    
    //
    return [NSError errorWithDomain:@"fail" code:007 userInfo:details];
}



@end
