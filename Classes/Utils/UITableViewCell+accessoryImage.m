//
//  UITableViewCell+accessoryImage.m
//  inquire
//
//  Created by Nicolas GARNAULT on 14/01/11.
//  Copyright 2011 Counterwinds. All rights reserved.
//

#import "UITableViewCell+accessoryImage.h"


@implementation UITableViewCell (Private)

- (void)buttonPressed:(id)sender {
	UITableView *t = (UITableView *)[self superview];
	NSIndexPath *i = [t indexPathForCell:self];
	[t.delegate tableView:t didDeselectRowAtIndexPath:i];
}

- (void)setAccessoryImage:(UIImage *)image {
	[self setAccessoryImage:image size:image.size];
}

- (void)setAccessoryImage:(UIImage *)image size:(CGSize)size {
	UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];	
	[b setBackgroundImage:image forState:UIControlStateNormal];
	[b setBackgroundImage:image forState:UIControlStateHighlighted];
	[b addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchDown];
	b.tag = 999;
	b.userInteractionEnabled = NO;
	[self.accessoryView addSubview:b];
}

@end
