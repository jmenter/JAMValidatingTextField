
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

- (void)setValidationDelegate:(id<JAMValidatingTextFieldValidationDelegate>)validationDelegate;
{
    _validationDelegate = validationDelegate;
    _validationBlock = nil;
}

- (void)setValidationBlock:(BOOL (^)(void))validationBlock;
{
    _validationBlock = validationBlock;
    _validationDelegate = nil;
}

- (void)validate;
{
    if (self.validationDelegate)
        self.valid = [self.validationDelegate textFieldIsValid:self];
     else if (self.validationBlock)
        self.valid = self.validationBlock();
}

- (CGRect)rightAlignedStatusViewRect;
{
    return CGRectMake(self.bounds.size.width - kStandardTextFieldHeight, 0, kStandardTextFieldHeight, kStandardTextFieldHeight);
}

- (CGRect)textRectForBounds:(CGRect)bounds;
{
    return [super textRectForBounds:UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, 6, 0, 24))];
}

- (CGRect)editingRectForBounds:(CGRect)bounds;
{
    return [super editingRectForBounds:UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, 6, 0, 24))];
}

- (void)layoutSubviews;
{
    [super layoutSubviews];
    self.validationStatusImageView.frame = self.rightAlignedStatusViewRect;
}

- (UIImage *)imageForValidStatus;
{
    [self beginImageContextAndPathStyle];
    CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), self.validColor.CGColor);

    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 6, 14);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 12, 24);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 24, 6);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    
    UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return returnImage;
}

- (UIImage *)imageForInValidStatus
{
    [self beginImageContextAndPathStyle];
    CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), self.inValidColor.CGColor);

    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 6, 6);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 24, 24);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 6, 24);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 24, 6);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    
    UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return returnImage;
}

- (void)beginImageContextAndPathStyle;
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(kStandardTextFieldHeight, kStandardTextFieldHeight), NO, 0);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), kIndicatorStrokeWidth);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineJoin(UIGraphicsGetCurrentContext(), kCGLineJoinRound);
}

@end
