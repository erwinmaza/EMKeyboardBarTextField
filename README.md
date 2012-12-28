# EMKeyboardBarTextField

A self-contained alternative to sliding the entire view to keep a text field in view: move just the text field

When the iOS keyboard is about to slide up and cover the input field it is for, Apple recommends you slide the appropriate container view up to keep the element visible.

Most often that is the best experience for the user, as it keeps the context of what they are inputting in view.  The practice of registering the view controller for keyboard event notifications and the mechanisms for smoothly keeping the field in view are well established, and are standard iOS developer techniques.

However, sometimes it is just as well to leave the view alone and keep just the text field visible. Maybe additional context is not helpful, or other screen elements (near the top of the screen) are more important.  Maybe you just want to deliver a different experience to your users.

The EMKeyboardBarTextField was built for these cases.  A subclass of UITextField, this control will listen for keyboard events, and when appropriate, will create a toolbar above the keyboard and place itself within it, with smooth animations to match the keyboard's show and hide events.

If all text inputs in the view are EMKeyboardBarTextFields, the view controller no longer needs to observe keyboard events. EMKeyboardBarTextField is fully self-contained.

The EMKeyboardBarTextField subclass code concerns itself only with the placement of the text field and related functions.

	* It does not interfere with the UITextField's delegate or other properties. 
	* It also does not guarantee a proper rendering under all circumstances. 
		It is up to you to set reasonable sizes and options.

The EMKeyboardBarTextField dismiss button title matches the UITextField's keyboard type.

Device rotation is supported, as well as auto layout. EMKeyboardBarTextField will work whether it has NSLayoutConstraints or not (mostly - see below). 

A sample app is included. While this is a universal build, EMKeyboardBarTextField has not been fully tested on the iPad. In particular, its behavior if loaded into a popover is unknown. Also, there is no support for split keyboards.

## Installation:

1 Copy the 2 files in the EMKeyboardBarTextField folder and add them to your project:

	* EMKeyboardBarTextField.h
	* EMKeyboardBarTextField.m
	
2 Import the class header file as appropriate:

	* #import "EMKeyboardBarTextField.h"

3 Optionally set the EMKeyboardBarTextField's *showPrompt* or *autoLayoutAnimateOnKeyboardWillShow* properties. 

	* showPrompt is self explanatory. 
	* autoLayoutAnimateOnKeyboardWillShow is discussed below.

## Sample App

You'll need to download this entire repo for the sample app to work, as the EMKeyboardBarTextField.xcodeproj references both the EMKeyboardBarTextField and Sample App top level folders.

Some screenshots:

![EMKeyboardBarTextField Table Sections](EMKeyboardBarTextField/wiki/images/keyboardTextfield1.png)
 
![EMKeyboardBarTextField Table Sections](EMKeyboardBarTextField/wiki/images/keyboardTextfield2.png)
 
![EMKeyboardBarTextField Table Sections](EMKeyboardBarTextField/wiki/images/keyboardTextfield3.png)

Feel free to toggle the "use auto layout" setting on the nib files.

## Auto Layout

As a generic control, EMKeyboardBarTextField cannot be written to animate its own constraints or those of its superview, as the type and number of these is unknown at design time. Thus the only way to animate its location is to temporarily remove those constraints. This can have undesired consequences (see note below).

It is recommended, if using auto layout, to not constrain any other screen elements to any EMKeyboardBarTextField, and then to set autoLayoutAnimateOnKeyboardWillShow to TRUE for each EMKeyboardBarTextField.

The following is noted in EMKeyboardBarTextField.h:

	The property autoLayoutAnimateOnKeyboardWillShow only has an effect if auto layout is used:

	When FALSE (default) the text field's constraints held by its superview are not removed until the keyboard animation 
	is complete. Thus, the text field will remain in place, then pop into the toolbar at the end of the animation.
	
	When TRUE, the superview's constraints that act on the text field are removed prior to the animation, and the text 
	field animates into place.
		* This results in jarring displacements of other elements on screen if their locations were constrained by the 
		animating text field.
		* This may or may not be bothersome, and if the newly unconstrained elements are behind the keyboard then is only 
		visible for a fracton of a second.

	The above is only an issue when the keyboard will show.  When it will hide, the constraints are restored at the start 
	of the animation, so everything is in place when the keyboard reveals the elements that were behind it.
	
	Note: in order to faciliate frame animation, EMKeyboardBarTextField will temporarily remove it's own layout constraints, 
	and those of its superview that affect it.
		* This means that if there are additional contraints, not owned by its immediate superview, EMKeyboardBarTextField 
		may not work properly (may not render in the toolbar).
	
## TODO

1. Full iPad support.

2. Localization of the dismiss button titles.

## License

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

