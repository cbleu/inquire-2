//
//  AdminLoadingView.h
//  inquire 2
//
//  Created by Nicolas GARNAULT on 26/07/12.
//  Copyright (c) 2012 Counterwinds. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdminLoadingView : UIView {
    IBOutlet UILabel *loadingLabel;
}

@property IBOutlet UILabel *loadingLabel;

+ (AdminLoadingView *)viewWithTitle:(NSString *)title;

@end
