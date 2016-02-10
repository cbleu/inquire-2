//
//  TextParagraph.m
//  inquire
//
//  Created by Nicolas GARNAULT on 17/03/11.
//  Copyright 2011 Counterwinds. All rights reserved.
//

#import "TextParagraph.h"
#import "UIColor+RGBComponents.h"
#import "ColorReader.h"
#import "UIColor+fromHex.h"

@implementation TextParagraph

@synthesize textAlignment, fontSize, fontColor, textContent;

- (id)init {
    if((self = [super init])) {
        self.textAlignment = NSTextAlignmentLeft;
        self.fontSize = 10;
        self.fontColor = [UIColor blackColor];
        self.textContent = @"";
    }
    return self;
}


#pragma --
#pragma XMLHandledProtocol
+ (id)loadFromElement:(RXMLElement *)element {
	TextParagraph *t = [[TextParagraph alloc] init];

    t.textContent = [[element child:@"text_content"] text];

    [element iterate:@"text" usingBlock:^(RXMLElement *_element) {
        if([_element attribute:@"color"]) {
            t.fontColor = [UIColor fromHex:[_element attribute:@"color"]];
        }

        if([_element attribute:@"align"]) {
            NSString *align = [_element attribute:@"align"];
            if([align isEqualToString:@"right"]) {
                t.textAlignment = NSTextAlignmentRight;
            } else if([align isEqualToString:@"center"]) {
                t.textAlignment = NSTextAlignmentCenter;
            } else {
                t.textAlignment = NSTextAlignmentLeft;
            }
        }
    }];

    t.fontSize = [[[element child:@"font"] attribute:@"size"] intValue];

	return t;
}

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"textContent : %@\nfontColor: %@\nfontSize: %ld\nalign: %d",
            textContent, fontColor, (long)fontSize, (int)textAlignment];
}

@end
