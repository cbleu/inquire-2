//
//  AppCredentials.h
//  inquire
//
//  Created by Nicolas GARNAULT on 28/01/11.
//  Copyright 2011 Counterwinds. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AppCredentials : NSObject {
    
}

+ (void)setPublicId:(NSString *)publicId secretKey:(NSString *)secretKey deviceIdentifier:(NSString *)deviceIdentifier;

+ (BOOL)areCredentialSet;

+ (NSString *)deviceIdentifier;
+ (NSString *)publicId;
+ (NSString *)secretKey;

+ (NSString *)currentSurveyId;
+ (void)setCurrentSurveyId:(NSString *)string;
+ (NSString *)currentSurveyDeploymentId;
+ (void)setCurrentSurveyDeploymentId:(NSString *)string;

+ (NSString *)lastResultsPostDateTime;
+ (void)setLastResultsPostDate:(NSDate *)date;

+ (void)resetAll;

+ (NSURLCredential *)userCredentials;

@end
