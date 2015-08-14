//
//  HVButton.m
//  ebuy
//
//  Created by David Ko on 15/7/25.
//  Copyright (c) 2015年 VeryApps. All rights reserved.
//

#import "HVButton.h"

@interface HVGradientColor ()

- (void)setColors:(NSArray *)colors;

@end

@implementation HVGradientColor

/**
 *  初始化渐变色对象
 *
 *  @param colors 颜色数组，从上到下的顺序
 *
 *  @return 渐变色对象
 */
+ (instancetype)gradientColorWithColors:(NSArray *)colors
{
    HVGradientColor *gradientColor = [[HVGradientColor alloc] init];
    [gradientColor setColors:colors];
    return gradientColor;
}

- (void)setColors:(NSArray *)colors
{
    _colors = colors;
}

@end

@implementation HVButton
{
    NSMutableDictionary *_dictBgColor;
    NSMutableDictionary *_dictGradientColor;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSetup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initSetup];
    }
    return self;
}

- (void)initSetup
{
    _borderWidth = 0;
    _borderColor = [UIColor clearColor];
    _corner = 0;
    _cornerRadius = 4;
}

#pragma mark - public
- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    [self setNeedsDisplay];
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    [self setNeedsDisplay];
}

- (void)setCorner:(UIRectCorner)corner
{
    _corner = corner;
    [self setNeedsDisplay];
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    [self setNeedsDisplay];
}

// ----------------- backgroundColor
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state
{
    if (!_dictBgColor) {
        _dictBgColor = [NSMutableDictionary dictionary];
        self.backgroundColor = [UIColor clearColor];
    }
    
    if (!backgroundColor) {
        backgroundColor = [UIColor clearColor];
    }
    _dictBgColor[@(state)] = backgroundColor;
    
    [self setNeedsDisplay];
}

- (UIColor *)backgroundColorForState:(UIControlState)state
{
    UIColor *bgColor = nil;
    
    do {
        NSArray *keys = [_dictBgColor.allKeys sortedArrayUsingSelector:@selector(compare:)];
        
        for (NSNumber *key in keys) {
            UIControlState keyState = [key integerValue];
            if (state==keyState) {
                bgColor = _dictBgColor[key];
                break;
            }
        }
        
        if (bgColor) break;
        
        for (NSNumber *key in _dictBgColor.allKeys) {
            UIControlState keyState = [key integerValue];
            if (keyState&state) {
                bgColor = _dictBgColor[key];
                break;
            }
        }
        
        if (bgColor) break;
        
//        bgColor = [UIColor clearColor];
    } while (NO);
    
    return bgColor;
}

// ----------------- gradientColor
- (void)setGradientColor:(HVGradientColor *)gradientColor forState:(UIControlState)state
{
    if (!_dictGradientColor) {
        _dictGradientColor = [NSMutableDictionary dictionary];
        self.backgroundColor = [UIColor clearColor];
    }
    
    if (!gradientColor) {
        gradientColor = [HVGradientColor gradientColorWithColors:@[[UIColor clearColor], [UIColor clearColor]]];
    }
    _dictGradientColor[@(state)] = gradientColor;
    
    [self setNeedsDisplay];
}

- (HVGradientColor *)gradientColorForState:(UIControlState)state
{
    HVGradientColor *gradientColor = nil;
    
    do {
        NSArray *keys = [_dictGradientColor.allKeys sortedArrayUsingSelector:@selector(compare:)];
        
        for (NSNumber *key in keys) {
            UIControlState keyState = [key integerValue];
            if (state==keyState) {
                gradientColor = _dictGradientColor[key];
                break;
            }
        }
        
        if (gradientColor) break;
        
        for (NSNumber *key in _dictBgColor.allKeys) {
            UIControlState keyState = [key integerValue];
            if (keyState&state) {
                gradientColor = _dictGradientColor[key];
                break;
            }
        }
        
        if (gradientColor) break;
        
//        gradientColor = [HVGradientColor gradientColorWithColors:@[[UIColor clearColor], [UIColor clearColor]]];
    } while (NO);
    
    return gradientColor;
}

#pragma mark - super methods
- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    [self setNeedsDisplay];
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    
    [self setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    
    NSLog(@"%s, %zd", __FUNCTION__, self.state);
    UIColor *fillColor = [self backgroundColorForState:self.state];
    HVGradientColor *gradientColor = [self gradientColorForState:self.state];
    UIColor *strokeColor = _borderColor?:[UIColor clearColor];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:_corner cornerRadii:CGSizeMake(_cornerRadius, _cornerRadius)];
    [path addClip];
    CGContextAddPath(context, path.CGPath);
    
    if (gradientColor) {
        NSMutableArray *arrColor = [NSMutableArray array];
        NSInteger gradientCount = gradientColor.colors.count;
        for (NSInteger i=0; i<gradientCount; i++) {
            UIColor *color = gradientColor.colors[i];
            [arrColor addObject:(id)color.CGColor];
        }
        if (arrColor.count==1) {
            [arrColor addObject:(id)((UIColor *)gradientColor.colors[0]).CGColor];
        }
        CFArrayRef arrColorRef = (__bridge CFArrayRef)arrColor;
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, arrColorRef, NULL);
        CGContextDrawLinearGradient(context, gradient, CGPointMake(self.width*0.5, 0), CGPointMake(self.width*0.5, self.height), kCGGradientDrawsAfterEndLocation);
        CGColorSpaceRelease(colorSpace);
        CGGradientRelease(gradient);
    }
    else {
        if (!fillColor) {
            fillColor = [UIColor clearColor];
        }
        
        CGContextSetFillColorWithColor(context, fillColor.CGColor);
        CGContextFillPath(context);
    }
    
    CGContextSetStrokeColorWithColor(context, strokeColor.CGColor);
    path.lineWidth = _borderWidth*2;
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
//    [path stroke];
}

@end
