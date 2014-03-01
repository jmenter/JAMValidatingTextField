JAMValidatingTextField
======================

JAMValidatingTextField adds validation facilities to UITextField in iOS, solving the problem of how to visually indicate that a text field's contents are valid.

There are properties for setting the valid/invalid colors, status, validation block, validation regular expression, and validation delegate. You can either set the isValid BOOL directly in your controller, assign a validation block, assign an NSRegularExpression, or implement the validation delegate protocol. The assigned validation check gets fired at every change to the text field. Setting one validation method will cancel out the other methods.

The visual feedback by default shows an invalid text field with a red outline and red X, and a valid text field with a green outline and green checkmark.

![example image](http://jeffmenter.files.wordpress.com/2014/02/ios-simulator-screen-shot-feb-28-2014-2-39-22-pm.png "JAMValidatingTextField Example Image")

Example of validating using a block:

    textField.validationBlock = ^{
        return (BOOL)(textField.text.length > 3);
    };

Example of validating using the delegate protocol:

    - (BOOL)textFieldIsValid:(JAMValidatingTextField *)textField
    {
        return (textField.text.length > 10);
    }

Example of validating using an NSRegularExpression:

    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    self.textField.validationRegularExpression = [NSRegularExpression regularExpressionWithPattern:emailRegEx options:NSRegularExpressionCaseInsensitive error:nil];
