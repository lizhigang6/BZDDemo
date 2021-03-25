//
//  UIView+BZDExtension.m
//  BZDDemo
//
//  Created by 李志刚 on 2021/3/23.
//

#import "UIView+BZDExtension.h"






@implementation UIView (BZDFrame)

- (CGFloat)dd_x {
    return self.frame.origin.x;
}

- (void)setDd_x:(CGFloat)dd_x {
    CGRect frame = self.frame;
    frame.origin.x = dd_x;
    self.frame = frame;
}

- (CGFloat)dd_y {
    return self.frame.origin.y;
}

- (void)setDd_y:(CGFloat)dd_y {
    CGRect frame = self.frame;
    frame.origin.y = dd_y;
    self.frame = frame;
}

- (CGFloat)dd_width {
    return self.frame.size.width;
}

- (void)setDd_width:(CGFloat)dd_width {
    if (dd_width < 0) {
        return;
    }
    CGRect frame = self.frame;
    frame.size.width = dd_width;
    self.frame = frame;
}

- (CGFloat)dd_height {
    return self.frame.size.height;
}

- (void)setDd_height:(CGFloat)dd_height {
    if (dd_height < 0) {
        return;
    }
    CGRect frame = self.frame;
    frame.size.height = dd_height;
    self.frame = frame;
}

- (CGFloat)dd_MaxX {
    return CGRectGetMaxX(self.frame);
}

- (void)setDd_MaxX:(CGFloat)dd_MaxX {
    CGRect frame = self.frame;
    if (dd_MaxX < frame.origin.x) {
        return;
    }
    frame.size.width = dd_MaxX - frame.origin.x;
    self.frame = frame;
}

- (CGFloat)dd_MaxY {
    return CGRectGetMaxY(self.frame);
}

- (void)setDd_MaxY:(CGFloat)dd_MaxY {
    CGRect frame = self.frame;
    if (dd_MaxY < frame.origin.y) {
        return;
    }
    frame.size.height = dd_MaxY - frame.origin.y;
    self.frame = frame;
}

- (CGFloat)dd_centerX {
    return self.center.x;
}

- (void)setDd_centerX:(CGFloat)dd_centerX {
    CGPoint center = self.center;
    center.x = dd_centerX;
    self.center = center;
}

- (CGFloat)dd_centerY {
    return self.center.y;
}

- (void)setDd_centerY:(CGFloat)dd_centerY {
    CGPoint center = self.center;
    center.y = dd_centerY;
    self.center = center;
}

- (CGSize)dd_size {
    return self.bounds.size;
}

- (void)setDd_size:(CGSize)dd_size {
    if (dd_size.width < 0 || dd_size.height < 0) {
        return;
    }
    CGRect frame = self.frame;
    frame.size = dd_size;
    self.frame = frame;
}

@end



@implementation UIView (BZDDraw)

- (void)setGradientColors:(NSArray *)colors
               startPoint:(CGPoint)startPoint
                 endPoint:(CGPoint)endPoint {
    [self clearGradient];
    
    NSMutableArray *tempColors = [NSMutableArray array];
    for (UIColor *color in colors) {
        [tempColors addObject:(__bridge id)color.CGColor];
    }
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = tempColors;
    gradientLayer.startPoint = startPoint;
    gradientLayer.endPoint = endPoint;
    gradientLayer.frame = self.bounds;
    gradientLayer.cornerRadius = self.layer.cornerRadius;
    gradientLayer.masksToBounds = self.layer.masksToBounds;
    [self.layer insertSublayer:gradientLayer atIndex:0];
}

- (void)clearGradient {
    [self.layer.sublayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isMemberOfClass:[CAGradientLayer class]]) {
            [obj removeFromSuperlayer];
            *stop = YES;
        }
    }];
}

- (void)setRecCorner:(CGSize)cornerSize byCorners:(UIRectCorner)corners {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:cornerSize];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}



@end


@implementation NSString (BZDShow)

+ (NSString *)professionWithIntegralProfession:(NSString *)string {
    NSArray *professionLevels = [string componentsSeparatedByString:@"-"];
    if (professionLevels.count == 1) {
        return professionLevels[0];
    }
    NSString *profession = @"";
    if ([string containsString:@"其他"]) {
        profession = [professionLevels firstObject];
    } else {
        profession = [professionLevels lastObject];
    }
    return profession;
}

+ (NSString *)positionWithIntegralPosition:(NSString *)string {
    NSArray *positionLevels = [string componentsSeparatedByString:@"-"];
    if (positionLevels.count == 1) {
        return positionLevels[0];
    }
    NSString *position = @"";
    if ([string containsString:@"其他"]) {
        position = [positionLevels firstObject];
    } else {
        position = [positionLevels lastObject];
    }
    return position;
}

- (NSString *)formatPrice {
    if (self.length == 0) {
        return @"0";
    }
    if (![self containsString:@"."]) {
        return self;
    }
    NSArray *components = [self componentsSeparatedByString:@"."];
    if (components.count != 2) {
        return self;
    }
    NSString *last = [components lastObject];
    if (last.length > 2) {
        last = [last substringToIndex:2];
    }
    // 循环切割掉最后的0
    while (last.length > 0) {
        if ([[last substringFromIndex:last.length - 1] isEqualToString:@"0"]) {
            last = [last substringToIndex:last.length - 1];
        } else {
            break;
        }
    }
    if (last.length > 0) {
        return [NSString stringWithFormat:@"%@.%@", [components firstObject], last];
    } else {
        return [components firstObject];
    }
}

+ (NSString *)formatPriceWithCent:(NSInteger)cent {
    return [NSString stringWithFormat:@"%.2f", cent / 100.0].formatPrice;
}

- (NSString *)ossAvatarProcess {
    if ([self containsString:@"lvoss.10m.com.cn"]) {
        if ([self containsString:@"x-oss-process"]) {
            return self;
        } else {
            return [self stringByAppendingString:@"?x-oss-process=image/resize,m_fill,h_120,w_120/circle,r_60/format,png"];
        }
    } else {
        return self;
    }
}

- (NSString *)ossThumbProcess {
    if ([self containsString:@"lvoss.10m.com.cn"]) {
        if ([self containsString:@"x-oss-process"]) {
            return self;
        } else {
            return [self stringByAppendingString:@"?x-oss-process=image/resize,m_fill,h_120,w_120/format,png"];
        }
    } else {
        return self;
    }
}

- (NSString *)ossSnapshotProcess {
    if ([self containsString:@"lvoss.10m.com.cn"]) {
        if ([self containsString:@"x-oss-process"]) {
            return self;
        } else {
            return [self stringByAppendingString:@"?x-oss-process=video/snapshot,t_0,f_png,w_120,ar_auto"];
        }
    } else {
        return self;
    }
}

- (NSString *)ossCoverProcess {
    if ([self containsString:@"lvoss.10m.com.cn"]) {
        if ([self containsString:@"x-oss-process"]) {
            return self;
        } else {
            CGFloat width = SCREEN_WIDTH;
            CGFloat scale = [UIScreen mainScreen].scale;
            int w = width * scale;
            return [self stringByAppendingFormat:@"?x-oss-process=image/resize,m_fill,h_%d,w_%d/format,png", w, w];
        }
    } else {
        return self;
    }
}

@end
