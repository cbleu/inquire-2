//
//  NSString+ maxFontSizeThatFitsRect.h
//  inquire
//
//  Created by Nicolas GARNAULT on 08/03/11.
//  Copyright 2011 Counterwinds. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString(maxFontSizeThatFitsRect)

- (CGFloat)maxFontSizeThatFitsRect:(CGRect)rect withFont:(NSString *)fontName baseSize:(CGFloat)maxFontSize;

@end
