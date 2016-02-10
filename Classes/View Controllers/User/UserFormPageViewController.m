    //
//  UserFormPageViewController.m
//  inquire
//
//  Created by Nicolas GARNAULT on 03/02/11.
//  Copyright 2011 Counterwinds. All rights reserved.
//

#import <BlocksKit/BlocksKit.h>
#import <BlocksKit/BlocksKit+UIKit.h>

#import "UserFormPageViewController.h"
#import "TextParagraph.h"
#import "FormPage.h"
#import "FormFieldProtocol.h"
#import "TextInputFormFieldUserView.h"
#import "SurveyConfiguration.h"
#import "TextInputFormField.h"
#import "KeyPadView.h"

#define WIDGET_MARGIN 20

@interface UserFormPageViewController(Private)
- (NSArray *)answeredValues;
- (void)reloadPage;
- (void)setupControlView;
- (void)resetIdleTimer;
- (void)dismissKeyboard;
- (void)redrawUI;
- (void)configureButton:(GradientButton *)button;
- (void)configureRedactionalTextView:(UITextView *)textView withTextParagraph:(TextParagraph *)paragraph;
- (void)displayAlertWithTitle:(NSString *)title message:(NSString *)message;
@end

@implementation UserFormPageViewController

@synthesize delegate;
@synthesize page;

- (void)dealloc {
    scrollView.tappableDelegate = nil;
    idleMeasureEnabled = NO;
    delegate = nil;
    [idleTimer invalidate];
    idleTimer = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        formFieldViews = [[NSMutableArray alloc] init];
        idleMeasureEnabled = YES;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    // 
    headerTextView1.hidden = YES;
    headerTextView2.hidden = YES;
    headerTextView3.hidden = YES;
    footerTextView1.hidden = YES;

    [self reloadPage];
}

- (void)viewWillAppear:(BOOL)animated {

    // Default values
    [userDetailsFormButton setTitle:[delegate configuration].optinButtonLabel forState:UIControlStateNormal];
    userDetailsFormButton.titleLabel.numberOfLines = 0;
    userDetailsFormButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    userDetailsFormButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    userDetailsFormButton.titleLabel.minimumScaleFactor = 0.5;

    // Measuring time between interactions
    idleMeasureEnabled = YES;
    [self resetIdleTimer];

    // begin cbleu fix
    [super viewWillAppear:animated];
    // end cbleu fix
}

- (void)viewWillDisappear:(BOOL)animated {
    idleMeasureEnabled = NO;
    [self resetIdleTimer];

    // begin cbleu fix
    [super viewWillDisappear:animated];
    // end cbleu fix
}

- (void)viewDidAppear {
    // begin cbleu fix
//	if(UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
//		[self willRotateToInterfaceOrientation:UIInterfaceOrientationLandscapeLeft duration:0];
//	} else {
//		[self willRotateToInterfaceOrientation:UIInterfaceOrientationPortrait duration:0];
//	}
    [[UIApplication sharedApplication] statusBarOrientation];
    // end cbleu fix
}

#pragma mark --
#pragma mark Rotation related
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self redrawUI];
}

// < IOS6
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return YES;
}

// IOS6
/*
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeRight;
}
 */

// begin cbleu fix

//- (NSUInteger)supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskAll;
//}
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 90000
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
    return UIInterfaceOrientationMaskAll;
}

// end cbleu fix

#pragma mark --
#pragma mark Slide Detection
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *t = (UITouch *)[touches anyObject];

    /* If the touch did end in the bottom zone */
    /* And if a similar move was already begun */
    if([t locationInView:scrollView].y > 0.8*scrollView.frame.size.height &&
       [t locationInView:scrollView].x > 0.6*scrollView.frame.size.width  &&
       (slideMovementStarted == YES)) {
        idleMeasureEnabled = NO;
        [self resetIdleTimer];
        [delegate formPageControllerDidAskUserExitToLogin:self];
        return;
    }

    slideMovementStarted = NO;
    [self resetIdleTimer];
    [self dismissKeyboard];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *t = [touches anyObject];

    /* If the touch did end in the bottom zone */
    if([t locationInView:scrollView].y > 0.8*scrollView.frame.size.height &&
       [t locationInView:scrollView].x < 0.4*scrollView.frame.size.width) {
        slideMovementStarted = YES;
    } else {
        slideMovementStarted = NO;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *t = [touches anyObject];
    
    /* If a slide movement was started on the bottom zone, but the current touch
     * is not in the zone anymore
     */
    if([t locationInView:scrollView].y < 0.8*scrollView.frame.size.height) {
        slideMovementStarted = NO;
    }
}

#pragma mark --
#pragma mark TappableScrollViewDelegate methods
- (void)tappableScrollViewDidTouched:(TappableScrollView *)scrollView {
    [self resetIdleTimer];
    [self dismissKeyboard];
}

#pragma mark --
#pragma mark Custom UI Methods
- (IBAction)prevPagePressed:(id)sender {
    NSAssert(false, @"Not implemented yet");
}

- (IBAction)nextPagePressed:(id)sender {
    [self tryPageValidation:NO];
}

- (IBAction)userDetailsFormPressed:(id)sender {
    [self tryPageValidation:YES];
}

#pragma mark --
#pragma mark Private methods
// Reloads the content of the page
- (void)reloadPage {

	// Unloading previous form field views
	for (UIView *v in formFieldViews) {
		[v removeFromSuperview];
	}
	[formFieldViews removeAllObjects];

	// Configuring the view
	backgroundImageView.image = [delegate configuration].backgroundImage;
	logoImageView.image = [delegate configuration].logoImage;

	// Putting fields
    NSMutableArray *fields = [NSMutableArray array];

    if(page.isOptin && [delegate configuration].logoImage) {
        [fields addObjectsFromArray:page.formFields];
    } else {
        [fields addObjectsFromArray:page.formFields];
    }

    for (id<FormFieldProtocol> formField in fields) {
        UIView *v = [formField userViewForConfiguration:[delegate configuration]];
        [formFieldViews addObject:v];
        [scrollView addSubview:v];

        for(UIView *v2 in v.subviews) {
            if([v2 isKindOfClass:[UITextField class]]) {
                ((UITextField *)v2).delegate = self;
            }
        }
    }

    [self redrawUI];
}

- (void)redrawUI {
    // Headers
    NSArray *headers = [NSArray arrayWithObjects:headerTextView1, headerTextView2, headerTextView3, nil];
    double headerOffsetY = headerTextView1.frame.origin.y;
    
    // Doing header stuff
    for (NSInteger i = 0 ; i < [[delegate configuration] numberOfHeaders] ; ++i) {
        // Configuring the header
        UITextView *textView = [headers objectAtIndex:i];
        [self configureRedactionalTextView:textView
                         withTextParagraph:[[delegate configuration].headers objectAtIndex:i]];

        // 
        if([textView.text length] > 0) {
            CGRect frame = textView.frame;
            frame.size.height = textView.contentSize.height;
            frame.origin.y = headerOffsetY;
            textView.frame = frame;
            headerOffsetY += frame.size.height;
            textView.hidden = NO;
        } else {
            textView.text = @"";
            textView.hidden = YES;
        }
    }
    
    // Footer
    footerTextView1.hidden = YES;
    if([delegate configuration].numberOfFooters > 0) {
        // 
        TextParagraph *paragraph = [[delegate configuration].footers objectAtIndex:0];
        
        // configuring
        [self configureRedactionalTextView:footerTextView1
                         withTextParagraph:paragraph];

        footerTextView1.hidden = [paragraph.textContent length] == 0 || ![delegate formPageControllerIsLastPage:self];

        CGRect frame = footerTextView1.frame;
        frame.size.height = MIN(controlView.frame.size.height, footerTextView1.contentSize.height);
        footerTextView1.frame = frame;
        footerTextView1.center = CGPointMake(controlView.frame.size.width/2, controlView.frame.size.height/2);
    }

    double yOffset = logoImageView.frame.size.height + logoImageView.frame.origin.y;
    yOffset = MAX(yOffset, headerOffsetY);
    for(UIView *v in formFieldViews) {
        CGRect r = v.frame;
        r.origin.y = yOffset;
        r.size.width = scrollView.frame.size.width;
        v.frame = r;
        yOffset += v.frame.size.height + WIDGET_MARGIN;
    }

	// Resize scrollView
	[scrollView setContentSize:CGSizeMake(self.view.frame.size.width, yOffset)];

	// Setting-up controlView
	[self setupControlView];
}

- (void)setupControlView {
    // Setting buttons appearance
    [self configureButton:nextPageButton];
    [self configureButton:prevPageButton];
    [self configureButton:userDetailsFormButton];
    
    // Setting (bottom) controlView background color
    controlView.backgroundColor = [UIColor clearColor];

    // If the next page is the last one or if we have an optin page
	if([delegate formPageControllerIsLastPage:self]) {
        // If we're not in optin mode, do propose it
        userDetailsFormButton.hidden = page.isOptin || [[delegate configuration].optinPages count] == 0;
		[nextPageButton setTitle:NSLocalizedString(@"Valider le formulaire", @"") forState:UIControlStateNormal];
	} 
    // Else
    else {
		[nextPageButton setTitle:NSLocalizedString(@"Page suivante", @"") forState:UIControlStateNormal];
        userDetailsFormButton.hidden = YES;
	}

    // No possibility to go back
    prevPageButton.hidden = YES;
}

- (void)displayAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertView *a = [[UIAlertView alloc] initWithTitle:title
                                                message:message
                                               delegate:nil
                                      cancelButtonTitle:NSLocalizedString(@"Valider", @"")
                                      otherButtonTitles:nil];
    [a show];
}

// Used to configure buttons
- (void)configureButton:(GradientButton *)button {
    /*
	[button useSimpleWithColor:[delegate configuration].backgroundGradientColorBottom
                 gradientColor:[delegate configuration].backgroundGradientColorTop];
	[button setTitleColor:[delegate configuration].textColor forState:UIControlStateNormal];
     */
    /*
    [button useSimpleWithColor:[UIColor whiteColor]];
    [button setTintColor:[UIColor blackColor]];
     */

    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

// Used to configure textView of headers and footers
- (void)configureRedactionalTextView:(UITextView *)textView withTextParagraph:(TextParagraph *)paragraph {
    textView.text = paragraph.textContent;
    textView.textAlignment = paragraph.textAlignment;
    textView.textColor = paragraph.fontColor;
    textView.font = [UIFont fontWithName:textView.font.fontName size:paragraph.fontSize];
}

// Return values for current page
- (NSArray *)answeredValues {
    NSMutableArray *returnedValues = [NSMutableArray array];
    for (id<UserViewProtocol>v in formFieldViews) {
        if([v canBeAnswered]) {
            [returnedValues addObjectsFromArray:[v values]];
        }
    }
    return returnedValues;
}

- (void)tryPageValidation:(BOOL)askForOptinPageInsteadOfNextPage {
    for (id<UserViewProtocol>field in formFieldViews) {
        if(!field.isFieldFilled && !field.formField.isOptional) {
            [self displayAlertWithTitle:NSLocalizedString(@"Des champs ne sont pas renseignés", @"")
                                message:nil];
            return;
        }
    }

    // Stop measuring elapsed time
    idleMeasureEnabled = NO;
    [self resetIdleTimer];

    // Ask for the next page
    if(askForOptinPageInsteadOfNextPage) {
        [delegate formPageController:self didAskSwitchingStage:UserMainControllerSurveyStageOptin];
        [delegate formPageControllerDidAskNextPage:self withValues:[self answeredValues] finalValidation:NO];
    } else if([delegate formPageControllerIsLastPage:self]) {
        [delegate formPageControllerDidAskNextPage:self withValues:[self answeredValues] finalValidation:YES];
    } else {
        [delegate formPageControllerDidAskNextPage:self withValues:[self answeredValues] finalValidation:NO];
    }

}

#pragma mark --
#pragma mark UIScrollViewDelegate methods
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self resetIdleTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self resetIdleTimer];
}

#pragma mark -
#pragma mark Handling idle timeout
- (void)resetIdleTimer {

    // Invalidating timer
    [idleTimer invalidate];
    idleTimer = nil;
    
    if (idleMeasureEnabled && [[delegate configuration].screensaverPictures count] > 0) {
        idleTimer = [NSTimer scheduledTimerWithTimeInterval:[delegate configuration].screensaverInactivityTrigger
                                                     target:self
                                                   selector:@selector(idleTimerExceeded)
                                                   userInfo:nil
                                                    repeats:NO];
    }
}

- (void)idleTimerExceeded {
    [idleTimer invalidate];
    idleTimer = nil;
    [delegate formPageControllerDidDetectIdleness:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // Dismiss the keyboard
    [textField resignFirstResponder];

    // If the next field is a textField, focus on it
    NSInteger index = [formFieldViews indexOfObject:textField.superview];
    if(index != NSNotFound && index + 1 < [formFieldViews count]) {
        if([[formFieldViews objectAtIndex:(index+1)] isKindOfClass:[TextInputFormFieldUserView class]]) {
            TextInputFormFieldUserView *view = ((TextInputFormFieldUserView *)[formFieldViews objectAtIndex:(index+1)]);
            [view.textField becomeFirstResponder];
        }
    }

    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    UIView *v = textField;
    while (v.superview && ![v isKindOfClass:[TextInputFormFieldUserView class]]) {
        v = v.superview;
    }
    
    if([v isKindOfClass:[TextInputFormFieldUserView class]]) {
        TextInputFormField *f = (TextInputFormField *)((TextInputFormFieldUserView *)v).formField;
        
        if(f.dataType == TextInputDataTypeDate) {
            
            NSString *previousText = textField.text;
            NSDateFormatter *formater = [[NSDateFormatter alloc] init];
			
// begin cbleu fix
// Format de la date en fonction de la langue du systeme
// => supprimer le format en dur
//            [formater setDateFormat:@"YYYY-MM-dd"];
			[formater setDateStyle: NSDateFormatterShortStyle];
// end cbleu fix
			
            UIDatePicker *datePicker = [[UIDatePicker alloc] init];
            datePicker.datePickerMode = UIDatePickerModeDate;
            [datePicker bk_addEventHandler:^(UIDatePicker *sender) {
                textField.text = [formater stringFromDate:datePicker.date];
            } forControlEvents:(UIControlEventValueChanged)];

            if(textField.text && [formater dateFromString:textField.text]) {
                datePicker.date = [formater dateFromString:textField.text];
            }

            textField.inputView = datePicker;
            
            UIToolbar * keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];

            UIBarButtonItem *extraSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

// begin cbleu fix
//            UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] bk_initWithTitle:@"Cancel"
//                style:UIBarButtonItemStyleBordered handler:
//                ^(id sender)
//                {
//                    textField.text = previousText;
//                    [textField resignFirstResponder];
//                }];


//			UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] bk_initWithTitle:@"Cancel"
//																				style:UIBarButtonItemStylePlain
//																			  handler:
//											 ^(id sender)
//											 {
//												 textField.text = previousText;
//												 [textField resignFirstResponder];
//											 }];
			UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] bk_initWithTitle:NSLocalizedString(@"toolbar.keyboard.cancel", nil)
																				style:UIBarButtonItemStylePlain
																			  handler:
											 ^(id sender)
											 {
												 textField.text = previousText;
												 [textField resignFirstResponder];
											 }];
			
//			UIBarButtonItem *validateButton = [[UIBarButtonItem alloc] bk_initWithTitle:@"Validate"
//																				  style:UIBarButtonItemStyleDone handler:
//											   ^(id sender)
//											   {
//												   [textField resignFirstResponder];
//												   [self textFieldShouldReturn:textField];
//											   }];
			UIBarButtonItem *validateButton = [[UIBarButtonItem alloc] bk_initWithTitle:NSLocalizedString(@"toolbar.keyboard.validate", nil)
																				  style:UIBarButtonItemStyleDone handler:
											   ^(id sender)
											   {
												   [textField resignFirstResponder];
												   [self textFieldShouldReturn:textField];
											   }];
			
// end cbleu fix
			
            [keyboardToolbar setItems:@[cancelButton, extraSpace, validateButton]];
            textField.inputAccessoryView = keyboardToolbar;

        } else if(f.dataType == TextInputDataTypeInteger) {
            NSString *previousText = textField.text;
            
            KeyPadView *v = [KeyPadView view];
            v.backspacePressed = ^{
                if(textField.text.length) {
                    textField.text = [textField.text substringToIndex:[textField.text length] - 1];
                }
            };
            v.numberPressed = ^(NSInteger number) {
                textField.text = [NSString stringWithFormat:@"%@%ld", textField.text, (long)number];
            };
            textField.inputView = v;

            UIToolbar * keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
            
            UIBarButtonItem *extraSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            
            // begin cbleu fix
//            UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] bk_initWithTitle:@"Cancel"
//                style:UIBarButtonItemStyleBordered handler:
//                ^(id sender)
//                {
//                    textField.text = previousText;
//                    [textField resignFirstResponder];
//                }];
			
//			UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] bk_initWithTitle:@"Cancel"
//																				style:UIBarButtonItemStylePlain
//																			  handler:
//											 ^(id sender)
//											 {
//												 textField.text = previousText;
//												 [textField resignFirstResponder];
//											 }];
			UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] bk_initWithTitle:NSLocalizedString(@"toolbar.keypad.cancel", nil)
																				style:UIBarButtonItemStylePlain
																			  handler:
											 ^(id sender)
											 {
												 textField.text = previousText;
												 [textField resignFirstResponder];
											 }];

//			UIBarButtonItem *validateButton = [[UIBarButtonItem alloc] bk_initWithTitle:@"Validate"
//																				  style:UIBarButtonItemStyleDone handler:
//											   ^(id sender)
//											   {
//												   [textField resignFirstResponder];
//												   [self textFieldShouldReturn:textField];
//											   }];
			UIBarButtonItem *validateButton = [[UIBarButtonItem alloc] bk_initWithTitle:NSLocalizedString(@"toolbar.keypad.validate", nil)
																				  style:UIBarButtonItemStyleDone handler:
											   ^(id sender)
											   {
												   [textField resignFirstResponder];
												   [self textFieldShouldReturn:textField];
											   }];
			
			// end cbleu fix
			

            //
            [keyboardToolbar setItems:@[cancelButton, extraSpace, validateButton]];
            textField.inputAccessoryView = keyboardToolbar;
        }
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    initialContentOffset = scrollView.contentOffset;

    [UIView animateWithDuration:0.25 delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState animations:^
    {
        scrollView.contentOffset = CGPointMake(0, textField.superview.frame.origin.y - 300);
    } completion:nil];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.25 delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState animations:^
     {
         scrollView.contentOffset = initialContentOffset;
     } completion:nil];
}

- (void)dismissKeyboard {
    for(UIView *v in formFieldViews) {
        for(UIView *v2 in v.subviews) {
            if([v2 isKindOfClass:[UITextField class]] && [v2 isFirstResponder]) {
                [v2 resignFirstResponder];
            }
        }
    }
}

- (UIResponder *)nextResponder {
    [self resetIdleTimer];
    return [super nextResponder];
}

@end
