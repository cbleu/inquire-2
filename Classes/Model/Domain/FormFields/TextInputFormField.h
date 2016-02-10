//
//  TextInputFormField.h
//  inquire
//
//  Created by Nicolas GARNAULT on 13/01/11.
//  Copyright 2011 Counterwinds. All rights reserved.
//

#import "FormFieldProtocol.h"

typedef enum {
    TextInputDataTypeText,
    TextInputDataTypeDate,
    TextInputDataTypeInteger,
    TextInputDataTypeEmailAddress,
} TextInputDataType;

@interface TextInputFormField : NSObject<FormFieldProtocol> {
	NSString *questionTitle;
}

@property NSString *questionTitle;
@property TextInputDataType dataType;

@end
