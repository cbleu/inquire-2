//
//  AppCredentials.m
//  inquire
//
//  Created by Nicolas GARNAULT on 28/01/11.
//  Copyright 2011 Counterwinds. All rights reserved.
//

#import "AppCredentials.h"


@implementation AppCredentials

+ (BOOL)areCredentialSet {
    return [[AppCredentials publicId] length] > 0 && [[AppCredentials secretKey] length] > 0;
}

+ (NSString *)deviceIdentifier {
	[[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
															 @"", @"app_credential_device_identifier", nil]];
	return [[NSUserDefaults standardUserDefaults] objectForKey:@"app_credential_device_identifier"];
}

+ (void)setPublicId:(NSString *)publicId secretKey:(NSString *)secretKey deviceIdentifier:(NSString *)deviceIdentifier {
	[[NSUserDefaults standardUserDefaults] setObject:publicId forKey:@"app_credential_public_id"];
	[[NSUserDefaults standardUserDefaults] setObject:secretKey forKey:@"app_credential_secret_key"];
	[[NSUserDefaults standardUserDefaults] setObject:secretKey forKey:@"app_crediential_device_identifier"];
	[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"app_credential_were_set"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)publicId {
	// Default value for last fetch
	[[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
															 @"", @"app_credential_public_id", nil]];
	return [[NSUserDefaults standardUserDefaults] objectForKey:@"app_credential_public_id"];
}

+ (NSString *)secretKey {
	// Default value for last fetch
	[[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
															 @"", @"app_credential_secret_key", nil]];
	return [[NSUserDefaults standardUserDefaults] objectForKey:@"app_credential_secret_key"];
}

+ (NSString *)currentSurveyId {
	[[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
															 @"", @"app_current_survey_id", nil]];
	return [[NSUserDefaults standardUserDefaults] objectForKey:@"app_current_survey_id"];
}

+ (void)setCurrentSurveyId:(NSString *)string {
    [[NSUserDefaults standardUserDefaults] setObject:string forKey:@"app_current_survey_id"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)currentSurveyDeploymentId {
    [[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
                                                         @"", @"app_current_survey_deployment_id", nil]];
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"app_current_survey_deployment_id"];
}

+ (void)setCurrentSurveyDeploymentId:(NSString *)string {
    [[NSUserDefaults standardUserDefaults] setObject:string forKey:@"app_current_survey_deployment_id"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)lastResultsPostDateTime {
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateStyle:NSDateFormatterMediumStyle];
    [f setTimeStyle:NSDateFormatterMediumStyle];

    //
	[[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
															 @"", @"app_last_result_post_date", nil]];
    
	return [f stringFromDate:[[NSUserDefaults standardUserDefaults] objectForKey:@"app_last_result_post_date"]];
}

+ (void)setLastResultsPostDate:(NSDate *)date {
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"app_last_result_post_date"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)resetAll {
    NSDictionary *defaultsDict = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
    for (NSString *key in [defaultsDict allKeys])
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSURLCredential *)userCredentials {
    return [NSURLCredential credentialWithUser:[self publicId]
                                      password:[self secretKey]
                                   persistence:NSURLCredentialPersistenceForSession];
}

@end
