//
//  TappableScrollView.h
//  inquire
//
//  Created by Nicolas GARNAULT on 08/04/11.
//  Copyright 2011 Counterwinds. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TappableScrollView;

@protocol TappableScrollViewDelegate <NSObject>
- (void)tappableScrollViewDidTouched:(TappableScrollView *)scrollView;
@end

@interface TappableScrollView : UIScrollView {
    id <TappableScrollViewDelegate> __weak tappableDelegate;
}

@property (nonatomic, weak) IBOutlet id <TappableScrollViewDelegate> tappableDelegate;

@end
