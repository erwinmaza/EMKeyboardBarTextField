//  RootViewController.m
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


#import "RootViewController.h"
#import "EMKeyboardBarTextField.h"

@interface RootViewController ()


@end

@implementation RootViewController {
	
	
}

@synthesize field2, field4;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	LogMethod
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
	}
	return self;
}

- (void)viewDidLoad {
	LogMethod
	[super viewDidLoad];
	
	field2.showPrompt = field4.showPrompt = TRUE;
	field2.autoLayoutAnimateOnKeyboardWillShow = TRUE;
}

- (void)viewDidUnload {
	LogMethod
	[super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
	LogMethod
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	LogMethod
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	LogMethod
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	LogMethod
	[super viewDidDisappear:animated];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	LogMethod
	[textField resignFirstResponder];
	return TRUE;
}

@end
