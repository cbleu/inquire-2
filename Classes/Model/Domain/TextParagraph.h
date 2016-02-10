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
// begin cbleu fix
//    UITextAlignment textAlignment;
    NSTextAlignment textAlignment;
// end cbleu fix
}

@property (nonatomic, strong) NSString *textContent;
@property (nonatomic, assign) NSInteger fontSize;
@property (nonatomic, strong) UIColor *fontColor;
// begin cbleu fix
//@property (nonatomic, assign) UITextAlignment textAlignment;
@property (nonatomic, assign) NSTextAlignment textAlignment;
// end cbleu fix
@end
