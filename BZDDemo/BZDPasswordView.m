//
//  BZDPasswordView.m
//  BZDDemo
//
//  Created by 李志刚 on 2021/3/18.
//

#import "BZDPasswordView.h"
#import <objc/runtime.h>


#define WIDTH6                  375.0



#define XX_6(value)             (1.0 * (value) * SCREEN_WIDTH / WIDTH6)
#define PasswordBoxWidth XX_6(70)
#define PasswordBoxSpace XX_6(8)
#define PasswordBoxMargin XX_6(16)
#define PasswordBoxNumber 6

@interface BZDPasswordView ()<UITextFieldDelegate>
{
    int viewWight;
}

@property (nonatomic, strong) NSMutableArray <UILabel*> *labelBoxArray;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) NSString *currentText;

@property (nonatomic, assign) BOOL enabled;

@end
@implementation BZDPasswordView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        viewWight = frame.size.width;
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, viewWight, XX_6(60));
        [self addSubview:self.textField];
        [self.textField becomeFirstResponder];
        [self initData];
    }
    return self;
}


- (void)initData
{
    self.currentText = @"";
    self.asterisk = @"*";
    for (int i = 0; i < PasswordBoxNumber; i ++)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(PasswordBoxMargin + i *((viewWight-64)/6 + PasswordBoxSpace), 0, (viewWight-64)/6, PasswordBoxWidth)];
        label.textColor = [UIColor blackColor];
        label.layer.borderWidth = 1;
        label.layer.borderColor = HEX(0xEAEAEA).CGColor;
        label.layer.cornerRadius = XX_6(8);
        label.layer.masksToBounds = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = BZDFONT(24);
        [self addSubview:label];
        [self.labelBoxArray addObject:label];
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [label addGestureRecognizer:tap];
    }
}
-(void)tap:(UITapGestureRecognizer *)tap
{
    [self.textField becomeFirstResponder];
}

- (void)startShakeViewAnimation
{
    CAKeyframeAnimation *shake = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
    shake.values = @[@0,@-10,@10,@-10,@0];
    shake.additive = YES;
    shake.duration = 0.25;
    [self.layer addAnimation:shake forKey:@"shake"];
}

- (void)textDidChanged:(UITextField *)textField
{
    if (textField.text.length > PasswordBoxNumber)
    {
        textField.text = [textField.text substringToIndex:PasswordBoxNumber];
    }
    
    [self updateLabelBoxWithText:textField.text];
    if (textField.text.length == PasswordBoxNumber&&self.enabled==NO)
    {

        if (self.completionBlock)
        {
            
            [textField resignFirstResponder];
            self.completionBlock(self.textField.text);
        }
        self.enabled = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.enabled = NO;
        });
    }
}

- (void)asterisk:(BOOL)isAsterisk
{
    if (isAsterisk) {
        self.asterisk = @"";
    }
    else
    {
        self.asterisk = @"*";
    }
    
    [self updateLabelBoxWithText:self.currentText];
}

#pragma mark - Public

- (void)updateLabelBoxWithText:(NSString *)text
{
    //输入时
    if (text.length > self.currentText.length) {
        for (int i = 0; i < PasswordBoxNumber; i++)
        {
            UILabel *label = self.labelBoxArray[i];
            
            if (i < text.length - 1)
            {
                
                label.text = [text substringWithRange:NSMakeRange(i, 1)];
                if (self.asterisk.length!=0) {
                    //特殊字符不居中显示，设置文本向下偏移
                    NSAttributedString * att1 = [[NSAttributedString alloc] initWithString:self.asterisk attributes:@{NSBaselineOffsetAttributeName:@(-3)}];
                    label.attributedText = att1;
                }
                label.layer.borderColor = HEX(0x222222).CGColor;
            }
            else if (i == text.length - 1)
            {
                label.text = [text substringWithRange:NSMakeRange(i, 1)];
                if (self.asterisk.length!=0) {
                    [self animationShowTextInLabel: label];
                }
                label.layer.borderColor = HEX(0x222222).CGColor;
            }
            else
            {
                label.text = @"";
                label.layer.borderColor = HEX(0xEAEAEA).CGColor;
            }
        }
    }
    //删除时
    else
    {
        for (int i = 0; i < PasswordBoxNumber; i++)
        {
            UILabel *label = self.labelBoxArray[i];
            if (i < text.length)
            {
                if (self.asterisk.length!=0)
                {
                    //特殊字符不居中显示，设置文本向下偏移
                    NSAttributedString * att1 = [[NSAttributedString alloc] initWithString:self.asterisk attributes:@{NSBaselineOffsetAttributeName:@(-3)}];
                    label.attributedText = att1;
                }
                else
                {
                     label.text = [text substringWithRange:NSMakeRange(i, 1)];
                }
            }
            else
            {
                label.text = @"";
                label.layer.borderColor = HEX(0xEAEAEA).CGColor;
            }
        }
    }
    self.textField.text = text;
    self.currentText = text;
}

- (void)animationShowTextInLabel:(UILabel *)label
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //特殊字符不居中显示，设置文本向下偏移
        NSAttributedString * att1 = [[NSAttributedString alloc] initWithString:self.asterisk attributes:@{NSBaselineOffsetAttributeName:@(-3)}];
        label.attributedText = att1;
    });
}

- (void)didInputPasswordError
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startShakeViewAnimation];
        self.textField.text = @"";
        [self updateAllLabelTextToNone];
    });
}

- (void)updateAllLabelTextToNone
{
    for (int i = 0; i < PasswordBoxNumber; i++)
    {
        UILabel *label = self.labelBoxArray[i];
        label.text = @"";
        label.layer.borderColor = HEX(0xEAEAEA).CGColor;
    }
}

- (void)transformTextInTextField:(UITextField *)textField
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        textField.text = @"*";
    });
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

#pragma mark - Getter/Setter

- (NSMutableArray *)labelBoxArray
{
    if (!_labelBoxArray)
    {
        _labelBoxArray = [NSMutableArray array];
    }
    return _labelBoxArray;
}

- (UITextField *)textField
{
    if (!_textField)
    {
        _textField = [[UITextField alloc] init];
        [_textField addTarget:self action:@selector(textDidChanged:) forControlEvents:UIControlEventEditingChanged];
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.delegate = self;
        _textField.backgroundColor = [UIColor redColor];
    }
    return _textField;
}

@end
