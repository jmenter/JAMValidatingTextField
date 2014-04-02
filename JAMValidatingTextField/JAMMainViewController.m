
#import "JAMMainViewController.h"
#import "JAMValidatingTextField.h"

@interface JAMMainViewController () <JAMValidatingTextFieldValidationDelegate>
@property (weak, nonatomic) IBOutlet JAMValidatingTextField *emailTextField;
@property (weak, nonatomic) IBOutlet JAMValidatingTextField *charactersTextField;
@property (weak, nonatomic) IBOutlet JAMValidatingTextField *letterTextField;
@end

@implementation JAMMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSRegularExpression *emailRegex = [NSRegularExpression regularExpressionWithPattern:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}" options:NSRegularExpressionCaseInsensitive error:nil];
    self.emailTextField.validationRegularExpression = emailRegex;

    self.charactersTextField.validationBlock = ^{
        return (BOOL)(self.charactersTextField.text.length > 5);
    };
    self.letterTextField.validationDelegate = self;
}

- (BOOL)textFieldIsValid:(JAMValidatingTextField *)textField;
{
    return [textField.text rangeOfString:@"P"].location != NSNotFound;
}

@end
