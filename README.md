JAMValidatingTextField
======================

JAMValidatingTextField adds validation facilities to UITextField in iOS.

There are properties for setting the valid/invalid status colors, status, validation block, and delegate. You can either set the valid BOOL in your controller, assign a validation block, or implement the validation delegate protocol. An invalid text field has a red outline and red X, a valid text field has a green outline and green checkmark.

Validation block example:

    textField.validationBlock = ^{
        return (BOOL)(textField.text.length > 3);
    };

Delegate protocol example:

- (BOOL)textFieldIsValid:(JAMValidatingTextField *)textField
{
    return (textField.text.length > 10);
}
