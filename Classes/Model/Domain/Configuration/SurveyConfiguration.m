//
//  SurveyConfiguration.m
//  inquire 2
//
//  Created by Nicolas Garnault on 16/07/12.
//  Copyright (c) 2012 Counterwinds. All rights reserved.
//

#import <RaptureXML/RXMLElement.h>

#import "SurveyConfiguration.h"
#import "UrlHelper.h"
#import "TextParagraph.h"
#import "FormPage.h"
#import "UIColor+fromHex.h"
#import "NSData+Base64.h"
#import "FormFieldProtocol.h"
#import "TextInputFormField.h"

@interface SurveyConfiguration(Private)
+ (void)parseScreensaverElement:(RXMLElement *)element withConfiguration:(SurveyConfiguration *)configuration;
+ (void)parseThemeFromElement:(RXMLElement *)element withConfiguration:(SurveyConfiguration *)configuration;
+ (void)parsePagesFromElement:(RXMLElement *)element withConfiguration:(SurveyConfiguration *)configuration;
+ (NSArray *)parseHeadersFromElement:(RXMLElement *)element;
+ (NSArray *)parseFootersFromElement:(RXMLElement *)element;
@end

@implementation SurveyConfiguration

- (NSInteger)numberOfFooters {
    return self.footers.count;
}

- (NSInteger)numberOfHeaders {
    return self.headers.count;
}

- (NSInteger)numberOfFormPages {
    return self.formPages.count;
}

- (NSInteger)numberOfOptinPages {
    return self.optinPages.count;
}

- (NSString *)optinButtonLabel {
    return NSLocalizedString(@"Laissez vos coordonnées", @"");
}

- (NSString *)csvFormQuestions {
    NSMutableArray *titles = [NSMutableArray array];
    
    for (FormPage *p in self.formPages) {
        for (id<FormFieldProtocol> field in p.formFields) {
            if([field canBeAnswered]) {
                [titles addObjectsFromArray:[field questions]];
            }
        }
    }
    
    return [NSString stringWithFormat:NSLocalizedString(@"\"Date\",\"iPad\",\"Geoloc. lat.\",\"Geoloc. long.\",%@", @""), [titles componentsJoinedByString:@","]];
}

- (NSString *)csvOptinQuestions {
    NSMutableArray *titles = [NSMutableArray array];

    for (FormPage *p in self.optinPages) {
        for (id<FormFieldProtocol> field in p.formFields) {
            if([field canBeAnswered]) {
                [titles addObjectsFromArray:[field questions]];
            }
        }
    }
    
    return [titles componentsJoinedByString:@","];
}


#pragma mark --
#pragma mark Parsing

+ (SurveyConfiguration *)configuration {
    SurveyConfiguration *c = [[SurveyConfiguration alloc] init];

    NSError *error = nil;
    NSString *s = [NSString stringWithContentsOfFile:[UrlHelper configurationFilePath]
                                            encoding:NSUTF8StringEncoding
                                               error:&error];

    if(!s.length) {
        return nil;
    }
    
    RXMLElement *rootXML = [RXMLElement elementFromXMLString:s encoding:NSUTF8StringEncoding];
    
    
    c.version = [rootXML attribute:@"version"];
    c.surveyId = [rootXML attribute:@"survey_id"];
    c.surveyDeploymentId = [rootXML attribute:@"survey_deployment_id"];

    for(RXMLElement *_element in [[rootXML child:@"redactional"] children:@"headers"]) {
        c.headers = [SurveyConfiguration parseHeadersFromElement:_element];
    }
    for(RXMLElement *_element in [[rootXML child:@"redactional"] children:@"footers"]) {
        c.footers = [SurveyConfiguration parseFootersFromElement:_element];
    }

    [SurveyConfiguration parsePagesFromElement:[rootXML child:@"pages"]
                             withConfiguration:c];

    [SurveyConfiguration parseThemeFromElement:[rootXML child:@"theme"]
                             withConfiguration:c];

    [SurveyConfiguration parseScreensaverElement:[rootXML child:@"screensaver"]
                               withConfiguration:c];
    
    return c;
}


+ (void)parseScreensaverElement:(RXMLElement *)element withConfiguration:(SurveyConfiguration *)configuration {

    configuration.screensaverInactivityTrigger = [[element attribute:@"inactivity_trigger"] intValue];
    configuration.screensaverDisplayInterval = [[element attribute:@"display_interval"] intValue];
    
    NSMutableArray *pictures = [NSMutableArray array];

    for(RXMLElement *_element in [[element child:@"pictures"] children:@"picture"]) {
        [pictures addObject:[UIImage imageWithData:[NSData dataFromBase64String:_element.text]]];
    }

    configuration.screensaverPictures = [NSArray arrayWithArray:pictures];
}

+ (void)parseThemeFromElement:(RXMLElement *)element withConfiguration:(SurveyConfiguration *)configuration {

    RXMLElement *_element = nil;

    //
    if([[element child:@"text"] attribute:@"color"]) {
        configuration.textColor = [UIColor fromHex:[[element child:@"text"] attribute:@"color"]];
    }

    if([[element child:@"font"] attribute:@"size"]) {
        configuration.fontSize = [[[element child:@"font"] attribute:@"size"] integerValue];
    }

    _element = [element child:@"background_gradient_bottom"];
    if(_element) {
        configuration.backgroundGradientColorBottom = [UIColor fromHex:_element.text];
    }

    _element = [element child:@"background_gradient_top"];
    if(_element) {
        configuration.backgroundGradientColorTop = [UIColor fromHex:_element.text];
    }

    _element = [element child:@"logo_picture"];
    if(_element) {
        configuration.logoImage = [UIImage imageWithData:[NSData dataFromBase64String:_element.text]];
    }

    _element = [element child:@"background_picture"];
    if(_element) {
        configuration.backgroundImage = [UIImage imageWithData:[NSData dataFromBase64String:_element.text]];
    }
}

+ (void)parsePagesFromElement:(RXMLElement *)element withConfiguration:(SurveyConfiguration *)configuration {

    NSMutableArray *formPages = [NSMutableArray array];
    NSMutableArray *optinPages = [NSMutableArray array];

    [element iterate:@"page" usingBlock:^(RXMLElement *_element) {
        FormPage *p = [FormPage loadFromElement:_element];
        if(p.isOptin) {
            [optinPages addObject:p];
        } else {
            [formPages addObject:p];
        }
    }];

    for(FormPage *p in formPages) {
        for(id<FormFieldProtocol> f in p.formFields) {
            NSLog(@"is_optional : %d", f.isOptional);
        }
    }

    for(FormPage *p in optinPages) {
        for(NSObject<FormFieldProtocol> *f in p.formFields) {
            NSLog(@"is_optional : %d", f.isOptional);
            if([f isKindOfClass:[TextInputFormField class]]) {
                NSLog(@"data_type: %d", ((TextInputFormField *)f).dataType);
            }
        }
    }

    configuration.formPages = formPages;
    configuration.optinPages = optinPages;
}

+ (NSArray *)parseHeadersFromElement:(RXMLElement *)element {
    NSMutableArray *header = [NSMutableArray array];
    [element iterate:@"header" usingBlock:^(RXMLElement *_element) {
        [header addObject:[TextParagraph loadFromElement:_element]];
    }];
    return header;
}

+ (NSArray *)parseFootersFromElement:(RXMLElement *)element {
    NSMutableArray *footers = [NSMutableArray array];
    [element iterate:@"footer" usingBlock:^(RXMLElement *_element) {
        [footers addObject:[TextParagraph loadFromElement:_element]];
    }];
    return footers;
}

@end
