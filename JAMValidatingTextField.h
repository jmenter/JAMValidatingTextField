
 /* The MIT License (MIT)
 
 Copyright (c) 2014 Jeff Menter
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of
 this software and associated documentation files (the "Software"), to deal in
 the Software without restriction, including without limitation the rights to
 use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 the Software, and to permit persons to whom the Software is furnished to do so,
 subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import <UIKit/UIKit.h>

@class JAMValidatingTextField;

@protocol JAMValidatingTextFieldValidationDelegate <NSObject>
@optional
-(BOOL)textFieldIsValid:(JAMValidatingTextField *)textField;
@end

@interface JAMValidatingTextField : UITextField

@property (nonatomic, weak) id <JAMValidatingTextFieldValidationDelegate> validationDelegate;

// TextField Properties
@property (nonatomic, getter = isValid) BOOL valid;
@property (nonatomic) UIColor *validColor;
@property (nonatomic) UIColor *inValidColor;

// Validation properties. These are mutually exclusive.
@property (nonatomic, copy) BOOL (^validationBlock)(void);
@property (nonatomic) NSRegularExpression *validationRegularExpression;

@end
