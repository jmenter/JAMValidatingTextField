JAMValidatingTextField
======================

JAMValidatingTextField adds validation facilities to UITextField in iOS, solving the problem of how to visually indicate that a text field's contents are valid.

It extends the basic UITextField to have three different validation states; valid, invalid, and indeterminate. Validation is applied by either setting a built-in validation type (email, URL, phone, or zip code) or by assigning a validation block, an NSRegularExpression, or good old delegate.

The visual feedback by default shows an indeterminate text field with a gray outline and gray dash. An invalid text field has a red outline and red X, and a valid text field has a green outline and green checkmark. Empty text fields are considered "indeterminate" unless you set isRequired to YES.

![example image](https://raw.githubusercontent.com/jmenter/JAMValidatingTextField/master/example.png "JAMValidatingTextField Example Image")

Example of setting validation to a built-in type:

    self.emailTextField.validationType = JAMValidatingTextFieldTypeEmail;

Example of validating using a block:

    self.blockTextField.validationBlock = ^{
        if (self.blockTextField.text.length == 0) {
            return JAMValidatingTextFieldStatusIndeterminate;
        }
        if (self.blockTextField.text.length > 5) {
            return JAMValidatingTextFieldStatusValid;
        }
        return JAMValidatingTextFieldStatusInvalid;
    };

Example of validating using the delegate protocol:

    - (JAMValidatingTextFieldStatus)textFieldStatus:(JAMValidatingTextField *)textField;
    {
        if (textField.text.length == 0) {
            return JAMValidatingTextFieldStatusIndeterminate;
        }
        return [textField.text rangeOfString:@"P"].location != NSNotFound;
    }

Example of validating using an NSRegularExpression:

    self.regexTextField.validationRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[0-9]{5}" options:0 error:nil];
    self.regexTextField.required = YES;
