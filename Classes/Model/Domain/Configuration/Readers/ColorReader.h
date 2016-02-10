//
//  ColorReader.h
//  inquire
//
//  Created by Nicolas GARNAULT on 30/01/11.
//  Copyright 2011 Counterwinds. All rights reserved.
//

#import <RaptureXML/RXMLElement.h>

#import <Foundation/Foundation.h>

@interface ColorReader : NSObject {

}

+ (UIColor *)colorFromElement:(RXMLElement *)element;

@end
