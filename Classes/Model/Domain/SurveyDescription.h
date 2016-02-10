//
//  SurveyDescription.h
//  inquire 2
//
//  Created by Nicolas Garnault on 15/07/12.
//  Copyright (c) 2012 Counterwinds. All rights reserved.
//

#import <RaptureXML/RXMLElement.h>

#import <Foundation/Foundation.h>

@interface SurveyDescription : NSObject

@property NSString *surveyId;
@property NSString *surveyDeploymentId;
@property NSString *title;

+ (id)fromXml:(RXMLElement *)xmlElement;

@end
