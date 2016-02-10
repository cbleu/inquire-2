//
//  InformativeTextFormField.h
//  inquire
//
//  Created by Nicolas GARNAULT on 21/01/11.
//  Copyright 2011 Counterwinds. All rights reserved.
//

#import "FormFieldProtocol.h"

@interface InformativeTextFormField : NSObject<FormFieldProtocol> {
	NSString *title;
	NSString *text;
}

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *text;

@end
