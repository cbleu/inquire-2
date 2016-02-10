//
//  UserViewProtocol.h
//  inquire
//
//  Created by Nicolas GARNAULT on 04/02/11.
//  Copyright 2011 Counterwinds. All rights reserved.
//


@protocol FormFieldProtocol;

@protocol UserViewProtocol
- (NSArray *)values;
- (BOOL)isFieldFilled;
- (BOOL)canBeAnswered;

@property __weak id<FormFieldProtocol> formField;

@end
