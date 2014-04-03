
#import "JAMMainViewController.h"
#import "JAMValidatingTextField.h"

@interface JAMMainViewController () <JAMValidatingTextFieldValidationDelegate>
@property (weak, nonatomic) IBOutlet JAMValidatingTextField *emailTextField;
@property (weak, nonatomic) IBOutlet JAMValidatingTextField *urlTextField;
@property (weak, nonatomic) IBOutlet JAMValidatingTextField *phoneTextField;
@property (weak, nonatomic) IBOutlet JAMValidatingTextField *zipTextField;
@property (weak, nonatomic) IBOutlet JAMValidatingTextField *blockTextField;
@property (weak, nonatomic) IBOutlet JAMValidatingTextField *delegateTextField;
@property (weak, nonatomic) IBOutlet JAMValidatingTextField *regexTextField;

@end

@implementation JAMMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.emailTextField.validationType = JAMValidatingTextFieldTypeEmail;
    self.urlTextField.validationType = JAMValidatingTextFieldTypeURL;
    self.phoneTextField.validationType = JAMValidatingTextFieldTypePhone;
    self.phoneTextField.required = YES;
    self.zipTextField.validationType = JAMValidatingTextFieldTypeZIP;
    self.zipTextField.required = YES;
    self.blockTextField.validationBlock = ^{
        if (self.blockTextField.text.length == 0) {
            return JAMValidatingTextFieldStatusIndeterminate;
        }
        if (self.blockTextField.text.length > 5) {
            return JAMValidatingTextFieldStatusValid;
        }
        return JAMValidatingTextFieldStatusInvalid;
    };
    self.delegateTextField.validationDelegate = self;
    self.regexTextField.validationRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[0-9]{5}" options:0 error:nil];
    self.regexTextField.required = YES;
}

- (JAMValidatingTextFieldStatus)textFieldStatus:(JAMValidatingTextField *)textField;
{
    if (textField.text.length == 0) {
        return JAMValidatingTextFieldStatusIndeterminate;
    }
    return [textField.text rangeOfString:@"P"].location != NSNotFound;
}

@end
