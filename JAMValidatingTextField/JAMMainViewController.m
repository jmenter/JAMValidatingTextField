
#import "JAMMainViewController.h"
#import "JAMValidatingTextField.h"

@interface JAMMainViewController () <JAMValidatingTextFieldValidationDelegate>
@property (weak, nonatomic) IBOutlet JAMValidatingTextField *emailTextField;
@property (weak, nonatomic) IBOutlet JAMValidatingTextField *charactersTextField;
@property (weak, nonatomic) IBOutlet JAMValidatingTextField *letterTextField;
@property (weak, nonatomic) IBOutlet JAMValidatingTextField *zipTextField;
@end

@implementation JAMMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSRegularExpression *emailRegex = [NSRegularExpression regularExpressionWithPattern:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}" options:NSRegularExpressionCaseInsensitive error:nil];

    self.emailTextField.validationRegularExpression = emailRegex;
    self.charactersTextField.validationType = JAMValidatingTextFieldTypeURL;
    self.charactersTextField.required = YES;
    self.letterTextField.validationType = JAMValidatingTextFieldTypePhone;
    self.zipTextField.validationType = JAMValidatingTextFieldTypeZIP;
}

- (void)viewDidAppear:(BOOL)animated;
{
    [super viewDidAppear:animated];
}

- (JAMValidatingTextFieldStatus)textFieldStatus:(JAMValidatingTextField *)textField;
{
    if (textField.text.length == 0) {
        return JAMValidatingTextFieldStatusIndeterminate;
    }
    return [textField.text rangeOfString:@"P"].location != NSNotFound;
}

@end
