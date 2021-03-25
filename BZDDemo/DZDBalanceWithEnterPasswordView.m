//
//  DZDBalanceWithEnterPasswordView.m
//  BZDDemo
//
//  Created by 李志刚 on 2021/3/18.
//

#import "DZDBalanceWithEnterPasswordView.h"

#import "BZDPasswordView.h"
//#import "DDParticipantsRequest.h"

@interface DZDBalanceWithEnterPasswordView()
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView * containerView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIButton *  cancelButton;
@property (nonatomic, strong) UIButton *  passwordForgotButton;
@property (nonatomic, strong) UILabel * prompt_Label;
@property (nonatomic, strong) BZDPasswordView * pursePossworView;

@end


@implementation DZDBalanceWithEnterPasswordView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
        
    }
    
    return self;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark --键盘弹出
- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    //取出键盘动画的时间(根据userInfo的key----UIKeyboardAnimationDurationUserInfoKey)
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    //取得键盘最后的frame(根据userInfo的key----UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 227}, {320, 253}}";)
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //计算控制器的view需要平移的距离
    CGFloat transformY = keyboardFrame.origin.y - self.frame.size.height;
    self.frame = CGRectMake(0, transformY, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    //执行动画
    [UIView animateWithDuration:duration animations:^{
        
    }];
}
#pragma mark --键盘收回
- (void)keyboardDidHide:(NSNotification *)notification{
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
}
-(void)setAmount:(NSString *)amount
{
    _amount = amount;
}
-(void)setPoundage:(NSString *)poundage
{
    _poundage = poundage;
    NSMutableAttributedString * strE = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"到账金额 %@ 元，手续费 %@元",self.amount,self.poundage]];
    [strE addAttribute:NSForegroundColorAttributeName
                 value:HEX(0xFC2929)
                 range:NSMakeRange(5,self.amount.length)];
    _prompt_Label.attributedText = strE;
}
-(void)setISMerchants:(BOOL)iSMerchants
{
    _iSMerchants = iSMerchants;
    if (_iSMerchants) {
        _passwordForgotButton.hidden = YES;
    }
}

-(void)setupUI
{
    self.backgroundColor = HEXA(0x000000, 0.6);
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self addSubview:self.maskView];
    [self addSubview:self.containerView];
    [self.containerView addSubview:self.cancelButton];
    
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(32, 16, self.containerView.frame.size.width-64, 25)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = BZDBOLDFONT(18);
    _titleLabel.textColor = HEX(0x222222);
    _titleLabel.text = @"输入密码";
    [self.containerView addSubview:_titleLabel];
    
    
    _prompt_Label = [[UILabel alloc] initWithFrame:CGRectMake(0, _titleLabel.dd_MaxY+16, self.containerView.frame.size.width, 25)];
    _prompt_Label.textAlignment = NSTextAlignmentCenter;
    _prompt_Label.font = BZDFONT(14);
    _prompt_Label.textColor = HEX(0x222222);
    [self.containerView addSubview:_prompt_Label];
    
    
    BZDPasswordView * pursePossworView = [[BZDPasswordView alloc]initWithFrame:CGRectMake(0, _titleLabel.dd_MaxY+60, SCREEN_WIDTH, 80)];
    __weak typeof(self) weakSelf = self;
    pursePossworView.completionBlock = ^(NSString *password) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf requestWalletpwd:password];
    };
    [self.containerView addSubview:pursePossworView];
    self.pursePossworView = pursePossworView;
    
    
    _passwordForgotButton = [[UIButton alloc] initWithFrame:CGRectMake(self.containerView.frame.size.width-16-57, pursePossworView.dd_MaxY, 57, 20)];
    [_passwordForgotButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    [_passwordForgotButton setTitleColor:HEX(0x54A5F9) forState:UIControlStateNormal];
    _passwordForgotButton.titleLabel.font = BZDFONT(14);
    [_passwordForgotButton addTarget:self action:@selector(passwordForgotClick) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:_passwordForgotButton];
    
    
}



- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(16, 21, 16, 16)];
        [_cancelButton setImage:IMG(@"关闭") forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _cancelButton;
}


- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:self.bounds];
        _maskView.backgroundColor = RGBA(0, 0, 0, 0.5);
        [_maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)]];
    }
    return _maskView;
}
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-(225+ Bottom_HEIGHT), SCREEN_WIDTH, 225+Bottom_HEIGHT)];
        _containerView.backgroundColor = [UIColor whiteColor];
        //        _containerView.layer.cornerRadius = 16;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_containerView.bounds byRoundingCorners:  UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(16, 16)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _containerView.bounds;
        maskLayer.path = maskPath.CGPath;
        _containerView.layer.mask = maskLayer;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
        [_containerView addGestureRecognizer:tap];
    }
    
    return _containerView;
}
-(void)tap
{
    
}
-(void)cancel
{
    [self hide];
    
}
-(void)passwordForgotClick
{
    if (self.blockpasswordForgot) {
        self.blockpasswordForgot();
    }
    [self hide];
    
}


-(void)show
{
    if (self.superview) {
        return;
    }
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.containerView.frame = CGRectMake(0, self.bounds.size.height - self.containerView.bounds.size.height, self.containerView.bounds.size.width, self.containerView.bounds.size.height);
    } completion:nil];
}

- (void)hide {
   
    [UIView animateWithDuration:0.25 animations:^{
        self.containerView.frame = CGRectMake(0, self.bounds.size.height, self.containerView.bounds.size.width, self.containerView.bounds.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
   
}
//store/check_store_wallet_pwd  检验商家钱包交易密码
#pragma mark 检验钱包交易密码
#pragma mark requestWalletBalance
- (void)requestWalletpwd:(NSString *)password
{
    
    self.blockBWPSuccess(password);

}
    
   

@end
