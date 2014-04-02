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
@property (nonatomic) UIImageView *validationStatusImageView;
@end

@implementation JAMValidatingTextField

static const CGFloat kStandardTextFieldHeight = 30;
static const CGFloat kIndicatorStrokeWidth = 2;

- (id)initWithFrame:(CGRect)frame;
{
    if (!(self = [super initWithFrame:frame])) return nil;
    return [self initialize];
}

- (id)initWithCoder:(NSCoder *)aDecoder;
{
    if (!(self = [super initWithCoder:aDecoder])) return nil;
    return [self initialize];
}

- (instancetype)initialize;
{
    self.borderStyle = UITextBorderStyleNone;
    self.validationStatusImageView = [UIImageView.alloc initWithFrame:self.rightAlignedStatusViewRect];
    [self addSubview:self.validationStatusImageView];
    
    self.validColor = [UIColor colorWithHue:0.333 saturation:1 brightness:0.75 alpha:1];
    self.inValidColor = [UIColor colorWithHue:0 saturation:1 brightness:1 alpha:1];
    
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 5;
    
    [self addTarget:self action:@selector(validate) forControlEvents:UIControlEventAllEditingEvents];
    self.valid = NO;
    return self;
}

- (void)setValid:(BOOL)valid;
{
    _valid = valid;
    self.layer.borderColor = (_valid) ? self.validColor.CGColor : self.inValidColor.CGColor;
    self.validationStatusImageView.image = (_valid) ? self.imageForValidStatus : self.imageForInValidStatus;
}

- (void)validate;
{
    if (self.validationDelegate)
        self.valid = [self.validationDelegate textFieldIsValid:self];
    else if (self.validationBlock)
        self.valid = self.validationBlock();
    else if (self.validationRegularExpression)
        self.valid = (BOOL)[self.validationRegularExpression numberOfMatchesInString:self.text
                                                                             options:0
                                                                               range:NSMakeRange(0, self.text.length)];
}

- (void)setValidationDelegate:(id<JAMValidatingTextFieldValidationDelegate>)validationDelegate;
{
    [self clearAllValidationMethods];
    _validationDelegate = validationDelegate;
    [self validate];
}

- (void)setValidationBlock:(BOOL (^)(void))validationBlock;
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

- (void)clearAllValidationMethods;
{
    _validationRegularExpression = nil;
    _validationDelegate = nil;
    _validationBlock = nil;
}

- (CGRect)rightAlignedStatusViewRect;
{
    return CGRectMake(self.bounds.size.width - kStandardTextFieldHeight, 0,
                      kStandardTextFieldHeight, kStandardTextFieldHeight);
}

- (CGRect)textRectForBounds:(CGRect)bounds;
{
    return [super textRectForBounds:UIEdgeInsetsInsetRect(bounds, self.textRectInsets)];
}

- (CGRect)editingRectForBounds:(CGRect)bounds;
{
    return [super editingRectForBounds:UIEdgeInsetsInsetRect(bounds, self.textRectInsets)];
}

- (UIEdgeInsets)textRectInsets;
{
    return UIEdgeInsetsMake(0, 6, 0, 24);
}

- (void)layoutSubviews;
{
    [super layoutSubviews];
    self.validationStatusImageView.frame = self.rightAlignedStatusViewRect;
}

- (UIImage *)imageForValidStatus;
{
    CGContextRef context = [self beginImageContextAndSetPathStyle];

    CGContextMoveToPoint(context, 6, 14);
    CGContextAddLineToPoint(context, 12, 24);
    CGContextAddLineToPoint(context, 24, 6);
    CGContextStrokePath(context);
    
    UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return returnImage;
}

- (UIImage *)imageForInValidStatus
{
    CGContextRef context = [self beginImageContextAndSetPathStyle];

    CGContextMoveToPoint(context, 6, 6);
    CGContextAddLineToPoint(context, 24, 24);
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, 6, 24);
    CGContextAddLineToPoint(context, 24, 6);
    CGContextStrokePath(context);
    
    UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return returnImage;
}

- (CGContextRef)beginImageContextAndSetPathStyle;
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(kStandardTextFieldHeight, kStandardTextFieldHeight), NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, kIndicatorStrokeWidth);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetStrokeColorWithColor(context, (self.isValid) ? self.validColor.CGColor : self.inValidColor.CGColor);
    return context;
}

@end
