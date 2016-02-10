//
//  Paragraph.h
//  inquire
//
//  Created by Nicolas GARNAULT on 17/03/11.
//  Copyright 2011 Counterwinds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLHandledProtocol.h"


@interface TextParagraph : NSObject<XMLHandledProtocol> {
    NSString *textContent;
    NSInteger fontSize;
    UIColor *fontColor;
    UITextAlignment textAlignment;
}

@property (nonatomic, strong) NSString *textContent;
@property (nonatomic, assign) NSInteger fontSize;
@property (nonatomic, strong) UIColor *fontColor;
@property (nonatomic, assign) UITextAlignment textAlignment;

@end
