//
//  NSString+URLEncoding.h
//  inquire 2
//
//  Created by Nicolas GARNAULT on 06/10/12.
//  Copyright (c) 2012 Counterwinds. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URLEncoding)
-(NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding;
@end
