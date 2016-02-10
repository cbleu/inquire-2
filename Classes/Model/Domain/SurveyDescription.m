//
//  SurveyDescription.m
//  inquire 2
//
//  Created by Nicolas Garnault on 15/07/12.
//  Copyright (c) 2012 Counterwinds. All rights reserved.
//

#import "SurveyDescription.h"

@implementation SurveyDescription

+ (id)fromXml:(RXMLElement *)xmlElement {
    SurveyDescription *d = [[SurveyDescription alloc] init];

    d.surveyId = [xmlElement attribute:@"id"];
    d.surveyDeploymentId = [xmlElement attribute:@"deployment_id"];
    d.title = [[xmlElement child:@"name"] text];

    return d;
}

@end
