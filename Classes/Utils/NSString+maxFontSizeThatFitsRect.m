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
    CGSize stringSize = [self sizeWithFont:[UIFont fontWithName:fontName size:_fontSize] constrainedToSize:tallerSize];
	
    while (stringSize.height >= rect.size.height)
    {       
        _fontSize -= fontDelta;
        stringSize = [self sizeWithFont:[UIFont fontWithName:fontName size:_fontSize] constrainedToSize:tallerSize];
    }
	
    return _fontSize;
}
@end
