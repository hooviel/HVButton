# HVButton

```objc
HVButton *btn = [HVButton buttonWithType:UIButtonTypeCustom];
btn.frame = CGRectMake(50, 100, 120, 50);
[btn setTitle:@"HVButton" forState:UIControlStateNormal];
[self.view addSubview:btn];
```

###设置按钮指定状态的纯色背景
```objc
// 1、设置 UIControlStateNormal 状态纯色背景
[btn setBackgroundColor:[UIColor colorWithRGBValue:0xff33ad]
               forState:UIControlStateNormal];
```

###设置按钮指定状态的渐变背景，优先级大于纯色背景
```objc
// 2、设置 UIControlStateNormal 状态渐变背景，渐变背景优先级大于纯色背景，所以，UIControlStateNormal 下回显示渐变色背景
[btn setGradientColor:[HVGradientColor gradientColorWithColors:@[[UIColor colorWithRGBValue:0xff4567],
                                                                 [UIColor colorWithRGBValue:0xaa4567]]]
             forState:UIControlStateNormal];
// 设置 UIControlStateHighlighted 状态渐变背景
[btn setGradientColor:[HVGradientColor gradientColorWithColors:@[[UIColor colorWithRGBValue:0xff3456],
                                                                 [UIColor colorWithRGBValue:0xff8765]]]
             forState:UIControlStateHighlighted];
```

###设置圆角：上左、上右、右下、左下、全部圆角，默认是全部圆角
```objc
// 3、设置上左，下右
btn.corner = UIRectCornerTopLeft|UIRectCornerBottomRight;
```

###设置圆角半径，默认圆角半径为0，即：无圆角
```objc
// 4、设置圆角半径
btn.cornerRadius = 20;
```

###设置边框属性：宽
```objc
// 5、设置边框宽
btn.borderWidth = 4;
```

###设置边框属性：颜色
```objc
// 6、设置边框颜色
btn.borderColor = [UIColor orangeColor];
```
 
