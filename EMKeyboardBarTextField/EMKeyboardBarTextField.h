//  EMKeyboardBarTextField.h
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

/*

	The property autoLayoutAnimateOnKeyboardWillShow only has an effect if auto layout is used:
	
		When FALSE (default) the text field's constraints held by its superview are not removed until the keyboard animation is complete.
		Thus, the text field will remain in place, then pop into the toolbar at the end of the animation.
		
		When TRUE, the superview's constraints that act on the text field are removed prior to the animation, and the text field
		animates into place.  
		This results in jarring displacements of other elements on screen if their locations were constrained by the animating text field.
		This may or may not be bothersome, and if the newly unconstrained elements are behind the keyboard then is only visible for a fracton of a second.
	
		The above is only an issue when the keyboard will show.  When it will hide, the constraints are restored at the start of the animation, so everything
		is in place when the keyboard reveals the elements that were behind it.
		
	
	Note: in order to faciliate frame animation, EMKeyboardBarTextField will temporarily remove it's own layout constraints, and those of its superview that affect it.
		This means that if there are additional contraints, not owned by its immediate superview, EMKeyboardBarTextField may not work properly (will not render in the toolbar).

*/


#import <UIKit/UIKit.h>

@interface EMKeyboardBarTextField : UITextField {
	
}

@property (nonatomic, assign) BOOL	showPrompt;
@property (nonatomic, assign) BOOL	autoLayoutAnimateOnKeyboardWillShow;

@end
