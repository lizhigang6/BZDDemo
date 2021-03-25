//
//  BZDPasswordView.h
//  BZDDemo
//
//  Created by 李志刚 on 2021/3/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^InputPasswordCompletionBlock)(NSString *password);

@interface BZDPasswordView : UIView
@property (nonatomic,copy)InputPasswordCompletionBlock completionBlock;
@property (nonatomic,strong)NSString * asterisk;

/** 更新输入框数据 */
- (void)updateLabelBoxWithText:(NSString *)text;
- (void)asterisk:(BOOL)isAsterisk;


/** 抖动输入框 */
- (void)startShakeViewAnimation;
//输入错误
- (void)didInputPasswordError;

@end

NS_ASSUME_NONNULL_END
