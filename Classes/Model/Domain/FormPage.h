//
//  FormPage.h
//  inquire
//
//  Created by Nicolas GARNAULT on 13/01/11.
//  Copyright 2011 Counterwinds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLHandledProtocol.h"

@interface FormPage : NSObject<XMLHandledProtocol>

@property BOOL isOptin;
@property NSMutableArray *formFields;

@end
