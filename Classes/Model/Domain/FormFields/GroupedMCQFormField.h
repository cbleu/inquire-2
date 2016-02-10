//
//  GroupedMCQFormField.h
//  inquire
//
//  Created by Nicolas GARNAULT on 21/01/11.
//  Copyright 2011 Counterwinds. All rights reserved.
//

#import "FormFieldProtocol.h"

@interface GroupedMCQFormField : NSObject<FormFieldProtocol> {
    NSString *title;
	NSString *question;
	NSMutableArray *answers;
}

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *question;
@property (nonatomic, strong) NSMutableArray *answers;

@end
