//
//  XMLHandledProtocol.h
//  inquire
//
//  Created by Nicolas GARNAULT on 27/01/11.
//  Copyright 2011 Counterwinds. All rights reserved.
//

#import <RaptureXML/RXMLElement.h>

#import <UIKit/UIKit.h>

@protocol XMLHandledProtocol

+ (id)loadFromElement:(RXMLElement *)element;

@end
