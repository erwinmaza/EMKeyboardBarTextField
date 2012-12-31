//  EMKeyboardBarTextField.m
//  Created by erwin on 12/27/12.

/*
 
	Copyright (c) 2012 eMaza Mobile. All rights reserved.

	Permission is hereby granted, free of charge, to any person obtaining
	a copy of this software and associated documentation files (the
	"Software"), to deal in the Software without restriction, including
	without limitation the rights to use, copy, modify, merge, publish,
	distribute, sublicense, and/or sell copies of the Software, and to
	permit persons to whom the Software is furnished to do so, subject to
	the following conditions:

	The above copyright notice and this permission notice shall be
	included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
	MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
	NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
	LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
	OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
	WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

*/


#import "EMKeyboardBarTextField.h"

@interface EMKeyboardBarTextField ()

	@property (nonatomic, strong) UIToolbar *toolBar;
	@property (nonatomic, strong) UILabel	*promptLabel;
	@property (nonatomic, strong) NSArray	*originalConstraints;
	@property (nonatomic, strong) NSArray	*originalContainerConstraints;

	@property (nonatomic, weak)	  UIView	*fullView;
	@property (nonatomic, weak)	  UIView	*originalContainer;
	@property (nonatomic, assign) CGRect	originalFrame;
	@property (nonatomic, assign) int		originalIndex;

@end


@implementation EMKeyboardBarTextField {

}

#define fieldPadding	10
#define toolbarHeight	44

@synthesize showPrompt, autoLayoutAnimateOnKeyboardWillShow;

@synthesize toolBar, promptLabel, fullView;
@synthesize originalFrame, originalContainer, originalIndex, originalConstraints, originalContainerConstraints;

- (id)initWithCoder:(NSCoder *)aDecoder	{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self setup];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self setup];
	}
	return self;
}

- (void)setup {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)done {
    [self resignFirstResponder];
}

- (void)keyboardWillShow:(NSNotification *)notification {
	
	if (![self isFirstResponder]) return;
	
	NSDictionary *info = [notification userInfo];
	
	if (!fullView) {
		self.fullView = self.superview;
		
		while (![fullView.superview isKindOfClass:[UIWindow class]]) {
			self.fullView = fullView.superview;
		}
	}
	
	CGRect fieldFrame = self.frame;
	fieldFrame = [fullView convertRect:fieldFrame fromView:self.superview];
	int fieldBottom = fieldFrame.origin.y + fieldFrame.size.height;

	CGRect kbFrame = [[info valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	kbFrame = [fullView convertRect:kbFrame fromView:self.window];
	
	int kbTop = kbFrame.origin.y;
	int kbWidth = kbFrame.size.width;
	
	if (fieldBottom < kbTop) return;
	
	CGRect fullFrame = fullView.frame;
	
	if (!toolBar) {
	
		self.originalIndex = [self.superview.subviews indexOfObject:self];
		self.originalContainer = self.superview;
		self.originalConstraints = self.constraints;
		
		NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:0];
		for (NSLayoutConstraint *constraint in self.superview.constraints) {
			if (constraint.firstItem == self) [tmp addObject:constraint];
			if (constraint.secondItem == self) [tmp addObject:constraint];
		}
		
		self.originalContainerConstraints = [NSArray arrayWithArray:tmp];
		
		NSString *title = @"Return";
	
		switch (self.returnKeyType) {
			case UIReturnKeyGo:				{ title = @"Go";	break;}
			case UIReturnKeyGoogle:			{ title = @"Google";break;}
			case UIReturnKeyJoin:			{ title = @"Join";	break;}
			case UIReturnKeyNext:			{ title = @"Next";	break;}
			case UIReturnKeyRoute:			{ title = @"Route";	break;}
			case UIReturnKeySearch:			{ title = @"Search";break;}
			case UIReturnKeySend:			{ title = @"Send";	break;}
			case UIReturnKeyYahoo:			{ title = @"Yahoo";	break;}
			case UIReturnKeyDone:			{ title = @"Done";	break;}
			case UIReturnKeyEmergencyCall:	{ title = @"Call";	break;}
			default:
				break;
		}

		UIBarButtonItem *spacer =		[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:NULL action:NULL];
		UIBarButtonItem *doneButton =	[[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleBordered target:self action:@selector(done)];
		
		self.toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, fullFrame.size.height, kbWidth, toolbarHeight)];
		toolBar.barStyle = UIBarStyleBlack;
		toolBar.translucent = TRUE;
		toolBar.items = @[spacer, doneButton];
		toolBar.alpha = 0.0;
		
		if (showPrompt) {
			self.promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(fieldFrame.size.width + fieldPadding * 2, toolbarHeight/4, kbWidth/2, toolbarHeight/2)];
			promptLabel.backgroundColor = [UIColor clearColor];
			promptLabel.textColor = [UIColor whiteColor];
			promptLabel.font = [UIFont italicSystemFontOfSize:14];
			promptLabel.text = self.placeholder;
			promptLabel.alpha = 0.0;
			[toolBar addSubview:promptLabel];
		}
		
		[fullView addSubview:toolBar];
		
	}

	// Reset values in case device has rotated
	self.originalFrame = self.frame;
	toolBar.frame = CGRectMake(0, fullFrame.size.height, kbWidth, toolbarHeight);
	
	if ([originalConstraints count]) {
		[self removeConstraints:self.constraints];
		if (autoLayoutAnimateOnKeyboardWillShow) [originalContainer removeConstraints:originalContainerConstraints];
		
		int r = NSLayoutRelationEqual;
		int a = NSLayoutAttributeNotAnAttribute;
		NSLayoutConstraint *widthConstraint =	[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth  relatedBy:r toItem:nil attribute:a multiplier:1 constant:fieldFrame.size.width];
		NSLayoutConstraint *heightConstraint =	[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:r toItem:nil attribute:a multiplier:1 constant:fieldFrame.size.height];
		[self addConstraints:@[widthConstraint, heightConstraint]];
	}

	self.frame = fieldFrame;
	[fullView addSubview:self];

	CGRect toolFrame = toolBar.frame;
	toolFrame.origin.x = 0;
	
	fieldFrame.origin.x = fieldPadding;
	fieldFrame.origin.y = (toolFrame.size.height - fieldFrame.size.height) / 2;

	//	Temporarily set toolbar to final location, so fieldFrame conversion to newFrame is correct
	toolFrame.origin.y = kbTop - toolFrame.size.height;
	toolBar.frame = toolFrame;

	CGRect newFrame = [toolBar convertRect:fieldFrame toView:fullView];
	
	//	Set toolbar back to start location
	toolFrame.origin.y = fullFrame.size.height;
	toolBar.frame = toolFrame;

	toolFrame.origin.y = kbTop - toolFrame.size.height;
	
	[UIView animateWithDuration:[[info valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue] delay:0 options:[[info valueForKey:UIKeyboardAnimationCurveUserInfoKey] intValue] animations:^{
		self.frame = newFrame;
		toolBar.frame = toolFrame;
		toolBar.alpha = 1.0;
	} completion:^(BOOL finished){
		if (!autoLayoutAnimateOnKeyboardWillShow) [originalContainer removeConstraints:originalContainerConstraints];
		self.frame = fieldFrame;
		[toolBar addSubview:self];
		[UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationCurveEaseOut animations:^{
            promptLabel.alpha = 1.0;
		} completion:^(BOOL finished){	}];
	}];
}

- (void)keyboardWillHide:(NSNotification *)notification {
	
	if (![self isFirstResponder]) return;
	if (self.superview != toolBar) return;

	self.frame = [toolBar convertRect:self.frame toView:fullView];
	[fullView addSubview:self];

	CGRect toolBarFrame = toolBar.frame;
	toolBarFrame.origin.y = originalContainer.frame.size.height;

	if ([originalConstraints count]) {
		[originalContainer addConstraints:originalContainerConstraints];
	}

	NSDictionary *info = [notification userInfo];
	[UIView animateWithDuration:[[info valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue] delay:0 options:[[info valueForKey:UIKeyboardAnimationCurveUserInfoKey] intValue] animations:^{
		promptLabel.alpha = 0.0;
		self.frame = [fullView convertRect:originalFrame fromView:originalContainer];
		self.alpha = 1.0;
		toolBar.frame = toolBarFrame;
		toolBar.alpha = 0.0;
	} completion:^(BOOL finished){
		//  The order in which views are added to a superview and the addition of their contraints, matters
		self.frame = originalFrame;
		[originalContainer insertSubview:self atIndex:originalIndex];
		if ([originalConstraints count]) {
			[self removeConstraints:self.constraints];
			[self addConstraints:originalConstraints];
		}
	}];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
