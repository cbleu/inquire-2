//
//  UIColor+RGBComponents.h
//  inquire
//
//  Created by Nicolas GARNAULT on 08/01/11.
//  Copyright 2011 Counterwinds. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIColor  (Private)

@property (nonatomic, readonly) CGFloat red;
@property (nonatomic, readonly) CGFloat green;
@property (nonatomic, readonly) CGFloat blue;
@property (nonatomic, readonly) CGFloat alpha;

@end
