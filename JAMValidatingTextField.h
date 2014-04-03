
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

/** TextField status modes. */
typedef NS_ENUM(NSInteger, JAMValidatingTextFieldStatus) {
    JAMValidatingTextFieldStatusIndeterminate = -1,
    JAMValidatingTextFieldStatusInvalid,
    JAMValidatingTextFieldStatusValid
};

/** TextField types. */
typedef NS_ENUM(NSUInteger, JAMValidatingTextFieldType) {
    JAMValidatingTextFieldTypeNone,
    JAMValidatingTextFieldTypeEmail,
    JAMValidatingTextFieldTypeURL,
    JAMValidatingTextFieldTypePhone,
    JAMValidatingTextFieldTypeZIP
};

/** One of the validation options. */
@protocol JAMValidatingTextFieldValidationDelegate <NSObject>
@optional
-(JAMValidatingTextFieldStatus)textFieldStatus:(JAMValidatingTextField *)textField;
@end

/** JAMValidatingTextField is a class that extends UITextField and adds validation facilities including validation types and visual feedback.
 
 You can either set a type (email, URL, phone, zip, etc.) or set a property to validate via block, NSRegularExpression, or delegate.
 
 The text field will provide visual feedback indicating wheter it's in a valid, invalid, or indeterminate state.
 */
@interface JAMValidatingTextField : UITextField

/** Use this to get the validation status of your text field. */
@property (nonatomic, readonly) JAMValidatingTextFieldStatus validationStatus;

/** Use this property to quickly set a validation type for your text field. */
@property (nonatomic) JAMValidatingTextFieldType validationType;

/** Setting isRequired to YES will cause the textfield to appear invalid when it is empty. */
@property (nonatomic, getter = isRequired) BOOL required;

/** The color of the indeterminate indicator, default is 75% white. */
@property (nonatomic) UIColor *indeterminateColor;
/** The color of the invalid indicator, default is red. */
@property (nonatomic) UIColor *invalidColor;
/** The color of the invalid indicator, default is green. */
@property (nonatomic) UIColor *validColor;

/** @warning Validation methods (block, Regex, or delegate) and types are all mutally exclusive, that is, setting any one will clear out all the others. */
/** Sets the validation mechanism to be a block.
 @param validationBlock the block to use to validate the text field.
 */
@property (nonatomic, copy) JAMValidatingTextFieldStatus (^validationBlock)(void);

/** Sets the validation mechanism to be an NSRegularExpression. One or more matches will indicate a valid condition.
 @param validationRegularExpression the regular expression to use.
 */
@property (nonatomic) NSRegularExpression *validationRegularExpression;

/** Sets the validation mechanism to be a JAMValidatingTextFieldValidationDelegate. */
@property (nonatomic, weak) id <JAMValidatingTextFieldValidationDelegate> validationDelegate;

@end
