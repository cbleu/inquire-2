//
//  UITableViewCell+accessoryImage.h
//  inquire
//
//  Created by Nicolas GARNAULT on 14/01/11.
//  Copyright 2011 Counterwinds. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UITableViewCell (Private)

- (void)buttonPressed:(id)sender;
- (void)setAccessoryImage:(UIImage *)image;
- (void)setAccessoryImage:(UIImage *)image size:(CGSize)size;

@end
