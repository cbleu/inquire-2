//
//  CSVHelper.m
//  inquire 2
//
//  Created by Nicolas Garnault on 25/07/12.
//  Copyright (c) 2012 Counterwinds. All rights reserved.
//

#import "CSVHelper.h"

@implementation CSVHelper

+ (NSString *)formattedValue:(NSString *)inValue {
    NSString *s = [inValue stringByReplacingOccurrencesOfString:@"\"" withString:@"\"\""];
    return [NSString stringWithFormat:@"\"%@\"", s];
}

@end
