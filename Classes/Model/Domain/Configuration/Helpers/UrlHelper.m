//
//  UrlHelper.m
//  inquire
//
//  Created by Nicolas GARNAULT on 30/01/11.
//  Copyright 2011 Counterwinds. All rights reserved.
//

#import "UrlHelper.h"
#import "NSFileManager+DirectoryLocations.h"

@implementation UrlHelper


+ (NSString *)configurationFilePath {
    return [NSString stringWithFormat:@"%@/%@", [[NSFileManager defaultManager] applicationSupportDirectory], @"survey_configuration.xml"];
}

+ (NSString *)formResultsFilePath {
    return [NSString stringWithFormat:@"%@/%@", [[NSFileManager defaultManager] applicationSupportDirectory], @"form_results.csv"];
}

+ (NSString *)optinResultsFilePath {
    return [NSString stringWithFormat:@"%@/%@", [[NSFileManager defaultManager] applicationSupportDirectory], @"optin_results.csv"];
}

@end
