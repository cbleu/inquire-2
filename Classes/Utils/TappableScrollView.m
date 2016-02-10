//
//  TappableScrollView.m
//  inquire
//
//  Created by Nicolas GARNAULT on 08/04/11.
//  Copyright 2011 Counterwinds. All rights reserved.
//

#import "TappableScrollView.h"


@implementation TappableScrollView

@synthesize tappableDelegate;

- (id)initWithFrame:(CGRect)frame {
    return [super initWithFrame:frame];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.dragging) 
        [self.nextResponder touchesEnded:touches withEvent:event]; 
    else
        [super touchesEnded:touches withEvent:event];
    
    [tappableDelegate tappableScrollViewDidTouched:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.dragging) 
        [self.nextResponder touchesMoved:touches withEvent:event]; 
    else
        [super touchesMoved:touches withEvent:event];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.dragging) 
        [self.nextResponder touchesBegan:touches withEvent:event]; 
    else
        [super touchesBegan:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.dragging) 
        [self.nextResponder touchesCancelled:touches withEvent:event]; 
    else
        [super touchesCancelled:touches withEvent:event];
}

- (void)dealloc {
    tappableDelegate = nil;
}
@end
