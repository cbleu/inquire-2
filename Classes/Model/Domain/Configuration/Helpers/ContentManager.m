//
//  ContentManager.m
//  inquire 2
//
//  Created by Nicolas Garnault on 13/07/12.
//  Copyright (c) 2012 Counterwinds. All rights reserved.
//

#import <RaptureXML/RXMLElement.h>

#import "ContentManager.h"
#import "WebUrlHelper.h"
#import "UrlHelper.h"
#import "SurveyDescription.h"
#import "SurveyConfiguration.h"
#import "NSString+URLEncoding.h"

@interface ContentManager(Private)
- (NSArray *)surveysListFromString:(NSString *)content;
- (void)dumpConfigurationFile:(NSString *)content;
- (NSError *)errorForStatusCode:(NSInteger)statusCode;
- (NSError *)errorForError:(NSError *)error;
- (NSError *)errorWhithAuthenticationChallenge;
@end


@implementation ContentManager

@synthesize publicId, secretKey, delegate, currentOperation;

- (id)init {
    if((self = [super init])) {
        receivedData = [[NSMutableData alloc] init];
        expectedDataLength = 0;
    }
    return self;
}

- (BOOL)fetchSurveysList {
    if(currentOperation != ContentManagerOperationNone)
        return NO;
    
    //
    currentOperation = ContentManagerOperationSurveysList;

    NSURLRequest *request = [NSURLRequest requestWithURL:[WebUrlHelper surveysListURL]];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
    
    return YES;
}

- (BOOL)fetchSurveyConfigurationForSurveyId:(NSString *)surveyId {
    
    if(currentOperation != ContentManagerOperationNone)
        return NO;

    //
    currentOperation = ContentManagerOperationSurveyConfiguration;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[WebUrlHelper surveyConfigurationURLWithSurveyId:surveyId]];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];

    return YES;
}

- (BOOL)postSurveysResultsWithSurveyId:(NSString *)surveyId surveyDeploymentId:(NSString *)surveyDeploymentId formResults:(NSString *)formResults optinResults:(NSString *)optinResults {

    if(currentOperation != ContentManagerOperationNone)
        return NO;

    currentOperation = ContentManagerOperationSurveyResults;

    NSURL *url = [WebUrlHelper surveyResultsPostingURLWithSurveyId:surveyId surveyDeploymentId:surveyDeploymentId];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";

    
    formResults = [formResults urlEncodeUsingEncoding:NSUTF8StringEncoding];
    optinResults = [optinResults urlEncodeUsingEncoding:NSUTF8StringEncoding];

    NSString *postString = [NSString stringWithFormat: @"form_results=%@&optin_results=%@", formResults, optinResults];

    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];

    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];

    return YES;    
}

- (BOOL)updateDeviceWithCoordinates:(CLLocationCoordinate2D)location deviceToken:(NSString *)deviceToken {
    if(currentOperation != ContentManagerOperationNone)
        return NO;
    
    currentOperation = ContentManagerOperationDeviceUpdate;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[WebUrlHelper deviceUpdatingURL]];
    request.HTTPMethod = @"POST";
    
    NSString *postString = [NSString stringWithFormat:
                            @"latitude=%.8f&longitude=%.8f&device_token=%@",
                            location.latitude, location.longitude, deviceToken];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
    
    return YES;
}

- (BOOL)disassociateDeviceWithToken:(NSString *)deviceToken {
    if(currentOperation != ContentManagerOperationNone)
        return NO;
    
    currentOperation = ContentManagerOperationDeviceDisassociate;

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[WebUrlHelper deviceDisassociateURLWithDeviceToken:deviceToken]];
    request.HTTPMethod = @"PUT";
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
    
    return YES;
}

#pragma mark --
#pragma mark NSURLConnection delegate stuff

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"connection:didFailWithError : %@", error);

    // 
    [delegate contentManager:self didFailWithError:[self errorForError:error]];
    
    // Resetting contentManager current operation
    currentOperation = ContentManagerOperationNone;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    // NSLog(@"connection:willSendRequestForAuthenticationChallenge:");    

    if ([challenge previousFailureCount] == 0) {
        NSURLCredential *newCredential = [NSURLCredential credentialWithUser:publicId
                                                                    password:secretKey
                                                                 persistence:NSURLCredentialPersistenceForSession];
        
        [[challenge sender] useCredential:newCredential forAuthenticationChallenge:challenge];
    }
    else {
        NSLog(@"Failed authentication challenge");

        // Notifying the error
        [delegate contentManager:self didFailWithError:[self errorWhithAuthenticationChallenge]];
        
        // Resetting the manager current operation
        currentOperation = ContentManagerOperationNone;

        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}


// 
// iOS 4.X compatibility
//
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
//    NSLog(@"connection:willSendRequestForAuthenticationChallenge:");    
    
    if ([challenge previousFailureCount] == 0) {
        NSURLCredential *newCredential = [NSURLCredential credentialWithUser:publicId
                                                                    password:secretKey
                                                                 persistence:NSURLCredentialPersistenceForSession];
        
        [[challenge sender] useCredential:newCredential forAuthenticationChallenge:challenge];
    }
    else {
        NSLog(@"connection:didReceiveAuthenticationChallenge failed");

        // Notifying the error
        [delegate contentManager:self didFailWithError:[self errorWhithAuthenticationChallenge]];
        
        // Resetting the manager current operation
        currentOperation = ContentManagerOperationNone;

        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse {
//    NSLog(@"connection:willSendRequest:redirectResponse:");    
    return request;
}

#pragma mark --
#pragma mark NSURLConnectionData delegate stuff

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response {
//    NSLog(@"connection:didReceiveResponse: (code : %d)", response.statusCode);

    // Setting dataLength
    [receivedData setLength:0];
    
    // Doing something, according to response code
    if(response.statusCode == 200) {
        expectedDataLength = response.expectedContentLength;
    } else {
        NSLog(@"An error occured with status : %ld during operation : %d", (long)response.statusCode, currentOperation);

        // Cancelling the connection
        [connection cancel];

        // 
        [delegate contentManager:self didFailWithError:[self errorForStatusCode:response.statusCode]];
        
        // Updating the current fetching mode
        currentOperation = ContentManagerOperationNone;
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // NSLog(@"connection:didReceiveData:");

    // Apending data
    [receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection { 	
    // NSLog(@"connectionDidFinishLoading:");
 	NSString *content = [[NSString alloc] initWithData:receivedData
                                              encoding:NSUTF8StringEncoding];

    switch (currentOperation) {
        case ContentManagerOperationSurveysList: {
            NSLog(@"contentManagerOperation:ContentManagerOperationSurveysList");
            [delegate contentManager:self didFetchSurveysList:[self surveysListFromString:content]];
            break;
        }
        case ContentManagerOperationSurveyConfiguration: {
            NSLog(@"contentManagerOperation:ContentManagerOperationSurveyConfiguration");
            [self dumpConfigurationFile:content];
            [delegate contentManager:self didFetchSurveyConfiguration:[SurveyConfiguration configuration]];
            break;
        }
        case ContentManagerOperationSurveyResults: {
            NSLog(@"contentManagerOperation:ContentManagerOperationSurveyResults");
            [delegate contentManagerDidPostSurveyResults:self];
            break;
        }
        case ContentManagerOperationDeviceUpdate: {
            NSLog(@"contentManagerOperation:ContentManagerOperationDeviceUpdate");
            [delegate contentManagerDidUpdateDevice:self];
            break;
        }
        case ContentManagerOperationDeviceDisassociate: {
            NSLog(@"contentManagerOperation:ContentManagerOperationDeviceDisassociate");
            [delegate contentManagerDidDisassociateDevice:self];
        }
        default:
            break;
    }

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    currentOperation = ContentManagerOperationNone;
}

- (NSArray *)surveysListFromString:(NSString *)content {
    NSMutableArray *surveys = [NSMutableArray array];
    RXMLElement *rootXML = [RXMLElement elementFromXMLString:content
                                                    encoding:NSUTF8StringEncoding];

    [rootXML iterate:@"survey" usingBlock: ^(RXMLElement *survey) {
        [surveys addObject:[SurveyDescription fromXml:survey]];
    }];

    return surveys;
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
    return [NSError errorWithDomain:message code:ContentManagerErrorCodeLoginFailed userInfo:nil];
}


- (NSError *)errorForStatusCode:(NSInteger)statusCode {
    
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


@end
