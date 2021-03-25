//
//  DZDBalanceWithEnterPasswordView.h
//  BZDDemo
//
//  Created by 李志刚 on 2021/3/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^BlockBWPSuccess)(NSString * password );
typedef void(^BlockpasswordForgot)(void);
@interface DZDBalanceWithEnterPasswordView : UIView
@property (nonatomic, strong) NSString * amount;
@property (nonatomic, strong) NSString * poundage;
@property (nonatomic, assign)  BOOL iSMerchants;// 是否是商家
@property(nonatomic,copy) BlockBWPSuccess blockBWPSuccess;
@property(nonatomic,copy) BlockpasswordForgot blockpasswordForgot;

-(void)show;




@end

NS_ASSUME_NONNULL_END
