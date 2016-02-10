//
//  NSString+ maxFontSizeThatFitsForString.m
//  inquire
//
//  Created by Nicolas GARNAULT on 08/03/11.
//  Copyright 2011 Counterwinds. All rights reserved.
//

#import "NSString+maxFontSizeThatFitsRect.h"


@implementation NSString(maxFontSizeThatFitsRect)


- (CGFloat)maxFontSizeThatFitsRect:(CGRect)rect withFont:(NSString *)fontName baseSize:(CGFloat)maxFontSize {   
	
    // this is the maximum size font that will fit on the device
    float _fontSize = maxFontSize;
    float widthTweak;
	
    // how much to change the font each iteration. smaller
    // numbers will come closer to an exact match at the 
    // expense of increasing the number of iterations.
    float fontDelta = 2.0;

	widthTweak = 0.2;

    CGSize tallerSize = CGSizeMake(rect.size.width-(rect.size.width*widthTweak), 100000);
    // begin cbleu fix
//    CGSize stringSize = [self sizeWithFont:[UIFont fontWithName:fontName size:_fontSize] constrainedToSize:tallerSize];

//    CGSize stringSize = [self sizeWithAttributes: @{NSFontAttributeName:[UIFont fontWithName:fontName size:_fontSize]}];
//    CGSize adjustedSize = CGSizeMake(ceilf(stringSize.width), ceilf(stringSize.height));
    
    // Let's make an NSAttributedString first
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: self];
    //Add LineBreakMode
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
    [attributedString setAttributes:@{NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, attributedString.length)];
    // Add Font
    [attributedString setAttributes:@{NSFontAttributeName:[UIFont fontWithName:fontName size:_fontSize]} range:NSMakeRange(0, attributedString.length)];
    //Now let's make the Bounding Rect
    CGSize stringSize = [attributedString boundingRectWithSize:tallerSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;

    while (stringSize.height >= rect.size.height)
    {       
        _fontSize -= fontDelta;
//        stringSize = [self sizeWithFont:[UIFont fontWithName:fontName size:_fontSize] constrainedToSize:tallerSize];
        [attributedString setAttributes:@{NSFontAttributeName:[UIFont fontWithName:fontName size:_fontSize]} range:NSMakeRange(0, attributedString.length)];
        stringSize = [attributedString boundingRectWithSize:tallerSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    }

    // end cbleu fix
    
    return _fontSize;
}
@end
