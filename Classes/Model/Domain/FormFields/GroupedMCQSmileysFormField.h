//
//  GroupedMQCSmileysFormField.h
//  inquire
//
//  Created by Nicolas GARNAULT on 14/01/11.
//  Copyright 2011 Counterwinds. All rights reserved.
//

#import "FormFieldProtocol.h"

@interface GroupedMCQSmileysFormField : NSObject<FormFieldProtocol> {
	NSString *groupTitle;
	NSMutableArray *groupAnswers;
	NSMutableArray *groupQuestions;
}

@property (nonatomic, strong) NSString *groupTitle;
@property (nonatomic, strong) NSMutableArray *groupQuestions;
@property (nonatomic, strong) NSMutableArray *groupAnswers;

@end
