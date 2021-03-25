//
//  ViewController.m
//  BZDDemo
//
//  Created by 李志刚 on 2021/3/18.
//

#import "ViewController.h"
#import "BZDPasswordView.h"
#import "YZAuthID.h"
#import "LYSGPasswordView.h"
@interface ViewController ()<LYSGPasswordViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self password];
//    [self usingFaceFingerprints];
    [self passwordview];


}
-(void)passwordview
{
    self.view.backgroundColor = [UIColor lightGrayColor];
    
   
    
    LYSGPasswordView *gpView_small = [[LYSGPasswordView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 100)/2.0, 80, 100, 100) style:[LYSGPasswordStyle smallGpStyle]];
    [self.view addSubview:gpView_small];

    LYSGPasswordView *gpView = [[LYSGPasswordView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, self.view.frame.size.width) style:[LYSGPasswordStyle defaultStyle]];
    gpView.delegate = self;
    gpView.smallGpView = gpView_small;
    [self.view addSubview:gpView];
}
-(void)password
{
    
    BZDPasswordView * pursePossworView = [[BZDPasswordView alloc]initWithFrame:CGRectMake(0, 200, SCREEN_WIDTH, 80)];
    __weak typeof(self) weakSelf = self;
    pursePossworView.completionBlock = ^(NSString *password) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf requestWalletpwd:password];
    };
    [self.view addSubview:pursePossworView];
}

-(void)usingFaceFingerprints
{
    [[YZAuthID alloc] yz_showAuthIDWithDescribe:nil block:^(YZAuthIDState state, NSError *error) {
            
            if (state == YZAuthIDStateNotSupport) {
                NSLog(@"对不起，当前设备不支持指纹/面部ID");
            } else if(state == YZAuthIDStateFail) {
                NSLog(@"指纹/面部ID不正确，认证失败");
            } else if(state == YZAuthIDStateTouchIDLockout) {
                NSLog(@"多次错误，指纹/面部ID已被锁定，请到手机解锁界面输入密码");
            } else if (state == YZAuthIDStateSuccess) {
                NSLog(@"认证成功！");
            }
            
        }];
}
- (void)requestWalletpwd:(NSString *)password
{
    

    NSLog(@"输入的密码是：%@",password);
}






- (void)lyPasswordView:(LYSGPasswordView *)passwordView didSelectNum:(NSArray *)numAry{
NSLog(@"%@",numAry);
}
- (void)lyPasswordView:(LYSGPasswordView *)passwordView enError:(LYPasswordState)state {
NSLog(@"%ld",(long)state);

}
- (void)lyPasswordView:(LYSGPasswordView *)passwordView withPassword:(NSString *)password {
NSLog(@"%@",password);

}
- (void)lyPasswordViewDidStart:(LYSGPasswordView *)passwordView {
NSLog(@"开始");
}
- (void)lyPasswordViewDidEnd:(LYSGPasswordView *)passwordView {
NSLog(@"结束");
}

@end
