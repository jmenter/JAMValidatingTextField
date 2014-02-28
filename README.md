JAMValidatingTextField
======================

JAMValidatingTextField adds validation facilities to UITextField in iOS, solving the problem of how to visually indicate that a text field's contents are valid.

There are properties for setting the valid/invalid colors, status, validation block, and delegate. You can either set the isValid BOOL directly in your controller, assign a validation block (it gets fired at every text field change), or implement the validation delegate protocol. By default, an invalid text field has a red outline and red X, and a valid text field has a green outline and green checkmark.

Example of validating using a block:

    textField.validationBlock = ^{
        return (BOOL)(textField.text.length > 3);
    };

Example of validating using the delegate protocol:

    - (BOOL)textFieldIsValid:(JAMValidatingTextField *)textField
    {
        return (textField.text.length > 10);
    }
