//
//  HVButton.h
//  ebuy
//
//  Created by David Ko on 15/7/25.
//  Copyright (c) 2015年 VeryApps. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  渐变方向
 *  暂时没有用到***
 */
typedef NS_ENUM(NSInteger, HVGradientDirection){
    /**
     *  水平方向
     */
    HVGradientDirectionHor,
    /**
     *  垂直方向
     */
    HVGradientDirectionVer
};

@interface HVGradientColor : NSObject

/**
 *  Array of UIColor
 */
@property (nonatomic, strong, readonly) NSArray *colors;

/**
 *  初始化渐变色对象
 *
 *  @param colors 颜色数组，从上到下的顺序
 *
 *  @return 渐变色对象
 */
+ (instancetype)gradientColorWithColors:(NSArray *)colors;

@end

@interface HVButton : UIButton

/**
 *  边框宽, 默认0，无边框
 */
@property (nonatomic, assign) CGFloat borderWidth;
/**
 *  边框颜色，默认nil，无颜色
 */
@property (nonatomic, strong) UIColor *borderColor;

/**
 *  圆角，默认UIRectCornerAllCorners
 */
@property (nonatomic, assign) UIRectCorner corner;
/**
 *  圆角半径，默认0
 */
@property (nonatomic, assign) CGFloat cornerRadius;

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;
- (UIColor *)backgroundColorForState:(UIControlState)state;

- (void)setGradientColor:(HVGradientColor *)gradientColor forState:(UIControlState)state;
- (HVGradientColor *)gradientColorForState:(UIControlState)state;

@end
