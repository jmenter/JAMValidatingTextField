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

#import "JAMValidatingTextField.h"

@interface JAMValidatingTextField ()
@property (nonatomic, readwrite) JAMValidatingTextFieldStatus validationStatus;
@end

@implementation JAMValidatingTextField

static const CGFloat kStandardTextFieldHeight = 30;
static const CGFloat kIndicatorStrokeWidth = 2;
static const CGFloat kTextEdgeInset = 6;

#pragma mark - Initialization
- (instancetype)initWithFrame:(CGRect)frame;
{
    if (!(self = [super initWithFrame:frame])) return nil;
    return [self initialize];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder;
{
    if (!(self = [super initWithCoder:aDecoder])) return nil;
    return [self initialize];
}

- (instancetype)initialize;
{
    self.borderStyle = UITextBorderStyleNone;
    
    self.validColor = [UIColor colorWithHue:0.333 saturation:1 brightness:0.75 alpha:1];
    self.invalidColor = [UIColor colorWithHue:0 saturation:1 brightness:1 alpha:1];
    self.indeterminateColor = [UIColor colorWithWhite:0.75 alpha:1.0];
    
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 5;
    
    [self addTarget:self action:@selector(validate) forControlEvents:UIControlEventAllEditingEvents];
    
    self.validationStatus = JAMValidatingTextFieldStatusIndeterminate;
    return self;
}

#pragma mark - Setters
- (void)setRequired:(BOOL)required
{
    _required = required;
    [self validate];
}

- (void)setValidationStatus:(JAMValidatingTextFieldStatus)status;
{
    _validationStatus = status;
    switch (status) {
        case JAMValidatingTextFieldStatusIndeterminate:
            self.layer.borderColor = self.indeterminateColor.CGColor;
            self.rightView = self.imageViewForIndeterminateStatus;
            break;
        case JAMValidatingTextFieldStatusInvalid:
            self.layer.borderColor = self.invalidColor.CGColor;
            self.rightView = self.imageViewForInvalidStatus;
            break;
        case JAMValidatingTextFieldStatusValid:
            self.layer.borderColor = self.validColor.CGColor;
            self.rightView = self.imageViewForValidStatus;
            break;
    }
    self.rightViewMode = UITextFieldViewModeAlways;
}

- (void)setValidationType:(JAMValidatingTextFieldType)validationType;
{
    _validationType = validationType;
    switch (validationType) {
        case JAMValidatingTextFieldTypeEmail:
            [self applyEmailValidation];
            break;
        case JAMValidatingTextFieldTypeURL:
            [self applyURLValidation];
            break;
        case JAMValidatingTextFieldTypePhone:
            [self applyPhoneValidation];
            break;
        case JAMValidatingTextFieldTypeZIP:
            [self applyZIPValidation];
            break;
        default:
            [self clearAllValidationMethods];
            break;
    }
}

- (void)setValidationDelegate:(id<JAMValidatingTextFieldValidationDelegate>)validationDelegate;
{
    [self clearAllValidationMethods];
    _validationDelegate = validationDelegate;
    [self validate];
}

- (void)setValidationBlock:(JAMValidatingTextFieldStatus (^)(void))validationBlock;
{
    [self clearAllValidationMethods];
    _validationBlock = validationBlock;
    [self validate];
}

- (void)setValidationRegularExpression:(NSRegularExpression *)validationRegularExpression;
{
    [self clearAllValidationMethods];
    _validationRegularExpression = validationRegularExpression;
    [self validate];
}

#pragma mark - Setting built-in validation types
- (void)applyEmailValidation;
{
    [self clearAllValidationMethods];
    __weak JAMValidatingTextField *weakSelf = self;
    self.validationBlock = ^{
        if (weakSelf.text.length == 0 && !weakSelf.isRequired) {
            return JAMValidatingTextFieldStatusIndeterminate;
        }
        NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:NULL];
        NSArray *matches = [detector matchesInString:weakSelf.text options:0 range:NSMakeRange(0, weakSelf.text.length)];
        for (NSTextCheckingResult *match in matches) {
            if (match.resultType == NSTextCheckingTypeLink &&
                [match.URL.absoluteString rangeOfString:@"mailto:"].location != NSNotFound) {
                return JAMValidatingTextFieldStatusValid;
            }
        }
        return JAMValidatingTextFieldStatusInvalid;
    };
    [self validate];
}

- (void)applyURLValidation;
{
    [self clearAllValidationMethods];
    __weak JAMValidatingTextField *weakSelf = self;
    self.validationBlock = ^{
        if (weakSelf.text.length == 0 && !weakSelf.isRequired) {
            return JAMValidatingTextFieldStatusIndeterminate;
        }
        NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:NULL];
        NSArray *matches = [detector matchesInString:weakSelf.text options:0 range:NSMakeRange(0, weakSelf.text.length)];
        return (NSInteger)matches.count;
    };
    [self validate];
}

- (void)applyPhoneValidation;
{
    [self clearAllValidationMethods];
    __weak JAMValidatingTextField *weakSelf = self;
    self.validationBlock = ^{
        if (weakSelf.text.length == 0 && !weakSelf.isRequired) {
            return JAMValidatingTextFieldStatusIndeterminate;
        }
        NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypePhoneNumber error:NULL];
        NSArray *matches = [detector matchesInString:weakSelf.text options:0 range:NSMakeRange(0, weakSelf.text.length)];
        return (NSInteger)matches.count;
    };
    [self validate];
}

- (void)applyZIPValidation;
{
    [self clearAllValidationMethods];
    __weak JAMValidatingTextField *weakSelf = self;
    self.validationBlock = ^{
        if (weakSelf.text.length == 0 && !weakSelf.isRequired) {
            return JAMValidatingTextFieldStatusIndeterminate;
        }
        NSString *justNumbers = [[weakSelf.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
        if (justNumbers.length == 5 || justNumbers.length == 9) {
            return JAMValidatingTextFieldStatusValid;
        }
        return JAMValidatingTextFieldStatusInvalid;
    };
    [self validate];
}

- (void)clearAllValidationMethods;
{
    _validationRegularExpression = nil;
    _validationDelegate = nil;
    _validationBlock = nil;
    _validationType = JAMValidatingTextFieldTypeNone;
}

#pragma mark - Validation
- (void)validate;
{
    if (self.validationDelegate) {
        self.validationStatus = [self.validationDelegate textFieldStatus:self];
    } else if (self.validationBlock) {
        self.validationStatus = self.validationBlock();
    } else if (self.validationRegularExpression) {
        [self validateWithRegularExpression];
    }
}

- (void)validateWithRegularExpression
{
    if (self.text.length == 0 && !self.isRequired) {
        self.validationStatus = JAMValidatingTextFieldStatusIndeterminate;
    } else if ([self.validationRegularExpression numberOfMatchesInString:self.text options:0 range:NSMakeRange(0, self.text.length)]) {
        self.validationStatus = JAMValidatingTextFieldStatusValid;
    } else {
        self.validationStatus = JAMValidatingTextFieldStatusInvalid;
    }
}

#pragma mark - Indicator Image Generation

/** This shape is a dash */
- (UIImageView *)imageViewForIndeterminateStatus;
{
    CGContextRef context = [self beginImageContextAndSetPathStyle];

    CGContextMoveToPoint(context, 6, kStandardTextFieldHeight / 2.f);
    CGContextAddLineToPoint(context, 24, kStandardTextFieldHeight / 2.f);
    CGContextStrokePath(context);
    
    return [self finalizeImageContextAndReturnImageView];
}

/** This shape is an X */
- (UIImageView *)imageViewForInvalidStatus
{
    CGContextRef context = [self beginImageContextAndSetPathStyle];

    CGContextMoveToPoint(context, 6, 6);
    CGContextAddLineToPoint(context, 24, 24);
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, 6, 24);
    CGContextAddLineToPoint(context, 24, 6);
    CGContextStrokePath(context);
    
    return [self finalizeImageContextAndReturnImageView];
}

/** This shape is a check mark */
- (UIImageView *)imageViewForValidStatus;
{
    CGContextRef context = [self beginImageContextAndSetPathStyle];

    CGContextMoveToPoint(context, 6, 14);
    CGContextAddLineToPoint(context, 12, 24);
    CGContextAddLineToPoint(context, 24, 6);
    CGContextStrokePath(context);
    
    return [self finalizeImageContextAndReturnImageView];
}

- (CGContextRef)beginImageContextAndSetPathStyle;
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(kStandardTextFieldHeight, kStandardTextFieldHeight), NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, kIndicatorStrokeWidth);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    
    CGColorRef strokeColor = self.indeterminateColor.CGColor;
    if (self.validationStatus == JAMValidatingTextFieldStatusInvalid) strokeColor = self.invalidColor.CGColor;
    if (self.validationStatus == JAMValidatingTextFieldStatusValid) strokeColor = self.validColor.CGColor;
    
    CGContextSetStrokeColorWithColor(context, strokeColor);
    return context;
}

- (UIImageView *)finalizeImageContextAndReturnImageView;
{
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [UIImageView.alloc initWithImage:image];
}

#pragma mark - Custom UITextField rect sizing
- (CGRect)textRectForBounds:(CGRect)bounds;
{
    return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, kTextEdgeInset,
                                                          0, kStandardTextFieldHeight - kTextEdgeInset));
}

- (CGRect)editingRectForBounds:(CGRect)bounds;
{
    return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, kTextEdgeInset,
                                                          0, kStandardTextFieldHeight - kTextEdgeInset));
}


@end
