//
//  UIView+BZDExtension.h
//  BZDDemo
//
//  Created by 李志刚 on 2021/3/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



@interface UIView (BZDFrame)

@property (nonatomic, assign) CGFloat dd_x;
@property (nonatomic, assign) CGFloat dd_y;
@property (nonatomic, assign) CGFloat dd_width;
@property (nonatomic, assign) CGFloat dd_height;
@property (nonatomic, assign) CGFloat dd_MaxX;
@property (nonatomic, assign) CGFloat dd_MaxY;
@property (nonatomic, assign) CGFloat dd_centerX;
@property (nonatomic, assign) CGFloat dd_centerY;
@property (nonatomic, assign) CGSize dd_size;

@end



@interface UIView (BZDDraw)

- (void)setGradientColors:(NSArray *)colors
               startPoint:(CGPoint)startPoint
                 endPoint:(CGPoint)endPoint;
- (void)clearGradient;

- (void)setRecCorner:(CGSize)cornerSize
           byCorners:(UIRectCorner)corners;


@end


@interface NSString (BZDShow)

+ (NSString *)professionWithIntegralProfession:(NSString *)string;
+ (NSString *)positionWithIntegralPosition:(NSString *)string;

- (NSString *)formatPrice;
+ (NSString *)formatPriceWithCent:(NSInteger)cent;

- (NSString *)ossAvatarProcess;
- (NSString *)ossThumbProcess;
- (NSString *)ossSnapshotProcess;
- (NSString *)ossCoverProcess;
@end

NS_ASSUME_NONNULL_END
